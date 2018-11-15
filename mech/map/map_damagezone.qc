/*
battleMETAL
Author: Peter Roohr
Date: 11/14/2018
Overview: 
  A Damage Zone is an area that hurts all units within the zone.
  
Inputs
  .p_damage = <float> - amount of damage to impart
  .p_dmgtype = <float> [flag] 1 - DMG SHIELDS
  .p_dmgtype = <float> [flag] 2 - DMG ARMOR
  .p_dmgtype = <float> [flag] 4 - DMG ENERGY
  .p_dmgtype = <float> [flag] 8 - DMG SPEED
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .state_1 = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - remove on first touch
  .spawnflags = <float> [flag] 32 - activate on-touch
*/

void() map_damagezone_use;
void() map_damagezone_cool;
/*
  p_lifetime countdown timer hit.
*/
void() map_damagezone_think={
  
  self.isActive = FALSE;
  
  if( (self.spawnflags & 8) ){
    //spawnflags 8 = remove after first lifetime countdown
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
    return;
  }
  
  if( (self.spawnflags & 4) ){
    //reactivate damage zone after timer
    self.think = map_damagezone_cool;
    self.nextthink = time + self.state_1;
    return;
  }
  
  //otherwise do nothing else
  self.think = SUB_Null;
  self.nextthink = time + 0.1;
};

void() map_damagezone_cool={
  dprint("map_damagezone_cool \n");  //DEBUG
  self.isActive = TRUE;
  if( (self.spawnflags & 2) ){
    self.think = map_damagezone_think;
    self.nextthink = time + self.p_lifetime;
  }
};

/*
  Primary trigger channel, called by other map logic
*/
void() map_damagezone_use={

  if( (self.spawnflags & 4) ){
    //prevents mutli-activation if in cooldown
    if( time < self.nextthink ){
      return;
    }
  }
  
  if( !self.isActive ){
    self.isActive = TRUE;
    if( (self.spawnflags & 2) ){
      self.think = map_damagezone_think;
      self.nextthink = time + self.p_lifetime;
    }
  }
};

void() map_damagezone_touch={

  if( (self.spawnflags & 32) ){
    if( !self.isActive ){
      self.think = map_damagezone_use;
      self.nextthink = time + 0.1;
      return;
    }
  }

  if( self.isActive ){
    if( (other.flags & FL_UNIT) ){
      if( (self.p_dmgtype & 1) ){
        other.sh_cur = other.sh_cur - self.p_damage;
        if( other.sh_cur < 0 ){
          other.sh_cur = 0;
        }
      }
      if( (self.p_dmgtype & 2) ){
        local vector rpoint;
        rpoint = randomvec();
        rpoint_x = rpoint_x * (random() * self.maxs_x);
        rpoint_y = rpoint_y * (random() * self.maxs_y);
        rpoint_z = rpoint_z * (random() * self.maxs_z);
        rpoint = other.origin + rpoint;
        t_damage(other, self, world, self.p_damage, 0, rpoint, '0 0 0');

      }
      if( (self.p_dmgtype & 4) ){
        other.en_cur = other.en_cur - self.p_damage;
        if( other.en_cur < 0 ){
          other.en_cur = 0;
        }
      }
      if( (self.p_dmgtype & 8) ){
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

/*QUAKED map_damagezone (1 1 1)
*/
void() map_damagezone={
  local vector tempMin;
  local vector tempMax;
  
  tempMin = self.mins;
  tempMax = self.maxs;
  
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NONE;
  self.touch = map_damagezone_touch;
  
  setmodel( self, "q3mdl/testball.md3" ); //DEBUG
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );

  //self.effects = self.effects | EF_NODRAW;  //DEBUG

  if( (self.spawnflags & 2) ){
    if( !self.p_lifetime ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 2);
    }
  }
  
  if( (self.spawnflags & 4) ){
    if( !self.state_1 ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 4);
    }
  }
  
  if( (self.spawnflags & 1) ){
    //START_OFF
    self.isActive = 0;
    return;
  }
  
  self.isActive = 1;
  if( (self.spawnflags & 2) ){
    //map needs the countdown timer  
    self.think = map_damagezone_think;
    self.nextthink = time + self.p_lifetime;
  }
};