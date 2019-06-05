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
  self.energyRate = DAT_LAS_EN_RATE;
  self.reloadRate = DAT_LAS_RL_RATE;
  self.reloadValue = 100;
  self.reloadMax = DAT_LAS_RL_MAX;
  self.fire_sound = DAT_LAS_FIRESOUND;
  self.techLevel = DAT_LAS_TECH_LEVEL;
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
      self.reloadValue = 100;
      self.w_state = READY;
    }
    else{
      local float delta, lim;
      delta = time - self.count1;
      lim = self.reloadMax;      
      self.reloadValue = (delta / lim) * 100;
    }
  }
};


void() data_las_atk={
  local entity player, oself, part;
  local vector dir, org, adj;
  local float range;

  player = self.owner;
  range = self.w_range;
  
  if( self.w_currentammo ==  self.w_clipsize){
    if(self.energyRate && (player.energy >= self.energyRate)){
      player.energy = player.energy - self.energyRate;
      if(player.energy < 0){
        player.energy = 0;
      }
    }
    else{
      return;
    }
  }

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.reloadValue = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }

  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.partParentId, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  sound ( self, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LAS_MUZZLE"), self.origin, player.angles, 1);
  trailparticles( world, particleeffectnum("TE_LAS_RAIL"), org, dir);
  
  if( pointcontents(dir) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir, '0 0 0');
    if( trace_ent.shield <= 0 ){
      pointparticles(particleeffectnum("TE_LAS_HIT"), dir , normalize( org - dir ), 1);
    }
    return;
  }
  
  pointparticles(particleeffectnum("TE_LAS_DIRT"), dir , '0 0 0', 1);
};
