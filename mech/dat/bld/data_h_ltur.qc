/*
mech Mod
Author: Subject9x
Date: 10/28/2017
Overview:
  name: Human Light Turret
  type: turret
  size: small
*/

//MATOK MECH=============================
float DAT_TUR_IDX = ID_BLD_H_TURRET;
string DAT_TUR_VEC_NAME = "Light Turret";
float DAT_TUR_TECH_LEVEL = 1;
float DAT_TUR_RADAR_RANGE = 400;
float DAT_TUR_ENERGY_CUR = 0;
float DAT_TUR_ENERGY_MAX = 400;
float DAT_TUR_ENERGY_RATE = 1;
float DAT_TUR_SHIELD_CUR = 0;
float DAT_TUR_SHIELD_MAX = 1200;
float DAT_TUR_SHIELD_RATE = 0.35;
float DAT_TUR_YAWSPEED = 2.5;
vector DAT_TUR_CTOR_BBX_N ='-20 -20 0';
vector DAT_TUR_CTOR_BBX_X ='20 20 14';
float DAT_TUR_M_FSPEED=0;
float DAT_TUR_M_SSPEED=0;
float DAT_TUR_M_BSPEED=0;

string DAT_TUR_M_PITCH_N = "-25";
string DAT_TUR_M_PITCH_X = "45";

vector DAT_TUR_SPREAD_N = '8 6 0.01';
vector DAT_TUR_SPREAD_X = '14 10 0.03';

//HITPOINT VALUES
float DAT_TUR_CTOR_HP = 1200;
float DAT_TUR_CTOR_HPMAX= 1200;
float DAT_TUR_LEG_HP = 1500;
float DAT_TUR_LEG_HPMAX= 1500;

//ARMOR VALUES
float DAT_TUR_CTOR_ARMOR= 100;
float DAT_TUR_CTOR_ARMMAX= 100;
float DAT_TUR_LEG_ARMOR= 100;
float DAT_TUR_LEG_ARMMAX= 100;

//WEAOPON GROUPS
float DAT_TUR_WEP1_IDX= ID_WEP_LATC;
float DAT_TUR_WEP2_IDX= ID_WEP_LAS;
float DAT_TUR_WEP1_GROUP= 1;

//this is mostly cosmetics
string DAT_TUR_CTOR_MODEL= "q3mdl/mechs/hvd/mdl_hvd_t_cent.md3";

//LEGS
string DAT_TUR_LEG_CNAME= M_LEGS;
string DAT_TUR_LEG_MODEL= "q3mdl/mechs/hvd/mdl_hvd_legs.md3";
vector DAT_TUR_LEG_OFFSET= '0 -30 0';

//CENTER TORSO
string DAT_TUR_CTOR_CNAME= M_TOR_CENTER;

//WEAPON1
string DAT_TUR_WEP1_CPARENT= M_ARM_RIGHT;
vector DAT_TUR_WEP1_OFFSET= '3 -6 14';
vector DAT_TUR_WEP1_OFFSET_ALT= DAT_HVD_RARM_OFFSET;
vector DAT_TUR_WEP1_ADJ_ANG= '0 0 90';

//WEAPON2
string DAT_TUR_WEP2_CPARENT= M_ARM_RIGHT;
vector DAT_TUR_WEP2_OFFSET= '0 -8 14';
vector DAT_TUR_WEP2_OFFSET_ALT= DAT_HVD_RARM_OFFSET;
vector DAT_TUR_WEP2_ADJ_ANG= '0 0 90';


//=========================================
void() data_tur_hmn;
void() data_tur_ini;
void() data_tur_legs;
void() data_tur_ctor;
void() data_tur_wep1;
void() data_tur_wep2;

//call this guy at the start of the world ini
void() data_tur_hmn={
  local entity TUR, oself;
  TUR = spawn();
  oself = self;
  self = TUR;
    self.data_idx = DAT_TUR_IDX;
    self.classname = "data";
    self.data_type = DATA_VEHC;
    self.vec_name = DAT_TUR_VEC_NAME;
    self.vec_size = 1;
    self.unit_ini = data_tur_ini;
    self.unit_legs = data_tur_legs;
    self.unit_ctor = data_tur_ctor;
    self.unit_wep1 = data_tur_wep1;
    self.unit_wep2 = data_tur_wep2;
    self.w_group1 = self.w_group1 | WEAPON1 | WEAPON2;    
  self = oself;
};

void() data_tur_ini={
  self.data_idx= DAT_TUR_IDX;
  self.vec_name= DAT_TUR_VEC_NAME;
  self.data_type = DATA_VEHC;
  self.radar_range = DAT_TUR_RADAR_RANGE;
  self.i_techlvl= DAT_TUR_TECH_LEVEL;
  self.en_cur= DAT_TUR_ENERGY_CUR;
  self.en_max= DAT_TUR_ENERGY_MAX;
  self.en_rate= DAT_TUR_ENERGY_RATE;
  self.sh_cur= DAT_TUR_SHIELD_CUR;
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
  self.data_idx = ID_BLD_H_TURRET;
  self.data_type = DATA_BLD;
  self.vec_name = "Light Turret";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_fuel.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(500, 500, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 64');
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = BecomeExplosion;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = 1;
};

void() data_tur_legs={
  self.c_name = DAT_TUR_LEG_CNAME;
  self.health = DAT_TUR_LEG_HP;
  self.max_health = DAT_TUR_LEG_HPMAX;
  self.armorvalue = DAT_TUR_LEG_ARMOR;
  self.max_armor = DAT_TUR_LEG_ARMMAX;
  self.c_model = DAT_TUR_LEG_MODEL;
  self.c_ofs = DAT_TUR_LEG_OFFSET;
};

void() data_tur_ctor={
  self.c_name = DAT_TUR_CTOR_CNAME;
  self.health = DAT_TUR_CTOR_HP;
  self.max_health = DAT_TUR_CTOR_HPMAX;
  self.armorvalue = DAT_TUR_CTOR_ARMOR;
  self.max_armor = DAT_TUR_CTOR_ARMMAX;
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