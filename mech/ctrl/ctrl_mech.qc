/*
mech mod
Author: Subject9x
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={

  if(self.en_current < self.en_master){
    self.en_current = self.en_current + self.en_recharge;
    if(self.en_current > self.en_master){
      local float diff;
      diff = self.en_current - self.en_master;
      self.en_current = self.en_current - diff;
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