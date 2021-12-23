/*
battleMETAL
Author: Peter Roohr
Date: 3/21/2018
rebuild: 10/03/2020 - get it? the repair bay needed...repairing!?
Overview: 
  data file for the human repair bay.
  
  Refactored to use proper state system where repairBay.playerState will be used.
  
  PLAYER_ACTIVE = repair is actively repairing a specific part
  
  PLAYER_CONNECT = repair part filtering
  
  PLAYER_RESPAWN  = repair bay cooldown
  
  PLAYER_DEBRIEF = idle, recharge .reloadValue
  
*/

void() building_repair_touch;

void(entity item) building_repair_item_legs;

//generic, can be called by any state.
void() building_repair_recharge_frame={
  if(self.energy < self.energyMax ){
    self.energy = self.energy + self.energyRate;
  }
  if( self.energy >= self.energyMax ){
    self.energy = self.energyMax;
  }
  
  if( self.energy > self.energyRate ){
    self.reloadValue = self.reloadValue + self.reloadRate;
    self.energy = self.energy - self.reloadRate * 2;
    if(self.reloadValue > self.reloadMax){
      self.reloadValue = self.reloadMax;
    }
  }
};

/*
  Lets do this state thing proper, eh?*/

void() building_repair_fixing;    //repair bay has an active player its fixing
void() building_repair_select;    //choose the right part to fix
void() building_repair_idle;      //repair bay has no player, and is ok 
void() building_repair_cooldown;  //repair bay ran out of resources mid-repair, cut over to cooldown for a bit
void() building_repair_attack;    //multiplayer lolz.
void() building_repair_state;     //our old ai_api friend.


/*
  STATE: PLAYER_CONNECT
*/
void() building_repair_select={
  local entity player;
  local entity repairCheck;
  local entity part;
  local float lowHP;
  local float hp;
  local float typeId;
  
  if( self.ai_state == PLAYER_CONNECT && self.ai_state_last != PLAYER_CONNECT ){
    self.burstRate = 0;
    //fresh repair event
    if( self.reloadValue <= 0 ){
      //cut over to cooldown state;
      self.ai_state_next = PLAYER_RESPAWN;
      return;
    }
    
    if(self.trigger_field != world){
      player = self.trigger_field;
    }
    else{
      self.ai_state_next = PLAYER_RESPAWN;
      return;
    }
    
    if(csqc_updateCompStat(player) < 100){
      repairCheck = player;
      typeId = M_TOR_CENTER;
    }
    else{
      part = player.partNext;
      lowHP = 99.99;
      while(part){
        if( part.partTypeId != M_ITEM ){
          hp = csqc_updateCompStat(part);
          if( hp < lowHP){
            lowHP = hp;
            if( part.partTypeId == M_ARM_RIGHT && (player.damageValue & M_TOR_RIGHT) ){
              repairCheck = part.owner.torsoRight;
              typeId = repairCheck.partTypeId;
            }
            else if( part.partTypeId == M_ARM_LEFT && (player.damageValue & M_TOR_LEFT) ){
              repairCheck = part.owner.torsoLeft;
              typeId = repairCheck.partTypeId;
            }
            else{
              repairCheck = part;
              typeId = repairCheck.partTypeId;
            }
          }
        }
        part = part.partNext;
      }
    }
    if( repairCheck == world ){
      self.ai_state_next = PLAYER_DEBRIEF;
      return;
    }
    
    //smooth transitions between repairing pieces.
    if(self.ai_state_last != PLAYER_ACTIVE){
      if( !(player.flags & FL_NOSHOOT) ){
        player.flags = player.flags | FL_NOSHOOT;
        self.moveState = TRUE; //preserve client FL_NOSHOOT setting
        player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_EFLAGS;
      }
      client_send_event_repairs( player, TRUE );
    }
    self.attack_state = typeId;
    self.goalentity = repairCheck;
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.ai_state_next = PLAYER_ACTIVE;
  }
};

