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
  self.reloadValue = 1;
  self.reloadRate = DAT_ION_RL_RATE;
  self.reloadMax = DAT_ION_RL_MAX;
  self.energyRate = DAT_ION_EN_RATE;
  self.fire_sound = DAT_ION_FIRESOUND;
  self.techLevel = DAT_ION_TECH_LEVEL;
  self.i_size = DAT_ION_WSIZE;
  self.w_think = data_ion_think;
  self.health = DAT_ION_HPX;
  self.max_health = DAT_ION_HPX;
  self.p_dmgtype = (DMG_ENE | EFF_STX | EFF_ENE);
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
      self.reloadValue = (self.w_currentammo / self.w_clipsize) * 100;
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

void() data_ion_atk={
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
    self.w_isburst = FALSE;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.reloadRate * 1.5;
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.partParentId, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
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
  
  sound (newmis, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_ION_MUZZLE"), org + v_forward * 3 + v_up * 0.1, normalize( dir - org ) * 4, 1);
};