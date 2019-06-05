/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_HPX = 200;
void() data_latc_atk;
void() data_latc_think; 

void() data_latc_ini={
  self.data_idx = ID_WEP_LATC;
  self.w_name = DAT_LATC_NAME;
  self.p_dmgtype = (DMG_BAL | EFF_PRC);
  self.p_damage = DAT_LATC_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_currentammo = DAT_LATC_CLIPSIZE;
  self.w_fire_ofs = DAT_LATC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LATC_MODEL;
  self.w_attack = data_latc_atk;
  self.reloadValue = DAT_LATC_RL_MAX;
  self.reloadRate = DAT_LATC_RL_RATE;
  self.reloadMax = DAT_LATC_RL_MAX;
  self.energyRate = DAT_LATC_EN_RATE;
  self.fire_sound = DAT_LATC_FIRESOUND;
  self.techLevel = DAT_LATC_TECH_LEVEL;
  self.i_size = DAT_LATC_WSIZE;
  self.w_think = data_latc_think;
  self.health = DAT_LATC_HPX;
  self.max_health = DAT_LATC_HPX;
  self.w_range = DAT_LATC_RANGE;
  self.w_state = READY;
  self.spreadDefault = DAT_LATC_ACC;
};


void() data_latc_think={
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

void() data_latc_atk={
  local entity player, oself, part;
  local vector dir, org, adj;
  local float range;
  
  player = self.owner;
  range = self.w_range;

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
  
  pointparticles( particleeffectnum("TE_ATC_MUZZLE"), org, normalize( dir - org ) * 4, 1);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  
  if( vlen(dir - org) > 100 ){
    pointparticles( particleeffectnum("TE_ATC_TRACER"), org, normalize( dir - org ) * 1400, 1);
  }
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
      pointparticles( particleeffectnum("TE_ATC_DIRT"), dir + (v_up *1), normalize( (dir + (v_up *1)) - dir ) * 20, 1);
    }
    return;
  }
  
  if( trace_ent ){
    t_damage(trace_ent, self, player, self.p_damage, DMG_BAL, dir, '0 0 0');    
    if( trace_ent.shield <= 0 ){ 
      pointparticles( particleeffectnum("TE_ATC_ARMOR"), dir + v_forward * -3, normalize( dir - org ) * 4, 3);
    }
  }
};
