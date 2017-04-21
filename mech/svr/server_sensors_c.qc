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
  if(trace_ent != world){
    if(trace_ent.p_class != P_OBS){
      self.enemy = trace_ent;
      self.lock_timer = time + 5;
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
    self.stat_trg_vid = -1;
    self.stat_trg_dat = -1;
    mech_clearTargetInfo();
    self.stat_trg_ddflg = -1;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_orgx = 0;
    self.stat_trg_orgy = 0;
    self.stat_trg_orgz = 0;
    self.stat_trg_lg_hp = -1;
    self.stat_trg_ct_hp = -1;
    self.stat_trg_lt_hp = -1;
    self.stat_trg_rt_hp = -1;
    self.stat_trg_la_hp = -1;
    self.stat_trg_ra_hp = -1;
    if(self.stat_lck_stt & LOCK_TARG){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG);
    }
    return;
  }
  
  if(self.enemy.deadflag > DEAD_NO){
    self.stat_trg_vid = -1;
    self.stat_trg_dat = -1;
    // self.stat_trg_sh = -1;
    //gross
    mech_clearTargetInfo();
    self.stat_trg_ddflg = self.enemy.deadflag;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_orgx = 0;
    self.stat_trg_orgy = 0;
    self.stat_trg_orgz = 0;
    self.stat_trg_lg_hp = -1;
    self.stat_trg_ct_hp = -1;
    self.stat_trg_lt_hp = -1;
    self.stat_trg_rt_hp = -1;
    self.stat_trg_la_hp = -1;
    self.stat_trg_ra_hp = -1;
    if(self.stat_lck_stt & LOCK_TARG){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG);
      self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLYR);
    }
    return;
  }

  self.stat_trg_vid = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  self.stat_trg_ddflg = self.enemy.deadflag;
  self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  //self.stat_trg_fact = self.enemy.i_faction;
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
      self.lock_timer = time + 5;
    } 
    if((self.enemy.stat_lck_stt & LOCK_PLYR)){
      self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - (self.enemy.stat_lck_stt & LOCK_PLYR);
    }
  }
  server_calcTargetArmor();
  self.stat_trg_orgx = self.enemy.origin_x;
  self.stat_trg_orgy = self.enemy.origin_y;
  self.stat_trg_orgz = self.enemy.origin_z;
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
	local entity trg;
	float track;
	track = 0;
	trg = self.enemy;
	if(trg.p_class == P_MECH){
    self.stat_trg_lg_hp = csqc_updateCompStat(trg.e_legs);
    self.stat_trg_ct_hp = csqc_updateCompStat(trg);
    self.stat_trg_lt_hp = csqc_updateCompStat(trg.e_tor_l);
    self.stat_trg_rt_hp = csqc_updateCompStat(trg.e_tor_r);
    self.stat_trg_la_hp = csqc_updateCompStat(trg.e_arm_l);
    self.stat_trg_ra_hp = csqc_updateCompStat(trg.e_arm_r);
	}
};

void() server_radarSweep={
  
};

vector() server_updateRadarInfo={
  local vector toSender;
  toSender = radar_MakeSweep();
  return toSender;
};
