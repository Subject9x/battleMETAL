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
  self.p_dmgtype = (DMG_BAL | EFF_PRC);
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
  self.i_size = DAT_RPLAS_WSIZE;
  self.w_think = data_rplas_think;
  self.health = DAT_RPLAS_HPX;
  self.max_health = DAT_RPLAS_HPX;
  self.w_range = DAT_RPLAS_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.spreadDefault = DAT_RPC_ACC;
};

void() data_rplas_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
      self.rl_cur = (self.w_currentammo / self.w_clipsize) * 100;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
      self.rl_cur = 100;
      self.w_state = READY;
    }
    else{
      local float delta, lim;
      delta = time - self.count1;
      lim = self.rl_max;      
      self.rl_cur = (delta / lim) * 100;
    }
  }
};

void() data_rplas_atk={
  local entity player, oself, part;
  local vector dir, org, adj;
  local float range;
 
  player = self.owner;
  range = self.w_range;
 
  if( self.w_currentammo ==  self.w_clipsize){
    if(self.en_rate && (player.en_cur >= self.en_rate)){
      player.en_cur = player.en_cur - self.en_rate;
      if(player.en_cur < 0){
        player.en_cur = 0;
      }
    }
    else{
      return;
    }
  }
 
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    if( (player.flags & FL_MONSTER) ){
        self.w_firetime = time + (self.rl_rate / 1.5) * 2;
    }
    else{
        self.w_firetime = time + self.rl_rate / 1.5;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
 
  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.c_parent, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_RPC_MUZZLE"), org, normalize(dir - org) * 2, 1);
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.movetype = MOVETYPE_FLYMISSILE;
    self.solid = SOLID_BBOX;
    self.classname = "missile";
    self.velocity = normalize(dir - org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = SUB_Remove;
    self.nextthink = time + self.p_lifetime;
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');        
    setorigin(self, org);
  self = oself;
};
