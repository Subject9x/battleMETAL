/*
mech Mod
Author: Subject9x
Date: 9/1/2016
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think={
  local entity oself;
  oself = self;
  self = wep;
  if(self.deadflag >= DEAD_DYING){
    self.deadflag = DEAD_DEAD;
    self = oself;
    return;
  }
  
  if(self.deadflag == DEAD_DEAD){
    self = oself;
    return;
  }
  
  if(self.w_isfire == 1){
    if(self.w_currentammo > 0){
      if(time >= self.w_firetime){
        self.w_attack();
        self.w_currentammo = self.w_currentammo - 1;
        self.w_firetime = time + self.w_firerate;
      }
    }
    else{
      self.w_firetime = time + self.w_reloadtime;
      self.w_currentammo = self.w_clipsize;
    }
    self.w_isfire = 0;
  }
 
  self = oself;
};

void(entity wep) ctrl_weapon_tryFire={
  local entity oself;
  oself = self;
  self = wep;
    self.w_isfire = 1;
  self = oself;
};

void() ctrl_die_weapon={
  self.w_attack = SUB_Null;
	self.deadflag = DEAD_DEAD;
  setmodel(self, "");
  setsize(self, '0 0 0', '0 0 0');
};