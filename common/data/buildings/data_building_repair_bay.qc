/*
battleMETAL
Author: Peter Roohr
Date: 3/21/2018
Overview: 
  data file for the human repair bay
*/

void() building_repair_touch;
void() building_repair_node_think;  //cool down to prevent spam of notifications.

void() hrepair_th = [0, hrepair_th]{
  self.energy = self.energy + self.energyRate;
  if( self.energy > self.energyMax ){
    self.energy = self.energyMax;
  }
  
  if( self.trigger_field.takedamage >= DAMAGE_YES){
    self.th_walk();
    return;
  }
  else{
    if( self.energy > self.energyRate ){
      self.reloadValue = self.reloadValue + self.reloadRate;
      self.energy = self.energy - self.reloadRate * 2;
      if(self.reloadValue > self.reloadMax){
        self.reloadValue = self.reloadMax;
      }
    }
  }
  building_burn();
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
};

void() hrepair_rep = [0, hrepair_rep]{
  local float end_repair;
  local entity repairMe,fix;
  local entity part;
  local float lowHP;
  local float hp;
  local entity altSelf;
  
  fix = world;
  end_repair = TRUE;
  altSelf = self;
  
  if( self.reloadValue < 0  ){
    self.cockpit.ai_movedist = time + 30;
    self.think = hrepair_th;
    self.nextthink = time + 0.1;
    self.cockpit.attack_state = ST_MELEE;
    if( self.trigger_field ){
      client_send_event_repairs( self.trigger_field, FALSE ) ;
      if( self.startupDelay == FL_NOSHOOT ){
        self.trigger_field.flags = self.trigger_field.flags - (self.trigger_field.flags & FL_NOSHOOT);
      }
      self.trigger_field.stat_plr_rep = -1;
      self.trigger_field = world;
    }
    return;
  }
  
  if( self.cockpit.attack_state == ST_WALK ){
    if( vlen(self.trigger_field.origin - self.cockpit.origin) <= 32){
      repairMe = self.trigger_field;
      if(csqc_updateCompStat(repairMe) < 100){
        fix = repairMe;
      }
      else{
        part = repairMe.partNext;
        lowHP = 99.99;
        while(part){
          if( part.partTypeId != M_ITEM || part.partTypeId != M_CAMERA ){
            hp = csqc_updateCompStat(part);
            if( hp < lowHP){
              lowHP = hp;
              if( part.partTypeId == M_ARM_RIGHT && (repairMe.damageValue & M_TOR_RIGHT) ){
                fix = part.owner.torsoRight;
              }
              else if( part.partTypeId == M_ARM_LEFT && (repairMe.damageValue & M_TOR_LEFT) ){
                fix = part.owner.torsoLeft;
              }
              else{
                fix = part;
              }
            }
          }
          part = part.partNext;
        }
      }
      if( fix != world){
        self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
        end_repair = FALSE;
        self.compAltOffset = fix.origin;
        if( fix.deadflag == DEAD_NO ){
          fix.health = fix.health + self.reloadRate;
          self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (self.trigger_field.vec_size * 1.25));
        }
        else{
          fix.health = fix.health + self.reloadRate / 1.15;
          self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (self.trigger_field.vec_size * 1.75));
          if(fix.deadflag == DEAD_DEAD && fix.partTypeId != M_LEGS){
            self.deadflag = DEAD_DYING;
            if(fix.deadflag != DEAD_NO ){
              fix.deadflag = DEAD_NO;
              repairMe.damageValue = repairMe.damageValue - (repairMe.damageValue & fix.partTypeId);
              repairMe.critBits = repairMe.critBits - (repairMe.critBits & fix.partTypeId);
              
              if( (repairMe.flags & FL_CLIENT) ){
                repairMe.clientData.SendFlags = repairMe.clientData.SendFlags | SENDFLAG_CRIT;
              }
              
              part = repairMe.w_slot;
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
              if( !(fix.owner.damageValue & M_TOR_LEFT) ){
                fix.owner.shieldMax = fix.owner.shieldMax * 0.5;
              }
              if( !(fix.owner.damageValue & M_TOR_LEFT) ){
                fix.owner.shieldMax = fix.owner.shieldMax * 0.5;
              }
            }
          }
        }
        
        if(fix.health >= fix.max_health){
          fix.health = fix.max_health;
          if( fix.partTypeId == M_LEGS ){
            if( (fix.flags & FL_DISARMED) ) {
              fix.flags = fix.flags - (fix.flags & FL_DISARMED);
              fix.owner.data_speed_forward = fix.data_speed_forward;
              fix.owner.data_speed_backward = fix.data_speed_backward;
              fix.owner.data_speed_strafe = fix.data_speed_strafe;
              fix.owner.data_speed_accel = fix.data_speed_accel;
            }
          }
        }
        //really dumb fix, sorry
        if( (fix.owner.flags & FL_CLIENT) ){
          fix.owner.stat_plr_rep = (self.reloadValue / self.reloadMax) * 100;
        }
        else{
          fix.stat_plr_rep = (self.reloadValue / self.reloadMax) * 100;
        }
      }
    }
  }

  if(end_repair && self.cockpit.attack_state == ST_WALK ){
    client_send_event_repairs( self.trigger_field, FALSE ) ;
    if( self.startupDelay == FL_NOSHOOT ){
      self.trigger_field.flags = self.trigger_field.flags - FL_NOSHOOT;
    }
    self.trigger_field.stat_plr_rep = -1;
    
    part = repairMe.partNext;
    while(part){
      if( part.partTypeId != M_ITEM || part.partTypeId != M_CAMERA ){
        if(part.deadflag != DEAD_NO && part.health > 0){
          part.deadflag = DEAD_NO;
          self.trigger_field.critBits = self.trigger_field.critBits - (self.trigger_field.critBits & part.partTypeId);
        }
      }
      part = part.partNext;
    }
    
    self.trigger_field = world;
    self.th_stand();
    self.cockpit.think = building_repair_node_think;
    self.cockpit.nextthink = time + 3;
    self.cockpit.attack_state = ST_MELEE;
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  }
};

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
void() hrepair_die1 = [1, hrepair_die2]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
};
void() hrepair_die2 = [2, hrepair_die3]{};
void() hrepair_die3 = [3, hrepair_die4]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
};
void() hrepair_die4 = [4, hrepair_die5]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
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
};
void() hrepair_die13 = [13, hrepair_die14]{
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
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
  self.flags = self.flags | FL_MONSTER;
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }

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
  repairNode.deadflag = DEAD_NO;
  repairNode.trigger_field = world;
  repairNode.owner = this;
  this.cockpit = repairNode;
  self = repairNode;
    util_setModel("q3mdl/testball.md3", repairNode.skin, EF_LOWPRECISION) ;
    util_setCollider(FALSE, SOLID_TRIGGER, MOVETYPE_NONE) ;
    util_setHealthArmor(0, 0, 0, 0) ;
  self = this;
  setsize(repairNode, '-8 -8 -24', '8 8 32');
  setorigin(repairNode, this.compOffset);
  
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.compAltOffset = self.origin;
  self.th_die = hrepair_die;
  self.th_stand = hrepair_th;
  self.th_walk = hrepair_rep;
    
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;  
  if( (self.spawnflags & IT_QUAD) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
    
  self.think = hrepair_th;
  self.nextthink = time + 1;
};

