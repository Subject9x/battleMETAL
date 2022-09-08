/*
battleMETAL
Author: Peter Roohr
Date: 04/27/2020
Overview: 
  misc buildings that really serve no direct purpose
*/

float( float isNew, float changeFlags ) sendent_misc_building={
  
  WriteByte( MSG_ENTITY, SENDTYPE_MISC_BLD );
  WriteLong( MSG_ENTITY, changeFlags );
  //======================
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
    
    WriteByte( MSG_ENTITY, self.faction );
    WriteChar( MSG_ENTITY, self.vec_size );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteChar( MSG_ENTITY, self.canTarget );
    if( (self.spawnflags & IS_MAPKEY) ){
      WriteChar( MSG_ENTITY, TRUE );
    }
    else{
      WriteChar( MSG_ENTITY, FALSE );
    }
    if( (self.spawnflags & IS_VIP) ){
      WriteChar( MSG_ENTITY, TRUE );
    }
    else{
      WriteChar( MSG_ENTITY, FALSE );
    }
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  return TRUE;
};


void() misc_build_die7={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.think  = building_die;
  self.nextthink = time + 0.33;
};
void() misc_build_die6={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.nextthink = time + 0.33;
  if( self.vec_size > 2 ){
    self.think = misc_build_die7;
  }
  else{
    self.think  = building_die;
  }
};

void() misc_build_die5={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.think = misc_build_die6;
  self.nextthink = time + 0.33;
};

void() misc_build_die4={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.think = misc_build_die5;
  self.nextthink = time + 0.33;
};
void() misc_build_die3={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.nextthink = time + 0.33;
  if( self.vec_size > 1 ){
    self.think = misc_build_die4;
  }
  else{
    self.think  = building_die;
  }
};

void() misc_build_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.think = misc_build_die3;
  self.nextthink = time + 0.33;
};

void() misc_build_die1={
  local vector shoot;
  if( self.deadflag > DEAD_NO ){
    return;
  }
  
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.deadflag = DEAD_DYING;
  
  shoot = randompos(self.absmin * 0.67, self.absmax * 0.67);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  te_missile_explode( randompos(self.absmin, self.absmax), self.vec_size, '1 0.85 0.33', 0.01 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
  
  self.think = misc_build_die2;
  self.nextthink = time + 0.33;
};


//settles building origin and angle before doing model / collider.
void() misc_building_settle={

  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if(self.building_delay_think){
    self.think = self.building_delay_think;
  }
  else{
    self.think = building_burn_th;
  }
  self.nextthink = time + random() * 1;
};

/*
  Generic ini func for misc_buildings
*/
void( string modelName, float setSizeFlag ) misc_building={
  self.avelocity = '0 0 0';
  self.velocity = '0 0 0';
  self.movetype = MOVETYPE_STEP;
  self.solid = SOLID_NOT;
  
  precache_model(modelName);
  
  setmodel(self, modelName);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

  cons_logAVector(self.classname, self.origin);
  //self.angles_y = self.angle;
  cons_logAFloat(self.classname, self.angles_y);
  
  if( !(self.spawnflags & MISC_NO_DROP) ){
    droptofloor();
  }
  else{
    traceline(self.origin, self.origin + [0, 0, self.mins_z * 2], TRUE, self);
    setorigin(self, trace_endpos + [0, 0, self.mins_z * -1]);
  }
  
  trigger_ext_check();
  
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.alpha = TRUE;
  
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.th_die = misc_build_die1;
  
  self.data_type = DATA_BLD;
  self.canTarget = FALSE;
	
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = TRUE;
    self.SendEntity = sendent_misc_building;
  }
	self.think = misc_building_settle;
	self.nextthink = time + 0.01;
};

void() building_misc_apartment={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 1;
  
  if( !self.health) {
    self.health =  200;
  }
  self.max_health = self.health;
  self.vec_size = 1;
  
  misc_building("models/buildings/misc/apt_small/apt_sm.md3", TRUE);
};

void() building_misc_factory_med={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 2;
  
  if( !self.health) {
    self.health =  350;
  }
  self.max_health = self.health;
  self.vec_size = 2;

  misc_building("models/buildings/misc/fact_med/fact_med.md3", TRUE);
};

void() building_misc_lodge={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 3;
  
  if( !self.health) {
    self.health =  200;
  }
  self.max_health = self.health;
  self.vec_size = 1;
  
  misc_building("models/buildings/misc/lodge/lodge.md3", TRUE);
};

void() building_misc_off_pyra={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 4;
  if( !self.health) {
    self.health =  200;
  }
  self.max_health = self.health;
  self.vec_size = 2;
  
  if( self.angles_y ){
    self.angles_y = 0;
    //quick hack to fix a BBOX issue: if this model is rotated, somehow players can fall INTO them...
  }
  
  misc_building("models/buildings/misc/office_pyramid/off_pyramid.md3", TRUE);
};

void() building_misc_off_large={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 5;
  if( !self.health) {
    self.health =  250;
  }
  self.max_health = self.health;
  self.vec_size = 3;
  
  misc_building("models/buildings/misc/office_large/off_large.md3", TRUE);
};

void() building_misc_off_small={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 6;
  if( !self.health) {
    self.health =  100;
  }
  self.max_health = self.health;
  self.vec_size = 2;
  
  misc_building( "models/buildings/misc/office_small/off_sm.md3", TRUE);
};

void() building_misc_fact_steam={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 7;
  if( !self.health) {
    self.health =  100;
  }
  self.max_health = self.health;
  self.vec_size = 2;
  misc_building("models/buildings/misc/fact_steam/fact_steam.md3", TRUE);
};
void() building_misc_apt_large={
  self.nextVecChoice = TRUE; //ai_can_spawn compatability
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  
  self.data_idx = 8;
  if( !self.health) {
    self.health =  200;
  }
  self.max_health = self.health;
  self.vec_size = 3;

  misc_building( "models/buildings/misc/apt_large/apt_larg.md3", TRUE);
};