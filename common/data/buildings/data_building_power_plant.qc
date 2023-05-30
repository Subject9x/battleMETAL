/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: Power Plant
  faction: any
  func: provides radar scanning to all friendly units and buildings in radius.
*/

#ifdef CSQC
void() power_plant_die_vfx={
  local vector margin;
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    te_field_mineral( margin, normalize(margin - self.origin) * rint(random() * 32), rint(random()*3) );
    te_field_mineral_light( margin, rint(random()*3) );
  }
  sound7(self, CHAN_AUTO, "sound/weapons/esr_fire.ogg", 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
};
#endif

void() power_plant_die = [0, power_plant_die1]{
#ifdef SSQC
  if( self.deadflag > DEAD_NO){
    return;
  }
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  ai_alert_close(self.enemy);
#endif
#ifdef CSQC
  power_plant_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
#endif
};
void() power_plant_die1 = [1, power_plant_die2]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};
void() power_plant_die2 = [2, power_plant_die3]{};
void() power_plant_die3 = [3, power_plant_die4]{};
void() power_plant_die4 = [4, power_plant_die5]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 4, 1 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};
void() power_plant_die5 = [5, power_plant_die6]{};
void() power_plant_die6 = [6, power_plant_die7]{};
void() power_plant_die7 = [7, power_plant_die8]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};
void() power_plant_die8 = [8, power_plant_die9]{};
void() power_plant_die9 = [9, power_plant_die10]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 3, 2 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif

};
void() power_plant_die10 = [10, power_plant_die11]{};
void() power_plant_die11 = [11, power_plant_die12]{};
void() power_plant_die12 = [12, power_plant_die13]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 2, 3 );
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};
void() power_plant_die13 = [13, power_plant_die14]{};
void() power_plant_die14 = [14, power_plant_die15]{
#ifdef SSQC
  local vector shoot;
  local entity head;
  
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 3 );
  
  //EMP bomb
  for( head = nextent(world); head != world; head = nextent(head) ){
    if( vlen(head.origin - self.origin) > (self.ai_minrange / 2) ){
      continue;
    }
    if( !(head.flags & FL_UNIT) && !(head.flags & FL_CLIENT) ){
      continue;
    }
    head.energy = head.energy - self.energy * 0.25;
    if( head.energy < 0 ){
      head.energy = 0;
    }
  }
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};
void() power_plant_die15 = [15, SUB_Null]{
#ifdef SSQC
  building_die();
#endif
#ifdef CSQC
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.60 0.7 0.75', 0.1 );
  power_plant_die_vfx();
#endif
};

#ifdef SSQC
void() hpower_th ={
  local entity t;
  local float cost;
  
  cost = 0;
  if( self.energy > 0 ){
    //power friendly local buildings
    for( t = nextent(world); t != world; t = nextent(t)){
      if(t == self){
        continue;
      }
      if( t.data_type != DATA_BLD ){
        continue;
      }
      if(vlen(t.origin - self.origin) > self.ai_minrange){
        continue;
      }
      if(t.faction != self.faction){
        continue;
      }
      t.energy = t.energy + self.energyRate;
      if( t.energy > t.energyMax ){
        t.energy = t.energyMax;
      }
      cost = cost + (self.energyRate * 0.08);
    }
  }
  self.energy = self.energy - cost;
  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
    
  building_burn();
  
  self.SendFlags = self.SendFlags | SENDFLAG_ENERGY;
  
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  
  self.think = hpower_th;
  self.nextthink = time + 0.1;
}; 
#endif


#ifdef CSQC
void() power_plant_active;

void() power_plant_idle={
  local vector smoke;
  if( self.energy > 0 ){
    self.think = power_plant_active;
    self.nextthink = time + 1;
    return;
  }
  
  makevectors(self.angles);
  smoke = self.origin + (v_up * (self.maxs_z * 0.33)) + (v_right * self.mins_x * 0.75) + (v_forward * self.maxs_y);
  
  self.think = power_plant_idle;
  self.nextthink = time + 1;
};

void() power_plant_active={
  local vector vfx, vfx2, vfx3;
  
  if( self.energy <= 0 ){
    self.think = power_plant_idle;
    self.nextthink = time + 0.1;
    return;
  }
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
    //local vfx - green ball
    vfx = randompos( self.compAltOffset, self.compOffset);
    te_field_rad( vfx, normalize(self.origin - vfx), 0.5 );
    
    //local vfx - blue vent front
    vfx2 = randompos(self.wepFireOffset, self.wepFireOffsetCache);
    te_field_mineral( vfx2, normalize(self.origin - vfx2), 1 );
      
    //local vfx - blue vent front
    vfx3 = randompos(self.cockpitOffset, self.w_adj_ang);
    te_field_mineral( vfx3, normalize(self.origin - vfx3), 1 );
  }
  self.think = power_plant_active;
  self.nextthink = time + (random() * 1);
};
#endif


void() building_power={
  self.data_idx = self.nextVecChoice = UI_BUILDING_power_plant;
  self.data_type = DATA_BLD;
  
  self.deadflag = DEAD_NO;  
  self.vec_name = "Power Plant";
  self.flags = self.flags | FL_MONSTER ;
  self.vec_size = 3;
  self.scale = 1;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "models/buildings/power_plant/powerplant.md3";
  precache_model("models/buildings/power_plant/powerplant.md3");
  setmodel(self, "models/buildings/power_plant/powerplant.md3");
  setsize(self, self.mins, self.maxs);
  
  if( !self.health) {
    self.health = 1200;
  }
  self.max_health = self.health;
  self.shield = 0;
  self.shieldMax = 300;
  self.shieldRate = 0;  //needs Shield Generator
  
  if( !self.energy ){
    self.energy = self.energyMax = 4000;
  }
  if( !self.energyRate ){
    self.energyRate = 4;
  }
  
  self.th_die = power_plant_die;
#ifdef CSQC
  //FIXME
  self.th_walk = power_plant_active;
  //local vfx - green ball
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.8)) + (v_right * self.mins_x * 0.85) + (v_forward * (self.mins_y * 0.65));
  self.compAltOffset = self.origin + (v_up * (self.maxs_z * 0.85)) + (v_right * (self.mins_x * 0.67)) + (v_forward * (self.mins_y * 0.45));
  //local vfx - blue vent front
  self.wepFireOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.maxs_y * 0.9);
  self.wepFireOffsetCache = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.maxs_y * 0.9);
  //local vfx - blue vent front
  self.cockpitOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.mins_y * 0.9);
  self.w_adj_ang = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.mins_y * 0.9);

#endif
#ifdef SSQC
  if( self.angle ){
    self.angles_y = self.angle;
  }
  
  if( !self.ai_minrange ){
    self.ai_minrange = 800;
  }
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  self.effects = self.effects | EF_LOWPRECISION;
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();
  setorigin(self, self.origin);
  
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  
  self.use = multi_trigger;
  
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }  
  if( self.canTarget || (self.spawnflags & IS_MAPKEY) ){
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  }
  
  self.building_delay_think = hpower_th;
  self.think = building_bbox_settle;
  self.nextthink = time + 0.01;
#endif
};