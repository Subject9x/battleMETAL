/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//STANDARD LASER=======================
void() data_las_atk;
void() data_las_think;

void() data_las_ini={
  self.data_idx = ID_WEP_LAS;
  self.p_dmgtype = (DMG_ENE | EFF_STX);
  self.p_damage = DAT_LAS_DMG;
  self.w_name = DAT_LAS_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_LAS_CLIPSIZE;
  self.w_currentammo = DAT_LAS_CLIPSIZE;
  self.w_fire_ofs = DAT_LAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LAS_MODEL;
  self.w_attack = data_las_atk;
  self.en_rate = DAT_LAS_EN_RATE;
  self.rl_rate = DAT_LAS_RL_RATE;
  self.rl_cur = 100;
  self.rl_max = DAT_LAS_RL_MAX;
  self.fire_sound = DAT_LAS_FIRESOUND;
  self.i_techlvl = DAT_LAS_TECH_LEVEL;
  self.i_size = DAT_LAS_WSIZE;
  self.w_think = data_las_think;
  self.max_health = self.health = 1;
  self.w_range = DAT_LAS_RANGE;
  self.w_state = READY;
  self.spreadDefault = DAT_LAS_ACC;
};

void() data_las_think={  
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


void() data_las_atk={
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
  range = self.w_range;
  angl = player.v_angle; //set by each AI, due to FL_TURRET

  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
 
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI( org, angl, self.w_range, player );
  }
  dir = util_applySpreadToTrace( player.v_angle, self.w_range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }

  sound ( self, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), self.origin, player.angles, 1);
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), org, dir);
  
  if( pointcontents(dir) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir, '0 0 0');
    if( trace_ent.sh_cur <= 0 ){
      pointparticles(particleeffectnum("TE_LAS_HIT"), dir , normalize( org - dir ), 1);
    }
    return;
  }
  
  pointparticles(particleeffectnum("TE_LAS_DIRT"), dir , '0 0 0', 1);
};
