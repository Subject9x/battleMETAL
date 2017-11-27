/*
mech Mod
Author: Subject9x
Date: 11/26/2017
Overview: controller functions for buildings, mostly generics
*/


void() building_think={
  
  
  self.think = building_think;
  self.nextthink = time + 0.05;
};

void() building_die={
  activator = self.enemy;
	SUB_UseTargets ();
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.nextthink = time + 0.01;
  self.think =  SUB_Remove;
};