/*
  STATE: PLAYER_ACTIVE  
*/
void() building_repair_fixing={
  local entity player;
  local float end_repair;
  local entity fix;
  local entity part;
  local entity altSelf;
  
  if( self.reloadValue <= 0 ){
    //cut over to cooldown state;
    self.ai_state_next = PLAYER_RESPAWN;
    return;
  }

  if(self.trigger_field == world){
    self.ai_state_next = PLAYER_RESPAWN;
    return;
  }
  else{
    player = self.trigger_field;
  }
  
  if(vlen(player.origin - self.cockpit.origin) > 48){
    //player walked away from node
    self.ai_state_next = PLAYER_RESPAWN;
    return;
  }
  
   //ENTER STATE------------------------------------------
  if( self.ai_state == PLAYER_ACTIVE && self.ai_state_last != PLAYER_ACTIVE ){
    if(self.goalentity == world){
      //error out
      self.ai_state_next = PLAYER_RESPAWN;
      return;
    }
    self.burstRate = 0;
  }
  //------------------------------------------------------
  altSelf = self;
  fix = self.goalentity;  //between frame caching
  //energ recharge freebie
  player.energy = player.energy + (player.energyRate * 0.85);
  if( player.energy > player.energyMax ){
    player.energy = player.energyMax;
  }
  
  end_repair = FALSE;
  
  //fix 'client' / aka CT
  if( (fix.flags & FL_CLIENT) ){
    //part is not critical'd, repair as normal.
    fix.health = fix.health + self.reloadRate;
    self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (self.trigger_field.vec_size * 1.25));
  }
  else{
    //regular mech parts
    if( fix.deadflag == DEAD_NO ){
      //part is not critical'd, repair as normal.
      fix.health = fix.health + self.reloadRate;
      self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (self.trigger_field.vec_size * 1.25));
      if( fix.health >= fix.max_health * 0.5 ){
        player.burnBits = player.burnBits - (player.burnBits & fix.partTypeId);
        player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_BURN;
      }
    }
    else{
      //part has been blown off / destroyed.
      fix.health = fix.health + self.reloadRate / 1.15;
      self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (self.trigger_field.vec_size * 1.75));
      if(fix.deadflag == DEAD_DEAD && fix.partTypeId != M_LEGS){
        fix.deadflag = DEAD_DYING;
        if(fix.deadflag != DEAD_NO ){
          fix.deadflag = DEAD_NO;
          player.critBits = player.critBits | (fix.partTypeId | M_REPAIR);
          player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_CRIT;
          
          part = player.w_slot;
          while( part != world ){
            if( part.partParentId == fix.partTypeId && part.deadflag != DEAD_NO ){
              part.deadflag = DEAD_NO;
              part.think = part.w_think;
              if( part.item_run_upgrade ){
                self = part;
                  self.item_run_upgrade();
                self = altSelf;
              }
              setsize(part, '-1 -1 -1', '1 1 1');
            }
            part = part.w_slot;
          }
        }
      }
      else if(fix.deadflag == DEAD_DYING){
        if(fix.health > fix.max_health * 0.5){
          fix.deadflag = DEAD_NO;
          if( !(fix.owner.criticalHits & M_TOR_LEFT) ){
            fix.owner.shieldMax = fix.owner.shieldMax * 0.5;
          }
          if( !(fix.owner.criticalHits & M_TOR_LEFT) ){
            fix.owner.shieldMax = fix.owner.shieldMax * 0.5;
          }
        }
      }
    }

  }
  if(fix.health >= fix.max_health){
    end_repair = TRUE;
    fix.health = fix.max_health;
    if( fix.partTypeId == M_LEGS ){
      if( (fix.flags & FL_DISARMED) ) {
        //restore sprint/ram functionality
        fix.flags = fix.flags - (fix.flags & FL_DISARMED);
        fix.owner.data_speed_forward = fix.data_speed_forward;
        fix.owner.data_speed_backward = fix.data_speed_backward;
        fix.owner.data_speed_strafe = fix.data_speed_strafe;
        fix.owner.data_speed_accel = fix.data_speed_accel;
      }
    }
  }
  player.stat_plr_rep = (self.reloadValue / self.reloadMax) * 100;
  
  if(end_repair){  
    player.burnBits = player.burnBits - (player.burnBits & fix.partTypeId);
    player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_BURN;
    fix.deadflag = DEAD_NO;
    self.ai_state_next = PLAYER_CONNECT;
  }
};

