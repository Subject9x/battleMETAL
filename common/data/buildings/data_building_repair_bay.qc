/*
battleMETAL
Author: Peter Roohr
Date: 3/21/2018
rebuild: 10/03/2020 - get it? the repair bay needed...repairing!?
Overview: 
  data file for the human repair bay.
  
  Refactored to use proper state system where repairBay.playerState will be used.
  
  REPAIR_STATE_FIXING = repair is actively repairing a specific part
  
  REPAIR_STATE_START = repair part filtering
  
  REPAIR_STATE_COOLDOWN  = repair bay cooldown
  
  REPAIR_STATE_IDLE = idle, recharge .reloadValue
*/

#define REPAIR_STATE_START 1
#define REPAIR_STATE_FIXING 2
#define REPAIR_STATE_IDLE 3
#define REPAIR_STATE_COOLDOWN 4

#ifdef SSQC
void() building_repair_touch;

/*
  util to correctly set player FL_NOSHOOT state
*/
void(float toggleGuns) building_repair_allowGuns={
  local entity player, data;
  player = self.ladder_entity;
  
  if( (player.flags & FL_CLIENT) ){
    data = player.clientData;
    if(toggleGuns){
      player.flags = player.flags - (player.flags & FL_NOSHOOT);
    }
    else{
      player.flags = player.flags | FL_NOSHOOT;
    }
  }
  else{
    player.flags = player.flags | FL_DISARMED;
  }

  data.SendFlags = data.SendFlags | SENDFLAG_EFLAGS;
};

void() building_repair_touch;

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
  STATE: REPAIR_STATE_START
*/
void() building_repair_select={
  local entity player;
  local float lowHP;
  local float hp;
  local float typeId;
  
  if( self.ai_state == REPAIR_STATE_START && self.ai_state_last != REPAIR_STATE_START ){
    self.burstRate = 0;
    //fresh repair event
    if( self.reloadValue <= 0 ){
      //cut over to cooldown state;
      self.ai_state_next = REPAIR_STATE_COOLDOWN;
      return;
    }
    
    //player dead or exited repair bay
    if(self.goalentity == world || self.goalentity.deadflag != DEAD_NO){
      self.ai_state_next = REPAIR_STATE_COOLDOWN;
      return;
    }
    else{
      player = self.goalentity;
    }
    self.critBits = 0;
    self.attack_state = 0;
    if(player.health < player.max_health * 0.8){
      typeId = M_TOR_CENTER;
    }
    else{
      lowHP = 99.99;
      if( player.criticalHits != 0 ){
        //prioritize blown off sections first
        if( (player.criticalHits & M_LEGS) ){
          typeId = M_LEGS;
        }
        else if( (player.criticalHits & M_TOR_LEFT) ){
          typeId = M_TOR_LEFT;
        }
        else if( (player.criticalHits & M_TOR_RIGHT) ){
          typeId = M_TOR_RIGHT;
        }
        else if( (player.criticalHits & M_ARM_LEFT) ){
          typeId = M_ARM_LEFT;
        }
        else if( (player.criticalHits & M_ARM_RIGHT) ){
          typeId = M_ARM_RIGHT;
        }
        self.attack_state = TRUE; //marks that we're repairing up FROM a critical
      }
      else{
        //then find most-damaged part
        if( player.legs_hp < player.legs_hpMax * 0.75 ){
          typeId = M_LEGS;
        }
        else if( player.torL_hp < player.torL_hpMax * 0.85) {
          typeId = M_TOR_LEFT;
        }
        else if( player.torR_hp < player.torR_hpMax * 0.85) {
          typeId = M_TOR_RIGHT;
        }
        else if( player.armL_hp < player.armL_hpMax * 0.5) {
          typeId = M_TOR_LEFT;
        }
        else if( player.armR_hp < player.armR_hpMax * 0.5) {
          typeId = M_TOR_RIGHT;
        }
        else{
          if( (player.armR_hp < player.armR_hpMax) && player.armR_hp < player.armL_hp ){
            typeId = M_ARM_RIGHT;
          }
          else if( (player.armL_hp < player.armL_hpMax) && player.armL_hp < player.armR_hp ){
            typeId = M_ARM_LEFT;
          }
          else{
            if( player.armR_hp < player.armL_hpMax ){
              typeId = M_ARM_RIGHT;
            }
            else if( player.armL_hp < player.armL_hpMax ){
              typeId = M_ARM_LEFT;
            }
          }
        }
      }
    }
    self.critBits = typeId;
    if( self.critBits == 0 ){
      //nothing to actually repair;
      self.ai_state_next = REPAIR_STATE_IDLE;
      self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
      return;
    }
    
    //smooth transitions between repairing pieces.
    if(self.ai_state_last != REPAIR_STATE_FIXING){
      building_repair_allowGuns(FALSE);
      client_send_event_repairs(player, TRUE);
    }
    self.moveState = TRUE;
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.ai_state_next = REPAIR_STATE_FIXING;
  }
};

