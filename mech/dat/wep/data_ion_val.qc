/*
mech Mod
Author: Peter Roohr
Date: 01/20/2018
overiew: Ion Coil - a lighter ION cannon, 3-rnd burst
*/
//ION COIL GUN=======================

float DAT_ION_HPX = 200;

void() data_ion_atk;  //the actual attack call
void() data_ion_think;

void() data_ion_ini={
  self.data_idx = ID_WEP_ION;
  self.w_name = DAT_ION_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_ION_CLIPSIZE;
  self.w_currentammo = DAT_ION_CLIPSIZE;
  self.w_fire_ofs = DAT_ION_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ION_MODEL;
  self.w_attack = data_ion_atk;
  self.w_proj = DAT_ION_PROJ_ID;
  self.rl_cur = 1;
  self.rl_rate = DAT_ION_RL_RATE;
  self.rl_max = DAT_ION_RL_MAX;
  self.en_rate = DAT_ION_EN_RATE;
  self.fire_sound = DAT_ION_FIRESOUND;
  self.i_techlvl = DAT_ION_TECH_LEVEL;
  self.i_size = DAT_ION_WSIZE;
  self.w_think = data_ion_think;
  self.health = DAT_ION_HPX;
  self.max_health = DAT_ION_HPX;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_STX | EFF_ENE;
  self.w_range = DAT_ION_RANGE;
  self.w_state = READY;
  self.p_damage = DAT_ION_DMG;
  self.w_isburst = FALSE;
  self.spreadDefault = DAT_ION_ACC;
};

void() data_ion_think={
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

void() data_ion_atk={
  local entity player, proj, oself;
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
  angl = player.angles;
  range = self.w_range;
  if( (player.flags & FL_MONSTER) ){
    angl = player.v_angle; //set by each AI, due to FL_TURRET
    range = player.ai_minrange;    //convergence / spread works differently for AI
  }
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
    self.w_firetime = time + self.rl_rate * 1.5;
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.velocity = normalize(dir - org);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.p_lifetime = time + self.p_lifetime;
    self.w_firetime = time + 0.5;
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = data_prj_ion_think;
    self.nextthink = time + 0.01;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org);
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};