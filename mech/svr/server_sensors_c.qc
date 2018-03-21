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
  traceline(src.origin, src.origin + (v_forward * self.stat_rdr_rng), FALSE, self);
  if( ai_target_isValid_useDataType(trace_ent) ){
    
    self.enemy = trace_ent;
    if(trace_ent.data_type != DATA_POBS){
      if(self.stat_rdr_mode){
        self.lock_timer = time + self.w_firetime;
      }
      else{
        self.lock_timer = time + (self.w_firetime *1.75);
      }
    }
  }
  else{
    self.enemy = world;
    self.lock_timer = 0;
  }
};

/*scope - self = unit making the target call*/
void() server_updateTargetInfo={
  local float isvis;
 
  if( (!ai_target_isValid_useDataType(self.enemy)) || (self.enemy.health <= 0) ){
    self.stat_trg_vsize = -1;
    self.stat_trg_dataidx = -1;
    self.stat_trg_sh = 0;
    self.stat_trg_ddflg = -1;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.stat_trg_faction = -1;
    self.stat_trg_ent_id = -1;
    self.stat_trg_org_x = 0;
    self.stat_trg_org_y = 0;
    self.stat_trg_org_z = 0;
    if((self.stat_lck_stt & LOCK_TARG)){
      self.stat_lck_stt = self.stat_lck_stt - (self.stat_lck_stt & LOCK_TARG);
    }
    return;
  }
  
  self.stat_trg_org_x = self.enemy.origin_x;
  self.stat_trg_org_y = self.enemy.origin_y;
  self.stat_trg_org_z = self.enemy.origin_z;
  self.stat_trg_ent_id = num_for_edict(self.enemy);
  self.stat_trg_vsize = self.enemy.vec_size;
  self.stat_trg_dataidx = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  self.stat_trg_sh = (self.enemy.sh_cur / self.enemy.sh_max) * 100;
  self.stat_trg_faction = self.enemy.i_faction;
  self.stat_trg_ct_hp = csqc_updateCompStat(self.enemy);
  if( (self.stat_trg_dat == DATA_MECH_AI) || (self.stat_trg_dat == DATA_VEHC) || (self.stat_trg_dat == DATA_MECH) ){
    self.stat_trg_lg_hp = csqc_updateCompStat(self.enemy.e_legs);
  
  }
  if( (self.stat_trg_dat == DATA_MECH_AI) || (self.stat_trg_dat == DATA_MECH) ){
    self.stat_trg_lt_hp = csqc_updateCompStat(self.enemy.e_tor_l);
    self.stat_trg_rt_hp = csqc_updateCompStat(self.enemy.e_tor_r);
    self.stat_trg_la_hp = csqc_updateCompStat(self.enemy.e_arm_l);
    self.stat_trg_ra_hp = csqc_updateCompStat(self.enemy.e_arm_r);
  }

  local float dst;
  dst = vlen(self.enemy.origin - self.origin);
  if(dst > self.stat_rdr_rng){
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
};