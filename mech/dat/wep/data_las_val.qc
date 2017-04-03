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
float DAT_LAS_DMG = 15;
float DAT_LAS_FIRETIME = 0;
float DAT_LAS_CLIPSIZE = 1;
float DAT_LAS_CURRENTAMMO = 1;
float DAT_LAS_FIRERATE = 0.8;
float DAT_LAS_RELOADTIME = 0.8;
vector DAT_LAS_FIRE_OFS = '0 0 2';
string DAT_LAS_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_EN_COST =  0.095;
string DAT_LAS_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_TECH_LEVEL = 1;
float DAT_LAS_WSIZE = 1;

void() data_wep_las;
void() data_las_ini;
void() data_las_atk;
void() data_las_think;

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
  self.w_isready = 0;
  self.w_fire_ofs = DAT_LAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LAS_MODEL;
  self.w_attack = data_las_atk;
  self.en_cur = 0;
  self.en_max = DAT_LAS_EN_COST;
  self.fire_sound = DAT_LAS_SOUND;
  self.i_techlvl = DAT_LAS_TECH_LEVEL;
  self.i_size = DAT_LAS_WSIZE;
  self.w_think = data_las_think;
};

void() data_las_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
    else{
      self.w_isready = FALSE;
      self.w_firetime = time + self.w_reloadtime;
      self.w_currentammo = self.w_clipsize;
    }
  }
  else{
    self.w_isready = FALSE;
  }
  
  if(!self.w_isready){
    self.owner.en_cur = self.owner.en_cur - self.en_max;
  }
};


void() data_las_atk={
 local entity cam, player, oself, proj;
  local vector spread;
	local vector dir,org, end, adj;
  player = self.owner;
  
  self.w_isready = FALSE;
  self.w_currentammo = self.w_currentammo - 1;
  self.w_firetime = time + self.w_firerate;
  
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
  //setmodel(laser_org, "progs/laser.mdl");
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, org);
  
  //T_Damage(trace_ent, self.owner, self.owner, 12, 12, "", DT_IMPACT, other.origin, '0 0 0', Obituary_Generic);
  //damage_mech_main(trace_ent, self.owner, self.owner, 12, 0);
  local float dtype;
  dtype = DMG_ENE;
  t_damage(trace_ent, self, player, DAT_LAS_DMG, dtype, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/laser_test.ogg", 1, ATTN_NORM); 
  //te_lightning1(laser_org, laser_org.origin, dir);
  
  
  WriteByte(MSG_ALL, SVC_TEMPENTITY);
  WriteByte(MSG_ALL, TE_LIGHTNING1);
  WriteEntity(MSG_ALL, laser_org);
  WriteCoord(MSG_ALL, laser_org.origin_x);
  WriteCoord(MSG_ALL, laser_org.origin_y);
  WriteCoord(MSG_ALL, laser_org.origin_z);
  WriteCoord(MSG_ALL, dir_x);
  WriteCoord(MSG_ALL, dir_y);
  WriteCoord(MSG_ALL, dir_z);
  
  
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
  
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.01;// + 0.35;
};
