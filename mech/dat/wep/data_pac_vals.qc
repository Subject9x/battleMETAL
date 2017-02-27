/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_PAC_IDX = ID_WEP_PAC;
string DAT_PAC_NAME = "PAC";
float DAT_PAC_DMG = 45;
float DAT_PAC_FIRETIME = 0;
float DAT_PAC_CLIPSIZE = 1;
float DAT_PAC_CURRENTAMMO = 2;
float DAT_PAC_FIRERATE = 1;
float DAT_PAC_RELOADTIME = 1;
float DAT_PAC_ISFIRE = 0;
vector DAT_PAC_FIRE_OFS = '0 0 6';
string DAT_PAC_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_PAC_EN_COST = 60;
string DAT_PAC_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_PAC_TECH_LEVEL = 1;
float DAT_PAC_SPR_X = 0;
float DAT_PAC_SPR_Y = 0;

void() data_wep_pac;
void() data_pac_ini;
void() data_pac_atk;

void() data_wep_pac={
  local entity oself, PAC;
  PAC = spawn();
  oself = self;
  self = PAC;
    self.classname = "data";
    self.data_idx = DAT_PAC_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_pac_ini;
    self.w_name = DAT_PAC_NAME;
  self = oself;
};

void() data_pac_ini={
  self.data_idx = DAT_PAC_IDX;
  self.w_name = DAT_PAC_NAME;
  self.w_firetime = DAT_PAC_FIRETIME;
  self.w_clipsize = DAT_PAC_CLIPSIZE;
  self.w_currentammo = DAT_PAC_CURRENTAMMO;
  self.w_firerate = DAT_PAC_FIRERATE;
  self.w_reloadtime = DAT_PAC_RELOADTIME;
  self.w_isfire = DAT_PAC_ISFIRE;
  self.w_fire_ofs = DAT_PAC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_PAC_MODEL;
  self.w_attack = data_pac_atk;
  self.en_cur = 0;
  self.en_max = DAT_PAC_EN_COST;
  self.fire_sound = DAT_PAC_SOUND;
  self.i_techlvl = DAT_PAC_TECH_LEVEL;
};

void() data_pac_atk={
 local entity cam, player, oself, proj;
  local vector spread;
	local vector dir,org, end, adj;
  player = self.owner;
  
  makevectors(player.v_angle);
  cam = player.e_cam;//.clientcamera;
  traceline(cam.origin, cam.origin + v_forward*2000, FALSE, player);
  end = trace_endpos + (crandom() * (player.stat_spr_x + DAT_PAC_SPR_X) * v_right) + (v_up * crandom() * (player.stat_spr_y +  DAT_PAC_SPR_Y));
  
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
  dtype = DMG_ENE + EFF_PRC;
  t_damage(trace_ent, self, player, DAT_PAC_DMG, dtype, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/gauss.ogg", 1, ATTN_NORM); 
  te_lightning1(laser_org, laser_org.origin, dir); 
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
  
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
