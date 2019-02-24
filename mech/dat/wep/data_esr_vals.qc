/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//Electro static Rifle=======================
float DAT_ESR_HPX = 150; 

void() data_esr_atk;
void() data_esr_think;

void() data_esr_ini={
  self.data_idx = ID_WEP_ESR;
  self.w_name = DAT_ESR_NAME;
  self.p_dmgtype =  ( DMG_ENE | EFF_STX );
  self.p_damage = DAT_ESR_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_ESR_CLIPSIZE;
  self.w_currentammo = DAT_ESR_CLIPSIZE;
  self.w_fire_ofs = DAT_ESR_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ESR_MODEL;
  self.w_attack = data_esr_atk;
  self.rl_cur = DAT_ESR_RL_MAX;
  self.rl_rate = DAT_ESR_RL_RATE;
  self.rl_max = DAT_ESR_RL_MAX;
  self.en_rate = DAT_ESR_EN_RATE;
  self.fire_sound = DAT_ESR_FIRESOUND;
  self.i_techlvl = DAT_ESR_TECH_LEVEL;
  self.i_size = DAT_ESR_WSIZE;
  self.w_think = data_esr_think;
  self.health = DAT_ESR_HPX;
  self.max_health = DAT_ESR_HPX;
  self.w_range = DAT_ESR_RANGE;
  self.w_state = READY;
  self.w_isburst = FALSE;
  self.spreadDefault = DAT_ESR_ACC;
};

void() data_esr_think={
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

void() data_esr_atk={
  local entity player, proj, oself, this;
  local vector dir, org, end, adj, angl;
  local float range;
  
  player = self.owner;
  range = self.w_range;
  
  if( self.w_currentammo == self.w_clipsize){
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
    self.w_firetime = time + self.rl_rate;
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }

  adj = self.c_ofs + self.w_fire_ofs;
  makevectors( player.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  sound (self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ESR_MUZZLE"), org + v_forward * 4, normalize( dir - org ) * 1, 1);
  trailparticles( world, particleeffectnum("TE_ESR_RAIL"), org + (v_forward* 4), dir);
  
  if( pointcontents(dir) == CONTENT_SKY ){
    return;
  }
  
  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, player, self.p_damage, DMG_ENE, dir, '0 0 0');
    if( trace_ent.sh_cur > 0 ){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), dir + v_up * 1, normalize( dir - org ) * 1, 1);
    }
    else{
       pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), dir + v_up * 1, normalize( dir - org ) * 1, 1);
    }
    return;
  }
  
  pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), dir + v_up * 1, normalize( dir - org ) * 1, 1);
};
