/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//Electro static Rifle=======================
float DAT_ESR_IDX = ID_WEP_ESR;
string DAT_ESR_NAME = "ESR";
float DAT_ESR_DMG = 25;
float DAT_ESR_FIRETIME = 0;
float DAT_ESR_CLIPSIZE = 10;
float DAT_ESR_CURRENTAMMO = 10;
float DAT_ESR_FIRERATE = 0.1;
float DAT_ESR_RELOADTIME = 1;
vector DAT_ESR_FIRE_OFS = '0 0 2';
string DAT_ESR_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_EN_COST = 0.18;
string DAT_ESR_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_TECH_LEVEL = 1;
float DAT_ESR_SPR_X = 5;
float DAT_ESR_SPR_Y = 5;
float DAT_ESR_WSIZE = 3;
float DAT_ESR_HPX = 20;

void() data_wep_esr;
void() data_esr_ini;
void() data_esr_atk;
void() data_esr_think;

void() data_wep_esr={
  local entity oself, esr;
  esr = spawn();
  oself = self;
  self = esr;
    self.classname = "data";
    self.data_idx = DAT_ESR_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_esr_ini;
    self.w_name = DAT_ESR_NAME;
  self = oself;
};

void() data_esr_ini={
  self.data_idx = DAT_ESR_IDX;
  self.w_name = DAT_ESR_NAME;
  self.w_firetime = DAT_ESR_FIRETIME;
  self.w_clipsize = DAT_ESR_CLIPSIZE;
  self.w_currentammo = DAT_ESR_CURRENTAMMO;
  self.w_firerate = DAT_ESR_FIRERATE;
  self.w_reloadtime = DAT_ESR_RELOADTIME;
  self.w_isready = 0;
  self.w_fire_ofs = DAT_ESR_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ESR_MODEL;
  self.w_attack = data_esr_atk;
  self.en_cur = 0;
  self.en_max = DAT_ESR_EN_COST;
  self.fire_sound = DAT_ESR_SOUND;
  self.i_techlvl = DAT_ESR_TECH_LEVEL;
  self.i_size = DAT_ESR_WSIZE;
  self.w_think = data_esr_think;
  self.health = DAT_ESR_HPX;
  self.max_health = DAT_ESR_HPX;
};

void() data_esr_think={
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

void() data_esr_atk={
 local entity cam, player, oself, proj;
  local vector spread;
	local vector dir,org, end, adj;
  player = self.owner;
  
  self.w_isready = FALSE;
  self.w_currentammo = self.w_currentammo - 1;
  self.w_firetime = time + self.w_firerate;

  makevectors(player.v_angle);
  cam = player.e_cam;//.clientcamera;
  traceline(cam.origin, cam.origin + v_forward*500, FALSE, player);
  end = trace_endpos + (crandom() * (player.stat_spr_x + DAT_ESR_SPR_X) * v_right) + (v_up * crandom() * (player.stat_spr_y +  DAT_ESR_SPR_Y));
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  traceline(org, end, FALSE, player);
  dir = trace_endpos;
  
  //if (player.t_width < time){
   // player.t_width = time + 0.05;//0.6;
	//}
  if((self.flags & FL_CLIENT)){
  	player.punchangle_x = -0.05;
  }


  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, org);
  
  //T_Damage(trace_ent, self.owner, self.owner, 12, 12, "", DT_IMPACT, other.origin, '0 0 0', Obituary_Generic);
  //damage_mech_main(trace_ent, self.owner, self.owner, 12, 0);
  local float dtype;
  dtype = dtype | DMG_ENE;
  
  if(trace_ent != world){
    local float bbx;
    bbx = trace_ent.c_bbx_x_x / 4;
    dir = dir + (v_forward*bbx);
  }
  te_customflash(dir, 4, 10, '0 0 1');
  t_damage(trace_ent, self, player, DAT_ESR_DMG, dtype, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/laser_test.ogg", 1, ATTN_NORM); 
  te_beam(laser_org, laser_org.origin, dir); 
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
  
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
