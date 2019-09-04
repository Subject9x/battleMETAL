/*
battleMETAL
Author: Peter Roohr
Date: 9/3/2016
Overview: I pulled the ImpulseCommands() function out to its own
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
  local float wep_count, weaponGroup;
  
  if( (self.flags & FL_NOSHOOT) ){
    return;
  }
  
  weaponGroup = 0;
  if(self.button0){
    weaponGroup = self.currentWeaponGroup;
  }
  else{
    if(self.button3)
      weaponGroup = weaponGroup | self.w_group1;
    if(self.button4)
      weaponGroup = weaponGroup | self.w_group2;
    if(self.button5)
      weaponGroup = weaponGroup | self.w_group3;
    if(self.button6)
      weaponGroup = weaponGroup | self.w_group4;
    if(self.button7)
      weaponGroup = weaponGroup | self.w_group5;
  }
  
  oself = self;
  wep_chain = self.w_slot;
  wep_count = wep_chain.w_group;
  while(wep_chain){
    local float wgrp;
    wgrp = wep_chain.w_group;
    if( (weaponGroup > 0) && ( (self.stat_plr_stt == PLAYER_ACTIVE) || (self.stat_plr_stt == PLAYER_SPRINT_ON) )){
      if( (weaponGroup& wgrp) ){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = oself;
        }
      }
      else{
        if(wep_chain.w_isburst == TRUE){
          if(wep_chain.w_state == READY){
            self = wep_chain;
              self.w_attack();
            self = oself;
          }
        }
      }
    }
    else{
      if(wep_chain.w_isburst == TRUE){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = oself;
        }
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};

void() ImpulseCommands ={
    
  if(self.impulse == IMP_FGROUP){
    self.stat_plr_fir = FIRE_GROUP;
  }
  if(self.impulse == IMP_FCHAIN){
    self.stat_plr_fir = FIRE_CHAIN;
    self.currentWeaponGroup = 1;
  }
  if(self.impulse == IMP_FSINGLE){
    self.stat_plr_fir = FIRE_SINGLE;
  }
  
  if(self.impulse == IMP_PRVWGRP){
    self.state_1 = self.state_1 - 1;
    if(self.state_1 < 1){
      self.state_1 = 5;
    }
    mpls_groupFire(self.state_1);
  }
  if(self.impulse == IMP_NEXWGRP){
    self.state_1 = self.state_1 + 1;
    if(self.state_1 > 5){
      self.state_1 = 1;
    }
    mpls_groupFire(self.state_1);
  }

  if(self.stat_plr_fir == FIRE_SINGLE){
    //mpls_singleFire();
  }
  if(self.stat_plr_fir == FIRE_GROUP){
  }

  if(self.impulse == IMP_TARGET){
    sv_getTarget();
  }
  
  if(self.impulse == IMP_RADAR){
    if( self.stat_rdr_mode == TRUE ){
      self.stat_rdr_mode = FALSE;
      self.stat_rdr_rng = self.radar_range;
    }
    else{
      self.stat_rdr_mode = TRUE;
      if(self.stat_rdr_rng != self.radar_range * 2){
        self.stat_rdr_rng = self.radar_range * 2;
      }
    }
  } 

	self.impulse = 0;
};

void() ButtonCommands={
  if( self.button8 ){
    if( self.energy > 0 && !(self.legs.flags & FL_DISARMED)){
      if( self.stat_plr_stt == PLAYER_ACTIVE ){
        self.stat_plr_stt = PLAYER_SPRINT_ON;
        client_update_moveSpeed(self.data_speed_forward * self.data_speed_accel, self.data_speed_strafe * self.data_speed_accel, self.data_speed_backward * self.data_speed_accel, ftos(self.data_speed_accel), self.hud_rollangle);
      }
    }
  }
  
  if( self.button9 ){
    if( self.viewzoom > 0.25 ){
      self.viewzoom = self.viewzoom - 0.25;
    }
  }
};

void() mpls_singleFire={

};

void(float selector) mpls_groupFire={
  switch(selector){
    case 1:
      self.state_1 = 1;
      centerprint(self, "[Weapon Group 1]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group1;
      break;
    case 2:
      self.state_1 = 2;
      centerprint(self, "[Weapon Group 2]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group2;
      break;
    case 3:
      self.state_1 = 3;
      centerprint(self, "[Weapon Group 3]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group3;
      break;
    case 4:
      self.state_1 = 4;
      centerprint(self, "[Weapon Group 4]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group4;
      break;
    case 5:
      self.state_1 = 5;
      centerprint(self, "[Weapon Group 5]");
      self.currentWeaponGroup = 0;
      self.currentWeaponGroup = self.w_group5;
      break;
  }

};