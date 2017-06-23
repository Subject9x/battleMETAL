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
float DAT_LAS_DMG = 30;
float DAT_LAS_FIRETIME = 0;
float DAT_LAS_CLIPSIZE = 1;
float DAT_LAS_CURRENTAMMO = 1;
float DAT_LAS_FIRERATE = 10;
vector DAT_LAS_FIRE_OFS = '0 0 2';
string DAT_LAS_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_EN_MAX = 200;
float DAT_LAS_EN_RATE = 10;
string DAT_LAS_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_LAS_TECH_LEVEL = 1;
float DAT_LAS_WSIZE = 1;
float DAT_LAS_HPX = 30;
float DAT_LAS_RANGE = 2400;

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
  self.p_dmgtype = self.p_dmgtype | DMG_ENE;
  self.p_damage = DAT_LAS_DMG;
  self.w_name = DAT_LAS_NAME;
  self.w_firetime = DAT_LAS_FIRETIME;
  self.w_clipsize = DAT_LAS_CLIPSIZE;
  self.w_currentammo = DAT_LAS_CURRENTAMMO;
  self.w_firerate = DAT_LAS_FIRERATE;
  self.w_fire_ofs = DAT_LAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LAS_MODEL;
  self.w_attack = data_las_atk;
  self.en_cur = DAT_LAS_EN_MAX;
  self.en_rate = DAT_LAS_EN_RATE;
  self.en_max = DAT_LAS_EN_MAX;
  self.fire_sound = DAT_LAS_SOUND;
  self.i_techlvl = DAT_LAS_TECH_LEVEL;
  self.i_size = DAT_LAS_WSIZE;
  self.w_think = data_las_think;
  self.health = DAT_LAS_HPX;
  self.max_health = DAT_LAS_HPX;
  self.w_range = DAT_LAS_RANGE;
  self.w_state = READY;
};

void() data_las_think={  
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - (self.en_rate/4);
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.w_state = READY;
      }
    }
  }
};


void() data_las_atk={
  local entity cam, player, oself, proj;
  local vector spread, dir, org, end, adj;

  player = self.owner;
    
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading); 
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
  
  if((player.flags & FL_MONSTER)){
    if((end == player.origin) || (dir == player.origin)){
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

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, self.fx_origin);
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.01;// + 0.35;
  
  sound (laser_org, CHAN_WEAPON, "sound/laser_test.ogg", 1, ATTN_NORM); 
  te_lightning1(laser_org, laser_org.origin, dir + (v_forward*3));
  
  te_flamejet(dir, '0 25 0', 5);
  
  local float dtype;
  dtype = DMG_ENE;
  
  t_damage(trace_ent, self, player, self.p_damage, dtype, dir, '0 0 0');
};
