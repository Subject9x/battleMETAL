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
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  self.think = self.th_walk;
  
  if( self.isActive ){
    self.nextthink = time + (random() * self.wait);
    return;
  }
};

void(float entSize, void() thFunc, float defDmg, float defWait) map_damage_zone_ini={
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
  if( !self.wait ){
    self.wait = defWait;
  }
  if( !self.alpha ){
    self.alpha = 1.0;
  }
  
  if( !self.damageValue ){
    self.damageValue = defDmg;
  }
  self.effects = self.effects | EF_NODEPTHTEST;  
  self.data_type = DATA_MAP_DMG;
  self.model = "q3mdl/testball.md3";
  setmodel( self, self.model );
  self.think = map_hazard_ping;
  self.nextthink = time + 0.1;
  self.angles_y = anglemod( (random() * 180) + (random() * 180) );
};

void() map_damage_zone_rad_think={
  local entity unit;
  local vector mechHit;
  
  if( self.isActive ){
    for( unit = nextent(world); unit != world; unit = nextent(unit) ){
      if( !(unit.flags & FL_UNIT) ){
        continue;
      }
      if( vlen(unit.origin - self.origin) > (self.maxs_x * 3) ){
        continue;
      }
      if( unit.data_type == DATA_MECH ){
        mechHit = randomvec() * unit.maxs_x;
        mechHit = unit.origin + mechHit;
        t_damage(unit, self, world, self.damageValue, mechHit, '0 0 0');
      }
      else{
        t_damage(unit, self, world, self.damageValue, unit.origin, '0 0 0');  
      }
      if( (unit.flags & FL_CLIENT) ){
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
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
  self.nextthink = time + (random() * self.wait);
};
void() map_damage_zone_crs_think={
  local entity unit;
  
  if( self.isActive ){
    for( unit = nextent(world); unit != world; unit = nextent(unit) ){
      if( !(unit.flags & FL_UNIT) ){
        continue;
      }
      if( vlen(unit.origin - self.origin) > (self.maxs_x * 4) ){
        continue;
      }
      t_damage_shield(unit, self, world, self.damageValue, unit.origin, (self.vec_size > 1) );  
      if( (unit.flags & FL_CLIENT) ){
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
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
  self.nextthink = time + (random() * self.wait);
};
void() map_damage_zone_qtm_think={
  local entity unit;
  
  if( self.isActive ){
    for( unit = nextent(world); unit != world; unit = nextent(unit) ){
      if( !(unit.flags & FL_UNIT) ){
        continue;
      }
      if( vlen(unit.origin - self.origin) > (self.maxs_x * 4) ){
        continue;
      }
      if( unit.energy <= 0 ){
        continue;
      }
      unit.energy = unit.energy - self.damageValue;
      if( unit.energy < 0 ){
        unit.energy = 0;
      }
      if( (unit.flags & FL_CLIENT) ){
        self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
      }
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
  self.nextthink = time + (random() * self.wait);
};


/*QUAKED map_hazard_rad_small (0.8 0.45 0.25) (-18 -18 0) (18 18 20) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts ARMOR damage on any unit that touches it every rand*0.3 seconds.

damageValue = 1
wait = 0.3
alpha = 1

-------- KEYS -------- 
.damageValue = <float> 
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
.wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
.alpha = <float> - alpha level on model of ent
-------- SPAWNFLAGS -------- 
START_OFF 1: START_OFF - only activated by trigger
LIFETIME 2: lifetime
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
REMOVE_ONTOUCH 16: remove on first touch
ACTIVE_ONTOUCH 32: activate on-touch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() map_hazard_rad_small={
  self.data_idx = 1;
  self.damageType = 1;
  
  map_damage_zone_ini(1, map_damage_zone_rad_think, 1, 0.5);

  setsize( self, '-18 -18 0', '18 18 20' );
  setorigin( self, self.origin );
};
/*QUAKED map_hazard_rad_medium (0.8 0.45 0.25) (-40 -40 0) (40 40 25) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts ARMOR damage on any unit that touches it every rand*0.3 seconds.

damageValue = 2
wait = 0.25
alpha = 1

-------- KEYS -------- 
.damageValue = 0.67 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_rad_medium={
  self.data_idx = 2;
  self.damageType = 1;
  
  map_damage_zone_ini(2, map_damage_zone_rad_think, 2, 0.4);

  setsize( self, '-40 -40 0', '40 40 25' );
  setorigin( self, self.origin );
};
/*QUAKED map_hazard_rad_large (0.8 0.45 0.25) (-48 -48 0) (48 48 30) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts ARMOR damage on any unit that touches it every rand*0.3 seconds.

damageValue = 3
wait = 0.3
alpha = 1

-------- KEYS -------- 
.damageValue = 0.79 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_rad_large={
  self.data_idx = 3;
  self.damageType = 1;
  
  map_damage_zone_ini(3, map_damage_zone_rad_think, 3, 0.3);
  
  setsize( self, '-48 -48 0', '48 48 30' );
  setorigin( self, self.origin );
};
//=================================================================================================
/*QUAKED map_hazard_crys_small (0.25 0.45 0.8) (-20 -20 0) (20 20 25) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.3 seconds.

damageValue = 1
wait = 0.3
alpha = 1

-------- KEYS -------- 
.damageValue = <float> 
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
.wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
.alpha = <float> - alpha level on model of ent
-------- SPAWNFLAGS -------- 
START_OFF 1: START_OFF - only activated by trigger
LIFETIME 2: lifetime
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
REMOVE_ONTOUCH 16: remove on first touch
ACTIVE_ONTOUCH 32: activate on-touch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() map_hazard_crys_small={
  self.data_idx = 1;
  self.damageType = 2;
  
  map_damage_zone_ini(1, map_damage_zone_crs_think, 2, 0.5);

  setsize( self, '-20 -20 0', '20 20 25' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
};
/*QUAKED map_hazard_crys_medium (0.25 0.45 0.8) (-30 -30 0) (30 30 40) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.25 seconds.

damageValue = 2
wait = 0.25
alpha = 1

-------- KEYS -------- 
.damageValue = 0.67 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_crys_medium={
  self.data_idx = 2;
  self.damageType = 2;
  
  map_damage_zone_ini(2, map_damage_zone_crs_think, 4, 0.4);

  setsize( self, '-30 -30 0', '30 30 40' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
};
/*QUAKED map_hazard_crys_large (0.25 0.45 0.8) (-40 -40 0) (40 40 52) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.2 seconds.

damageValue = 3
wait = 0.2
alpha = 1

-------- KEYS -------- 
.damageValue = 0.79 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_crys_large={
  self.data_idx = 3;
  self.damageType = 2;
  
  map_damage_zone_ini(3, map_damage_zone_crs_think, 6, 0.2);
  
  setsize( self, '-40 -40 0', '40 40 52' );
  setorigin( self, self.origin );
  self.solid = SOLID_SLIDEBOX;
};
//=================================================================================================
/*QUAKED map_hazard_quant_small (0.8 0.25 0.8) (-25 -25 0) (25 25 30) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.3 seconds.

damageValue = 1
wait = 0.3
alpha = 1

-------- KEYS -------- 
.damageValue = <float> 
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
.wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
.alpha = <float> - alpha level on model of ent
-------- SPAWNFLAGS -------- 
START_OFF 1: START_OFF - only activated by trigger
LIFETIME 2: lifetime
REACTIVATE 4: reactivate after countdown
REMOVE_FIRSTUSE 8: remove after first countdown
REMOVE_ONTOUCH 16: remove on first touch
ACTIVE_ONTOUCH 32: activate on-touch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() map_hazard_quant_small={
  self.data_idx = 1;
  self.damageType = 3;
  
  map_damage_zone_ini(1, map_damage_zone_qtm_think, 3, 0.6);

  setsize( self, '-25 -25 0', '25 25 30' );
  setorigin( self, self.origin );
};
/*QUAKED map_hazard_quant_medium (0.8 0.25 0.8) (-35 -35 0) (35 35 45) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.25 seconds.

damageValue = 2
wait = 0.25
alpha = 1

-------- KEYS -------- 
.damageValue = 0.67 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_quant_medium={
  self.data_idx = 2;
  self.damageType = 3;
  
  map_damage_zone_ini(2, map_damage_zone_qtm_think, 4, 0.5);

  setsize( self, '-35 -35 0', '35 35 45' );
  setorigin( self, self.origin );
};
/*QUAKED map_hazard_quant_large (0.8 0.25 0.8) (-45 -45 0) (45 45 56) START_OFF LIFETIME REACTIVATE REMOVE_FIRSTUSE REMOVE_ONTOUCH ACTIVE_ONTOUCH - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - IS_MAPKEY -
Inflicts SHIELD damage on any unit that touches it every rand*0.2 seconds.

damageValue = 3
wait = 0.2
alpha = 1

-------- KEYS -------- 
.damageValue = 0.79 <DEFAULT>
.targetname = <string> [targetname] - make triggerable
.data_lifetime = <float> - time to live, use with spawnflags[LIFETIME]
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
void() map_hazard_quant_large={
  self.data_idx = 3;
  self.damageType = 3;
  
  map_damage_zone_ini(3, map_damage_zone_qtm_think, 5, 0.3);
  
  setsize( self, '-45 -45 0', '45 45 56' );
  setorigin( self, self.origin );
};