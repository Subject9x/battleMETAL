/*
battleMETAL
Author: Peter Roohr
Date: 9/3/2016
mod: 09/05/2019
Overview: 
  I pulled the ImpulseCommands() function out to its own
  file....
*/

//new commands
void() cycleWeaponGroup={};
void() cycleWeaponGroupReverse={};
void() switchFireMode={};
void() selectTarget={};
void() toggerRadar={};

void() playerAttack={
  local entity wep_chain, oself;
  local float weaponGroup;
  local float wgrp;
  
  if( (self.flags & FL_NOSHOOT) ){
    return;
  }
  
  weaponGroup = 0;
  if( self.stat_plr_fir == FIRE_CHAIN ){
    if( self.button0 || self.button3 ){
      if( time > self.chainWeaponTimer ){
        self.currentWeaponGroup = rint(self.currentWeaponGroup * 2);
        if( self.currentWeaponGroup > 256 ){
          self.currentWeaponGroup = 1;
        }
        weaponGroup = self.currentWeaponGroup;
        self.chainWeaponTimer = time + CHAIN_FIRE_INTERVAL;
      }
    }
  }
  else{
    if(self.button0){
      weaponGroup = self.currentWeaponGroup;  
    }
    else{
      if(self.button3){
        weaponGroup = weaponGroup | self.w_group1;
      }
      if(self.button4){
        weaponGroup = weaponGroup | self.w_group2;
      }
      if(self.button5){
        weaponGroup = weaponGroup | self.w_group3;
      }
      if(self.button6){
        weaponGroup = weaponGroup | self.w_group4;
      }
    }
  }
  oself = self;
  wep_chain = self.w_slot;
  while(wep_chain){
    wgrp = wep_chain.w_group;
    if( wep_chain.w_attack ){
      if( (weaponGroup > 0) && (self.playerState == PLAYER_ACTIVE) ){
        if( (weaponGroup & wgrp) ){
          if(wep_chain.wepReloadState == READY || wep_chain.wepReloadState == WAITING){
            self = wep_chain;
              self.w_attack();
            self = oself;
          }
        }
        else{
          if(wep_chain.w_isburst == TRUE){
            if(wep_chain.wepReloadState == READY){
              self = wep_chain;
                self.w_attack();
              self = oself;
            }
          }
        }
      }
      else{
        if(wep_chain.w_isburst == TRUE){
          if(wep_chain.wepReloadState == READY){
            self = wep_chain;
              self.w_attack();
            self = oself;
          }
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};

void() ImpulseCommands ={
  local entity client;
  local entity tmp;

  client = self;
  
  if(self.impulse == IMP_FGROUP){
    self.stat_plr_fir = FIRE_GROUP;
    self.currentWeaponGroup = 0;
  }
  if(self.impulse == IMP_FCHAIN){
    self.stat_plr_fir = FIRE_CHAIN;
    self.currentWeaponGroup = 1;
  }
  
  if(self.impulse == IMP_WGROUP1){
    if( self.stat_plr_fir == FIRE_GROUP ){
      self.currentWeaponGroup = self.w_group1;
    }
  }
  if(self.impulse == IMP_WGROUP2){
    if( self.stat_plr_fir == FIRE_GROUP ){
      self.currentWeaponGroup = self.w_group2;
    }
  }
  if(self.impulse == IMP_WGROUP3){
    if( self.stat_plr_fir == FIRE_GROUP ){
      self.currentWeaponGroup = self.w_group3;
    }
  }
  if(self.impulse == IMP_WGROUP4){
    if( self.stat_plr_fir == FIRE_GROUP ){
      self.currentWeaponGroup = self.w_group4;
    }
  }
  if(self.impulse == IMP_FSINGLE){
    self.stat_plr_fir = FIRE_SINGLE;
  }
  
  if(self.impulse == IMP_PRVWGRP){
    self.aState = self.aState - 1;
    if(self.aState < 1){
      self.aState = 5;
    }
    mpls_groupFire(self.aState);
  }
  if(self.impulse == IMP_NEXWGRP){
    self.aState = self.aState + 1;
    if(self.aState > 5){
      self.aState = 1;
    }
    mpls_groupFire(self.aState);
  }
  
  
  if(self.impulse == IMP_TARGET){
    sv_getTarget();
  }
  
  if(self.impulse == IMP_RADAR){
    if( self.stat_rdr_mode == TRUE ){
      //set to passive
      self.stat_rdr_mode = FALSE;
      self.stat_rdr_rng = self.radar_range;
    }
    else{
      //set to active
      self.stat_rdr_mode = TRUE;
      if(self.stat_rdr_rng != self.radar_range * 2){
        self.stat_rdr_rng = self.radar_range * 2;
      }
    }
    self.SendFlags = self.SendFlags | SENDFLAG_RADAR;
  } 

  if(self.impulse == IMP_SLIDE){
    if( time > self.ramCool ){
      if( self.ramUp >= self.ramUpMax ){
        if( self.energy >= (self.energyMax * (self.ramUpMax / 25)) ){
          self.ramCharge = time + (self.ramUp / 2);
          self.ramPower_x = self.data_speed_forward * 4;  //really not sure how this got broken... 5/23/2025
          self.ramPower_y = 0;
          self.ramPower_z = -15;
          self.ramVelocity = self.velocity;
          self.ramAngle_y = self.v_angle_y;
          self.ramTracker = self.ramCharge;
          self.energy = self.energy - (self.energyMax * (self.ramUpMax / 25));
        }
      }
    }
    else{
      self.ramUp = 0;
    }
  }

  // if(self.impulse == IMP_FAC_NEXT){
  //   self.faction = self.faction + 1;
  //   if( self.faction > 3 ){
  //     self.faction = 1;
  //   }
  //   if( self.data_type == DATA_MECH ){
  //     client_update_faction();
  //   }
  //   else{
  //     if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
  //       self.data_type = DATA_POBS;
  //       PutClientInServer();
  //     }
  //   }
  //   self.SendFlags = self.SendFlags | SENDFLAG_FACTION;
  // }
  
  // if(self.impulse == IMP_FAC_PREV){
  //   self.faction = self.faction - 1;
  //   if( self.faction < 1 ){
  //     self.faction = 3;
  //   }
  //   if( self.data_type == DATA_MECH ){
  //     client_update_faction();
  //   }
  //   else{
  //     if( ENT_SERVER_INFO.gameType == GAMEMODE_DM ){
  //       self.data_type = DATA_POBS;
  //       PutClientInServer();
  //     }
  //   }
  //   self.SendFlags = self.SendFlags | SENDFLAG_FACTION;
  // }

      // local entity e;
    // //debug

    // makevectors(self.v_angle);
    // traceline(self.origin, self.origin + (v_forward * 1024), TRUE, self);

    // e = findradius(trace_endpos, 32);
    // while(e){
    //   cons_logAVector(e.classname, e.origin);
    //   e = e.chain;
    // }

  if(self.impulse == IMP_EXTERNAL_CAMERA){
    if(self.chaseActive){
      self.chaseActive = FALSE;
    }
    else{
      self.chaseActive = TRUE;
    }
    self.SendFlags = self.SendFlags | SENDFLAG_CAMERA;
  }

  if(self.impulse == IMP_HEADLIGHT){
    if(self.headlight){
      self.headlight = FALSE;
    }
    else{
      self.headlight = TRUE;
    }
    self.SendFlags = self.SendFlags | SENDFLAG_CAMERA;
  }

  if(self.impulse == IMP_CHEAT_KILL){
    if(self.enemy){
      t_damage(self.enemy, self, self, self.enemy.max_health, self.enemy.origin, '0 0 0');
    }
  }

  if(self.impulse == IMP_CHEAT_WIN){
    if(cvar("gamemode") == GAMEMODE_CAMPAIGN){
      tmp = findchain(classname, "map_objective");
      while(tmp){
        if(tmp.faction == self.faction){
          tmp.think = tmp.use;
          tmp.nextthink = time;
        }
        tmp = tmp.chain;
      }
    }
  }

	self.impulse = 0;
};

/*
  Button commands are hold-on, off actions useful for input-over-time actions.
  they use a smaller palette of buttons defined in defs/ dpdefs
  .button0 - .button16
*/
void() ButtonCommands={
  //action mapping: +sprint 
  if( (self.unitModFlags & MOD_HAS_RAMSHOCKS) ){
    if( self.button8 ){
      if( self.energy > 0 && !(self.legs_flags & FL_DISARMED)){
        if( self.playerState == PLAYER_ACTIVE ){
          self.ramAngle_y = self.v_angle_y;
          if( (self.movement_x || self.movement_y) ){
            self.moveState = MOVE_SPRINT;
          }
        }
      }
    }
  }
  
  //action mapping: +zoom / -zoom
  if( self.button9 ){
    if( self.viewzoom > 0.25 ){
      self.viewzoom = self.viewzoom - 0.25;
    }
  }
  
  //action mapping: +regen
  if( time > self.shieldHitRegen ){
    if( (self.unitModFlags & MOD_HAS_SHIELD) ){
      if(self.button10 && (cvar("gamemode") == GAMEMODE_CAMPAIGN) ){
        if( self.energy >= (self.energyMax * 0.15) ){
          if( self.shield < self.shieldMax ){
            self.shield = self.shield + ((self.shieldRate + (self.shieldRate * self.shieldRateMod)) * 0.25);
            //1.15 - v5.4.0
            self.energy = self.energy - (self.shieldRate * 1.05);  //iirc, shield recharge module doesn't charge for the buff cost.
            self.energy = bound(0, self.energy, self.energyMax);
          }
        }
      }
    }
  }
};

void(float selector) mpls_groupFire={
  switch(selector){
    case 1:
      self.aState = 1;
      centerprint(self, "[Weapon Group 1]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group1;
      break;
    case 2:
      self.aState = 2;
      centerprint(self, "[Weapon Group 2]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group2;
      break;
    case 3:
      self.aState = 3;
      centerprint(self, "[Weapon Group 3]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group3;
      break;
    case 4:
      self.aState = 4;
      centerprint(self, "[Weapon Group 4]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group4;
      break;
  }
};