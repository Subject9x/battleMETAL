/*
  mech Mod
  Date: 5/2/2017
  Overview: super simple ai test
*/

/*QUAKED ai_mech (1 0 0) (-16 -16 -24) (16 16 40)
nextVecChoice = match to mech data id
i_faction = which faction
*/
void() ai_mech={
  //DEBUG
  /*if(deathmatch){
    remove(self);
    return;
  }*/
  
  self.flags = self.flags | FL_MONSTER;
  //ini all the unit stats
  self.p_class = P_MECH;
  self.data_idx = 0;
  self.currentWeaponGroup = self.currentWeaponGroup;
  //self.stat_eid = num_for_edict(self); - not needed
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  self.stat_legs_hp = 0;
  self.stat_legs_am = 0;
  self.stat_ctor_hp = 0;
  self.stat_ctor_am = 0;
  self.stat_ltor_hp = 0;
  self.stat_ltor_am = 0;
  self.stat_rtor_hp = 0;
  self.stat_rtor_am = 0;
  self.stat_larm_hp = 0;
  self.stat_larm_am = 0;
  self.stat_rarm_hp = 0;
  self.stat_rarm_am = 0;
  self.stat_cofs_x = 0;
  self.stat_cofs_y = 0;
  self.stat_cofs_z = 0;
  self.stat_w1_id = -1;
  self.stat_w2_id = -1;
  self.stat_w3_id = -1;
  self.stat_w4_id = -1;
  self.stat_w5_id = -1;
  self.stat_w6_id = -1;
  self.stat_w7_id = -1;
  self.stat_w8_id = -1;
  self.stat_w9_id = -1;
  self.w_group1 = 0;
  self.w_group2 = 0;
  self.w_group3 = 0;
  self.stat_wep_state = 0;
  self.stat_wep_rel = 0;
  
  self.stat_trg_vid = -1;
  self.stat_trg_ddflg = -1;
  self.stat_trg_sh = -1;
  self.stat_trg_dat = -1;
  self.stat_trg_face = -1;
  
  self.stat_trg_lg_hp = -1;
  self.stat_trg_ct_hp = -1;
  self.stat_trg_lt_hp = -1;
  self.stat_trg_rt_hp = -1;
  self.stat_trg_la_hp = -1;
  self.stat_trg_ra_hp = -1;
  
  self.radar_range = 800;
  self.radar_front = 0;
  self.radar_rear = 0;
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_plr_stt = 0;
  self.stat_plr_fir = FIRE_GROUP;
  self.stat_lck_stt = LOCK_NONE;
  self.stat_plr_ptc = 0;
  self.stat_plr_ang = 0;
  
  local entity dat;
  dat = mh_world_findData(self.nextVecChoice, DATA_MECH);
  if(!dat){
    bprint(strcat("mech id:",ftos(self.nextVecChoice)," was not found","\n"));
    remove(self);
    return;
  }
  
  
  self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
    
  buildVehicle(dat);
  
  self.th_die = ai_mech_die;
  self.th_walk = ai_mech_walk;
  self.th_run = ai_mech_run;
  self.th_missile = ai_mech_attack;
  self.th_stand = ai_mech_stand;
  self.ai_state = AI_STAND;
  
  self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
  
  self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.use = q_monster_use;
  
  if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner"){
      self.ai_state = AI_WALK;
			//self.th_walk ();
		}else{
			self.pausetime = 99999999;
      self.ai_state = AI_STAND;
			//self.th_stand ();
    }
	}
	else
	{
		self.pausetime = 99999999;
    self.ai_state = AI_STAND;
		//self.th_stand ();
	}
  self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2| WEAPON3| WEAPON4| WEAPON5;
  self.currentWeaponGroup = self.w_group1;
  self.think = ai_control;
  self.nextthink = time + 0.001;
};