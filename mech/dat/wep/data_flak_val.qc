/*
mech Mod
Author: Peter Roohr
Date: 01/18/2018
Overview: new year, new toys
*/
//FLAK CANNON=======================
float DAT_FLAK_IDX = ID_WEP_FLAK;
string DAT_FLAK_NAME = "Flak Cannon";
float DAT_FLAK_HPX = 200;

void() data_flak_atk;
void() data_flak_think; 

void() data_flak_ini={
  self.data_idx = ID_WEP_FLAK;
  self.w_name = DAT_FLAK_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL;
  self.p_damage = DAT_FLAK_DMG;
  self.w_proj = DAT_FLAK_PROJ_ID;
  self.w_firetime = 0;
  self.w_clipsize = DAT_FLAK_CLIPSIZE;
  self.w_currentammo = DAT_FLAK_CLIPSIZE;
  self.w_fire_ofs = DAT_FLAK_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_FLAK_MODEL;
  self.w_attack = data_flak_atk;
  self.rl_cur = DAT_FLAK_RL_MAX;
  self.rl_rate = DAT_FLAK_RL_RATE;
  self.rl_max = DAT_FLAK_RL_MAX;
  self.en_rate = DAT_FLAK_EN_RATE;
  self.fire_sound = DAT_FLAK_SOUND;
  self.i_techlvl = DAT_FLAK_TECH_LEVEL;
  self.stat_spr_x = DAT_FLAK_SPR_X;
  self.stat_spr_y = DAT_FLAK_SPR_Y;
  self.i_size = DAT_FLAK_WSIZE;
  self.w_think = data_flak_think;
  self.health = DAT_FLAK_HPX;
  self.max_health = DAT_FLAK_HPX;
  self.w_range = DAT_FLAK_RANGE;
  self.w_state = READY;
};


void() data_flak_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    self.rl_cur = self.rl_cur + self.rl_rate;
    if(self.rl_cur >= self.rl_max){
      self.rl_cur = self.rl_max;
      self.w_state = READY;
    }
  }
};

void() data_flak_atk={
  local entity player, this;
  local vector dir, end, adj, org; 
  
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
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
  }
  else{
    if((self.flags * FL_MONSTER)){
      self.w_firetime = time + (self.rl_rate / 10 ) / 1.5;
    }
    else{
      self.w_firetime = time + self.rl_rate / 2;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  newmis = spawn();
  this = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(this.w_proj);
    util_setModel(self.c_model, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setBoundBox('0 0 0', '0 0 0');
    self.velocity = normalize(dir - org);
    self.p_dmgtype = this.p_dmgtype;
    self.p_damage = this.p_damage;
    self.p_lifetime = time + self.p_lifetime;
    self.w_firetime = time + 0.1;
    setorigin(self, org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = data_prj_flak_think;
    self.touch = data_prj_flak_touch;
    self.nextthink = time + 0.01;
  self = this;
  
  
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
