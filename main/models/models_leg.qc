/*
battleMETAL
Author: Peter Roohr
Date: 9/22/2016
Refactor: 12/29/2018
Overview: 
  old - test animation harness
  
  worked out animation frame binding for leg models.
  the leg entities execute the frame macros, whereas leg-state is handled by the controller functions ( ctrl_updateLegs )
*/

void() leg_die1={
  self.frame = 5;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.think = SUB_Remove;
  self.nextthink = time + 3600;
}

void() leg_die_touch={
  if( other == world || other.classname == "map_terrain_model" ){
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    return;
  }
  if( other.vec_size ){
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.think = BecomeExplosion;
    self.nextthink = time + 0.1;
    return;
  }
};
/*
  Bot Leg death frames
*/
void() bot_leg_die1={
  self.mins = self.mins * 0.67;
  self.mins_z = self.mins_z / 4;
  self.maxs = self.maxs * 0.67;
  self.maxs_z = self.mins_z / -4;
  
  self.frame = 1;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  self.think = bot_leg_die2;
  self.nextthink = time + 0.1;
};
void() bot_leg_die2={
  self.frame = rint(1 + random() * 3);
  
  local vector fall;
  makevectors(self.angles);
  fall = self.origin + (v_forward * (crandom() * 256)) + (v_right * (crandom() * 256)) + (v_up * 128);
  self.velocity =  normalize(self.origin - fall);
  self.avelocity = self.velocity * 2;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_BBOX;
  self.think = bot_leg_die3;
  self.nextthink = time + 2;
};
void() bot_leg_die3={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  setsize(self, '-4 -4 -4', '4 4 4');
  setorigin(self, self.origin);
  self.deadflag = DEAD_DEAD;
  self.think = SUB_Remove;
  self.nextthink = time + 7200;
};