/*
mech Mod
Author: Peter Roohr
Date: 11/26/2017
Overview: controller functions for buildings, mostly generics
*/

void() building_die={
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_CORPSE;
  
  building_die_removeFire();
  
  self.nextthink = time + 0.01;
  self.think =  BecomeExplosion;
  
  local entity ruins;
  ruins = spawn();
  ruins.solid = SOLID_CORPSE;
  ruins.movetype = MOVETYPE_NONE;
  switch( self.vec_size ){
    case 2:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_medium.obj"));
      break;
    case 3:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_large.obj"));
      break;
    default:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_small.obj"));
      break;
  }
  setsize(ruins, ruins.mins, ruins.maxs * 0.75);
  setorigin(ruins, self.origin);
  ruins.vec_size = self.vec_size;
  ruins.angles = self.angles;
  ruins.armLeft = te_building_fire_start( ruins );
  if( ruins.vec_size > 1 ){
    ruins.armRight = te_building_fire_start( ruins );
    ruins.torsoLeft = te_building_fire_start( ruins );
  }
};

void() building_die_removeFire={
  //remove fire effects
  if( self.armLeft ){
    remove( self.armLeft );
  }
  
  if( self.armRight ){
    remove( self.armRight );
  }
  
  if( self.torsoLeft ){
    remove( self.torsoLeft );
  }
};

void() building_burn_th={

  self.c_alt_ofs = te_apply_wind( self.origin );
  pointparticles( self.damageValue, self.origin, normalize(self.c_alt_ofs - self.origin) * WINDDIR_z, self.count);
  self.think = building_burn_th;
  self.nextthink = time + 0.1;
};

void() building_burn={
  if( self.health < self.max_health * 0.65){
    if( !self.armLeft || (self.armLeft == world) ){
      self.armLeft  = te_building_fire_start( self );
    }
    if( self.health < self.max_health * 0.45){
      if( !self.armRight || (self.armRight == world) ){
        self.armRight = te_building_fire_start( self );
      }
      if( self.health < self.max_health *0.25){
        if( !self.torsoLeft || (self.torsoLeft == world) ){
          self.torsoLeft = te_building_fire_start( self );
        }
      }
    }
  }
};