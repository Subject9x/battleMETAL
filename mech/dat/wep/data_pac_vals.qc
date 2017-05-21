/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_PAC_IDX = ID_WEP_PAC;
string DAT_PAC_NAME = "PAC";
float DAT_PAC_DMG = 60;
float DAT_PAC_FIRETIME = 0;
float DAT_PAC_CLIPSIZE = 1;
float DAT_PAC_CURRENTAMMO = 1;
float DAT_PAC_FIRERATE = 2;
float DAT_PAC_RELOADTIME = 2;
vector DAT_PAC_FIRE_OFS = '0 0 2';
string DAT_PAC_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_PAC_EN_COST =  0.15;
string DAT_PAC_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_PAC_TECH_LEVEL = 1;
float DAT_PAC_SPR_X = 0;
float DAT_PAC_SPR_Y = 0;
float DAT_PAC_WSIZE = 2;
float DAT_PAC_HPX = 20;
float DAT_PAC_RANGE = 600;

void() data_wep_pac;
void() data_pac_ini;
void() data_pac_atk;
void() data_pac_think;

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
  self.w_isready = 0;
  self.w_fire_ofs = DAT_PAC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_PAC_MODEL;
  self.w_attack = data_pac_atk;
  self.en_cur = 0;
  self.en_max = DAT_PAC_EN_COST;
  self.fire_sound = DAT_PAC_SOUND;
  self.i_techlvl = DAT_PAC_TECH_LEVEL;
  self.i_size = DAT_PAC_WSIZE;
  self.w_think = data_pac_think;
  self.health = DAT_PAC_HPX;
  self.max_health = DAT_PAC_HPX;
  self.w_range = DAT_PAC_RANGE;
};

void() data_pac_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
  }
  else{
    if(self.owner.en_cur > 0){
      self.owner.en_cur = util_zeroStat(self.en_max, self.owner.en_cur);
    }
    else{
      self.w_firetime = time + self.w_reloadtime;
    }
    self.w_isready = FALSE;
  }
};

void() data_pac_atk={
  
  self.w_isready = FALSE;
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <=0){
    self.w_firetime = time + self.w_reloadtime;
    self.power_timer = self.w_firetime;
    self.w_currentammo = self.w_clipsize;
  }
  else{
    self.w_firetime = time + self.w_firerate;
  }
  
  local entity cam, player, oself, proj;
  local vector spread;
	local vector dir, end, adj;
  player = self.owner;
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, (player.stat_spr_x + self.stat_spr_x), (player.stat_spr_y+self.stat_spr_y), '1 1 1', self.w_range);
  }
  else{
    local vector spr;
    spr_x = player.stat_spr_x + self.stat_spr_x;
    spr_y = player.stat_spr_y + self.stat_spr_y;
    end = util_traceForAI(player, spr, '1 1 1', self.w_range, 10); 
  }
  dir = util_traceForOffset(player, self, end);
  
	player.punchangle_x = -0.05;

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, self.fx_origin);
  
  local float dtype;
  dtype = DMG_ENE + EFF_PRC;

  t_damage(trace_ent, self, player, DAT_PAC_DMG, dtype, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/gauss.ogg", 1, ATTN_NORM); 
  te_beam(laser_org, laser_org.origin, dir); 
  te_flamejet(dir, '0 25 0', 5);
  te_plasmaburn(dir);
  
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.011;// + 0.35;
};
