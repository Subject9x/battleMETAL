/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//QUANTUM RIFLE=======================
float DAT_QRFL_HPX = 150; 
float DAT_QRFL_QBITS = 8; 

void() data_qrfl_atk;
void() data_qrfl_think;

void() data_qrfl_ini={
  self.data_idx = ID_WEP_QRF;
  self.w_name = DAT_QRF_NAME;
  self.damageType = self.damageType | (DMG_BAL | EFF_STX | EFF_ENE);
  self.damageValue = DAT_QRFL_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_QRFL_CLIPSIZE;
  self.w_currentammo = DAT_QRFL_CLIPSIZE;
  self.w_fire_ofs = DAT_QRFL_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_QRFL_MODEL;
  self.w_attack = data_qrfl_atk;
  self.w_proj = DAT_QRFL_PROJ_ID;
  self.reloadMax = DAT_QRFL_RL_MAX;
  self.reloadRate = DAT_QRFL_RL_RATE;
  self.reloadValue = DAT_QRFL_RL_MAX;
  self.energyRate = DAT_QRFL_EN_RATE;
  self.fire_sound = DAT_QRFL_FIRESOUND;
  self.techLevel = DAT_QRFL_TECH_LEVEL;
  self.i_size = DAT_QRFL_WSIZE;
  self.w_think = data_qrfl_think;
  self.health = DAT_QRFL_HPX;
  self.max_health = DAT_QRFL_HPX;
  self.w_range = DAT_QRFL_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.spreadDefault = DAT_QRFL_ACC;
};

void() data_qrfl_think={
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

void() data_qrfl_atk={
  local entity player, oself, part;
  local vector dir, org, end, adj;
  local float range;
  local float qbits;
  local vector hitZone;
  local vector hitMin;
  local vector hitMax;
  local vector rando;

  local vector prtclRail_org;
  local vector prtclRail_end;
  local vector prtclSpark_org;
  
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
  
  hitZone = dir;
  hitMax = '25 25 25';
  hitMin = '-25 -25 -25';
  if( trace_ent.takedamage ){
    hitZone = trace_ent.origin;
    hitMin = trace_ent.mins * 2;
    hitMax = trace_ent.maxs * 2;
  }
  
  qbits = DAT_QRFL_QBITS;
  while(qbits > 0){
    newmis = spawn();
    oself = self;
    self = newmis;
      self.owner = player;
      data_iniProjectile(oself.w_proj);
      rando = randomvec();
      rando_x = hitZone_x + (hitMin_x - rando_x * hitMin_x) + (hitMax_x + random() * hitMax_x);
      rando_y = hitZone_y + (hitMin_y - rando_y * hitMin_y) + (hitMax_y + random() * hitMax_y);
      rando_z = hitZone_z + (hitMin_z - rando_z * hitMin_z) + (hitMax_z + random() * hitMax_z);
      self.damageType = oself.damageType;
      self.damageValue = oself.damageValue;
      self.velocity = normalize(hitZone - rando);
      self.think = SUB_Remove;
      self.nextthink = time + self.p_lifetime;
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
      if(pointcontents(rando) != CONTENT_SOLID){
        util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
        util_setModel(self.c_model, 0, 0);
        setsize(self, '0 0 0', '0 0 0');
        setorigin(self, rando);
        qbits = qbits - 1;
      }
      self = oself;
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  prtclRail_org = org + (v_forward * 2);
  prtclRail_end = org + (v_forward * 48);
  prtclSpark_org = org + (v_forward * 22);
  
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE"), prtclRail_org, normalize( dir - org ), 1);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org + (v_right * 0.5), normalize( dir - org ) * 30, 1);
  pointparticles( particleeffectnum("TE_QRFL_MUZZLE_SPARK"), prtclSpark_org - (v_right * 0.5), normalize( dir - org ) * 30, 1);
  trailparticles( self, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org + (v_right * 0.5), prtclRail_end + (v_right * 0.5));
  trailparticles( self, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), prtclRail_org - (v_right * 0.5), prtclRail_end - (v_right * 0.5));
};
