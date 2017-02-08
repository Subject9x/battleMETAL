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
    if(time > self.w_firetime){
      if(self.w_currentammo > 0){
        self.w_currentammo = self.w_currentammo - 1;
        self.w_attack();
        if(self.w_currentammo < 0){
          self.w_currentammo = 0;
        }
        self.w_firetime = time + self.w_firerate;
        oself.en_cur = oself.en_cur - self.en_max;
      }
      else{
        self.w_firetime = time + self.w_reloadtime;
        self.w_currentammo = self.w_currentammo + self.w_clipsize;
        self.w_isfire = 0;
      }
    }
  }
  self = oself;
};

//gross
void(entity wep, float state) ctrl_weapon_addState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state + state;
};

void(entity wep, float state) ctrl_weapon_subState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state);
};

void(entity wep, float state1, float state2) ctrl_weapon_clearState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & (state1 | state2));
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
      setorigin(newmis, oself.origin);
      BecomeExplosion();
    self = oself;
    ctrl_weapon_subState(self, self.state_1);
    ctrl_weapon_addState(self, self.state_2);
    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
  }
};