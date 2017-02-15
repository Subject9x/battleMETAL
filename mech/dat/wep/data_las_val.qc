/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LAS_IDX = ID_WEP_LAS;
string DAT_LAS_NAME = "Light Laser";
float DAT_LAS_DMG = 5;
float DAT_LAS_FIRETIME = 0;
float DAT_LAS_CLIPSIZE = 1;
float DAT_LAS_CURRENTAMMO = 1;
float DAT_LAS_FIRERATE = 0.8;
float DAT_LAS_RELOADTIME = 0.8;
float DAT_LAS_ISFIRE = 0;
vector DAT_LAS_FIRE_OFS = '0 0 6';
string DAT_LAS_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_EN_COST = 10;
string DAT_LAS_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_TECH_LEVEL = 1;

void() data_wep_las;
void() data_las_ini;
void() data_las_atk;

void() data_wep_las={
  local entity oself, las;
  las = spawn();
  oself = self;
  self = las;
    self.classname = "data";
    self.data_idx = DAT_LAS_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_las_ini;
    self.w_name = DAT_LAS_NAME;
  self = oself;
};

void() data_las_ini={
  self.data_idx = DAT_LAS_IDX;
  self.w_name = DAT_LAS_NAME;
  self.w_firetime = DAT_LAS_FIRETIME;
  self.w_clipsize = DAT_LAS_CLIPSIZE;
  self.w_currentammo = DAT_LAS_CURRENTAMMO;
  self.w_firerate = DAT_LAS_FIRERATE;
  self.w_reloadtime = DAT_LAS_RELOADTIME;
  self.w_isfire = DAT_LAS_ISFIRE;
  self.w_fire_ofs = DAT_LAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LAS_MODEL;
  self.w_attack = data_las_atk;
  //self.w_proj = DAT_LAS_PROJ_ID;
  self.en_max = DAT_LAS_EN_COST;
  self.fire_sound = DAT_LAS_SOUND;
  self.i_techlvl = DAT_LAS_TECH_LEVEL;
};

void() data_las_atk={
 local entity cam, player, oself, proj;
  local vector spread;
	local vector dir,org, end, adj;
  player = self.owner;
  
  makevectors(player.v_angle);
  cam = player.e_cam;//.clientcamera;
  traceline(cam.origin, cam.origin + v_forward*10000, FALSE, player);
  end = trace_endpos + (crandom() * (player.stat_spr_x / 0.75) * v_right) + (v_up * crandom() * (player.stat_spr_y /  0.75));
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  traceline(org, end, FALSE, player);
  dir = trace_endpos;
  
  if (player.t_width < time){
    player.t_width = time + 0.05;//0.6;
	}
	player.punchangle_x = -0.05;

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, org);
  
  //T_Damage(trace_ent, self.owner, self.owner, 12, 12, "", DT_IMPACT, other.origin, '0 0 0', Obituary_Generic);
  //damage_mech_main(trace_ent, self.owner, self.owner, 12, 0);
  local float dtype;
  dtype = DMG_ENE;
  t_damage(trace_ent, self, player, DAT_LAS_DMG, dtype, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/weapons/laser_3.ogg", 1, ATTN_NORM); 
  te_lightning1(laser_org, laser_org.origin, dir); 
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.001;// + 0.35;
};
