/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Item - Weapon
    Light Laser
      Range - Long
      Consumes Energy
      Mild Dmg buff against shields

*/
void() data_ini_attack_laser;

void() data_ini_light_laser={
  
  self.data_idx = 3;
  self.w_name = "Light Laser";
  
  self.w_clipsize = 1;
  self.rl_rate = 0.6;
  self.rl_max = 0.6;
  self.en_rate =  6.67;
  self.spreadDefault = '0.0075 0.0075 0';
  
  self.w_think = default_weapon_think;
  self.w_attack = data_ini_attack_laser;

  self.w_range = 2000;
  self.p_damage = 10;
  self.p_dmgtype = (DMG_ENE | EFF_STX);
 
  self.w_fire_ofs = '0 0 3.5'; 
  self.fire_sound = "sound/weapons/laser_fire.ogg";
  self.model = "q3mdl/weapons/w_laser.md3";
  self.i_techlvl = 1;
  self.i_size = 1;
};

void() data_ini_attack_laser={
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
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }

  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.c_parent, player);
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
    if( trace_ent.sh_cur <= 0 ){
      pointparticles(particleeffectnum("TE_LAS_HIT"), dir , normalize( org - dir ), 1);
    }
    return;
  }
  
  pointparticles(particleeffectnum("TE_LAS_DIRT"), dir , '0 0 0', 1);
};
