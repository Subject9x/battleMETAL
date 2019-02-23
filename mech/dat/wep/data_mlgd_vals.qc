/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
float DAT_MLGD_HPX = 125;

void() data_mlgd_atk;
void() data_mlgd_think;

void() data_mlgd_ini={
  self.data_idx = ID_WEP_MLGD;
  self.w_name = DAT_MLGD_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_MLGD_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_MLGD_CLIPSIZE;
  self.w_currentammo = DAT_MLGD_CLIPSIZE;
  self.w_fire_ofs = DAT_MLGD_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_MLGD_MODEL;
  self.w_attack = data_mlgd_atk;
  self.w_proj = DAT_MLGD_PROJ_ID;
  self.rl_cur = DAT_MLGD_RL_MAX;
  self.rl_rate = DAT_MLGD_RL_RATE;
  self.rl_max = DAT_MLGD_RL_MAX;
  self.en_rate = DAT_MLGD_EN_RATE;
  self.fire_sound = DAT_MLGD_FIRESOUND;
  self.i_techlvl = DAT_MLGD_TECH_LEVEL;
  self.i_size = DAT_MLGD_WSIZE;
  self.w_think = data_mlgd_think;
  self.health = DAT_MLGD_HPX;
  self.max_health = DAT_MLGD_HPX;
  self.w_range = DAT_MLGD_RANGE;
  self.w_isburst = FALSE;
  self.spreadDefault = DAT_LGM_ACC;
};

void() data_mlgd_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.rl_cur = 100;
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
      lim = self.rl_max;      
      self.rl_cur = (delta / lim) * 100;
    }
  }
};

void() data_mlgd_atk={
  local entity player, oself;
  local vector dir, org, end, adj, angl, lasOrg;
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
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.rl_rate;
    self.w_state = RECOIL;
  }
  
  lasOrg = org + (v_forward * 2.1) + (v_up * -0.5);
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), org + (v_forward * 2) + (v_right * -0.65), normalize((org + v_up * 2) - org), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), org + (v_forward * 2) + (v_right * 0.65), normalize((org + v_up * 2) - org), 1);
  pointparticles( particleeffectnum("TE_LGM_MUZZLE"), org + (v_forward * 2) + (v_up * 1), normalize((org + v_up * 2) - org), 1);
  
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), lasOrg + (v_right * 0.5), lasOrg + (v_forward * 16) + (v_right * 0.5) );
  trailparticles( world, particleeffectnum("TE_LGM_MUZZLE_LASER"), lasOrg + (v_right * -0.5), lasOrg + (v_forward * 16) + (v_right * -0.5) );
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.velocity = normalize(dir - org);
    self.think = data_prj_mlgd_th;
    self.nextthink = time + 0.05;
    self.p_lifetime = time + self.p_lifetime;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setModel(self.c_model, 0, 0);
    setsize(self, '0 0 0', '0 0 0');
    setorigin(self, org + (v_forward * 4));
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
  self = oself;
};