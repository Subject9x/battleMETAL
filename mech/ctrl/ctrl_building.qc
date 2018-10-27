/*
mech Mod
Author: Peter Roohr
Date: 11/26/2017
Overview: controller functions for buildings, mostly generics
*/

void() build_stand1 = [ $build_think1, build_stand1]{};


void() building_die={
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_CORPSE;

  self.nextthink = time + 0.01;
  self.think =  BecomeExplosion;
};