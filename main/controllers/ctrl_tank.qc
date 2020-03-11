/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  per-frame game logic update functions
  
*/

void() ctrl_updateTank={
  local entity cam;
  local entity wep;
  local vector v1;
  local vector spark;
  local float hp;
  
  cam = self.cockpit;
  
  if( !(self.flags & FL_TURRET) ){
    //Unit lacks a turret.
    self.v_angle = self.angles;
  }
  
  makevectors(self.v_angle);
  v1 = self.origin + (v_right * cam.compOffset_x) + (v_up*cam.compOffset_y) + (v_forward*cam.compOffset_z);
  traceline(v1, v1 + v_forward * 10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  self.laser_sight_timer = time + 0.05;

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if(self.energy >= 0){
      self.energy = self.energy + self.energyRate;
      if(self.energy > self.energyMax){
        self.energy = self.energyMax;
      }
    }  
    if(self.energy < 0){
      self.energy = 0;
    }
    else if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
  
  self.ai_attackPreviousEnergy = self.ai_weaponEnergy;
  self.ai_weaponEnergy = 0;
  self.currentWeaponGroup = 0;
  
  wep = self.w_slot;
  while(wep){
    ctrl_weapon_think_ai(wep);
    wep = wep.w_slot;
  }
  
  //damage-based cosmetics for unit component pieces
  if( self.deadflag <= DEAD_NO ){
    hp = self.health / self.max_health;
    if( hp <= 0.75){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      client_send_particle( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 0.5);
    }
    else if( hp <= 0.5){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      client_send_particle( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 0.5);
      client_send_particle( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - self.origin) * 5, 0.5);
    }
    else if( hp <= 0.25){
      makevectors( self.angles );
      spark = self.origin + (v_up * (self.maxs_z * 0.75));
      client_send_particle( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - self.origin) * 5, 0.5);
      client_send_particle( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - self.origin) * 5, 0.5);
    }
  }
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
};

float( entity dest, float changedflags ) ctrl_send_tank={
  WriteByte( MSG_ENTITY, SENDTYPE_TANK );
  WriteByte( MSG_ENTITY, changedflags );
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteCoord( MSG_ENTITY, self.angles_x );
    WriteCoord( MSG_ENTITY, self.angles_y );
    WriteCoord( MSG_ENTITY, self.angles_z );
  }
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_x );
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.modelindex );
    WriteByte( MSG_ENTITY, self.skin );
    if( (self.flags & FL_TURRET) ){
      WriteByte( MSG_ENTITY, 1);  //TURRET FLAG
      WriteByte( MSG_ENTITY, self.torsoCenter.modelindex);
      WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_x );
      WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_y );
      WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_z );
    }
    else{
      WriteByte( MSG_ENTITY, 0);  //TURRET FLAG
    }
  }
  return TRUE;
};

float( entity dest, float changedflags ) ctrl_send_spg={
  WriteByte( MSG_ENTITY, SENDTYPE_SPG );
  WriteByte( MSG_ENTITY, changedflags );
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteCoord( MSG_ENTITY, self.angles_x );
    WriteCoord( MSG_ENTITY, self.angles_y );
    WriteCoord( MSG_ENTITY, self.angles_z );
  }
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.modelindex );
    WriteByte( MSG_ENTITY, self.skin );
  }
  return TRUE;
};

float( entity dest, float changedflags ) ctrl_send_gev={
  WriteByte( MSG_ENTITY, SENDTYPE_GEV );
  WriteByte( MSG_ENTITY, changedflags );
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    WriteCoord( MSG_ENTITY, self.angles_x );
    WriteCoord( MSG_ENTITY, self.angles_y );
    WriteCoord( MSG_ENTITY, self.angles_z );
  }
  if( (changedflags & SENDFLAG_TURRET) ){
    //WriteCoord( MSG_ENTITY, self.torsoCenter.angles_x );
   // WriteCoord( MSG_ENTITY, self.torsoCenter.angles_y );
   // WriteCoord( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    WriteByte( MSG_ENTITY, self.data_type );
    WriteByte( MSG_ENTITY, self.modelindex );
    WriteByte( MSG_ENTITY, self.skin );
    if( (self.flags & FL_TURRET) ){
     // WriteByte(MSG_ENTITY, self.torsoCenter.modelindex);
      //WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_x );
     // WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_y );
     // WriteCoord( MSG_ENTITY, self.torsoCenter.compOffset_z );
    }
  }
  return TRUE;
};
