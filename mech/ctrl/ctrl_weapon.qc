/*
mech Mod
Author: Peter Roohr
Date: 9/1/2016
      mod - 3/4/2017
Overview: weapon controller header
*/

void(entity wep) ctrl_wpn_think={

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
    if(self.w_think){
      if(!(oself.flags & FL_MONSTER)){
        if(self.w_isready){
          ctrl_weapon_isReady(self, self.stat_wep_rel);
        }else{
          ctrl_weapon_isReload(self, self.stat_wep_rel);
        }
      }
      self.w_think();
    }
  self = oself;
};

void() ctrl_wpn_think_clip={
  
};
void() ctrl_wpn_think_ene={

};

//gross
void(entity wep, float wstate) ctrl_weapon_addState={
  if(!(wep.owner.stat_wep_state & wstate)){
    wep.owner.stat_wep_state = wep.owner.stat_wep_state | wstate;
  }
};

void(entity wep, float wstate) ctrl_weapon_subState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & wstate);
};

void(entity wep, float state1, float state2) ctrl_weapon_clearState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state1);
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state2);
};

void(entity wep, float wstate) ctrl_weapon_isReload={
  if(!(wep.owner.stat_wep_rel & wstate)){
    wep.owner.stat_wep_rel = wep.owner.stat_wep_rel | wstate;
  }
};

void(entity wep, float wstate) ctrl_weapon_isReady={
  wep.owner.stat_wep_rel = wep.owner.stat_wep_rel - (wep.owner.stat_wep_rel & wstate);
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
    if((oself.currentWeaponGroup & self.w_group)){
      oself.currentWeaponGroup = oself.currentWeaponGroup - (oself.currentWeaponGroup & self.w_group);
      self.w_group = 0;
    }
    if((self.owner.flags & FL_CLIENT)){
      ctrl_weapon_subState(self, self.state_1);
      ctrl_weapon_addState(self, self.state_2);
    }
    else{
      ai_core_calcranges();
    }
    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    
    if( (self.p_dmgtype & DMG_MSC) ){
      //weapon is equip, run death func
       self.unit_wep1();
    }
  }
};

void() ctrl_die_weapon