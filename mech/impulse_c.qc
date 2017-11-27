/*
mech Mod
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
  local float wep_count;
  oself = self;
  wep_chain = self.w_slot;
  wep_count = wep_chain.w_group;
  while(wep_chain){
    local float wgrp;
    wgrp = wep_chain.w_group;
    if(self.button0){
      if((self.currentWeaponGroup & wgrp)){
        if(wep_chain.w_state == READY){
          self = wep_chain;
            self.w_attack();
          self = oself;
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
    self.impulse =  mpls_changeGroup();
  }
  if(self.impulse == IMP_NEXWGRP){
    self.state_1 = self.state_1 + 1;
    if(self.state_1 > 5){
      self.state_1 = 1;
    }
    self.impulse = mpls_changeGroup();
  }
  if(self.state_1 < 1){
    self.state_1 = 5;
  }
  else if (self.state_1 > 5){
    self.state_1 = 1; 
  }

  if(self.stat_plr_fir == FIRE_SINGLE){
    //mpls_singleFire();
  }
  if(self.stat_plr_fir == FIRE_GROUP){
    mpls_groupFire();
  }
  
  if(self.impulse == IMP_TARGET){
    server_getTarget();
  }
  
  if(self.impulse == IMP_RADAR){
    if(self.stat_rdr_mode){
      self.stat_rdr_mode = FALSE;
      self.radar_range = self.radar_range / 2;
    }
    else{
      self.stat_rdr_mode = TRUE;
      self.radar_range = self.radar_range * 2;
    }
  }
  
  /*
  if(self.impulse == IMP_SUICIDE){
    ClientKill(); WHOOPS!
  }
  
  //abstract out into handler at some point

  if(self.nextVecChoice > 3){
    self.nextVecChoice = 0;
  }
  else if(self.nextVecChoice < 0){
    self.nextVecChoice = 3;
  }
	
  if(change == 1){
    if( self.nextVecChoice == 0){
      centerprint(self, "Spawn as Observer");
      self.p_class_next = P_OBS;
    }else{
      self.p_class_next = P_MECH;
      local entity e;
      e = mh_world_findData(self.nextVecChoice, DATA_MECH);
      centerprint(self, strcat("Spawn as ", e.vec_name));
    }
    change = 0;
  }*/
  
	self.impulse = 0;
};

void() mpls_singleFire={
  if(self.impulse == IMP_SWEAPON1){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON1;
  }
  if(self.impulse == IMP_SWEAPON2){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON2;
  }
  if(self.impulse == IMP_SWEAPON3){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON3;
  }
  if(self.impulse == IMP_SWEAPON4){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON4;
  }
  if(self.impulse == IMP_SWEAPON5){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON5;
  }
  if(self.impulse == IMP_SWEAPON6){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON6;
  }
  if(self.impulse == IMP_SWEAPON7){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON7;
  }
  if(self.impulse == IMP_SWEAPON8){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON8;
  }
  if(self.impulse == IMP_SWEAPON9){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON9;
  }
};

float() mpls_changeGroup={
  if(self.state_1 == 1){
    return IMP_WGROUP1;
  }
  else if(self.state_1 == 2){
    return IMP_WGROUP2;
  }
  else if(self.state_1 == 3){
    return IMP_WGROUP3;
  }
  else if(self.state_1 == 4){
    return IMP_WGROUP4;
  }
  else if(self.state_1 == 5){
    return IMP_WGROUP5;
  }
};

void() mpls_groupFire={
  if(self.impulse == IMP_WGROUP1){
    if(!(self.currentWeaponGroup & self.w_group1)){
      self.state_1 = 1;
      centerprint(self, "[Weapon Group 1]");
      self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group2 | self.w_group3 | self.w_group4 | self.w_group5));
      self.currentWeaponGroup = self.currentWeaponGroup + self.w_group1;
    }
  }
  if(self.impulse == IMP_WGROUP2){
    if(!(self.currentWeaponGroup & self.w_group2)){
      self.state_1 = 2;
      centerprint(self, "[Weapon Group 2]");
      self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group3 | self.w_group4 | self.w_group5));
      self.currentWeaponGroup = self.currentWeaponGroup + self.w_group2;
    }
  }
  if(self.impulse == IMP_WGROUP3){
    if(!(self.currentWeaponGroup & self.w_group3)){
      self.state_1 = 3;
      centerprint(self, "[Weapon Group 3]");
      self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group4 | self.w_group5));
      self.currentWeaponGroup = self.currentWeaponGroup + self.w_group3;
    }
  }
  if(self.impulse == IMP_WGROUP4){
    if(!(self.currentWeaponGroup & self.w_group4)){
      self.state_1 = 4;
      centerprint(self, "[Weapon Group 4]");
      self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3 | self.w_group5));
      self.currentWeaponGroup = self.currentWeaponGroup + self.w_group4;
    }
  }
  if(self.impulse == IMP_WGROUP5){
    if(!(self.currentWeaponGroup & self.w_group5)){
      self.state_1 = 5;
      centerprint(self, "[Weapon Group 5]");
      self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3 | self.w_group4));
      self.currentWeaponGroup = self.currentWeaponGroup + self.w_group5;
    }
  }
  
};