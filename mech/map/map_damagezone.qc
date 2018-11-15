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
  .spawnflags = <float> [flag] 1 - START_OFF
*/
void() map_damagezone_use={
  self.isActive = TRUE;
};

void() map_damagezone_touch={
  cons_logAString("other", other.classname);  //DEBUG
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
        
      }
    }
  
  }
};

void() map_damagezone_think={
  
  
  self.think = map_damagezone_think;
  self.nextthink = time + self.p_velocity;
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
  setmodel( self, "q3mdl/testball.md3" );
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );

  self.think = map_damagezone_think;
  self.touch = map_damagezone_touch;
  
  if( (self.spawnflags & 1) ){
    self.isActive = 0;
    return;
  }
  self.isActive = 1;
};