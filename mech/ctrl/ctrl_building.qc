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
  makevectors( self.angles );
  self.c_alt_ofs = self.origin + (v_up * 4);
  pointparticles( self.damageValue, self.origin, normalize(self.c_alt_ofs - self.origin) * 1, self.count);
  self.think = building_burn_th;
  self.nextthink = time + 0.1;
};

void() building_burn={
  if( self.health < self.max_health * 0.65){
    if( !self.armLeft || (self.armLeft == world) ){
      self.armLeft  = te_building_fire_start( self );
      /*self.armLeft = spawn();
      self.armLeft.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
      self.armLeft.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
      self.armLeft.think = building_burn_th;
      self.armLeft.nextthink = time + 0.1;
      self.armLeft.angles = self.angles;
      self.armLeft.count = self.vec_size+1/3;
      te_debris(self.armLeft.origin, self.angles, '1 1 8', random() * (self.vec_size * 6), self.vec_size);
      self.color = self.color - '0.1 0.1 0.1';*/
    }
    if( self.health < self.max_health * 0.45){
      if( !self.armRight || (self.armRight == world) ){
        self.armRight = te_building_fire_start( self );
        /*self.armRight = spawn();
        self.armRight.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
        self.armRight.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
        self.armRight.think = building_burn_th;
        self.armRight.nextthink = time + 0.1;
        self.armRight.angles = self.angles;
        self.armRight.count = self.vec_size+1/3;
        te_debris(self.armRight.origin, self.angles, '1 1 5', random() * (self.vec_size * 5), self.vec_size);
        self.color = self.color - '0.1 0.1 0.1';*/
      }
      if( self.health < self.max_health *0.25){
        if( !self.torsoLeft || (self.torsoLeft == world) ){
          self.torsoLeft = te_building_fire_start( self );
          /*self.torsoLeft = spawn();
          self.torsoLeft.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
          self.torsoLeft.damageValue = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
          self.torsoLeft.think = building_burn_th;
          self.torsoLeft.nextthink = time + 0.1;
          self.torsoLeft.angles = self.angles;
          self.torsoLeft.count = self.vec_size+1/3;
          te_debris(self.torsoLeft.origin, self.angles, '1 1 3', random() * (self.vec_size * 4), self.vec_size);
          self.color = self.color - '0.1 0.1 0.1';*/
        }
      }
    }
  }
};