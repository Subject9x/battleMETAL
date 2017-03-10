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
  
  if(time > self.w_firetime){
    if(self.owner.stat_wep_rel & self.stat_wep_rel){
      self.owner.stat_wep_rel = self.owner.stat_wep_rel - ( self.owner.stat_wep_rel & self.stat_wep_rel);
    }
  }else{
    if(!(self.owner.stat_wep_rel & self.stat_wep_rel)){
      self.owner.stat_wep_rel = self.owner.stat_wep_rel | self.stat_wep_rel;
    }
  }
  
  
  if(self.w_isfire == 1){
    if(time > self.w_firetime){
      if(self.w_currentammo > 0){
        if((self.en_cur == self.en_max) || (self.en_max == -1)){
          self.w_currentammo = self.w_currentammo - 1;
          self.w_attack();
          if(self.w_currentammo < 0){
            self.w_currentammo = 0;
          }
          self.w_firetime = time + self.w_firerate;
          
          if(self.en_cur != -1){
            
            self.en_cur = self.en_cur - (self.en_max/self.w_clipsize);
          }
          
          //oself.en_cur = oself.en_cur - self.en_max;
        }
        else{
          self.w_isfire = 0;
        }
      }
      else{
        self.w_firetime = time + self.w_reloadtime;
        self.w_currentammo = self.w_currentammo + self.w_clipsize;
        self.w_isfire = 0;
        
      }
    }
  }
  
  if(self.en_cur != -1){
    if(self.en_cur < self.en_max){
      self.en_cur = self.en_cur + self.owner.en_rate;
      self.owner.en_cur = self.owner.en_cur - (self.owner.en_rate * 1.35);
      if(self.en_cur > self.en_max){
        self.en_cur = self.en_max;
      }
      self.w_isfire = 0;
    }
  }
  self = oself;
};

//gross
void(entity wep, float wstate) ctrl_weapon_addState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state | wstate;
};

void(entity wep, float wstate) ctrl_weapon_subState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & wstate);
};

void(entity wep, float state1, float state2) ctrl_weapon_clearState={
  if(wep.owner.stat_wep_state & state1){
    wep.owner.stat_wep_state = wep.owner.stat_wep_state - ( wep.owner.stat_wep_state & state1);
  }
  if(wep.owner.stat_wep_state & state2){
    wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state2);
  }
};

void(entity wep, float wstate) ctrl_weapon_isReload={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state | wstate;
};

void(entity wep, float wstate) ctrl_weapon_isReady={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & wstate);
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
    if(oself.currentWeaponGroup & self.w_group){
      oself.currentWeaponGroup = oself.currentWeaponGroup - (oself.currentWeaponGroup & self.w_group);
      self.w_group = 0;
    }
    ctrl_weapon_subState(self, self.state_1);
    ctrl_weapon_addState(self, self.state_2);
    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
  }
};