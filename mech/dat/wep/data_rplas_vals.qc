/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//ROTARY PLASMA CANNON=======================
float DAT_RPLAS_HPX = 150;
float DAT_RPLAS_SHOT = 6;

void() data_rplas_atk;
void() data_rplas_think;

void() data_rplas_ini={
  self.data_idx = ID_WEP_RPC;
  self.w_name = DAT_RPC_NAME;
  self.w_isready = 0;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL;
  self.p_damage = DAT_RPLAS_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_RPLAS_CLIPSIZE;
  self.w_currentammo = DAT_RPLAS_CLIPSIZE;
  self.w_fire_ofs = DAT_RPLAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_RPLAS_MODEL;
  self.w_attack = data_rplas_atk;
  self.w_proj = DAT_RPLAS_PROJ_ID;
  self.rl_cur = DAT_RPLAS_RL_MAX;
  self.rl_rate = DAT_RPLAS_RL_RATE;
  self.rl_max = DAT_RPLAS_RL_MAX;
  self.en_rate = DAT_RPLAS_EN_RATE;
  self.fire_sound = DAT_RPLAS_FIRESOUND;
  self.i_techlvl = DAT_RPLAS_TECH_LEVEL;
  self.stat_spr_x = DAT_RPLAS_SPR_X;
  self.stat_spr_y = DAT_RPLAS_SPR_Y;
  self.i_size = DAT_RPLAS_WSIZE;
  self.w_think = data_rplas_think;
  self.health = DAT_RPLAS_HPX;
  self.max_health = DAT_RPLAS_HPX;
  self.w_range = DAT_RPLAS_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
};

void() data_rplas_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - self.en_rate;  
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur >= self.rl_max){
        self.rl_cur = self.rl_max;
        self.w_state = READY;
      }
    }
  }
};

void() data_rplas_atk={
  local entity player, proj, oself;
  player = self.owner;
  local vector dir, org, end, adj;
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading);  
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);

  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
  }
  else{
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + (self.rl_rate/1.5);
    }
    else{
      self.w_firetime = time + self.rl_rate/1.5;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);

  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);

  local vector sfx;
  adj_z = adj_z + 45;
  sfx = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.solid = SOLID_NOT;
  bul_fx.classname = "missile";
  bul_fx.movetype = MOVETYPE_NONE;
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '0 0 0', '0 0 0');
  setorigin(bul_fx, sfx);
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.001;// + 0.35;
  
  local vector norg;
  norg = org;
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.velocity = normalize(dir - org);
    self.think = SUB_Remove;
    self.nextthink = time + self.p_lifetime;
    self.velocity = self.velocity * self.p_velocity;
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.angles = vectoangles(self.velocity);
    util_setModel(self.c_model, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLY);
    util_setBoundBox('0 0 0', '0 0 0');        
    self.angles = oself.angles;
    makevectors(self.angles);
    norg = org + (v_up * 8);
    setorigin(self, norg);
  self = oself;
};
