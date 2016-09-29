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
  if(self.deadflag <= DEAD_NO){
    local entity oself;
    oself = self;
    newmis = spawn();
    self = newmis;
      util_setHealthArmor(10,10,10,10);
      self.th_die = SUB_Remove;
      setorigin(self, oself.origin);
      util_setCollider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_BOUNCE);
      setmodel(self, oself.model);
      setsize(self, '-3 -3 -3', '3 3 3');
      self.velocity = '0 500 0';
      self.think = SUB_Remove;
      self.nextthink = time + 1000;
    self = oself;

    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    setmodel(self, "");
    setsize(self, '0 0 0', '0 0 0');
  }
};