/*
  mech Mod
  Date: 5/2/2017
  Overview: super simple ai test
  mod - 2/2/2018
*/

/*QUAKED ai_mech (1 0 0) (-16 -16 -24) (16 16 40)
"nextVecChoice" : number, match to mech data id
"vec_size" : number, weight class for mech data
"i_faction" : bitflags for faction which faction
"state_1" : number, initial order
  -1 = debug mode (stand still, no interaction)
  1 = stand at the .target
  2 = defend the .target
  3 = patrol the .target
  4 = attack the .target
"p_damage" : number,AI pilot rating, will affect accuracy
  0 = ACE 
  1 = VETERAN
  2 = REGULAR
  3 = ROOKIE
"ai_style" : AI's combat style
  0, or none = skirmisher - normal movement
  1 = sniper - tries to stay at long range
  2 = brawler - always stays up close to target
  3 = flanker - tries to get behind player
  4 = stalker - extra patience when hunting targets
  5 = random of 1-4
"ai_type" : AI's personality
  0, or none = normal
  1 = aggressive - will always run around, stay in fight
  2 = rescue - tries to save friendlies by pulling aggro
  3 = coward - will run away or to friends easily
  4 = random of 1-4
"next_wepn1" : float, data_idx for weapon slot
    this goes to next_wepn9
*/
void() ai_mech={
  local float mod_sh, mod_am, mod_yaw;
  //DEBUG
  /*if(deathmatch){
    remove(self);
    return;
  }*/
  self.flags = self.flags | FL_MONSTER;
  //ini all the unit stats
  self.data_idx = 0;
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  self.stat_legs_hp = 0;
  self.stat_ctor_hp = 0;
  self.stat_ltor_hp = 0;
  self.stat_rtor_hp = 0;
  self.stat_larm_hp = 0;
  self.stat_rarm_hp = 0;
  
  self.radar_range = 0; 
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = FALSE;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_lck_stt = LOCK_NONE;
  self.w_clipsize = ((0 - self.p_damage) *-1) + 1; //use this for the movement frame counter (I love co-opting existing variables :( ) 
  self.w_isready = time; //and this guy too
  self.delay = time;
  self.ideal_yaw = self.angles * '0 1 0';

  //randomized pilot rank
  if(self.p_damage == 4){
    self.p_damage = util_roll_dice(4) - 1;
  }
  if(self.ai_style == 5){
    self.ai_style = util_roll_dice(5) - 1;
  }
  if(self.ai_type == 4){
    self.ai_type = util_roll_dice(4) - 1;
  }
  data_iniMech(self.vec_size, self.nextVecChoice);
  
  ai_core_calcranges();
  mod_am = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod_am; 
  self.e_legs.max_health = self.e_legs.health = self.e_legs.health * mod_am; 
  self.e_tor_l.max_health = self.e_tor_l.health = self.e_tor_l.health * mod_am; 
  self.e_tor_r.max_health = self.e_tor_r.health = self.e_tor_r.health * mod_am; 
  self.e_arm_r.max_health = self.e_arm_r.health = self.e_arm_r.health * mod_am; 
  self.e_arm_l.max_health = self.e_arm_l.health = self.e_arm_l.health * mod_am;
  
  mod_sh = ai_pilot_shield_mod();
  self.sh_max = self.sh_cur = self.sh_cur * mod_sh;
  
  if (!self.yaw_speed){
    mod_yaw = ai_pilot_yaw_mod();
    self.yaw_speed = self.m_rot_speed - (self.m_rot_speed * mod_yaw);
  }
  self.ai_leading = ai_pilot_rating_leading();
  self.stat_spr_x = self.conv_min_x + self.conv_max_x;
  self.stat_spr_y = self.conv_min_y + self.conv_max_y;
  self.ai_rte_cnv = ai_pilot_rating_converg();
  self.ai_rte_rng = ai_pilot_rating_range();
  self.stat_rdr_mode = TRUE;
  self.ai_next_state = SUB_Null;
  self.th_die = ai_mech_die;
  self.th_missile = ai_attack;
  self.ai_unit_update = ai_mech_update;
  self.ai_next_move = ai_move_stand;
  self.touch = ai_mech_touch;
  self.ai_optical = self.radar_range / 2;
  self.maxpatience = ai_pilot_rating_patience();
  self.patience = 0;
 
  setorigin(self, util_findOpenSpawnArea(self.angles, self.origin, self.maxs) );
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  self.movetype = MOVETYPE_STEP;
  droptofloor();
  
  //set first order based on self.state_1
  ai_util_firstOrder_nonStatic(self.state_1);
  
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
  self.prev_pos = self.origin;
  self.prev_angle = self.v_angle;
  self.e_cam.SendEntity = send_ai_mech;
  self.e_cam.SendFlags = -1;
  self.nextthink = time + 4; //power up timer 7
  self.think = ai_control;
};