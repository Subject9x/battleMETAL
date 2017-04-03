/*
mech Mod
Author: Subject9x
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
  wep_chain = self.w_slot;
  wep_count = wep_chain.w_group;
  while(wep_chain){
    local float wgrp;
    wgrp = wep_chain.w_group;
    if((self.currentWeaponGroup & wgrp)){
      if(wep_chain.w_isready){
        oself = self;
        self = wep_chain;
          self.w_attack();
        self = oself;
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
  
  if(self.stat_plr_fir == FIRE_SINGLE){
    mpls_singleFire();
  }
  if(self.stat_plr_fir == FIRE_GROUP){
    mpls_groupFire();
  }

  local float change;
  change = 0;
  
  if(self.impulse == IMP_VECPREV){
    change = 1;
    self.nextVecChoice = self.nextVecChoice - 1;
  }
  
  if(self.impulse == IMP_VECNEXT){
    change = 1;
    self.nextVecChoice = self.nextVecChoice + 1;
  }
  
  if(self.impulse == IMP_SUICIDE){
    ClientKill();
  }
  
  if(self.impulse == IMP_TARGET){
    server_getTarget();
  }
  
  if(self.impulse == IMP_RADAR){
    if(self.stat_rdr_mode){
      self.stat_rdr_mode = FALSE;
    }
    else{
      self.stat_rdr_mode = TRUE;
    }
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
  }
  
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

void() mpls_groupFire={
  if(self.impulse == IMP_WGROUP1){
    centerprint(self, "[Weapon Group 1]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group1;
  }
  if(self.impulse == IMP_WGROUP2){
    //21
    centerprint(self, "[Weapon Group 2]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group2;
  }
  if(self.impulse == IMP_WGROUP3){
    centerprint(self, "[Weapon Group 3]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group3;
  }
};