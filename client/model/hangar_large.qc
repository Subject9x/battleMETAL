/*
battleMETAL
Author: Peter Roohr
Date: 03/24/2020
Overview: 
  CSQC-side animations for large hangars
*/


/*
  Hangar large  - DEATH
*/
void() hangar_large_die1={
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

  self.think = hangar_large_die2;
  self.nextthink = time + 0.1;
};

void() hangar_large_die2={
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

  self.think = hangar_large_die3;
  self.nextthink = time + 0.1;
};

void() hangar_large_die3={
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 4, '0.67 0.3 0.1', 0.0075 );
  building_sound_explode();

  self.think = hangar_large_die4;
  self.nextthink = time + 0.1;
};

void() hangar_large_die4={

  self.think = hangar_large_die5;
  self.nextthink = time + 0.1;
};

void() hangar_large_die5={
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * self.maxs_z) + (v_forward * (self.mins_y * 0.9)) + (v_right * (self.mins_x * 0.15));

  te_missile_explode( vfx, 3, '0.67 0.3 0.1', 0.0025 );
  building_sound_explode();
  
  self.think = hangar_large_die6;
  self.nextthink = time + 0.1;
};

void() hangar_large_die6={

  self.think = hangar_large_die7;
  self.nextthink = time + 0.1;
};

void() hangar_large_die7={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();
  
  self.think = hangar_large_die8;
  self.nextthink = time + 0.1;
};

void() hangar_large_die8={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die9;
  self.nextthink = time + 0.1;
};

void() hangar_large_die9={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die10;
  self.nextthink = time + 0.1;
};

void() hangar_large_die10={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die11;
  self.nextthink = time + 0.1;
};

void() hangar_large_die11={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die12;
  self.nextthink = time + 0.1;
};

void() hangar_large_die12={

  self.think = hangar_large_die13;
  self.nextthink = time + 0.1;
};

void() hangar_large_die13={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die14;
  self.nextthink = time + 0.1;
};

void() hangar_large_die14={

  self.think = hangar_large_die15;
  self.nextthink = time + 0.1;
};

void() hangar_large_die15={
  te_missile_explode( randompos(self.absmin, self.absmax), 3, '1 0.67 0.1', 0.01 );
  building_sound_explode();

  self.think = hangar_large_die16;
  self.nextthink = time + 0.1;
};

void() hangar_large_die16={

  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};