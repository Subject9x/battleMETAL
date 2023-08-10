/*
battleMETAL
Author: Peter Roohr
Date: 11/26/2017
mod: 07/15/2019 
  Overview: 
    controller functions for buildings.
    Generic 'die' functon.
    Building Fire management.
      Building Fires are cosmetic entities that spawn fire effects as the building is damaged.
*/


void() building_ruin_smoke={
  local vector v;
  
  v = self.origin + [0,0, self.maxs_z + 5] + WeatherDominator.wind;
  if( time > self.ai_action_time ){
    if( self.vec_size > 1 ){
      pointparticles( particleeffectnum("TE_WRECK_SMOKE"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
    }
    else{
      pointparticles( particleeffectnum("TE_WRECK_SMOKE_SM"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
    
    }
  }
  else{
    if( self.vec_size > 1 ){
      pointparticles( particleeffectnum("TE_WRECK_SMOKE_LG"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
    }
    else{
      pointparticles( particleeffectnum("TE_WRECK_SMOKE"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
    }
  }
  
  if( time < self.ai_viewtime ){
    self.think = building_ruin_smoke;
    self.nextthink = time + 0.1;
  }
};


void() building_die={
  local vector destOrg;
  local entity ruins;
  
  if( self.deadflag == DEAD_NO || self.deadflag == DEAD_DEAD){
    return;
  }
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.solid = SOLID_NOT;
  self.deadflag = DEAD_DEAD;
  self.touch = SUB_Null;
  
  //traceline(self.origin, self.origin + (v_up * self.mins_z), TRUE, self);
  destOrg = self.origin;
  destOrg_z = destOrg_z + self.mins_z;
  
  switch( self.vec_size ){
    case 2:
      setmodel(self, "models/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel(self, "models/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel(self, "models/map/ruins/ruin_small.obj");
      break;
  }
  setsize(self, self.mins, self.maxs);
  setorigin(self, destOrg);
  
  self.enemy = world;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD | SENDFLAG_MOVE;
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
  
  ruins = spawn();
  if( !ruins ){return;}
  
  ruins.movetype = MOVETYPE_NONE;
  ruins.solid = SOLID_NOT;
  ruins.takedamage = DAMAGE_NO;
  ruins.vec_size = self.vec_size;
  
  ruins.ai_viewtime = time + 180 + (random() * 180);
  ruins.ai_action_time = time + 90 + (random() * self.vec_size * 45 );
  
  setmodel(ruins, self.model);
  setsize(ruins, ruins.mins, ruins.maxs);
  setorigin(ruins, destOrg);
  
  ruins.think = building_ruin_smoke;
  ruins.nextthink = time + 0.1;
};


/*
  IF a building lacks a unique think function, use this 
*/
void() building_burn_th={
  
  building_burn();
  
  if( self.last_energy != self.energy ){
    self.SendFlags = self.SendFlags | SENDFLAG_ENERGY;
    self.last_energy = self.energy;
  }
  
  if( (self.unitModFlags & MOD_HAS_SHIELD)){
    if( self.last_shield != self.stat_client_shield ){
      self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
      self.last_shield = self.stat_client_shield;
    }
  }
  
  self.think = building_burn_th;
  self.nextthink = time + 0.1 + (random() * 0.5);
};


/*
  Particle System  - control for burn-effect on buildings
*/
void() building_burn={
  if( self.health < self.max_health * 0.75){
    if( !(self.burnBits & WEAPON1) ){
      self.burnBits = self.burnBits | WEAPON1;
      self.SendFlags = self.SendFlags | SENDFLAG_BURN;
    }
  }
  if( self.health < self.max_health * 0.55){
    if( !(self.burnBits & WEAPON2) ){
      self.burnBits = self.burnBits | WEAPON2;
      self.SendFlags = self.SendFlags | SENDFLAG_BURN;
    }
    
  }
  if( self.health < self.max_health * 0.33){
    if( !(self.burnBits & WEAPON3) ){
      self.burnBits = self.burnBits | WEAPON3;
      self.SendFlags = self.SendFlags | SENDFLAG_BURN;
    }
  }
};

float( float isNew, float changedflags ) ctrl_send_turret={
  
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_TURRET );
  WriteLong( MSG_ENTITY, changedflags );
  //=================
  
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
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
    if( (self.spawnflags & MUTE_ME) ){
      WriteChar( MSG_ENTITY, TRUE );
    }
    else{
      WriteChar( MSG_ENTITY, FALSE );
    }
    WriteChar( MSG_ENTITY, self.subType );
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  if( (changedflags & SENDFLAG_BURN) ){
    WriteLong( MSG_ENTITY, self.burnBits );
  }
  
  if( (changedflags & SENDFLAG_CAMERA)) {
    WriteByte( MSG_ENTITY, self.groundEnt );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100);
  }
  
  if( (changedflags & SENDFLAG_ATTACK) ){
    WriteLong( MSG_ENTITY, self.attackFlag );
  }
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torC_angl_y );
  }
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};

float( float isNew, float changedflags ) ctrl_send_building={
  local float mapKey;
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_BUILD );
  WriteLong( MSG_ENTITY, changedflags );
  //=================
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteLong( MSG_ENTITY, num_for_edict(self));
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
    
    WriteChar( MSG_ENTITY, self.faction );
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
    
    if( (self.spawnflags & MUTE_ME) ){
      WriteChar( MSG_ENTITY, TRUE );
    }
    else{
      WriteChar( MSG_ENTITY, FALSE );
    }
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  
  if( (changedflags & SENDFLAG_FACTION) ){
    WriteChar( MSG_ENTITY, self.faction );
  }
  
  if( (changedflags & SENDFLAG_BURN) ){
    WriteLong( MSG_ENTITY, self.burnBits );
  }
  
  if( (changedflags & SENDFLAG_ENERGY) ){
    WriteShort( MSG_ENTITY, self.energy );
  }
  
  if( (changedflags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (changedflags & SENDFLAG_CAMERA)) {
    WriteByte( MSG_ENTITY, self.groundEnt );
  }
  
  if( (changedflags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
    WriteByte( MSG_ENTITY, (self.health / self.max_health) * 100);
  }
  
  if( (changedflags & SENDFLAG_EXDATA) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      WriteByte( MSG_ENTITY, self.burstRate );
      WriteLong( MSG_ENTITY, self.critBits);  //send the partTypeId value to the client
      if( self.critBits != FALSE ){
        WriteLong( MSG_ENTITY, num_for_edict(self.goalentity) );
        if( self.critBits == M_TOR_CENTER ){
          WriteByte( MSG_ENTITY, (self.goalentity.health / self.goalentity.max_health) * 100 );
        }
        else if( self.critBits == M_TOR_LEFT ){
          WriteByte( MSG_ENTITY, (self.goalentity.torL_hp / self.goalentity.torL_hpMax) * 100 );
        }
        else if( self.critBits == M_TOR_RIGHT ){
          WriteByte( MSG_ENTITY, (self.goalentity.torR_hp / self.goalentity.torR_hpMax) * 100 );
        }
        else if( self.critBits == M_ARM_LEFT ){
          WriteByte( MSG_ENTITY, (self.goalentity.armL_hp / self.goalentity.armL_hpMax) * 100 );
        }
        else if( self.critBits == M_ARM_RIGHT ){
          WriteByte( MSG_ENTITY, (self.goalentity.armR_hp / self.goalentity.armR_hpMax) * 100 );
        }
        else if( self.critBits == M_LEGS ){
          WriteByte( MSG_ENTITY, (self.goalentity.legs_hp / self.goalentity.legs_hpMax) * 100 );
        }
      }
    }
    if( self.data_idx == UI_BUILDING_radar ){
      WriteByte( MSG_ENTITY, self.attack_state );
    }
    if(  self.data_idx == UI_BUILDING_guard_tower ){
      WriteByte( MSG_ENTITY, self.style );
    }
  }
  
  if( (changedflags & SENDFLAG_VOICE) ){
    if( !(changedflags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  
  self.shieldHitFlag = 0;
  return TRUE;
};


void() building_bbox_settle={
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if( self.canTarget ){
    self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  }
  
  if( self.building_delay_think ){
    self.think = self.building_delay_think;
  }
  else{
    self.think = building_burn_th;
  }
    self.nextthink = time + random() * 1;
};