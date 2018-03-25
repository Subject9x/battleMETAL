/*
mech Mod
Author: Peter Roohr
Date: 10/28/2017
Overview:
  name: Human Light Turret
  type: turret
  size: small
*/

//HUMAN LIGHT TURRET=============================
string DAT_TUR_VEC_NAME = "Light Turret";
float DAT_TUR_TECH_LEVEL = 1;


float DAT_TUR_YAWSPEED = 5;
vector DAT_TUR_CTOR_BBX_N ='-20 -20 -12';
vector DAT_TUR_CTOR_BBX_X ='20 20 14';
float DAT_TUR_M_FSPEED  =-1;
float DAT_TUR_M_SSPEED  =-1;
float DAT_TUR_M_BSPEED  =-1;

string DAT_TUR_M_PITCH_N = "-25";
string DAT_TUR_M_PITCH_X = "45";

//WEAOPON GROUPS
float DAT_TUR_WEP1_IDX  = ID_WEP_LATC;
float DAT_TUR_WEP2_IDX  = ID_WEP_LAS;
float DAT_TUR_WEP1_GROUP  = 1;
float DAT_TUR_WEP2_GROUP  = 1;

//this is mostly cosmetics

//LEGS
string DAT_TUR_LEG_CNAME= M_LEGS;
vector DAT_TUR_LEG_OFFSET= '0 -2 0';

//CENTER TORSO
string DAT_TUR_CTOR_CNAME= M_TOR_CENTER;

//WEAPON1
string DAT_TUR_WEP1_CPARENT= M_TOR_CENTER;
vector DAT_TUR_WEP1_OFFSET= '3 4 10';
vector DAT_TUR_WEP1_OFFSET_ALT = '0 0 0';
vector DAT_TUR_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_TUR_WEP2_CPARENT= M_TOR_CENTER;
vector DAT_TUR_WEP2_OFFSET= '6 4 10';
vector DAT_TUR_WEP2_OFFSET_ALT= '0 0 0';
vector DAT_TUR_WEP2_ADJ_ANG= '0 0 90';

//CAMERA
string DAT_TUR_CAM_CNAME= "camera";
vector DAT_TUR_CAM_OFFSET= '0 0 0';
vector DAT_TUR_CAM_OFFSET_ALT= '0 0 0';

//=========================================
void() data_tur_ini;
void() data_tur_legs;
void() data_tur_ctor;
void() data_tur_cam;
void() data_tur_wep1;
void() data_tur_wep2;

void() data_tur_ini={
  self.unit_legs = data_tur_legs;
  self.unit_ctor = data_tur_ctor;
  self.unit_wep1 = data_tur_wep1;
  self.unit_wep2 = data_tur_wep2;
  self.unit_cam = data_tur_cam;

  self.data_idx= ID_BLD_H_TURRET;
  self.vec_name= DAT_TUR_VEC_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_TUR_RADAR_RANGE;
  self.i_techlvl= DAT_TUR_TECH_LEVEL;
  self.en_cur= DAT_TUR_ENERGY_MAX;
  self.en_max= DAT_TUR_ENERGY_MAX;
  self.en_rate= DAT_TUR_ENERGY_RATE;
  self.sh_cur= DAT_TUR_SHIELD_MAX;
  self.sh_max= DAT_TUR_SHIELD_MAX;
  self.sh_rate= DAT_TUR_SHIELD_RATE;
  self.m_rot_speed = DAT_TUR_YAWSPEED;
  self.c_bbx_n = DAT_TUR_CTOR_BBX_N;
  self.c_bbx_x = DAT_TUR_CTOR_BBX_X;
  self.c_model = DAT_TUR_CTOR_MODEL;
  self.conv_min = DAT_TUR_SPREAD_N; 
  self.conv_max = DAT_TUR_SPREAD_X; 
  self.m_fspeed = DAT_TUR_M_FSPEED;
  self.m_sspeed = DAT_TUR_M_SSPEED;
  self.m_bspeed = DAT_TUR_M_BSPEED;
  self.m_pitch_max = DAT_TUR_M_PITCH_N;
  self.m_pitch_min = DAT_TUR_M_PITCH_X;
};

/*QUAKED building_tur (0.5 .85 .2) (-10 -10 0) (10 10 25)
*/
void() building_tur;