/*
  STATE: PLAYER_DEBRIEF
*/
void() building_repair_idle={
  if( self.ai_state == PLAYER_DEBRIEF && self.ai_state_last != PLAYER_DEBRIEF ){
    self.cockpit.touch = building_repair_touch;
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.burstRate = 1;
    if( self.ai_state_last != PLAYER_RESPAWN ){
      if( self.moveState == TRUE){
        //player's FL_NOSHOOT was only for the repair action, so we remove it now.
        self.trigger_field.flags = self.trigger_field.flags - (self.trigger_field.flags & FL_NOSHOOT);
         self.trigger_field.clientData.SendFlags = self.trigger_field.clientData.SendFlags | SENDFLAG_EFLAGS;
        self.moveState = FALSE;
      }
      self.goalentity = world;
      self.attack_state = 0;
      if(self.trigger_field != world){
        self.trigger_field.stat_plr_rep = -1;
        self.trigger_field = world;
      }
    }
    return;
  }
  building_repair_recharge_frame();
};

void() building_repair_cooldown={
  if( self.ai_state == PLAYER_RESPAWN && self.ai_state_last != PLAYER_RESPAWN ){
    if( self.moveState == TRUE){
      //player's FL_NOSHOOT was only for the repair action, so we remove it now.
      self.trigger_field.flags = self.trigger_field.flags - (self.trigger_field.flags & FL_NOSHOOT);
       self.trigger_field.clientData.SendFlags = self.trigger_field.clientData.SendFlags | SENDFLAG_EFLAGS;
      self.moveState = FALSE;
    }
    client_send_event_repairs( self.trigger_field, FALSE );
    self.trigger_field.stat_plr_rep = -1;
    self.goalentity = world;
    self.attack_state = 0;
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.burstRate = 2;
    if(self.trigger_field != world){
      self.trigger_field.stat_plr_rep = -1;
      self.trigger_field = world;
    }
    if( skill < SKILL_VET ){
      self.ai_movedist = time + 15;
    }
    else if( skill == SKILL_VET ){
      self.ai_movedist = time + 25;
    }
    else{
      self.ai_movedist = time + 35;
    }
  }
  building_repair_recharge_frame();
  if( time > self.ai_movedist ){
    self.ai_state_next = PLAYER_DEBRIEF;
  }
};

void() building_repair_attack={
  if( self.ai_state == PLAYER_SPRINT_ON && self.ai_state_last != PLAYER_SPRINT_ON ){
    
  }

};
//===========================================================================

void(entity item) building_repair_item_legs={

};

void() building_repair_touch;

void() hrepair_die = [0, hrepair_die1]{
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD; 
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  ai_alert_close(self.enemy);
  
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
};


void() building_repair_state={
  self.ai_state_last = self.ai_state;
  self.ai_state = self.ai_state_next;
  
  switch(self.ai_state){
    case PLAYER_ACTIVE:
      building_repair_fixing();
      break;
      
    case PLAYER_RESPAWN:
      building_repair_cooldown();
      break;
      
    case PLAYER_SPRINT_ON:
      building_repair_attack();
      break;
    
    case PLAYER_CONNECT:
      building_repair_select();
      break;
      
    default:
      building_repair_idle();
      break;
  }
  
  building_burn();
    
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  self.think = building_repair_state;
  self.nextthink = time + 0.1;
};


