/*
mech Mod
Author: Peter Roohr
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
  traceline(src.origin, src.origin + v_forward*self.radar_range, FALSE, self);
  if(trace_ent != world){
    self.enemy = trace_ent;
    if(trace_ent.data_type != DATA_POBS){
      if(self.stat_rdr_mode){
        self.lock_timer = time + self.w_firetime;
      }
      else{
        self.lock_timer = time + (self.w_firetime *1.75);
      }
    }
    else{
      self.enemy = world;
    }
  }else{
    self.enemy = world;
  }
};

/*scope - self = unit making the target call*/
void() server_updateTargetInfo={
  local float isvis;
  
  if(self.enemy == world){
    self.stat_trg_ddflg = -1;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_orgx = 0;
    self.stat_trg_orgy = 0;
    self.stat_trg_orgz = 0;
    if((self.stat_lck_stt & LOCK_TARG)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG);
    }
    return;
  }
  
  if(self.enemy.deadflag > DEAD_NO){
    self.enemy = world;
    self.stat_trg_ddflg = self.enemy.deadflag;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_orgx = 0;
    self.stat_trg_orgy = 0;
    self.stat_trg_orgz = 0;
    if(self.stat_lck_stt & LOCK_TARG){
      self.stat_lck_stt = 0;
    }
    return;
  }
  local float dst;
  dst = vlen(self.enemy.origin - self.origin);
  if(dst > self.radar_range){
    self.enemy = world;
    return;
  }
  
  self.stat_trg_ddflg = self.enemy.deadflag;
  self.stat_trg_dist = dst;
  self.stat_trg_face = util_checkPointAngle(self.enemy);
  
  if(self.stat_trg_face <= 0){
    isvis = TRUE;
    if(time > self.lock_timer){
      if(!(self.stat_lck_stt & LOCK_TARG)){
        self.stat_lck_stt = self.stat_lck_stt | LOCK_TARG;
      }
    }
  }
  else{
    isvis = FALSE;
    if((self.stat_lck_stt & LOCK_TARG)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG);
      if(self.stat_rdr_mode){
        self.lock_timer = time + self.w_firetime;
      }
      else{
        self.lock_timer = time + (self.w_firetime *1.75);
      }
    } 
    if((self.enemy.stat_lck_stt & LOCK_PLYR)){
      self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLYR);
    }
  }
  self.stat_trg_orgx = self.enemy.origin_x;
  self.stat_trg_orgy = self.enemy.origin_y;
  self.stat_trg_orgz = self.enemy.origin_z;
};

void() server_radarSweep={
  
};

vector() server_updateRadarInfo={
  local vector toSender;
  toSender = radar_MakeSweep();
  return toSender;
};
