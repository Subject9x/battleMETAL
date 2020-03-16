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

void() map_damage_zone_use;
void() map_damage_zone_cool;

void() map_damage_zone_think={
  
  makevectors(self.angles);

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
    if( time < self.nextthink )
      return;
  }
  
  if( !self.isActive ){
    self.isActive = TRUE;
    self.SendEntity = send_damage_zone;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
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
        if( other.shield < 0 )
          other.shield = 0;
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
        //te_field_mineral(rpoint, normalize(rpoint - other.origin) * 10, 0.5);
      }
      
      //Zone Damage - ARMOR
      if( (self.damageType & 2) ){
        if( (other.data_type == DATA_VEHC) || (other.data_type == DATA_MECH) ){
          rpoint = randomvec();
          rpoint_x = rpoint_x * (random() * self.compAltOffset_x);
          rpoint_y = rpoint_y * (random() * self.compAltOffset_y);
          rpoint_z = rpoint_z * (random() * self.compAltOffset_z);
          rpoint = other.origin + rpoint;
          //te_field_rad(rpoint, normalize(rpoint - self.dest) * 10, 0.5);
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

void() map_damage_zone_ini={
  if( self.classname == "func_damage_zone" ){
    self.modelindex = 0;
    self.model = "";
  }
    cons_logAFloat("map_damage_zone_ini()->data_type", self.data_type);  //DEBUG
  self.think = map_damage_zone_think;
  self.nextthink = time + 1;
};

/*QUAKED map_damage_zone (0.8 0.45 0.25) (-8 -8 -8) (8 8 8) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - - - - - - - - - - - - IS_MAPKEY -
A Damage Zone is an area that hurts all units within the zone.
  
-------- KEYS -------- 
.mins = <vector> lower bounds of box if using point entity
.maxs = <vector> upper bounds of box if using point entity
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
  self.think = map_damage_zone_ini;
  self.count1 = time + (random() * 0.5);
  
  util_MapDeveloperMarker();
  setsize( self, tempMin, tempMax );
  setorigin( self, self.origin );
  self.data_type = DATA_MAP_DMG;
  
  self.SendEntity = send_damage_zone;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  //compatability with func_damage_zone
  self.dest = self.origin;
  self.compAltOffset = self.maxs;
  self.compOffset = self.mins;
  
  //volume limiter to prevent render choke, this will default to the LAST damageType in the flag value, but if you're already blending, you probably dont' care.
  if( (self.damageType & 1) ){
    if( self.maxs_x <= 128 ){
      self.count = SHIELD_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = SHIELD_MEDIUM;
    }
    else{
      self.count = SHIELD_LARGE;
    }
  }
  if( (self.damageType & 2) ){
    if( self.maxs_x <= 128 ){
      self.count = RAD_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = RAD_MEDIUM;
    }
    else{
      self.count = RAD_LARGE;
    }
  }
  if( (self.damageType & 4) ){
    if( self.maxs_x <= 128 ){
      self.count = QUAN_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = QUAN_MEDIUM;
    }
    else{
      self.count = QUAN_LARGE;
    }
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
  
  //if( (self.spawnflags & IT_QUAD) ){
    //IF marked for mapKey, tag data_type as such.
    //self.data_type = DATA_MAP_OBJ;
  //}
  //else{
 // }

  if( (self.spawnflags & 2) ){
    //map needs the countdown timer  
    self.nextthink = time + self.data_lifetime;
  }
  else{
    self.nextthink = time + 0.1;
  }
};

/*
  Brush-binding compatability.
*/
void() func_damage_zone={
	if (self.movedir == '0 0 0')
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel( self, self.model );	// set size and link into world
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
	self.movetype = MOVETYPE_NONE;
  
  self.isActive = TRUE;
  self.touch = map_damage_zone_touch;
  self.think = map_damage_zone_ini;
  self.count1 = time + (random() * 0.5);
  self.data_type = DATA_MAP_DMG;
  
  self.dest = (self.absmin + self.absmax) * 0.5;
  self.compAltOffset = self.absmax - self.dest;
  self.compOffset = self.compAltOffset * -1;

  self.SendEntity = send_damage_zone;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
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
    //volume limiter to prevent render choke, this will default to the LAST damageType in the flag value, but if you're already blending, you probably dont' care.
  if( (self.damageType & 1) ){
    if( self.maxs_x <= 128 ){
      self.count = SHIELD_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = SHIELD_MEDIUM;
    }
    else{
      self.count = SHIELD_LARGE;
    }
  }
  if( (self.damageType & 2) ){
    if( self.maxs_x <= 128 ){
      self.count = RAD_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = RAD_MEDIUM;
    }
    else{
      self.count = RAD_LARGE;
    }
  }
  if( (self.damageType & 4) ){
    if( self.maxs_x <= 128 ){
      self.count = QUAN_SMALL;
    }
    else if( self.maxs_x <= 256 ){
      self.count = QUAN_MEDIUM;
    }
    else{
      self.count = QUAN_LARGE;
    }
  }
  
  if( (self.spawnflags & 1) ){
    //START_OFF
    self.isActive = FALSE;
    return;
  }
  
  //if( (self.spawnflags & IT_QUAD) ){
    //IF marked for mapKey, tag data_type as such.
    //self.data_type = DATA_MAP_OBJ;
  //}
  //else{
    //self.data_type = 0;
  //}

  if( (self.spawnflags & 2) ){
    //map needs the countdown timer  
    self.nextthink = time + self.data_lifetime;
  }
  else{
    self.nextthink = time + 0.1;
  }
};