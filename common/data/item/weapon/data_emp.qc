/*
battleMETAL
Author: Peter Roohr
Date: 05/28/2019
Overview: 
  Data File - Item - Weapon
    EMP
      Short range.
      Shield breaking.
      Small AoE.
      Consumes Energy
*/
void() data_ini_attack_emp_;

void() data_ini_emp_={

  self.data_idx = 2;  
  self.w_name = "EMP Cannon";
  
  self.w_clipsize = 1;
  self.rl_rate = 0.1;
  self.rl_max = 6;
  self.en_rate = 266.7;
  self.spreadDefault = '0.009 0.008 0';
  
  self.w_range = 1700;
  self.p_damage = 400;
  self.p_dmgtype = (DMG_ENE | EFF_STX | EFF_ENE);
  
  self.w_attack = data_ini_attack_emp_;
  self.think = default_weapon_think;
  self.data_ini_projectile = data_projectile_ini_emp_;
  
  self.w_fire_ofs = '0 0.1 7';
  self.fire_sound = "sound/weapons/emp_fire.ogg";
  self.model = "q3mdl/weapons/w_emp.md3";
  self.i_techlvl = 2;
  self.i_size = 3;
};

void() data_ini_attack_emp_={
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
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  if( self.c_part ){
    part = self.c_part;
  }
  else{
    part = player;
  }
  
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.rl_cur = 0;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  if( self.data_ini_projectile ){
    newmis = spawn();
    oself = self;
    self = newmis;
      self.owner = player;
      self.velocity = normalize(dir - org);
      self.p_dmgtype = oself.p_dmgtype;
      self.p_damage = oself.p_damage;
      self.p_lifetime = time + self.p_lifetime;
      self.w_firetime = time + 0.5;
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
      self.nextthink = time + 0.01;
      util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
      util_setModel(self.c_model, 0, 0);
      setsize(self, '0 0 0', '0 0 0');
      setorigin(self, org);
    self = oself;
  }
  
  sound (newmis, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_EMP_MUZZLE"), org + v_forward * 3 + v_up * 0.1, normalize( dir - org ) * 4, 1);
};
