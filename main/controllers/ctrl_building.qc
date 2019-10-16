/*
battleMETAL
Author: Peter Roohr
Date: 11/26/2017
mod: 07/15/2019 
  Overview: 
    controller functions for buildings.
    Generic 'die' functon.
    Building Fire management.
      Building Fires are cosmetic entities that spawn fire effects as the building is damaged.
*/

void() building_die={
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );
  
  world_remove_dlight(self);
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  
  building_die_removeFire();
  
  self.nextthink = time + 0.01;
  self.think =  BecomeExplosion;
  
  local entity ruins;
  ruins = spawn();
  ruins.solid = SOLID_NOT;
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
    self.armLeft.think = SUB_Remove;
    self.armLeft.nextthink = time + 0.1;
  }
  
  if( self.armRight ){
    self.armRight.think = SUB_Remove;
    self.armRight.nextthink = time + 0.1;
  }
  
  if( self.torsoLeft ){
    self.torsoLeft.think = SUB_Remove;
    self.torsoLeft.nextthink = time + 0.1;
  }
};

void() building_burn_th={
  self.c_alt_ofs = te_apply_wind( self.origin );
  pointparticles( self.damageValue, self.origin, normalize(self.c_alt_ofs - self.origin) * WINDDIR_z, self.count);
  self.think = building_burn_th;
  self.nextthink = time + 0.1;
};

void() building_burn={
  if( self.health < self.max_health * 0.75){
    if( !self.armLeft || (self.armLeft == world) ){
      self.armLeft  = te_building_fire_start( self );
    }
    if( self.health < self.max_health * 0.55){
      if( !self.armRight || (self.armRight == world) ){
        self.armRight = te_building_fire_start( self );
      }
      if( self.health < self.max_health *0.33){
        if( !self.torsoLeft || (self.torsoLeft == world) ){
          self.torsoLeft = te_building_fire_start( self );
        }
      }
    }
  }
};