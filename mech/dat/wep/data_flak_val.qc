/*
battleMETAL
Author: Peter Roohr
Date: 01/18/2018
mod - 03/09/2019
Overview:
  slight upgrade from the ATC
  fires at rate 2/3 slower than ATC
  shrapnel explodes in front of target, like a small shotgun
*/
//FLAK CANNON=======================

float DAT_FLAK_HPX = 200;

void() data_flak_atk;
void() data_flak_think; 

void() data_flak_ini={
  self.data_idx = ID_WEP_FLAK;
  self.w_name = DAT_FLAK_NAME;
  self.damageType = self.damageType | DMG_BAL;
  self.damageValue = DAT_FLAK_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_FLAK_CLIPSIZE;
  self.w_currentammo = DAT_FLAK_CLIPSIZE;
  self.w_fire_ofs = DAT_FLAK_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_FLAK_MODEL;
  self.w_attack = data_flak_atk;
  self.reloadValue = DAT_FLAK_RL_MAX;
  self.reloadRate = DAT_FLAK_RL_RATE;
  self.reloadMax = DAT_FLAK_RL_MAX;
  self.energyRate = DAT_FLAK_EN_RATE;
  self.fire_sound = DAT_FLAK_FIRESOUND;
  self.techLevel = DAT_FLAK_TECH_LEVEL;
  self.i_size = DAT_FLAK_WSIZE;
  self.w_think = data_flak_think;
  self.health = DAT_FLAK_HPX;
  self.max_health = DAT_FLAK_HPX;
  self.w_range = DAT_FLAK_RANGE;
  self.w_state = READY;
  self.spreadDefault = DAT_FLAK_ACC;
};

void() data_flak_think={
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

void() data_flak_atk={
  local entity player, enm, part;
  local vector dir, org, adj;
  local float range;
  local entity boom;
  local vector ang, v;
  local float d;
  
  player = self.owner;
  range = self.w_range;
  enm = trace_ent;
  
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
    if((self.flags * FL_MONSTER)){
      self.w_firetime = time + (self.reloadRate / 10 ) / 1.5;
    }
    else{
      self.w_firetime = time + self.reloadRate / 2;
    }
    self.w_state = RECOIL;
    self.w_isburst = FALSE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs;
  part = util_getPartFromName(self.partParentId, player);
  makevectors( part.angles );
  org = player.origin + (v_forward * adj_z) + (v_right * adj_x) + (v_up * adj_y);
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  pointparticles( particleeffectnum("TE_FLK_MUZZLE"), org, normalize( dir - org ) * 4, 1);
  
  if( vlen(trace_endpos - org) > 100 ){
    pointparticles( particleeffectnum("TE_FLK_TRACER"), org, normalize( dir - org ) * 1600, 1);
  }
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
      pointparticles( particleeffectnum("TE_FLK_DIRT"), dir + (v_up * 3) + (v_forward * -7), normalize( dir - org ) * 20, 1);
    }
    return;
  }
  if(enm && enm != world){
    local float totes;
    totes = DAT_FLAK_SHRAP_TOTAL;
    if(enm.shield > 0){
      t_damage(enm, self, self.owner, self.damageValue * totes, self.damageType, trace_endpos, '0 0 0');
    }
    else{
      local vector shotpoint;
      local vector shrapPoint;
      local vector shotDir;
      local vector shrapDir;
      
      shotpoint = trace_endpos + (v_forward * -32);
      shotDir = normalize(trace_endpos - shotpoint);
      pointparticles( particleeffectnum("TE_FLK_IMPACT"), shotpoint, shotDir * 4, 1);
      while(totes > 0){
        shrapDir = shotDir + (crandom()*DAT_FLAK_SHRAP_SPREAD_x*v_right) + (crandom()*DAT_FLAK_SHRAP_SPREAD_y*v_up);
        shrapPoint = shotpoint + shrapDir*DAT_FLAK_SHRAP_SPREAD_z;
        traceline( shotpoint, shrapPoint, FALSE, self.owner);
        t_damage(enm, self, self.owner, self.damageValue, self.damageType, trace_endpos, '0 0 0');
        totes = totes - 1;
      }
    }
  }
};
