/*
battleMETAL
Author: Peter Roohr
Date: 11/14/2018
Overview: 
  A Damage Zone is an area that hurts all units within the zone.
  These are brush-based model usually, but can be set via entity text editing.
  HOW TO USE
    where ever you put 1 of the 'radical' textures, if you want that area to damage the player,
    then you place this entity over that textured spot.

*/

void() map_damage_zone_particles_shields={
  local vector velocityOffset, particleOffset;
  
  velocityOffset = self.origin + (v_up * 16);
  te_particlerain( self.absmin, self.absmax, normalize(velocityOffset - self.origin) * 50, floor(self.maxs_x / 84), 244); 

  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.maxs_x;
    particleOffset_z = crandom() * self.maxs_y;
    particleOffset_y = random() * (self.maxs_z * 0.25);
    
    particleOffset = self.origin + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    if( random() < 0.8){
      te_field_mineral(particleOffset, normalize(velocityOffset - self.origin) * 25, 5);
    }
    
    te_field_mineral_light(particleOffset, 1);
    if( self.maxs_x > 128){
      te_field_mineral_light(particleOffset, 1);
      if( self.maxs_x > 256){
        te_field_mineral_light(particleOffset, 1);
        if( self.maxs_x > 512){
          te_field_mineral_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_particles_armor={
  local vector velocityOffset, particleOffset;
  
  velocityOffset = self.origin + (v_up * 16);
  te_particlecube( self.absmin, self.absmax, normalize(velocityOffset - self.origin) * 5, floor(self.maxs_x / 32), 176, FALSE, 1); 

  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.maxs_x;
    particleOffset_z = crandom() * self.maxs_y;
    particleOffset_y = random() * (self.maxs_z / 2);
    
    particleOffset = self.origin + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    if( random() < 0.2){
      te_field_rad(particleOffset, normalize(velocityOffset - self.origin) * 4, 1);
    }
    
    te_field_rad_light(particleOffset, 1);
    if( self.maxs_x > 256){
      te_field_rad_light(particleOffset, 1);
      if( self.maxs_x > 512){
        te_field_rad_light(particleOffset, 1);
        if( self.maxs_x > 1024){
          te_field_rad_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_particles_energy={
  local vector velocityOffset, particleOrigin, particleOffset;
  
  velocityOffset = self.origin + (v_up * 2);
  te_particlecube( self.absmin, self.absmax, '0 0 0', floor(self.maxs_x / 56), 128, FALSE, 10); 
  
  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.maxs_x;
    particleOffset_z = crandom() * self.maxs_y;
    particleOffset_y = random() * (self.maxs_z / 2);
    
    particleOffset = self.origin + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    
    if( random() <= 0.8 ){
      particleOrigin_x = crandom() * self.maxs_x;
      particleOrigin_z = crandom() * self.maxs_y;
      particleOrigin_y = random() * self.maxs_z;
      particleOrigin = self.origin + (v_right * particleOrigin_x) + (v_forward * particleOrigin_z) + (v_up * particleOrigin_y);
      te_field_quantum(particleOffset, particleOrigin);
    }
    
    te_field_quantum_light(particleOffset, 1);
    if( self.maxs_x > 256){
      te_field_quantum_light(particleOffset, 1);
      if( self.maxs_x > 512){
        te_field_quantum_light(particleOffset, 1);
        if( self.maxs_x > 1024){
          te_field_quantum_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_use;
void() map_damage_zone_cool;

void() map_damage_zone_think={
  
  makevectors(self.angles);
  if( (self.damageType & 1) ){
    map_damage_zone_particles_shields();
  }
  
  if( (self.damageType & 2) ){
    map_damage_zone_particles_armor();
  }
  
  if( (self.damageType & 4) ){
    map_damage_zone_particles_energy();
  }
  
  if( (self.spawnflags & 8) ){
    //spawnflags 8 = remove after first lifetime countdown
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
    return;
  }
  
  if( (self.spawnflags & 4) ){
    //reactivate damage zone after timer
    self.think = map_damage_zone_cool;
    self.nextthink = time + self.wait;
    return;
  }
  
  //otherwise do nothing else
  self.think = map_damage_zone_think;
  self.nextthink = time + 0.1;
};

void() map_damage_zone_cool={
  self.isActive = TRUE;
  if( (self.spawnflags & 2) ){
    self.think = map_damage_zone_think;
    self.nextthink = time + self.data_lifetime;
  }
};

/*
  Primary trigger channel, called by other map logic
*/
void() map_damage_zone_use={

  if( (self.spawnflags & 4) ){
    //prevents mutli-activation if in cooldown
    if( time < self.nextthink ){
      return;
    }
  }
  
  if( !self.isActive ){
    self.isActive = TRUE;
    self.think = map_damage_zone_think;
    if( (self.spawnflags & 2) ){
      self.nextthink = time + self.data_lifetime;
    }
    else{
      self.nextthink = time + 0.1;
    }
  }
};

void() map_damage_zone_touch={
  local vector rpoint;

  if( (self.spawnflags & 32) ){
    if( !self.isActive ){
      self.think = map_damage_zone_use;
      self.nextthink = time + 0.1;
      return;
    }
  }

  if( self.isActive ){
    if( (other.flags & FL_UNIT) ){
      
      //Zone Damage - SHIELDS
      if( (self.damageType & 1) ){
        //shield damage is gated so as not to trigger an energy draining feedback loop
        other.shield = other.shield - self.damageValue;
        if( other.shield < 0 ){
          other.shield = 0;
        }
        if( time > other.shieldHitDelay ){
          other.shieldHitDelay = time + 1;
        }
        else{
          other.shieldHitDelay = time + 3;
        }
        rpoint = randomvec();
        rpoint_x = rpoint_x * (random() * other.maxs_x);
        rpoint_y = rpoint_y * (random() * other.maxs_y);
        rpoint_z = rpoint_z * (random() * other.maxs_z);
        rpoint = other.origin + rpoint;
        te_field_mineral(rpoint, normalize(rpoint - other.origin) * 10, 0.5);
      }
      
      //Zone Damage - ARMOR
      if( (self.damageType & 2) ){
        if( (other.data_type == DATA_VEHC) || (other.data_type == DATA_MECH) ){
          rpoint = randomvec();
          rpoint_x = rpoint_x * (random() * self.maxs_x);
          rpoint_y = rpoint_y * (random() * self.maxs_y);
          rpoint_z = rpoint_z * (random() * self.maxs_z);
          rpoint = other.origin + rpoint;
          te_field_rad(rpoint, normalize(rpoint - self.origin) * 10, 0.5);
          t_damage(other, self, world, self.damageValue, 0, rpoint, '0 0 0');        
        }
      }
      
      //Zone Damage - ENERGY
      if( (self.damageType & 4) ){
        other.energy = other.energy - self.damageValue;
        if( other.energy < 0 ){
          other.energy = 0;
        }
        //realized damageValue can be inverted...
        if( other.energy > other.energyMax ){
          other.energy = other.energyMax;
        }
      }
      
      if( (other.flags & FL_CLIENT) ){
        client_send_enviro_warning( other );
      }
      
      if( (self.damageType & 8) ){
        //TODO - impact speed?
      }
      
      if( (self.spawnflags & 16) ){
        //remove on first touch
        self.think = SUB_Remove;
        self.nextthink = time + 0.01;
      }
    }
  }
};

/*QUAKED map_damage_zone (0.8 0.45 0.25) (-8 -8 -8) (8 8 8) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - - - - - - - - - - - - IS_MAPKEY -
A Damage Zone is an area that hurts all units within the zone.
  
-------- KEYS -------- 
.mins = <vector> lower bounds of box
.maxs = <vector> upper bounds of box
.targetname = <string> [targetname] - make triggerable
.damageValue = <float> - amount of damage to impart
.damageType = <float> [flag] 1 - NO_DMG SHIELDS
.damageType = <float> [flag] 2 - NO_DMG ARMOR
.damageType = <float> [flag] 4 - NO_DMG ENERGY
.damageType = <float> [flag] 8 - NO_DMG SPEED
.data_lifetime = <float> - time to live, use with spawnflags[2]
.wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]

-------- SPAWNFLAGS -------- 
START_OFF 1: START_OFF - only activated by trigger
LIFETIME 2: lifetime
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
REMOVE_ONTOUCH 16: remove on first touch
ACTIVE_ONTOUCH 32: activate on-touch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() map_damage_zone={
  local vector tempMin;
  local vector tempMax;
  
  self.isActive = TRUE;
  
  if( !self.mins ){
    self.mins = VEC_HULL_MIN;
  }
  if( !self.maxs ){
    self.mins = VEC_HULL_MAX;
  }
  
  tempMin = self.mins;
  tempMax = self.maxs;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.touch = map_damage_zone_touch;
  self.think = map_damage_zone_think;
  self.count1 = time + (random() * 0.5);
  
  //setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  
  if( !cvar("developer") ){
    //self.effects = self.effects | EF_NODRAW;
  }
  
  if( (self.spawnflags & 2) ){
    if( !self.data_lifetime ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 2);
    }
  }
  
  if( (self.spawnflags & 4) ){
    if( !self.wait ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 4);
    }
  }
  
  if( (self.spawnflags & 1) ){
    //START_OFF
    self.isActive = FALSE;
    return;
  }
  
  if( (self.spawnflags & IT_QUAD) ){
    //IF marked for mapKey, tag data_type as such.
    self.data_type = DATA_MAP_OBJ;
  }
  else{
    self.data_type = 0;
  }

  if( (self.spawnflags & 2) ){
    //map needs the countdown timer  
    self.nextthink = time + self.data_lifetime;
  }
  else{
    self.nextthink = time + 0.1;
  }
};