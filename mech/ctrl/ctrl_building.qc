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
};

void() building_die_removeFire={
  //remove fire effects
  if( self.e_arm_l ){
    remove( self.e_arm_l );
  }
  
  if( self.e_arm_r ){
    remove( self.e_arm_r );
  }
  
  if( self.e_tor_l ){
    remove( self.e_tor_l );
  }
};

void() building_burn_th={
  makevectors( self.angles );
  self.c_alt_ofs = self.origin + (v_up * 4);
  pointparticles( self.p_damage, self.origin, normalize(self.c_alt_ofs - self.origin) * 1, self.count);
  self.think = building_burn_th;
  self.nextthink = time + 0.1;
};

void() building_burn={
  if( self.health < self.max_health * 0.65){
    if( !self.e_arm_l || (self.e_arm_l == world) ){
      self.e_arm_l = spawn();
      self.e_arm_l.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
      self.e_arm_l.p_damage = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
      self.e_arm_l.think = building_burn_th;
      self.e_arm_l.nextthink = time + 0.1;
      self.e_arm_l.angles = self.angles;
      self.e_arm_l.count = self.vec_size+1/3;
      te_debris(self.e_arm_l.origin, self.angles, '1 1 8', random() * (self.vec_size * 6), self.vec_size);
      self.color = self.color - '0.1 0.1 0.1';
    }
    if( self.health < self.max_health * 0.45){
      if( !self.e_arm_r || (self.e_arm_r == world) ){
        self.e_arm_r = spawn();
        self.e_arm_r.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
        self.e_arm_r.p_damage = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
        self.e_arm_r.think = building_burn_th;
        self.e_arm_r.nextthink = time + 0.1;
        self.e_arm_r.angles = self.angles;
        self.e_arm_r.count = self.vec_size+1/3;
        te_debris(self.e_arm_r.origin, self.angles, '1 1 5', random() * (self.vec_size * 5), self.vec_size);
        self.color = self.color - '0.1 0.1 0.1';
      }
      if( self.health < self.max_health *0.25){
        if( !self.e_tor_l || (self.e_tor_l == world) ){
          self.e_tor_l = spawn();
          self.e_tor_l.origin = util_pointNearBoxEdge( self.origin, self.angles, self.mins, self.maxs );
          self.e_tor_l.p_damage = particleeffectnum(strcat("TE_FIRE_", ftos(self.vec_size)));
          self.e_tor_l.think = building_burn_th;
          self.e_tor_l.nextthink = time + 0.1;
          self.e_tor_l.angles = self.angles;
          self.e_tor_l.count = self.vec_size+1/3;
          te_debris(self.e_tor_l.origin, self.angles, '1 1 3', random() * (self.vec_size * 4), self.vec_size);
          self.color = self.color - '0.1 0.1 0.1';
        }
      }
    }
  }
};