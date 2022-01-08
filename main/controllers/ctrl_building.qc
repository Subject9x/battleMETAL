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

void() building_die={
  
  if( self.deadflag != DEAD_NO){
    return;
  }
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
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
  self.nextthink = time + 1 + (random() * 0.5);
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
  local float scopeFlags;
  scopeFlags = 0;
  if( isNew ){
    scopeFlags = scopeFlags | changedflags;
    scopeFlags = scopeFlags | (SENDFLAG_MOVE | SENDFLAG_ANGLE | SENDFLAG_DEAD | SENDFLAG_FACTION | SENDFLAG_EXDATA);
  }
  
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_TURRET );
  WriteCoord( MSG_ENTITY, scopeFlags );
  //=================
  
  if( (scopeFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    if(self.deadflag != DEAD_NO){
      WriteByte( MSG_ENTITY, self.vec_size );
    }
  }
  
  if( (scopeFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  if( (scopeFlags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (scopeFlags & SENDFLAG_EXDATA) ){
    WriteByte( MSG_ENTITY, self.next_wepn1);
    WriteByte( MSG_ENTITY, self.next_wepn2);
    WriteByte( MSG_ENTITY, self.next_wepn3);
    WriteByte( MSG_ENTITY, self.next_wepn4);
    WriteByte( MSG_ENTITY, self.next_wepn5);
    WriteByte( MSG_ENTITY, self.next_wepn6);
    WriteByte( MSG_ENTITY, self.next_wepn7);
    WriteByte( MSG_ENTITY, self.next_wepn8);
    WriteByte( MSG_ENTITY, self.next_wepn9);
  }
  
  if( (scopeFlags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.spawnflags );
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  if( (scopeFlags & SENDFLAG_CAMERA)) {
    WriteByte( MSG_ENTITY, self.groundEnt );
  }
  
  if( (scopeFlags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  
  if( (scopeFlags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (scopeFlags & SENDFLAG_ATTACK) ){
    WriteCoord( MSG_ENTITY, self.attackFlag );
  }
  if( (scopeFlags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  if( (scopeFlags & SENDFLAG_TURRET) ){
    WriteAngle( MSG_ENTITY, self.v_angle_x );
    WriteAngle( MSG_ENTITY, self.torsoCenter.angles_y );
  }
  if( (scopeFlags & SENDFLAG_BURN) ){
    WriteCoord( MSG_ENTITY, self.burnBits );
  }
  if( (scopeFlags & SENDFLAG_VOICE) ){
    if( !(scopeFlags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  self.shieldHitFlag = 0;
  return TRUE;
};

float( float isNew, float changedflags ) ctrl_send_building={
  local float newFlags;
  newFlags = 0;
  if( isNew ){
    newFlags = newFlags | changedflags;
    newFlags = newFlags | (SENDFLAG_MOVE | SENDFLAG_ANGLE | SENDFLAG_DEAD | SENDFLAG_FACTION | SENDFLAG_EXDATA);
  }
  //HEADER
  WriteByte( MSG_ENTITY, SENDTYPE_BUILD );
  WriteCoord( MSG_ENTITY, newFlags );
  //=================
  
  if( (newFlags & SENDFLAG_ENERGY) ){
    WriteShort( MSG_ENTITY, self.energy );
  }
  
  if( (newFlags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    if(self.deadflag != DEAD_NO){
      WriteByte( MSG_ENTITY, self.vec_size );
    }
  }
  
  if( (newFlags & SENDFLAG_MOVE) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
  }
  if( (newFlags & SENDFLAG_ANGLE) ){
    WriteAngle( MSG_ENTITY, self.angles_x );
    WriteAngle( MSG_ENTITY, self.angles_y );
    WriteAngle( MSG_ENTITY, self.angles_z );
  }
  
  if( (newFlags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.spawnflags );
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  if( (newFlags & SENDFLAG_CAMERA)) {
    WriteByte( MSG_ENTITY, self.groundEnt );
  }
  
  if( (newFlags & SENDFLAG_SHIELD) ){
    WriteByte( MSG_ENTITY, self.stat_client_shield );
  }
  if( (newFlags & SENDFLAG_IMPACT) ){
    WriteByte( MSG_ENTITY, self.shieldHitFlag );
  }
  
  if( (newFlags & SENDFLAG_EXDATA) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      WriteByte( MSG_ENTITY, self.burstRate );
      WriteByte( MSG_ENTITY, self.attack_state);  //send the partTypeId value to the client
      if( self.attack_state > FALSE ){
        WriteCoord( MSG_ENTITY, num_for_edict(self.trigger_field.clientData) );
      }
    }
    if( self.data_idx == UI_BUILDING_radar ){
      WriteByte( MSG_ENTITY, self.attack_state );
    }
    if(  self.data_idx == UI_BUILDING_guard_tower ){
      WriteByte( MSG_ENTITY, self.style );
    }
  }
  
  if( (newFlags & SENDFLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.faction );
  }
  
  if( (newFlags & SENDFLAG_BURN) ){
    WriteCoord( MSG_ENTITY, self.burnBits );
  }
  if( (newFlags & SENDFLAG_VOICE) ){
    if( !(newFlags & SENDFLAG_NEWENT) ){
      WriteByte( MSG_ENTITY, self.ai_voice_id );
    }
  }
  
  self.shieldHitFlag = 0;
  return TRUE;
};
