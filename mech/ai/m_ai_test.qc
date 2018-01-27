/*
  mech Mod
  Date: 5/2/2017
  Overview: super simple ai test
*/



/*QUAKED ai_mech (1 0 0) (-16 -16 -24) (16 16 40)
nextVecChoice = match to mech data id
vec_size = weight class for mech data
i_faction = which faction
ai_leading = how bad does the ai suck at aiming? 0.0 is ACE, 0.2 is pretty bad
state_1 = initial order
  0 = Attack the .target
  1 = defend the .target
  2 = patrol the .target
  3 = stand at the .target
p_damage = AI pilot rating, will affect accuracy
  0 = ACE 
  1 = VETERAN
  2 = REGULAR
  3 = ROOKIE
*/
void() ai_mech={
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
  
  self.ideal_yaw = self.angles * '0 1 0';
		
  data_iniMech(self.vec_size, self.nextVecChoice);
  
  ai_core_calcranges();
  local float mod;
  mod = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod; 
  self.e_legs.max_health = self.e_legs.health = self.e_legs.health * mod; 
  self.e_tor_l.max_health = self.e_tor_l.health = self.e_tor_l.health * mod; 
  self.e_tor_r.max_health = self.e_tor_r.health = self.e_tor_r.health * mod; 
  self.e_arm_r.max_health = self.e_arm_r.health = self.e_arm_r.health * mod; 
  self.e_arm_l.max_health = self.e_arm_l.health = self.e_arm_l.health * mod; 
  if (!self.yaw_speed){
    local float m;
    m = ai_pilot_yaw_mod();
    self.yaw_speed = self.m_rot_speed + (self.m_rot_speed * m);
  }
  mod = ai_pilot_rating_leading();
  self.ai_leading = mod;
  self.stat_spr_x = self.conv_min_x + self.conv_max_x;
  self.stat_spr_y = self.conv_min_y + self.conv_max_y;
  mod = ai_pilot_rating_converg();
  self.ai_rte_cnv = mod;
  mod = ai_pilot_rating_range();
  self.ai_rte_rng = mod;
  self.stat_rdr_mode = TRUE;
  self.th_die = ai_mech_die;
  self.th_missile = ai_mech_attack;
  self.ai_unit_update = ai_mech_update;
  self.ai_next_move = ai_move_stand;
  self.touch = ai_mech_touch;
  self.ai_optical = self.radar_range /2;
  mod = ai_pilot_rating_patience();
  self.maxpatience = 0;
  self.patience = 0;
  self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
  
  //set first order based on self.state_1
  if(self.state_1 == AI_ORDER_ATTACK){
    self.ai_first_order = AI_ORDER_ATTACK;
  }
  else if(self.state_1 == AI_ORDER_DEFEND){
    self.ai_first_order = AI_ORDER_DEFEND;
  }
  else if(self.state_1 == AI_ORDER_PATROL){
    self.ai_first_order = AI_ORDER_PATROL;
    self.ai_next_state = ai_find_patrol_node;
  }
  else if(self.state_1 == AI_ORDER_STAND){
    self.ai_first_order = AI_ORDER_STAND;
    self.ai_next_state = ai_sweep_stand;
  }
  else if(self.state_1 == AI_ORDER_DEBUG){
    self.ai_first_order = AI_ORDER_DEBUG;
  }
  else{
    self.ai_first_order = AI_ORDER_STAND;
    self.ai_next_state = ai_sweep_stand;
  }
  
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
  self.think = ai_control;
  self.nextthink = time + 7; //power up timer
};