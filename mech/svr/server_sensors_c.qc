/*
mech Mod
Author: Subject9x
Date: 1/26/2017
Overview: necessary targeting and radar functions
*/

float(float current, float total) server_calcComponentArmor;
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
  if(self.enemy.deadflag > DEAD_NO || self.enemy == world){
    self.stat_trg_vid = -1;
    self.stat_trg_dat = -1;
    self.stat_trg_sh = -1;
    self.stat_trg_am = -1;
    self.stat_trg_dist = -1;
    self.stat_trg_face = -1;
    self.targetpip.effects = EF_NODRAW + EF_LOWPRECISION;
    if(self.stat_lck_stt & LOCK_TARG){
      self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG;
    }
    return;
  }

  self.stat_trg_vid = self.enemy.data_idx;
  self.stat_trg_dat = self.enemy.data_type;
  self.stat_trg_am = 0;
  self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  //self.stat_trg_fact = self.enemy.i_faction;
  self.stat_trg_face = util_checkPointAngle(self.enemy);
  
  if(self.stat_trg_face <= 0){
    isvis = TRUE;
    if(time > self.lock_timer){
      if(!(self.stat_lck_stt & LOCK_TARG)){
        self.stat_lck_stt = self.stat_lck_stt + LOCK_TARG;
      }
      if(!(self.enemy.stat_lck_stt & LOCK_PLYR)){
        self.enemy.stat_lck_stt = self.enemy.stat_lck_stt + LOCK_PLYR;
      }
    }
  }
  else{
    isvis = FALSE;
    if(self.stat_lck_stt & LOCK_TARG){
      self.stat_lck_stt = self.stat_lck_stt - LOCK_TARG;
      self.lock_timer = time + 5;
    } 
    if(self.enemy.stat_lck_stt & LOCK_PLYR){
      self.enemy.stat_lck_stt = self.enemy.stat_lck_stt - LOCK_PLYR;
    }
  }
  sever_handleTargetMarkEnt(isvis);
  server_calcTargetArmor();
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

void(float vis) sever_handleTargetMarkEnt={
  local entity oself;
  local vector t_height;
  t_height_z = self.enemy.c_bbx_x_z + 1;
  t_height_x = 0;
  t_height_y = 0;
  local float sz;
  sz = self.stat_trg_dist / 25;
  if(sz <= 2){
    sz = 2;
  }
  else if(sz > 5){
    sz = 5;
  }
  oself = self;
  self = self.targetpip;
  if(vis == TRUE){
    self.effects = EF_FULLBRIGHT + EF_NODEPTHTEST + EF_LOWPRECISION;
    setmodel(self, "q3mdl/green_pip.spr32");
    setorigin(self, oself.enemy.origin + (t_height * 1.15));
    self.scale = sz/10;
  }
  else{
    self.effects = EF_NODRAW + EF_LOWPRECISION;
  }
  self = oself;
};


void() server_calcTargetArmor={
	local entity trg;
	float track;
	track = 0;
	trg = self.enemy;
	if(trg.p_class == P_MECH){
		track = server_calcComponentArmor(trg.health, trg.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_CT_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_CT_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_CT_OK;
		}
		
		track = server_calcComponentArmor(trg.e_tor_l.health, trg.e_tor_l.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_LT_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_LT_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_LT_OK;
		}
		
		track = server_calcComponentArmor(trg.e_tor_r.health, trg.e_tor_r.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_RT_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_RT_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_RT_OK;
		}
		
		track = server_calcComponentArmor(trg.e_arm_l.health, trg.e_arm_l.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_LA_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_LA_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_LA_OK;
		}
		
		track = server_calcComponentArmor(trg.e_arm_r.health, trg.e_arm_r.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_RA_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_RA_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_RA_OK;
		}

		track = server_calcComponentArmor(trg.e_legs.health, trg.e_legs.max_health);
		if(track == 0){
			self.stat_trg_am = self.stat_trg_am | TARG_LG_DD;
		}
		else if(track == 1){
			self.stat_trg_am = self.stat_trg_am | TARG_LG_DM;
		}
		else if(track == 2){
			self.stat_trg_am = self.stat_trg_am | TARG_LG_OK;
		}
	}
};

float(float current, float total) server_calcComponentArmor={
	float threes;
	threes = total - (total/4);
	if(current <= 0){
		return 0;
	}
	else if((current >= 0) && (current <= threes)){
		return 1;
	}
	else{
		return 2;
	}
};

void() server_radarSweep={
  
};

vector() server_updateRadarInfo={
  local vector toSender;
  toSender = radar_MakeSweep();
  return toSender;
};
