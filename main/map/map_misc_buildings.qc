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
    WriteByte( MSG_ENTITY, self.vec_size );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.canTarget );
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
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
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
  
  self.think  = building_die;
  self.nextthink = time + 0.1;
};
void() misc_build_die6={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  
  if( self.vec_size > 2 ){
    self.think = misc_build_die7;
    self.nextthink = time + 0.1;
  }
  else{
    self.think  = building_die;
    self.nextthink = time + 0.1;
  }
};

void() misc_build_die5={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  
  self.think = misc_build_die6;
  self.nextthink = time + 0.1;
};

void() misc_build_die4={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  
  self.think = misc_build_die5;
  self.nextthink = time + 0.1;
};
void() misc_build_die3={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  
  if( self.vec_size > 1 ){
    self.think = misc_build_die4;
    self.nextthink = time + 0.1;
  }
  else{
    self.think  = building_die;
    self.nextthink = time + 0.1;
  }
};

void() misc_build_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
  
  self.think = misc_build_die3;
  self.nextthink = time + 0.1;
};

void() misc_build_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.deadflag = DEAD_DYING;
  
  local vector shoot;
  shoot = randompos(self.absmin * 0.67, self.absmax * 0.67);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  
  self.think = misc_build_die2;
  self.nextthink = time + 0.1;
};




/*
  Generic ini func for misc_buildings
*/
void( string modelName, float setSizeFlag ) misc_building={
  self.avelocity = '0 0 0';
  self.velocity = '0 0 0';
  setmodel(self, modelName);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if( !(self.spawnflags & MISC_NO_DROP) ){
    droptofloor();
  }
  else{
    traceline(self.origin, self.origin + [0, 0, self.mins_z * 2], TRUE, self);
    setorigin(self, trace_endpos + [0, 0, self.mins_z * -1]);
  }
  
  trigger_ext_check();
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  self.takedamage = DAMAGE_AIM;
  self.deadflag = DEAD_NO;
  self.alpha = TRUE;
  
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.th_die = misc_build_die1;
  self.think = building_burn_th;
  self.nextthink = time + random() * 1;
  
  self.data_type = DATA_BLD;
  self.canTarget = FALSE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = TRUE;
    self.SendEntity = sendent_misc_building;
  }
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
  
  self.angles = '0 90 0';
  misc_building("q3mdl/buildings/misc/misc_apt_sm.obj", TRUE);
  setorigin(self, self.origin);
};

void() building_misc_apartment_wide={
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
  
  misc_building("q3mdl/buildings/misc/misc_apt_sm.obj", TRUE);
  setorigin(self, self.origin);
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

  misc_building("q3mdl/buildings/misc/misc_fact_med.obj", TRUE);
  setorigin(self, self.origin);
  self.angles = '0 90 0';
};

void() building_misc_factory_med_wide={
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
  misc_building("q3mdl/buildings/misc/misc_fact_med.obj", TRUE);
  setorigin(self, self.origin);
  self.angles = '0 0 0';
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
  
  misc_building("q3mdl/buildings/misc/misc_lodge.obj", TRUE);
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
  
  misc_building("q3mdl/buildings/misc/misc_off_pyramid.obj", TRUE);
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
  
  misc_building("q3mdl/buildings/misc/misc_off_large.obj", TRUE);
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
  
  misc_building( "q3mdl/buildings/misc/misc_off_sm.obj", TRUE);
  setorigin(self, self.origin);
};

void() building_misc_off_small_wide={
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
  
  self.angles = '0 90 0';
  misc_building( "q3mdl/buildings/misc/misc_off_sm.obj", TRUE );
  setorigin(self, self.origin);
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
  misc_building("q3mdl/buildings/misc/misc_fact_steam.obj", TRUE);
};


void() building_misc_apt_large_north={
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
  self.angles = '0 270 0';
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", TRUE);
  setorigin(self, self.origin);
};
void() building_misc_apt_large_east={
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
  
  self.angles = '0 180 0';
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", TRUE);
  setorigin(self, self.origin);
};
void() building_misc_apt_large_west={
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
  
  self.angles = '0 0 0';
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", TRUE);
  setorigin(self, self.origin);
};
void() building_misc_apt_large_south={
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
  
  self.angles = '0 90 0';
  misc_building( "q3mdl/buildings/misc/misc_apt_larg.obj", TRUE);
  setorigin(self, self.origin);
};