void() building_tur={
  local float mod_sh, mod_am, mod_yaw;
  
  self.flags = self.flags | FL_MONSTER;
  self.deadflag = DEAD_NO;
  self.data_type = DATA_VEHC;
  self.en_cur = 0;
  self.en_max = DAT_TUR_ENERGY_MAX;
  self.en_rate = DAT_TUR_ENERGY_RATE;
  self.sh_cur = 0;
  self.sh_max = DAT_TUR_SHIELD_MAX;
  self.sh_rate = DAT_TUR_SHIELD_RATE;
  self.stat_ctor_hp = 0;
  self.radar_range = 0; 
  self.was_hit = FALSE;
  self.hitdir_buffer = 0;
  self.stat_hit_dirs = 0;
  self.stat_rdr_mode = 0;
  
  self.stat_spr_x = 0;
  self.stat_spr_y = 0;
  self.conv_min = '0 0 0';
  self.conv_max = '0 0 0';
  self.stat_lck_stt = LOCK_NONE;
  self.ideal_yaw = self.angles * '0 1 0';
  self.e_legs.prev_angle = self.angles;
  
  data_iniBuilding(ID_BLD_H_TURRET);
  ai_core_calcranges();

  mod_am = ai_pilot_armor_mod();
  self.max_health = self.health = self.health * mod_am; 
  if (!self.yaw_speed){
    mod_yaw = ai_pilot_yaw_mod();
    self.yaw_speed = self.m_rot_speed + (self.m_rot_speed * mod_yaw);
  }
  mod_yaw = ai_pilot_rating_leading();
  self.stat_spr_x = self.conv_min_x + self.conv_max_x;
  self.stat_spr_y = self.conv_min_y + self.conv_max_y;
  self.ai_rte_cnv = ai_pilot_rating_converg();
  self.ai_rte_rng = ai_pilot_rating_range();
  self.ai_optical = self.radar_range /2;
  self.maxpatience = ai_pilot_rating_patience();
  self.patience = 0;
  
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  self.flags = self.flags | FL_ONGROUND;
  
  if(self.state_1){
    self.ai_first_order = AI_ORDER_DEBUG;
  }
  else{
    self.ai_first_order = AI_ORDER_DEFEND;
  }
  self.enemy = world;
  self.oldgoal = world;
  self.ai_unit_update = ai_turret_update;
  self.th_missile = ai_attack;
  self.e_cam.SendEntity = send_vehicle;
  self.e_cam.SendFlags = -1;
  self.th_die = ai_turret_die;
  self.touch = ai_turret_touch;
  self.think = ai_turret_control;
  self.nextthink = time + 0.1;
};

void() data_tur_legs={
  self.c_name = DAT_TUR_LEG_CNAME;
  self.health = DAT_TUR_LEG_HP;
  self.max_health = DAT_TUR_LEG_HP;
  self.armorvalue = DAT_TUR_LEG_ARMOR;
  self.max_armor = DAT_TUR_LEG_ARMOR;
  self.c_model = DAT_TUR_LEG_MODEL;
  self.c_ofs = DAT_TUR_LEG_OFFSET;
};

void() data_tur_ctor={
  self.c_name = DAT_TUR_CTOR_CNAME;
  self.health = DAT_TUR_CTOR_HP;
  self.max_health = DAT_TUR_CTOR_HP;
  self.armorvalue = DAT_TUR_CTOR_ARMOR;
  self.max_armor = DAT_TUR_CTOR_ARMOR;
  self.c_model = DAT_TUR_CTOR_MODEL;
};

void() data_tur_wep1={  
  self.c_parent = DAT_TUR_WEP1_CPARENT;
  self.data_idx = DAT_TUR_WEP1_IDX; //consult weapon idx table!
  self.c_ofs = DAT_TUR_WEP1_OFFSET;
  self.c_alt_ofs = DAT_TUR_WEP1_OFFSET_ALT;
  self.w_adj_ang = DAT_TUR_WEP1_ADJ_ANG;
  self.w_group = WEAPON1;
};
void() data_tur_wep2={  
  self.c_parent = DAT_TUR_WEP2_CPARENT;
  self.data_idx = DAT_TUR_WEP2_IDX; //consult weapon idx table!
  self.c_ofs = DAT_TUR_WEP2_OFFSET;
  self.c_alt_ofs = DAT_TUR_WEP2_OFFSET_ALT;
  self.w_adj_ang = DAT_TUR_WEP2_ADJ_ANG;
  self.w_group = WEAPON2;
};

void() data_tur_cam={ 
  self.c_name = DAT_TUR_CAM_CNAME;
  self.c_ofs = DAT_TUR_CAM_OFFSET;
  self.c_alt_ofs = DAT_TUR_CAM_OFFSET_ALT;
  self.c_model = DAT_TUR_CAM_MODEL;
};