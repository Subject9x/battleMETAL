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
  self.stat_trg_am = 0;
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

void() server_updateRadarInfo={
  self.radar_front = radar_MakeSweep();  
};
