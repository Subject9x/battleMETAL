/*
mech Mod
Author: Peter Roohr
Date: 11/5/2017
Overview:
  name: Human medium tank
  type: vehicle
  size: mediums
*/

//HUMAN LIGHT TNKRET=============================
float DAT_TNK_IDX = ID_VEC_TANK;
string DAT_TNK_VEC_NAME = "Medium Tank";

float DAT_TNK_YAWSPEED = 2.5;
vector DAT_TNK_CTOR_BBX_N ='-20 -20 -10';
vector DAT_TNK_CTOR_BBX_X ='20 20 14';

string DAT_TNK_M_PITCH_N = "-25";
string DAT_TNK_M_PITCH_X = "45";

//WEAOPON GROUPS
float DAT_TNK_WEP1_IDX= ID_WEP_PAC;
float DAT_TNK_WEP2_IDX= ID_WEP_PAC;
float DAT_TNK_WEP1_GROUP= 1;
float DAT_TNK_WEP2_GROUP= 1;

//this is mostly cosmetics


//LEGS
string DAT_TNK_LEG_CNAME= M_LEGS;

//CENTER TORSO
string DAT_TNK_CTOR_CNAME= M_TOR_CENTER;

//WEAPON1
string DAT_TNK_WEP1_CPARENT= M_TOR_CENTER;
vector DAT_TNK_WEP1_OFFSET_ALT = '0 0 0';
vector DAT_TNK_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_TNK_WEP2_CPARENT= M_TOR_CENTER;
vector DAT_TNK_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_TNK_WEP2_ADJ_ANG= '0 0 90';

//CAMERA
string DAT_TNK_CAM_CNAME= "camera";
vector DAT_TNK_CAM_OFFSET= '0 0 0';
vector DAT_TNK_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_TNK_ini;
void() data_TNK_legs;
void() data_TNK_ctor;
void() data_TNK_cam;
void() data_TNK_wep1;
void() data_TNK_wep2;

void() data_TNK_ini={
  self.unit_legs = data_TNK_legs;
  self.unit_ctor = data_TNK_ctor;
  self.unit_wep1 = data_TNK_wep1;
  self.unit_wep2 = data_TNK_wep2;
  self.unit_cam = data_TNK_cam;
    
  self.data_idx= DAT_TNK_IDX;
  self.vec_name= DAT_TNK_VEC_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_TNK_RADAR_RANGE;
  self.i_techlvl= DAT_TNK_TECH_LEVEL;
  self.en_cur= DAT_TNK_ENERGY_MAX;
  self.en_max= DAT_TNK_ENERGY_MAX;
  self.en_rate= DAT_TNK_ENERGY_RATE;
  self.sh_cur= DAT_TNK_SHIELD_MAX;
  self.sh_max= DAT_TNK_SHIELD_MAX;
  self.sh_rate= DAT_TNK_SHIELD_RATE;
  self.m_rot_speed = DAT_TNK_YAWSPEED;
  self.c_bbx_n = DAT_TNK_CTOR_BBX_N;
  self.c_bbx_x = DAT_TNK_CTOR_BBX_X;
  self.c_model = DAT_TNK_CTOR_MODEL;
  self.conv_min = DAT_TNK_SPREAD_N; 
  self.conv_max = DAT_TNK_SPREAD_X; 
  self.m_fspeed = DAT_TNK_M_FSPEED;
  self.m_sspeed = DAT_TNK_M_SSPEED;
  self.m_bspeed = DAT_TNK_M_BSPEED;
  self.m_pitch_max = DAT_TNK_M_PITCH_N;
  self.m_pitch_min = DAT_TNK_M_PITCH_X;
};

/*QUAKED ai_tank (0.5 .85 .2) (-10 -10 0) (10 10 25)

*/
void() ai_tank;

void() ai_tank={
  //DEBUG
  /*if(deathmatch){
    remove(self);
    return;
  }*/
  self.flags = self.flags | FL_MONSTER;
  //ini all the unit stats
  self.data_type = DATA_VEHC;
  self.data_idx = 0;
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  self.stat_legs_hp = 0;
  self.stat_ctor_hp = 0;
  
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
  self.w_clipsize = 0; //use this for the movement frame counter (I love co-opting existing variables :( ) 
  self.w_isready = 0; //and this guy too
  
  self.ideal_yaw = self.angles * '0 1 0';
		
  //buildVehicle(dat);
  data_iniVehc (self.vec_size, self.nextVecChoice);
  ai_core_calcranges();
  local float mod;
  mod = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod; 
  self.e_legs.max_health = self.e_legs.health = self.e_legs.health * mod; 
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
  self.th_die = ai_mech_die;
  self.th_missile = ai_attack;
  self.ai_unit_update = ai_mech_update;
  self.ai_next_move = ai_move_stand;
  self.touch = ai_mech_touch;
  self.ai_optical = self.radar_range /2;
  mod = ai_pilot_rating_patience();
  self.maxpatience = mod;
  self.patience = 0;
  self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
  self.movetarget = world;
  self.oldgoal = world;
  
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
  self.think = ai_control;
  self.nextthink = time + 5; //power up timer
};

void() data_TNK_legs={
  self.c_name = DAT_TNK_LEG_CNAME;
  self.health = DAT_TNK_LEG_HP;
  self.max_health = DAT_TNK_LEG_HP;
  self.armorvalue = DAT_TNK_LEG_ARMOR;
  self.max_armor = DAT_TNK_LEG_ARMOR;
  self.c_model = DAT_TNK_LEG_MODEL;
  self.c_ofs = DAT_TNK_LEG_OFFSET;
};

void() data_TNK_ctor={
  self.c_name = DAT_TNK_CTOR_CNAME;
  self.health = DAT_TNK_CTOR_HP;
  self.max_health = DAT_TNK_CTOR_HP;
  self.armorvalue = DAT_TNK_CTOR_ARMOR;
  self.max_armor = DAT_TNK_CTOR_ARMOR;
  self.c_model = DAT_TNK_CTOR_MODEL;
};

void() data_TNK_wep1={  
  self.c_parent = DAT_TNK_WEP1_CPARENT;
  self.data_idx = DAT_TNK_WEP1_IDX; //consult weapon idx table!
  self.c_ofs = DAT_TNK_WEP1_OFFSET;
  self.c_alt_ofs = DAT_TNK_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_TNK_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_TNK_wep2={  
  self.c_parent = DAT_TNK_WEP2_CPARENT;
  self.data_idx = DAT_TNK_WEP2_IDX; //consult weapon idx table!
  self.c_ofs = DAT_TNK_WEP2_OFFSET;
  self.c_alt_ofs = DAT_TNK_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_TNK_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};

void() data_TNK_cam={ 
  self.c_name = DAT_TNK_CAM_CNAME;
  self.c_ofs = DAT_TNK_CAM_OFFSET;
  self.c_alt_ofs = DAT_TNK_CAM_OFFSET_ALT;
  self.c_model = DAT_TNK_CAM_MODEL;
};