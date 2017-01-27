/*
mech Mod
Author: Subject9x
Date: 1/26/2017
Overview: necessary targeting and radar functions
*/

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
  self.targ = trace_ent;
};

/*scope - self = unit making the target call*/
void() server_updateTargetInfo={
  if(self.targ != world){
    if(self.targ.data_type != P_OBS){
      self.stat_trg_vid = self.targ.data_idx;
      self.stat_trg_dat = self.targ.data_type;
      if(self.targ.sh_cur){
        self.stat_trg_sh = (self.targ.sh_cur / self.targ.sh_max) * 100;
      }
    }
  }
  else{
    self.stat_trg_sh = -1;
    self.stat_trg_vid = -1;
    self.stat_trg_dat = -1;
  }
};

void() server_radarSweep={

};

void() server_updateRadarInfo={

};
