/*
mech Mod
Author: Peter Roohr
Date: 11/26/2017
Overview: controller functions for buildings, mostly generics
*/

$frame build_think1

void() build_stand1 = [ $build_think1, build_stand1]{};

void() building_think={
  
  
  self.think = building_think;
  self.nextthink = time + 0.05;
};

void() building_die={
  activator = self.enemy;
	SUB_UseTargets ();
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_CORPSE;
  multi_trigger();
  self.nextthink = time + 0.01;
  self.think =  BecomeExplosion;
};