/*QUAKED building_human_repair (0 0 1) (-53 -53 0) (53 53 80) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/repair/repair.md3"); }
[ADVISED] - put it near a power plant for more energy.

Repairs vehicles, mostly for player.
AI DOES NOT know how to use Repair Bays, sorry.

Health = 600. (default)

Energy Max = 1000 units. (default)
Energy Rate = 0.67 / 0.1 tic. (default)

Shield Max = 250. (default)
Shield Rate = 0. (default)

Repair Rate = 4 HP / 0.1 tic.
Repair Max = 1250 | 750 (default based on difficulty)

behavior: death() will severely damage any player standing in it when it finally kabooms

-------- KEYS -------- 
faction: <float> = 1, 2, 3 [REQUIRED]
targetname : <string>, used for trigger calls from other ents.
target : <string> name of ent to go to, usually a patrol node.
trigOnSpawn: <string> ent, fire this ENTITY when activated.
trigOnDeath: <string> target, fire this ENTITY when killed.
reloadMax: <float> max amount of repair charge.
reloadRate: <float> repair speed.
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_human_repair={
  
  self.data_idx = self.nextVecChoice = UI_BUILDING_repair_bay;
  self.data_type = DATA_BLD;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

  self.flags = self.flags | FL_MONSTER;
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  self.vec_name = "Repair Bay";
  self.vec_size = 3;
  macro_set_collider(DAMAGE_YES, SOLID_BSP, MOVETYPE_NONE)
  macro_set_model("q3mdl/buildings/repair_bay/mdl_repair_bay.md3", self.skin, EF_LOWPRECISION)
  setsize(self, '-53 -53 0', '53 53 80');
  
  if( !self.health ){
    self.health = self.max_health = 600;
  }

  if( !self.energy ){
    self.energy = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 1000;
  }
  if( !self.energyRate ){
    self.energyRate = 0.67;
  }
  
  if( !self.shield ){
    self.shield = 0;
  }
  if( !self.shieldMax ){
    self.shieldMax = 250;
  }
  self.shieldRate = 0.33;
  
  if( !self.reloadMax ){
    if( skill > SKILL_REG ){
      self.reloadMax = 750;
    }
    else{
      self.reloadMax = 1250;
    }
  }
  
  if( !self.reloadValue ){
    self.reloadValue = self.reloadMax;
  }

  if( !self.reloadRate ){
    self.reloadRate = 4;
  }

  self.nextthink = time + 0.1;
  self.use = multi_trigger;
  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  
  makevectors(self.angles);
  self.compOffset = self.origin + (v_forward * -20) + (v_up * 30) + (v_right * 4);
  local entity repairNode, this;
  this  = self;
  repairNode = spawn();
  repairNode.effects = repairNode.effects | EF_NODRAW;
  repairNode.touch = building_repair_touch;
  repairNode.owner = this;
  this.cockpit = repairNode;
  self = repairNode;
    util_setModel("q3mdl/testball.md3", repairNode.skin, EF_LOWPRECISION) ;
    util_setCollider(FALSE, SOLID_TRIGGER, MOVETYPE_NONE) ;
    util_setHealthArmor(0, 0, 0, 0) ;
  self = this;
  setsize(repairNode, '-8 -8 -16', '8 8 16');
  setorigin(repairNode, this.compOffset);
  
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.compAltOffset = self.origin;
  self.th_die = hrepair_die;
    
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  self.ai_state_next = PLAYER_DEBRIEF;
  self.think = building_repair_state;
  self.nextthink = time + 0.1;
};

void() building_repair_touch={
  if( !(other.flags & FL_CLIENT) ){
    return;
  }
  if( self.owner.trigger_field != world ){
    return;
  }
  if(util_getMechHpAverage(other) >= 1){
    return;
  }
  if( self.owner.ai_state != PLAYER_DEBRIEF ){
    //repair either already has a client, or is cooling off
    return;
  }
  if(other.faction != self.owner.faction){
    //TODO -> repair bay will 'attack' by deconstructing your mech >:|
    return;
  }
  self.owner.trigger_field = other;
  self.owner.ai_state_next = PLAYER_CONNECT;
  self.touch = SUB_Null;
};

void() hrepair_die1 = [1, hrepair_die2]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
void() hrepair_die2 = [2, hrepair_die3]{};
void() hrepair_die3 = [3, hrepair_die4]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
void() hrepair_die4 = [4, hrepair_die5]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
void() hrepair_die5 = [5, hrepair_die6]{};
void() hrepair_die6 = [6, hrepair_die7]{};
void() hrepair_die7 = [7, hrepair_die8]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
};
void() hrepair_die8 = [8, hrepair_die9]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
};
void() hrepair_die9 = [9, hrepair_die10]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
};
void() hrepair_die10 = [10, hrepair_die11]{};
void() hrepair_die11 = [11, hrepair_die12]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
};
void() hrepair_die12 = [12, hrepair_die13]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
void() hrepair_die13 = [13, hrepair_die14]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
void() hrepair_die14 = [14, hrepair_die15]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
};
void() hrepair_die15 = [15, hrepair_die16]{};
void() hrepair_die16 = [16, SUB_Null]{
  local vector ouch;
  if( self.trigger_field != world ){
    ouch = randompos( self.trigger_field.absmin, self.trigger_field.absmax);
    t_damage( self.trigger_field, self, world, random() * self.max_health, ouch, normalize(ouch - self.trigger_field.origin) * 1);
  }
};
