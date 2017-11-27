/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//Electro static Rifle=======================
float DAT_ESR_IDX = ID_WEP_ESR;
string DAT_ESR_NAME = "ESR";
float DAT_ESR_DMG = 25; //v0.0.3
float DAT_ESR_FIRETIME = 0;
float DAT_ESR_CLIPSIZE = 20;
float DAT_ESR_CURRENTAMMO = 20; //v0.0.3
float DAT_ESR_FIRERATE = 0.05; //v0.0.3
vector DAT_ESR_FIRE_OFS = '0 0 4';
string DAT_ESR_MODEL = "q3mdl/weapons/w_esr.md3";
float DAT_ESR_EN_COST = 10;
float DAT_ESR_EN_MAX = 500;
string DAT_ESR_SOUND = "sound/weapons/esr_fire.ogg";
float DAT_ESR_TECH_LEVEL = 1;
float DAT_ESR_SPR_X = 2; //v0.0.3
float DAT_ESR_SPR_Y = 2; //v0.0.3
float DAT_ESR_WSIZE = 3;
float DAT_ESR_HPX = 150; //v0.0.3
float DAT_ESR_RANGE = 800;//v0.0.3

void() data_esr_atk;
void() data_esr_think;

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
      self.owner.en_cur = self.owner.en_cur - (self.en_rate / 1.5);
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.en_cur = self.en_max;
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
    if((player.flags & FL_MONSTER) && (self.w_currentammo == self.w_clipsize) ){
      if(end == player.origin){
        player.patience = player.patience + 1;
        return;
      }
    }    
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.en_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    return;
  }
  else{
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + (self.w_firerate/1000);
    }
    else{
      self.w_firetime = time + self.w_firerate;
    }

    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }

  local entity laser_org, this;
  t_damage(trace_ent, self, player, self.p_damage, DMG_ENE, dir, '0 0 0');

  this = self;
  laser_org = spawn();
  self = laser_org;
    self.movetype = SOLID_NOT;
    self.classname = "missile";
    makevectors(this.angles);
    this.fx_origin = this.fx_origin + (v_forward*2);
    setorigin(self, this.fx_origin);
    setsize(self, '0 0 0', '0 0 0');
    self.scale = 1;
    self.think = SUB_Remove;
    self.nextthink = time + 0.01; //0.01
  self = this;
  sound (laser_org, CHAN_WEAPON, DAT_ESR_SOUND, 1, ATTN_NORM);
  
  te_beam(laser_org, laser_org.origin, dir); 

  
  te_flamejet(dir, '0 15 0', 5);
  te_customflash(dir, 4, 10, '0 0 1');
};
