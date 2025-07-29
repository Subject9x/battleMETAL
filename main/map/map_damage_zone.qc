/*
battleMETAL
Author: Peter Roohr
Date: 11/14/2018
mod: 05/10/2020
Overview: 
  Damage ones are like small-scale toxic pools. They're a single obj, 1 of 3 sizes - Small, Med, Large.
  There are 3 flavors of Damage.
    RAD = Radiation - deals damage directly to armor, ignores shields.
    QTM = Quantum - deals damage as energy sapped from colliding unit's energy pool.
    STA = Static - deals damage to unit's shields.

  SPAWNFLAGS
    START_OFF 1: START_OFF - only activated by trigger
    LIFETIME 2: lifetime
    REACTIVATE 4: reactivate after countdown
    REMOVE_FIRSTUSE 8: remove after first countdown
    REMOVE_ONTOUCH 16: remove on first touch
    ACTIVE_ONTOUCH 32: activate on-touch
    IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() map_hazard_ping={
  self.SendEntity = send_damage_zone;
  self.SendFlags = self.SendFlags | SENDFLAG_UPDATE_FULL;
  self.think = self.th_walk;
  
  if( self.isActive ){
    self.nextthink = time + (random() * self.wait);
  }
};

void(float entSize, void() thFunc, float defDmg, float defWait, string modelName) map_damage_zone_ini={
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  self.vec_size = entSize;
  self.th_walk = thFunc;
  
  if( (self.spawnflags & START_OFF) ){
    self.isActive = FALSE;
  }
  else{
    self.isActive = TRUE;
  }
  if( (self.spawnflags & LIFETIME) ){
    if( !self.data_lifetime ){
      //lifetime not specified, and there's no default value;
      self.spawnflags = self.spawnflags - (self.spawnflags & LIFETIME);
    }
  }
  if( !defWait ){
    self.wait = 0.5;
  }
  if( !self.alpha ){
    self.alpha = 1.0;
  }
  
  if( !self.damageValue ){
    self.damageValue = defDmg;
  }
  
  self.reloadRate = defWait * 0.5;

  self.data_type = DATA_MAP_DMG;
  
  if( (self.spawnflags & IS_MAPKEY) ){
    setmodel( self, "models/testball.md3" );
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);

    self.effects = self.effects | EF_NODEPTHTEST;
    self.think = map_hazard_ping;
    self.nextthink = time + 1.0;
  }
  else{
    setmodel( self, modelName );
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);

    self.think = self.th_walk;
  
    if( self.isActive ){
      self.nextthink = time + (random() * self.wait);
    }
  }

  self.angles_y = anglemod( (random() * 180) + (random() * 180) );
  self.angles_x = anglemod( crandom() * 5);
};

void() map_damage_zone_rad_think={
  local entity unit;
  local vector rando;
  
  if( self.isActive ){
    if(random() > 0.9){
      makevectors(self.angles); 

      rando = randomvec();
      TEMP_VEC3 = self.origin;
      TEMP_VEC3 = TEMP_VEC3 + (v_up * (self.maxs_z * 0.5));
      TEMP_VEC3_x = TEMP_VEC3_x + (self.maxs_x * rando_x);
      TEMP_VEC3_y = TEMP_VEC3_y + (self.maxs_x * rando_y);
    
      pointparticles( particleeffectnum("TE_FIELD_RAD"), TEMP_VEC3, normalize((TEMP_VEC3 + (v_up * 5)) - self.origin) * 2, 1);
    }
    
    unit = findradius(self.view_ofs, self.maxs_x);
    while(unit){
      if(unit.deadflag == DEAD_NO){
        if((unit.flags & FL_UNIT)){
          if( unit.data_type == DATA_MECH ){
            TEMP_VEC2 = unit.origin + randompos(unit.maxs, unit.mins);
            t_damage(unit, self, world, self.damageValue, TEMP_VEC2, '0 0 0');
          }
          else{
            t_damage(unit, self, world, self.damageValue, unit.origin, '0 0 0');  
          }
          if( (unit.flags & FL_CLIENT) ){
            self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
            unit.stat_env_warn = unit.stat_env_warn | 2;
          }
        }
      }
      unit = unit.chain;
    }
  }
  
  if( (self.spawnflags & LIFETIME) ){
    if( time > self.data_lifetime ){
      self.isActive = FALSE;
      self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
      return;
    }
  }
  self.think = map_damage_zone_rad_think;
  self.nextthink = time + self.reloadRate + (random() * self.wait);
};


void() map_damage_zone_crs_think={
  local entity unit;
  local vector rando;
  
  if( self.isActive ){
    if( random() > 0.9){
      makevectors(self.angles); 

      rando = randomvec();
      TEMP_VEC3 = self.origin;
      TEMP_VEC3 = TEMP_VEC3 + (v_up * (self.maxs_z * 0.5));
      TEMP_VEC3_x = TEMP_VEC3_x + ((self.maxs_x * 2) * rando_x);
      TEMP_VEC3_y = TEMP_VEC3_y + ((self.maxs_y * 2) * rando_y);
      pointparticles(particleeffectnum("TE_FIELD_MINERAL"), TEMP_VEC3, normalize((TEMP_VEC3 + (v_up * 5)) - self.origin) * 25, 1);
    }

    unit = findradius(self.view_ofs, self.maxs_x * 3);
    while(unit){
      if((unit.flags & FL_UNIT)){
        if(unit.shield > 0){

          t_damage_shield(unit, self, world, self.damageValue, unit.origin, TRUE);

          TEMP_VEC1 = self.view_ofs + (randompos(self.maxs, self.mins) * 0.5);
          TEMP_VEC2 = unit.origin + (randompos(unit.maxs, unit.mins) * 0.85);
          traceline(TEMP_VEC1, TEMP_VEC2, MOVE_NORMAL, self);
          client_send_particle_rail( BEAM_ESR, FALSE, TEMP_VEC1, trace_endpos, 4, 0 );

          if( (unit.flags & FL_CLIENT) ){
            self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
            unit.stat_env_warn = unit.stat_env_warn | 1;
          }
        }
      }
      unit = unit.chain;
    }
  }
  
  if( (self.spawnflags & LIFETIME) ){
    if( time > self.data_lifetime ){
      self.isActive = FALSE;
      self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
      return;
    }
  }
  self.think = map_damage_zone_crs_think;
  self.nextthink = time + self.reloadRate + (random() * self.wait);
};

void() map_damage_zone_qtm_think={
  local entity unit;
  local vector rando;
  local vector v;
  
  
  if( self.isActive ){ 
    if( random() > 0.9){
      makevectors(self.angles);
      
      rando = randomvec();
      TEMP_VEC3 = self.origin;
      TEMP_VEC3 = TEMP_VEC3 + (v_up * (self.maxs_z * 0.5));
      TEMP_VEC3_x = TEMP_VEC3_x + ((self.maxs_x * 2) * rando_x);
      TEMP_VEC3_y = TEMP_VEC3_y + ((self.maxs_y * 2) * rando_y);
  
      pointparticles( particleeffectnum("TE_FIELD_QUANTUM"), TEMP_VEC3, normalize( v - TEMP_VEC3 ), 1);
      pointparticles( particleeffectnum("TE_FIELD_QUANTUM"), TEMP_VEC3, normalize( v - TEMP_VEC3 ) * 30, 1);
      trailparticles( world, particleeffectnum("TE_QRFL_MUZZLE_RAIL"), TEMP_VEC3, v);
    }

    unit = findradius(self.view_ofs, self.maxs_x);
    while(unit){
      if((unit.flags & FL_UNIT)){
        if(unit.deadflag == DEAD_NO){
          if(unit.energy > 0){
            unit.energy = max(0, unit.energy - self.damageValue);
            if( (unit.flags & FL_CLIENT) ){
              self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
              unit.stat_env_warn = unit.stat_env_warn | 4;
            }
          }
        }
      }
      unit = unit.chain;
    }
  }
  
  if( (self.spawnflags & LIFETIME) ){
    if( time > self.data_lifetime ){
      self.isActive = FALSE;
      self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
      return;
    }
  }
  self.think = map_damage_zone_qtm_think;
  self.nextthink = time + self.reloadRate + (random() * self.wait);
};

void() map_hazard_rad_small={
  self.data_idx = 1;
  self.damageType = 1;

  if(!self.damageValue){
    self.damageValue = 3.0;
  }

  if(!self.count){
    self.count = 2.0;
  }
  
  map_damage_zone_ini(1, map_damage_zone_rad_think, self.damageValue, self.count, "models/map/rads/rad_base_sm.obj");

  setsize( self, '-18 -18 0', '18 18 20' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};

void() map_hazard_rad_medium={
  self.data_idx = 2;
  self.damageType = 1;

  if(!self.damageValue){
    self.damageValue = 6.0;
  }

  if(!self.count){
    self.count = 1.5;
  }
  map_damage_zone_ini(2, map_damage_zone_rad_think, self.damageValue, self.count, "models/map/rads/rad_base_md.obj");

  setsize( self, '-40 -40 0', '40 40 25' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};

void() map_hazard_rad_large={
  self.data_idx = 3;
  self.damageType = 1;

  if(!self.damageValue){
    self.damageValue = 9.0;
  }

  if(!self.count){
    self.count = 1.0;
  }
  map_damage_zone_ini(3, map_damage_zone_rad_think, self.damageValue, self.count, "models/map/rads/rad_base_lg.obj");
  
  setsize( self, '-48 -48 0', '48 48 30' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};
//=================================================================================================

void() map_hazard_crys_die={
  self.solid = SOLID_NOT;
  self.takedamage = DAMAGE_NO;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.deadflag = DEAD_DEAD;

  te_debris( self.origin + [0,0, self.maxs_z * 0.5], normalize((self.origin + [0,0, self.maxs_z * 0.5]) - self.origin) * 5, '0 0 0', 6, 1 );

  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};

void() map_hazard_crys_small={
  self.data_idx = 1;
  self.damageType = 2;
  
  if(!self.damageValue){
    self.damageValue = 1.0;
  }

  if(!self.count){
    self.count = 2.0;
  }

  map_damage_zone_ini(1, map_damage_zone_crs_think, self.damageValue, self.count, "models/map/rads/min_base_sm.obj");

  setsize( self, '-20 -20 0', '20 20 25' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
  if(!self.health){
    self.health = 100;
  }
  self.max_health = self.health;
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.th_die = map_hazard_crys_die;
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};
void() map_hazard_crys_medium={
  self.data_idx = 2;
  self.damageType = 2;
  
  
  if(!self.damageValue){
    self.damageValue = 2.0;
  }
  
  if(!self.count){
    self.count = 1.5;
  }

  map_damage_zone_ini(2, map_damage_zone_crs_think, self.damageValue, self.count, "models/map/rads/min_base_md.obj");

  setsize( self, '-30 -30 0', '30 30 40' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
  if(!self.health){
    self.health = 100;
  }
  self.max_health = self.health;
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.th_die = map_hazard_crys_die;
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};

void() map_hazard_crys_large={
  self.data_idx = 3;
  self.damageType = 2;
  
  
  if(!self.damageValue){
    self.damageValue = 3.0;
  }

  map_damage_zone_ini(3, map_damage_zone_crs_think, self.damageValue, self.count, "models/map/rads/min_base_lg.obj");
  
  setsize( self, '-40 -40 0', '40 40 52' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
  if(!self.health){
    self.health = 100;
  }
  self.max_health = self.health;
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.th_die = map_hazard_crys_die;
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};

void() map_hazard_quant_small={
  self.data_idx = 1;
  self.damageType = 3;
  
  
  if(!self.damageValue){
    self.damageValue = 3.0;
  }
  
  if(!self.count){
    self.count = 0.5;
  }
  map_damage_zone_ini(1, map_damage_zone_qtm_think, self.damageValue, self.count, "models/map/rads/qtm_base_sm.obj");

  
  self.effects = self.effects | EF_DOUBLESIDED | EF_NOSHADOW;
  setsize( self, '-25 -25 0', '25 25 30' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};


void() map_hazard_quant_medium={
  self.data_idx = 2;
  self.damageType = 3;
  
  
  if(!self.damageValue){
    self.damageValue = 5;
  }
  
  if(!self.count){
    self.count = 0.5;
  }
  map_damage_zone_ini(2, map_damage_zone_qtm_think, self.damageValue, self.count, "models/map/rads/qtm_base_md.obj");

  self.effects = self.effects | EF_DOUBLESIDED | EF_NOSHADOW;
  setsize( self, '-35 -35 0', '35 35 45' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};


void() map_hazard_quant_large={
  self.data_idx = 3;
  self.damageType = 3;
  
  
  if(!self.damageValue){
    self.damageValue = 7;
  }
  
  if(!self.count){
    self.count = 0.5;
  }

  map_damage_zone_ini(3, map_damage_zone_qtm_think, self.damageValue, self.count, "models/map/rads/qtm_base_lg.obj");
  
  self.effects = self.effects | EF_DOUBLESIDED | EF_NOSHADOW;
  setsize( self, '-45 -45 0', '45 45 56' );
  setorigin( self, self.origin );
  self.view_ofs = self.origin + [0, 0, self.maxs_z / 2];
};