/*
mech mod
Author: Subject9x
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={
  if(self.en_cur < self.en_max){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur > self.en_max){
      local float diff;
      diff = self.en_cur - self.en_max;
      self.en_cur = self.en_cur - diff;
    }
  }
 
  //shield recharge
};

void() ctrl_dieMech={
  /*if(self.deadflag <= DEAD_NO){
    self.solid = SOLID_NOT;
    self.deadflag = DEAD_DYING;
    self.takedamage = DAMAGE_NO;
    setmodel(self, "");
    setsize(self, '0 0 0', '0 0 0'); 
  }*/
};