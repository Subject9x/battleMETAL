/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//Electro static Rifle=======================
float DAT_ESR_IDX = ID_WEP_ESR;
string DAT_ESR_NAME = "ESR";
float DAT_ESR_DMG = 50;
float DAT_ESR_FIRETIME = 0;
float DAT_ESR_CLIPSIZE = 10;
float DAT_ESR_CURRENTAMMO = 10;
float DAT_ESR_FIRERATE = 0.1;
vector DAT_ESR_FIRE_OFS = '0 0 2';
string DAT_ESR_MODEL = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_EN_COST = 10;
float DAT_ESR_EN_MAX = 500;
string DAT_ESR_SOUND = "q3mdl/weapons/w_laser.md3";
float DAT_ESR_TECH_LEVEL = 1;
float DAT_ESR_SPR_X = 8;
float DAT_ESR_SPR_Y = 8;
float DAT_ESR_WSIZE = 3;
float DAT_ESR_HPX = 20;
float DAT_ESR_RANGE = 400;

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
  self.p_dmgtype = self.p_dmgtype | DMG_ENE;
  self.p_damage = DAT_ESR_DMG;
  self.w_firetime = DAT_ESR_FIRETIME;
  self.w_clipsize = DAT_ESR_CLIPSIZE;
  self.w_currentammo = DAT_ESR_CURRENTAMMO;
  self.w_firerate = DAT_ESR_FIRERATE;
  self.w_fire_ofs = DAT_ESR_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ESR_MODEL;
  self.w_attack = data_esr_atk;
  self.en_cur = DAT_ESR_EN_MAX;
  self.en_rate = DAT_ESR_EN_COST;
  self.en_max = DAT_ESR_EN_MAX;
  self.fire_sound = DAT_ESR_SOUND;
  self.i_techlvl = DAT_ESR_TECH_LEVEL;
  self.i_size = DAT_ESR_WSIZE;
  self.w_think = data_esr_think;
  self.health = DAT_ESR_HPX;
  self.max_health = DAT_ESR_HPX;
  self.w_range = DAT_ESR_RANGE;
  self.stat_spr_x = DAT_ESR_SPR_X;
  self.stat_spr_y = DAT_ESR_SPR_Y;
  self.w_state = READY;
  self.w_isburst = FALSE;
};

void() data_esr_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - self.en_rate;
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.w_state = READY;
      }
    }
  }
};

void() data_esr_atk={
  local entity cam, player, oself, proj;
  local vector spr;
	local vector dir,org, end, adj;
  player = self.owner;
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading);
    if((player.flags & FL_MONSTER)){
      if((end == player.origin) || (dir == player.origin)){
        player.patience = player.patience + 1;
        return;
      }
    }    
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
    self.w_isburst = FALSE;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, self.fx_origin);
  
  //T_Damage(trace_ent, self.owner, self.owner, 12, 12, "", DT_IMPACT, other.origin, '0 0 0', Obituary_Generic);
  //damage_mech_main(trace_ent, self.owner, self.owner, 12, 0);
  local float dtype;
  dtype = dtype | DMG_ENE;
  
  
  t_damage(trace_ent, self, player, self.p_damage, dtype, dir + (v_forward*3), '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/laser_test.ogg", 1, ATTN_NORM); 
  te_beam(laser_org, laser_org.origin, dir); 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.01;
  
  if(pointcontents(dir) == CONTENT_SOLID){
    te_flamejet(dir, '0 25 0', 5);
    te_customflash(dir, 4, 10, '0 0 1');
  }
};