/*
  STATE: REPAIR_STATE_FIXING  
*/
void() building_repair_fixing={
  local entity player;
  local float end_repair;
  local entity part;
  local entity altSelf;
  
  if( self.reloadValue <= 0 ){
    //cut over to cooldown state;
    self.ai_state_next = REPAIR_STATE_COOLDOWN;
    return;
  }

  if(self.goalentity == world || self.goalentity.deadflag != DEAD_NO){
    self.ai_state_next = REPAIR_STATE_COOLDOWN;
    return;
  }
  else{
    player = self.goalentity;
  }
  
  if(vlen(player.origin - self.origin) > player.maxs_x){
    //player walked away from node
    self.ai_state_next = REPAIR_STATE_COOLDOWN;
    return;
  }
  
  //ENTER STATE------------------------------------------
  if( self.ai_state == REPAIR_STATE_FIXING && self.ai_state_last != REPAIR_STATE_FIXING ){
    if(self.critBits == FALSE){
      //error out
      self.ai_state_next = REPAIR_STATE_COOLDOWN;
      return;
    }
    self.burstRate = 0;
  }
  //------------------------------------------------------
  altSelf = self;
  //energ recharge freebie
  player.energy = player.energy + (player.energyRate * 0.85);
  if( player.energy > player.energyMax ){
    player.energy = player.energyMax;
  }
  
  end_repair = FALSE;
  
  //fix 'client' / aka CT
  if( self.critBits == M_TOR_CENTER ){
    //part is not critical'd, repair as normal.
    player.health = min(player.health + self.reloadRate, player.max_health);
    self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (player.vec_size * 1.25));
    if( player.health >= player.max_health ){
      end_repair = TRUE;
    }
  }
  else{
    self.reloadValue = self.reloadValue - ( (self.reloadRate / 2) * (player.vec_size * 1.25));
    switch(self.critBits){
      case M_LEGS:
        player.legs_hp = min(player.legs_hp + self.reloadRate / 1.15, player.legs_hpMax);
        if( player.legs_hp == player.legs_hpMax ){
          end_repair = TRUE;
        }
        break;
      case M_TOR_LEFT:
        player.torL_hp = min(player.torL_hp + self.reloadRate / 1.15, player.torL_hpMax);
        if( player.torL_hp == player.torL_hpMax ){
          end_repair = TRUE;
        }
        break;
      case M_TOR_RIGHT:
        player.torR_hp = min(player.torR_hp + self.reloadRate / 1.15, player.torR_hpMax);
        if( player.torR_hp == player.torR_hpMax ){
          end_repair = TRUE;
        }
        break;
      case M_ARM_LEFT:
        player.armL_hp = min(player.armL_hp + self.reloadRate / 1.15, player.armL_hpMax);
        if( player.armL_hp == player.armL_hpMax ){
          end_repair = TRUE;
        }
        break;
      case M_ARM_RIGHT:
        player.armR_hp = min(player.armR_hp + self.reloadRate / 1.15, player.armR_hpMax);
        if( player.armR_hp == player.armR_hpMax ){
          end_repair = TRUE;
        }
        break;
    }
    if( (player.criticalHits & self.critBits) && self.attack_state){
      self.attack_state = FALSE;
      player.critBits = player.critBits | (M_REPAIR | self.critBits);
      if( (player.flags & FL_CLIENT) ){
        player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_CRIT;
      }
      else{
        player.SendFlags = player.SendFlags | SENDFLAG_CRIT;
      }
      part = player.w_slot;
      while( part != world ){
        if( part.partParentId == self.critBits && part.deadflag != DEAD_NO ){
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
      //repair shield/side torso debuff
      if( self.critBits == M_TOR_LEFT ) {
        if( player.torL_hp > player.torL_hpMax * 0.5){
          player.shieldMax = player.shieldMax * 0.5;
        }
      }
      else if( self.critBits == M_TOR_RIGHT ){
        if( player.torR_hp > player.torR_hpMax * 0.5){
          player.shieldMax = player.shieldMax * 0.5;
        }
      }
      if( self.critBits == M_LEGS ){
        player.data_speed_forward = player.cache_speed_fwd;
        player.data_speed_backward = player.cache_speed_back;
        player.data_speed_strafe = player.cache_speed_sid;
      }
    }
    
  }
  player.stat_plr_rep = (self.reloadValue / self.reloadMax) * 100;
  
  if(end_repair){
  
    player.burnBits = player.burnBits - (player.burnBits & self.critBits);
    if( (player.flags & FL_CLIENT) ){
      player.clientData.SendFlags = player.clientData.SendFlags | SENDFLAG_BURN;
    }
    else{
      player.SendFlags = player.SendFlags | SENDFLAG_BURN;
    }
    self.ai_state_next = REPAIR_STATE_START;
  }
};

/*
  STATE: REPAIR_STATE_IDLE
*/
void() building_repair_idle={
  if( self.ai_state == REPAIR_STATE_IDLE && self.ai_state_last != REPAIR_STATE_IDLE ){
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.burstRate = 1;
    
    if( self.ai_state_last != REPAIR_STATE_COOLDOWN ){
      if(self.ladder_entity != world){
        building_repair_allowGuns(TRUE);
        client_send_event_repairs( self.goalentity, FALSE );
      }
      self.critBits = 0;
      if(self.goalentity != world){
        self.goalentity.stat_plr_rep = -1;
        self.goalentity = world;
        self.ladder_entity = world;
      }
    }
    return;
  }
  building_repair_recharge_frame();
};

/*
  STATE: REPAIR_STATE_COOLDOWN
*/
void() building_repair_cooldown={
  if( self.ai_state == REPAIR_STATE_COOLDOWN && self.ai_state_last != REPAIR_STATE_COOLDOWN ){
    self.moveState = FALSE;
    building_repair_allowGuns(TRUE);
    client_send_event_repairs( self.goalentity, FALSE );
    self.goalentity.stat_plr_rep = -1;
    self.critBits = 0;
    self.SendFlags = self.SendFlags | SENDFLAG_EXDATA;
    self.burstRate = 2;
    if(self.goalentity != world){
      self.goalentity.stat_plr_rep = -1;
      self.goalentity = world;
      self.ladder_entity = world;
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
    self.ai_state_next = REPAIR_STATE_IDLE;
  }
};

void() building_repair_attack={
  if( self.ai_state == PLAYER_SPRINT_ON && self.ai_state_last != PLAYER_SPRINT_ON ){
    
  }

};
//===========================================================================

void() building_repair_touch;




void() building_repair_state={
  self.ai_state_last = self.ai_state;
  self.ai_state = self.ai_state_next;
  
  switch(self.ai_state){
    case REPAIR_STATE_FIXING:
      building_repair_fixing();
      break;
      
    case REPAIR_STATE_COOLDOWN:
      building_repair_cooldown();
      break;
      
    case PLAYER_SPRINT_ON:
      building_repair_attack();
      break;
    
    case REPAIR_STATE_START:
      building_repair_select();
      break;
      
    case REPAIR_STATE_IDLE:
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
#endif
void() hrepair_die;

#ifdef CSQC
void() repair_bay_dlights={
  local vector lightColor;
  local float lightStyle;
  
  makevectors(self.angles);
  
  if( self.deadflag == DEAD_NO ){
    if( self.faction == CLIENT_faction ){
      if( self.burstRate == 1 ){
        lightColor = '0.25 0.95 0.35';
        lightStyle = 11;
      }
      else if( self.burstRate == 2 ){
        lightColor = '1 0.6 0';
        lightStyle = 6;
      }
      else{
        lightColor = '0.25 0.25 0.25';
        lightStyle = 1;
      }
    }
    else{
      if( self.burstRate > 0 ){
        lightColor = '0 0 0';
        lightStyle = 1;
      }
      else{
        lightColor = '0.95 0.25 0.15';
        lightStyle = 4;
      }
    }    //apparently when menu running, these just get STACCCCCCKED and murder framerate.
    if(MENU_PROG_OFF){  
      particleDraw = vlen(client_vis_org - self.origin);      
      if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2 ){  
        adddynamiclight2( self.origin, 256, lightColor, lightStyle, "", PFLAGS_FULLDYNAMIC); 
      }
    }
  }
};
void() sendevent_repair_beam={
  local vector partOfs;
  local vector beamEnd;
  
  particleDraw = vlen(client_vis_org - self.origin);      
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2 ){  
  
    switch(self.critBits){
      case M_ARM_LEFT:
        partOfs = self.enemy.armL_org;
        break;
        
      case M_ARM_RIGHT:
        partOfs = self.enemy.armR_org;
        break;
        
      case M_TOR_LEFT:
        partOfs = self.enemy.torL_org;
        break;
        
      case M_TOR_RIGHT:
        partOfs = self.enemy.torR_org;
        break;
        
      case M_LEGS:
        partOfs = self.enemy.legs_org;
        break;
        
      default:
        partOfs = self.enemy.torC_org;
        break;
    }
    beamEnd = partOfs;
    
    beamEnd_x = beamEnd_x + (crandom() * 2);
    beamEnd_y = beamEnd_y + (crandom() * 2);
    beamEnd_z = beamEnd_z + (crandom() * 2);
    
    pointparticles( particleeffectnum("TE_REPAIR_MUZZLE"), self.compOffset, normalize( beamEnd - self.compOffset ) * 2, 1);
    pointparticles( particleeffectnum("TE_REPAIR_IMPACT"), beamEnd, normalize( self.compOffset - beamEnd ) * -2, 1);
    trailparticles( world, particleeffectnum("TE_REPAIR_RAIL"), self.compOffset, beamEnd);
  }
};
void() repair_bay_active={
  
  if(self.enemy != world && self.critBits != 0){
    sendevent_repair_beam();
  }
  self.think = repair_bay_active;
  self.nextthink = time + 0.1;
};

void() repair_bay_idle={  
  self.think = repair_bay_idle;
  self.nextthink = time + 0.1;
};
#endif


void() building_repair_bay={
  
  self.data_idx = self.nextVecChoice = UI_BUILDING_repair_bay;
  self.data_type = DATA_BLD;
  
  self.flags = self.flags | FL_MONSTER;
  self.deadflag = DEAD_NO;
  
  self.vec_name = "Repair Bay";
  self.vec_size = 3;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "models/buildings/repair_bay/repairbay.md3";
  precache_model("models/buildings/repair_bay/repairbay.md3");
  setmodel(self, "models/buildings/repair_bay/repairbay.md3");
  setsize(self, self.mins, self.maxs);
  self.th_die = hrepair_die;
    
  if( !self.health ){
    self.health = self.max_health = 600;
  }
  self.max_health = self.health;

  if( !self.energyMax ){
    self.energyMax = 1000;
  }
  if( !self.energy ){
    self.energy = self.energyMax;
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
    if( cvar("skill") > SKILL_REG ){
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

#ifdef CSQC
  makevectors(self.angles);
  self.render_dlights = repair_bay_dlights;
  self.w_firetime = 0;
  self.compOffset = self.origin + (v_up * 40) + (v_forward * -16);
  self.compAltOffset = self.origin;
  self.th_walk = repair_bay_active;
#endif

#ifdef SSQC
    self.angles_y = self.angle;
  self.effects = self.effects | EF_LOWPRECISION;
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

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
  setorigin(self, self.origin);
  
  self.compOffset = self.origin;// + (v_forward * (self.maxs_x/2)) + (v_up * self.mins_z + 16) + (v_right * self.mins_y/2);
  self.touch = building_repair_touch;
  
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.compAltOffset = self.origin;
    
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  self.ai_state_next = REPAIR_STATE_IDLE;
  self.building_delay_think = building_repair_state;
  self.think = building_bbox_settle;
  self.nextthink = time + 0.01;
#endif
};

#ifdef SSQC
void() building_repair_touch={
  if( !(other.flags & FL_CLIENT) ){
    return;
  }
  if( self.goalentity != world ){
    return;
  }
  if(util_getMechHpAverage(other) >= 1){
    return;
  }
  if( self.ai_state != REPAIR_STATE_IDLE ){
    //repair either already has a client, or is cooling off
    return;
  }
  if(other.faction != self.faction){
    //TODO -> repair bay will 'attack' by deconstructing your mech >:|
    return;
  }
  if( vlen(other.origin - self.origin) > other.maxs_x){
    return;
  }
  self.goalentity = other;
  self.ladder_entity = other;   //cache here to check for player disconnects.
  self.ai_state_next = REPAIR_STATE_START;
  self.moveState = FALSE;
};
#endif

void() hrepair_die = [0, hrepair_die1]{
#ifdef SSQC
  if( self.deadflag > DEAD_NO ){
    return;
  }
  ai_alert_close(self.enemy);
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 0) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die1 = [1, hrepair_die2]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 4) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die2 = [2, hrepair_die3]{
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 8) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die3 = [3, hrepair_die4]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 12) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die4 = [4, hrepair_die5]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 16) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die5 = [5, hrepair_die6]{
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 20) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die6 = [6, hrepair_die7]{
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 24) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die7 = [7, hrepair_die8]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 28) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die8 = [8, hrepair_die9]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 32) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die9 = [9, hrepair_die10]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 2 );
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 36) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die10 = [10, hrepair_die11]{
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 40) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die11 = [11, hrepair_die12]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 48) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die12 = [12, hrepair_die13]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 52) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die13 = [13, hrepair_die14]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 56) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  building_sound_explode();
#endif
};
void() hrepair_die14 = [14, hrepair_die15]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
#endif
#ifdef CSQC
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 60) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );

  self.think = sendevent_building_die;
#endif
};
void() hrepair_die15 = [15, hrepair_die16]{};
void() hrepair_die16 = [16, SUB_Null]{
#ifdef SSQC
  local vector ouch;
  if( self.goalentity != world ){
    ouch = randompos( self.goalentity.absmin, self.goalentity.absmax);
    t_damage( self.goalentity, self, world, random() * self.max_health, ouch, normalize(ouch - self.goalentity.origin) * 1);
  }
  building_die();
#endif
};