/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//PARTICLE ACCELERATOR CANNON=======================
float DAT_PAC_HPX = 100;

void() data_pac_atk;
void() data_pac_think;

void() data_pac_ini={
  self.data_idx = ID_WEP_PAC;
  self.w_name = DAT_PAC_NAME;
  self.p_damage = DAT_PAC_DMG;
  self.p_dmgtype = ( DMG_ENE | EFF_PRC);
  self.w_firetime = 0;
  self.w_clipsize = DAT_PAC_CLIPSIZE;
  self.w_currentammo = DAT_PAC_CLIPSIZE;
  self.w_fire_ofs = DAT_PAC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_PAC_MODEL;
  self.w_attack = data_pac_atk;
  self.reloadValue = DAT_PAC_RL_MAX;
  self.reloadRate = DAT_PAC_RL_RATE;
  self.reloadMax = DAT_PAC_RL_MAX;
  self.energyRate = DAT_PAC_EN_RATE;
  self.fire_sound = DAT_PAC_FIRESOUND;
  self.techLevel = DAT_PAC_TECH_LEVEL;
  self.i_size = DAT_PAC_WSIZE;
  self.w_think = data_pac_think;
  self.health = DAT_PAC_HPX;
  self.max_health = DAT_PAC_HPX;
  self.w_range = DAT_PAC_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.spreadDefault = DAT_PAC_ACC;
};

void() data_pac_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.reloadValue = 100;
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
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

void() data_pac_atk={
  local entity player, part;
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
  
  makevectors( self.angles );
  pointparticles( particleeffectnum("TE_PAC_MUZZLE"), org, normalize( dir - org ) * 4, 1);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  
  trailparticles( world, particleeffectnum("TE_PAC_RAIL"), org, dir);

  if( trace_ent.takedamage ){
    t_damage(trace_ent, self, player, self.p_damage, self.p_dmgtype, dir + (v_forward*3), '0 0 0');
    if( trace_ent.shield > 0 ){
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD"), dir + (v_forward * -5), normalize( dir - org ) * -4, 1);
      pointparticles( particleeffectnum("TE_PAC_IMPACT_SHIELD_POINT"), dir + (v_forward * -5), '0 0 0', 1);
    }
    else{
      pointparticles( particleeffectnum("TE_PAC_IMPACT_ARMOR"), dir + (v_forward * -5), normalize( dir - org ) * -4, 1);
    }
    return;
  }
  
  pointparticles( particleeffectnum("TE_PAC_IMPACT_GROUND"), dir + (v_forward * -5), normalize( dir - org ) * -4, 1);
};
