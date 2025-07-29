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
  
  makevectors(self.angles);

  if( !(self.criticalHits & M_ARM_RIGHT)){
    TEMP_VEC2 = self.armR_org;
  }
  else{
    TEMP_VEC2 = self.origin;
  }
  TEMP_VEC3 = '0 0 0';
  TEMP_VEC3 = TEMP_VEC2 + (v_forward * (crandom() * self.maxs_x / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_right * (crandom() * self.maxs_y / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_up * (crandom() * self.maxs_z / 2));
  
  te_missile_explode( TEMP_VEC3, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC3, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  
  self.think = mech_ai_die_stand2;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand2={
  makevectors(self.angles);

  if( !(self.criticalHits & M_ARM_LEFT)){
    TEMP_VEC2 = self.armL_org;
  }
  else{
    TEMP_VEC2 = self.origin;
  }
  TEMP_VEC3 = '0 0 0';
  TEMP_VEC3 = TEMP_VEC2 + (v_forward * (crandom() * self.maxs_x / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_right * (crandom() * self.maxs_y / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_up * (crandom() * self.maxs_z / 2));

  te_missile_explode( TEMP_VEC3, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC3, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);

  self.think = mech_ai_die_stand3;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand3={
  makevectors(self.angles);

  if( !(self.criticalHits & M_ARM_LEFT)){
    TEMP_VEC2 = self.armL_org;
  }
  else{
    TEMP_VEC2 = self.origin;
  }
  TEMP_VEC3 = '0 0 0';
  TEMP_VEC3 = TEMP_VEC2 + (v_forward * (crandom() * self.maxs_x / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_right * (crandom() * self.maxs_y / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_up * (crandom() * self.maxs_z / 2));

  te_missile_explode( TEMP_VEC3, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC3, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);

  self.think = mech_ai_die_stand4;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand4={
  makevectors(self.angles);

  if( !(self.criticalHits & M_ARM_LEFT)){
    TEMP_VEC2 = self.armL_org;
  }
  else{
    TEMP_VEC2 = self.origin;
  }
  TEMP_VEC3 = '0 0 0';
  TEMP_VEC3 = TEMP_VEC2 + (v_forward * (crandom() * self.maxs_x / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_right * (crandom() * self.maxs_y / 2));
  TEMP_VEC3 = TEMP_VEC3 + (v_up * (crandom() * self.maxs_z / 2));
  
  te_missile_explode( TEMP_VEC3, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC3, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  
  self.think = mech_ai_die_stand5;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand5={
  makevectors(self.angles);
  
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_y / 2));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( TEMP_VEC2, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  
  self.think = mech_ai_die_stand6;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand6={
  makevectors(self.angles);
  
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_y));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( TEMP_VEC2, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  self.think = mech_ai_die_stand7;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand7={
  makevectors(self.angles);
  
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_y));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( TEMP_VEC2, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  self.think = mech_ai_die_stand8;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand8={
  makevectors(self.angles);
  
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_y));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( TEMP_VEC2, self.vec_size * 2, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);

  self.think = mech_ai_die_stand9;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand9={
  makevectors(self.angles);
    
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_y));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_z));
  
  te_missile_explode( TEMP_VEC2, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  self.think = mech_ai_die_stand10;
  self.nextthink = servertime + 0.2;
};

void() mech_ai_die_stand10={
  makevectors(self.angles);
  
  TEMP_VEC2 = self.origin + (v_forward * (crandom() * self.maxs_z));
  TEMP_VEC2 = TEMP_VEC2 + (v_right * (crandom() * self.maxs_x));
  TEMP_VEC2 = TEMP_VEC2 + (v_up * (crandom() * self.maxs_y));
  
  te_missile_explode( TEMP_VEC2, self.vec_size, '0.5 0.85 0.96', 0.001 );
  PointSound_Dynamic(TEMP_VEC2, "sound/fx_boom%s.ogg", 1.0, ATTN_NORM, SOUNDFLAG_DYNAMIC_INT);
  self.data_lifetime = servertime + 360 + (random() * 180);
};