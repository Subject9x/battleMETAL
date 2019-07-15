/*
battleMETAL
Author: Peter Roohr
Date: 11/14/2018
Overview: 
  A Damage Zone is an area that hurts all units within the zone.
  
Inputs
  .targetname = <string> [targetname] - make triggerable
  .damageValue = <float> - amount of damage to impart
  .damageType = <float> [flag] 1 - DMG SHIELDS
  .damageType = <float> [flag] 2 - DMG ARMOR
  .damageType = <float> [flag] 4 - DMG ENERGY
  .damageType = <float> [flag] 8 - DMG SPEED
  .vec_size = <float> amount of particles.
  .data_lifetime = <float> - time to live, use with spawnflags[2]
  .wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - remove on first touch
  .spawnflags = <float> [flag] 32 - activate on-touch
*/

void() map_damage_zone_particles_shields={
  local vector velocityOffset;
  velocityOffset = self.origin + (v_up * 2);
  te_particlecube( self.mins, self.maxs, normalize(velocityOffset - self.origin) * 4, self.damageValue * 10, 244, FALSE, 1);
};

void() map_damage_zone_particles_armor={
  local vector velocityOffset, particleOrigin;
  velocityOffset = self.origin + (v_up * 4);
  te_particlesnow( self.mins, self.maxs, normalize(velocityOffset - self.origin) * 1, self.damageValue * 5, 176); 
  /*
    TODO - actual te_radiation particles
    like an inverted drip
    slosh particles at base
    drip particles shooting up
    small green flash at base
  */
  //if( random() >= 0.5 ){
    particleOrigin_x = crandom() * self.maxs_x;
    particleOrigin_y = crandom() * self.maxs_y;
    particleOrigin_z = (random() * self.maxs_z);
    te_field_rad( particleOrigin, normalize(velocityOffset - self.origin) * 8, 4);
  
  //}
};

void() map_damage_zone_particles_energy={
  local vector velocityOffset;
  velocityOffset = self.origin + (v_up * 2);
  te_particlecube( self.mins, self.maxs, normalize(velocityOffset - self.origin) * 5, self.damageValue * 10, 128, FALSE, 10); 
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
        other.shield = other.shield - self.damageValue;
        if( other.shield < 0 ){
          other.shield = 0;
        }
        //realized damage can be inverted...
        if( other.shield > other.shieldMax ){
          other.shield = other.shieldMax;
        }
      }
      
      //Zone Damage - ARMOR
      if( (self.damageType & 2) ){
        local vector rpoint;
        rpoint = randomvec();
        rpoint_x = rpoint_x * (random() * self.maxs_x);
        rpoint_y = rpoint_y * (random() * self.maxs_y);
        rpoint_z = rpoint_z * (random() * self.maxs_z);
        rpoint = other.origin + rpoint;
        t_damage(other, self, world, self.damageValue, 0, rpoint, '0 0 0');
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
      
      if( (self.damageType & 8) ){
        //TODO - impact speed?
      }
      
      if( (self.spawnflags & 16) ){
        //remove on first touch
        self.think = SUB_Remove;
        self.nextthink = time + 0.001;
      }
    }
  }
};

/*QUAKED map_damage_zone (1 1 1)
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
  
  //setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  
  if( !cvar("developer") ){
    self.effects = self.effects | EF_NODRAW;
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

  if( (self.spawnflags & 2) ){
    //map needs the countdown timer  
    self.nextthink = time + self.data_lifetime;
  }
  else{
    self.nextthink = time + 0.1;
  }
};