void() building_repair_touch={
  if( !(other.flags & FL_CLIENT) ){
    return;
  }
  if( self.owner.trigger_field != world ){
    return;
  }
  if(other.faction != self.owner.faction){
    return;
  }
  if(util_getMechHpAverage(other) >= 1){
    return;
  }
  if( self.attack_state == ST_WALK ){
    return;
  }
  if( time > self.ai_movedist ){
    if(self.owner.reloadValue <= 0){
      self.ai_movedist = time + 20;
      return;
    }
  }
  other.energy = other.energy + (other.energyRate * 0.45);
  if( other.energy > other.energyMax ){
    other.energy = other.energyMax;
  }
  
  
  self.owner.trigger_field = other;
  
  if( !(other.flags & FL_NOSHOOT) ){
    other.flags = other.flags | FL_NOSHOOT;
    self.owner.startupDelay = FL_NOSHOOT;
  }
  client_send_event_repairs( self.owner.trigger_field, TRUE );
  self.touch = SUB_Null;
  self.attack_state = ST_WALK;
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_VELOCITY);
};

void() building_repair_node_think={
  self.touch = building_repair_touch;
  self.attack_state = ST_STAND;
};  //cool down to prevent spam of notifications.

void() building_repair_die={
  self.cockpit.trigger_field = world;
  remove(self.cockpit);
  building_die();
};