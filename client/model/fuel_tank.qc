/*
battleMETAL
Author: Peter Roohr
Date: 03/24/2020
Overview: 
  CSQC-side animations for fuel tanks
*/


/*
  Fuel Tank - DEATH
*/
void() fuel_tank_die1={
  local vector pos;
  
  pos = randompos(self.absmin, self.absmax);
  te_missile_explode( pos, 1, '1 0.67 0.67', 0.01 );
  building_sound_explode();
  
  self.think = fuel_tank_die2;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die2={
  local vector pos;
  
  pos = randompos(self.absmin, self.absmax);
  te_missile_explode( pos, 1, '1 0.67 0.67', 0.01 );
  building_sound_explode();
  self.think = fuel_tank_die3;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die3={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.5))) + (v_forward * (crandom() * (self.maxs_y * 0.5)));
  pos = randompos(self.origin, vfx1);
  te_missile_explode( pos, 5, '1 0.67 0.67', 0.0015 );
  building_sound_explode();
  
  //funny - make wreckage first
  sendevent_building_die();
  
  self.think = fuel_tank_die4;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die4={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.45))) + (v_forward * (crandom() * (self.maxs_y * 0.45)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.15)), vfx1);
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die5;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die5={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.45))) + (v_forward * (crandom() * (self.maxs_y * 0.45)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.15)) , vfx1);
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die6;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die6={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.25)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.65))) + (v_forward * (crandom() * (self.maxs_y * 0.65)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.25)), vfx1);
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die7;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die7={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.25)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.65))) + (v_forward * (crandom() * (self.maxs_y * 0.65)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.25)), vfx1);
  te_missile_explode( pos, 3, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die8;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die8={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.75))) + (v_forward * (crandom() * (self.maxs_y * 0.75)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.5)), vfx1);
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die9;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die9={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.75))) + (v_forward * (crandom() * (self.maxs_y * 0.75)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.5)), vfx1);
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die10;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die10={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.6)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.75))) + (v_forward * (crandom() * (self.maxs_y * 0.75)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.6)), vfx1);
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die11;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die11={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.6)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.75))) + (v_forward * (crandom() * (self.maxs_y * 0.75)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.6)), vfx1);
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
  self.think = fuel_tank_die12;
  self.nextthink = time + 0.1;
};

void() fuel_tank_die12={
  local vector pos;
  local vector vfx1;
  
  makevectors(self.angles);
  vfx1 = self.origin + (v_up * (self.maxs_z * 0.6)) + (v_up * (random() * (self.maxs_z * 0.5))) + (v_right * (crandom() * (self.maxs_x * 0.75))) + (v_forward * (crandom() * (self.maxs_y * 0.75)));
  pos = randompos(self.origin + (v_up * (self.maxs_z * 0.6)), vfx1);
  te_missile_explode( pos, 2, '1 0.67 0.67', 0.0025 );
  building_sound_explode();
  
};