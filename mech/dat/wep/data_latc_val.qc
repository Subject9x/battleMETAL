/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_IDX = ID_WEP_LATC;
string DAT_LATC_NAME = "Light Autocannon";
float DAT_LATC_DMG = 20; //was 2 - 3/27/2017
float DAT_LATC_FIRETIME = 0;
float DAT_LATC_CLIPSIZE = 1;  //was 3 - 3/27/2017
float DAT_LATC_CURRENTAMMO = 1;  //was 3 - 3/27/2017
float DAT_LATC_FIRERATE = 0.3;//was 0.15; - 5/14/2-017  //was 0.2 - 3/27/2017
vector DAT_LATC_FIRE_OFS = '0 0 2';
string DAT_LATC_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_LATC_PROJ_ID= ID_PRJ_LATC;
float DAT_LATC_EN_COST = 10;
float DAT_LATC_EN_MAX = 100;
string DAT_LATC_SOUND = "sound/ac5.ogg";
float DAT_LATC_TECH_LEVEL = 1;
float DAT_LATC_SPR_X = 0.25; //v0.0.3
float DAT_LATC_SPR_Y = 0.35; //v0.0.3
float DAT_LATC_WSIZE = 1;
float DAT_LATC_HPX = 200; //v0.0.3
float DAT_LATC_RANGE = 2400;

void() data_wep_latc;
void() data_latc_ini;
void() data_latc_atk;
void() data_latc_think; 

void() data_wep_latc={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_LATC_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_latc_ini;
    self.w_name = DAT_LATC_NAME;
  self = oself;
};

void() data_latc_ini={
  self.data_idx = DAT_LATC_IDX;
  self.w_name = DAT_LATC_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL;
  self.p_damage = DAT_LATC_DMG;
  self.w_firetime = DAT_LATC_FIRETIME;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_currentammo = DAT_LATC_CURRENTAMMO;
  self.w_firerate = DAT_LATC_FIRERATE;
  self.w_fire_ofs = DAT_LATC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LATC_MODEL;
  self.w_attack = data_latc_atk;
  self.w_proj = DAT_LATC_PROJ_ID;
  self.en_cur = DAT_LATC_EN_MAX;
  self.en_rate = DAT_LATC_EN_COST;
  self.en_max = DAT_LATC_EN_MAX;
  self.fire_sound = DAT_LATC_SOUND;
  self.i_techlvl = DAT_LATC_TECH_LEVEL;
  self.stat_spr_x = DAT_LATC_SPR_X;
  self.stat_spr_y = DAT_LATC_SPR_Y;
  self.i_size = DAT_LATC_WSIZE;
  self.w_think = data_latc_think;
  self.health = DAT_LATC_HPX;
  self.max_health = DAT_LATC_HPX;
  self.w_range = DAT_LATC_RANGE;
  self.w_state = READY;
};


void() data_latc_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur >= self.en_max){
      self.w_state = READY;
    }
  }
};

void() data_latc_atk={
  local entity player;
  local vector dir, end; 
  
  player = self.owner;
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading);
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);

  if((player.flags & FL_MONSTER)){
    if(end == player.origin){
      player.patience = player.patience + 1;
      return;
    }
  }
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.en_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  te_superspike(dir);
  t_damage(trace_ent, self, player, self.p_damage, DMG_BAL, dir, '0 0 0');
  
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.movetype = SOLID_NOT;
  bul_fx.classname = "missile";
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '-1 -1 -1', '1 1 1');
  makevectors(self.angles);
  self.fx_origin = self.fx_origin + (v_forward * 5);
  setorigin(bul_fx, self.fx_origin);
  bul_fx.alpha = 0.85;
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.01;// + 0.35;
};
