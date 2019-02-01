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
  self.p_dmgtype = self.p_dmgtype | DMG_BAL | EFF_PRC;
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
  local entity player, oself;
  local vector dir, org, end, adj, angl;
  local float range;
 
  player = self.owner;
 
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
 
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  range = self.w_range;
  angl = player.v_angle; //set by each AI, due to FL_TURRET
 
  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
 
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI( org, angl, self.w_range, player );
  }
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

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
