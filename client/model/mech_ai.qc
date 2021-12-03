/*
battleMETAL
Author: Peter Roohr
Date: 10/03/2021
Overview: 
  animation frame sets 
*/


void() mech_ai_die_stand1;
void() mech_ai_die_stand2;
void() mech_ai_die_stand3;
void() mech_ai_die_stand4;
void() mech_ai_die_stand5;
void() mech_ai_die_stand6;
void() mech_ai_die_stand7;
void() mech_ai_die_stand8;
void() mech_ai_die_stand9;
void() mech_ai_die_stand10;


void() mech_ai_die_stand1={
  local vector ofs;
  local vector org;
  
  makevectors(self.angles);
  if( !(self.criticalHits & M_ARM_RIGHT)){
    org = self.armRight.origin;
  }
  else{
    org = self.origin;
  }
  
  ofs = org + (v_forward * (crandom() * self.maxs_x / 2));
  ofs = ofs + (v_right * (crandom() * self.maxs_y / 2));
  ofs = ofs + (v_up * (crandom() * self.maxs_z / 2));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  
  self.think = mech_ai_die_stand2;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand2={
  local vector ofs;
  local vector org;
  
  makevectors(self.angles);
  if( !(self.criticalHits & M_ARM_LEFT)){
    org = self.armLeft.origin;
  }
  else{
    org = self.origin;
  }
  ofs = org + (v_forward * (crandom() * self.maxs_x / 2));
  ofs = ofs + (v_right * (crandom() * self.maxs_y / 2));
  ofs = ofs + (v_up * (crandom() * self.maxs_z / 2));

  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );

  self.think = mech_ai_die_stand3;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand3={
  local vector ofs;
  local vector org;
  
  makevectors(self.angles);
  if( !(self.criticalHits & M_ARM_LEFT)){
    org = self.armLeft.origin;
  }
  else{
    org = self.origin;
  }
  ofs = org + (v_forward * (crandom() * self.maxs_x / 2));
  ofs = ofs + (v_right * (crandom() * self.maxs_y / 2));
  ofs = ofs + (v_up * (crandom() * self.maxs_z / 2));

  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );

  self.think = mech_ai_die_stand4;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand4={
  local vector ofs;
  local vector org;
  
  makevectors(self.angles);
  if( !(self.criticalHits & M_ARM_LEFT)){
    org = self.armLeft.origin;
  }
  else{
    org = self.origin;
  }
  ofs = org + (v_forward * (crandom() * self.maxs_x / 2));
  ofs = ofs + (v_right * (crandom() * self.maxs_y / 2));
  ofs = ofs + (v_up * (crandom() * self.maxs_z / 2));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  
  self.think = mech_ai_die_stand5;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand5={
  local vector ofs;
  
  makevectors(self.angles);
  
  ofs = self.origin + (v_forward * (crandom() * self.maxs_x));
  ofs = ofs + (v_right * (crandom() * self.maxs_y / 2));
  ofs = ofs + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  
  self.think = mech_ai_die_stand6;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand6={
  local vector ofs;
  makevectors(self.angles);
  
  ofs = self.origin + (v_forward * (crandom() * self.maxs_x));
  ofs = ofs + (v_right * (crandom() * self.maxs_y));
  ofs = ofs + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  self.think = mech_ai_die_stand7;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand7={
  local vector ofs;
  makevectors(self.angles);
  
  ofs = self.origin + (v_forward * (crandom() * self.maxs_x));
  ofs = ofs + (v_right * (crandom() * self.maxs_y));
  ofs = ofs + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  self.think = mech_ai_die_stand8;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand8={
  local vector ofs;
  makevectors(self.angles);
  
  ofs = self.origin + (v_forward * (crandom() * self.maxs_x));
  ofs = ofs + (v_right * (crandom() * self.maxs_y));
  ofs = ofs + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( ofs, self.vec_size * 2, '0.5 0.85 0.96', 0.001 );

  self.think = mech_ai_die_stand9;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand9={
  local vector ofs;
  makevectors(self.angles);
    
  ofs = self.origin + (v_forward * (crandom() * self.maxs_x));
  ofs = ofs + (v_right * (crandom() * self.maxs_y));
  ofs = ofs + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  self.think = mech_ai_die_stand10;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand10={
  local vector ofs;
  makevectors(self.angles);
  
  ofs = self.origin + (v_forward * (crandom() * self.maxs_z));
  ofs = ofs + (v_right * (crandom() * self.maxs_x));
  ofs = ofs + (v_up * (crandom() * self.maxs_y));
  
  te_missile_explode( ofs, self.vec_size, '0.5 0.85 0.96', 0.001 );
  self.data_lifetime = servertime + 360 + (random() * 180);
  self.think = mech_corpse_th;
  self.nextthink = servertime + 0.1;
};