/*
mech Mod
Author: Subject9x
Date: 1/26/2017
Overview: necessary targeting and radar functions
*/

void() server_calcTargetArmor;

/*scope - self = unit making the target call*/
void() server_getTarget={
  local entity src;
  makevectors(self.v_angle);
  if(self.e_cam != world){
    src = self.e_cam;
  }
  else{
    src = self;
  }
  traceline(src.origin, src.origin + v_forward*10000, FALSE, self);
  if(trace_ent != world){
    if(trace_ent.p_class != P_OBS){
      self.enemy = trace_ent;
    }
  }
};

/*scope - self = unit making the target call*/
void() server_updateTargetInfo={
  
  if(self.enemy.deadflag > DEAD_NO){
    self.stat_trg_vid = -1;
    self.stat_trg_dat = -1;
    self.stat_trg_sh = -1;
    self.stat_trg_am = -1;
    return;
  }
  
  self.stat_trg_vid = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  if(self.enemy.sh_cur > -1){
    if(self.enemy.sh_cur == 0){
      self.stat_trg_sh = 0;
    }
    else{
      self.stat_trg_sh = (self.enemy.sh_cur / self.enemy.sh_max) * 100;
    }
  }
  else{
    self.stat_trg_sh = -1;
  }
};

void() server_calcTargetArmor={

};

void() server_radarSweep={

};

void() server_updateRadarInfo={

};
