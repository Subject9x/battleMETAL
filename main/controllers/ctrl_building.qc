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
  
  if( self.deadflag > DEAD_NO){
    return;
  }
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  world_remove_dlight(self);
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
};

void() building_burn={

  if( self.health < self.max_health * 0.75){
    if( !(self.w_group & WEAPON1) ){
      self.w_group = self.w_group | WEAPON1;
      self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    }
  }
  if( self.health < self.max_health * 0.55){
    if( !(self.w_group & WEAPON2) ){
      self.w_group = self.w_group | WEAPON2;
      self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    }
    
  }
  if( self.health < self.max_health *0.33){
    if( !(self.w_group & WEAPON3) ){
      self.w_group = self.w_group | WEAPON3;
      self.SendFlags = self.SendFlags | SENDFLAG_CRIT;
    }
  }
};

float( entity dest, float changedflags ) ctrl_send_turret={
  WriteByte( MSG_ENTITY, SENDTYPE_TURRET );
  WriteByte( MSG_ENTITY, changedflags );
      
  if( (changedflags & SENDFLAG_MOVE) ){
    WriteByte( MSG_ENTITY, self.shield );
  }
  if( (changedflags & SENDFLAG_TURRET) ){
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_x );
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_y );
    WriteCoord( MSG_ENTITY, self.torsoCenter.angles_z );
  }
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
  }
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteCoord( MSG_ENTITY, self.angles_x );
    WriteCoord( MSG_ENTITY, self.angles_y );
    WriteCoord( MSG_ENTITY, self.angles_z );
    
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
    
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
  return TRUE;
};

float( entity dest, float changedflags ) ctrl_send_building={
  WriteByte( MSG_ENTITY, SENDTYPE_BUILD );
  WriteByte( MSG_ENTITY, changedflags );
  
  WriteByte( MSG_ENTITY, self.energy );
  WriteByte( MSG_ENTITY, self.shield );
  
  if( (changedflags & SENDFLAG_DEAD) ){
    WriteByte( MSG_ENTITY, self.deadflag );
    if( self.deadflag > DEAD_NO ){
      WriteCoord( MSG_ENTITY, self.origin_x );
      WriteCoord( MSG_ENTITY, self.origin_y );
      WriteCoord( MSG_ENTITY, self.origin_z );
      
      WriteCoord( MSG_ENTITY, self.angles_x );
      WriteCoord( MSG_ENTITY, self.angles_y );
      WriteCoord( MSG_ENTITY, self.angles_z );
    }
  }
  
  if( (changedflags & SENDFLAG_NEWENT) ){
    WriteCoord( MSG_ENTITY, self.origin_x );
    WriteCoord( MSG_ENTITY, self.origin_y );
    WriteCoord( MSG_ENTITY, self.origin_z );
    
    WriteCoord( MSG_ENTITY, self.angles_x );
    WriteCoord( MSG_ENTITY, self.angles_y );
    WriteCoord( MSG_ENTITY, self.angles_z );
    
    WriteByte( MSG_ENTITY, self.faction );
    WriteByte( MSG_ENTITY, self.data_idx );
  }
  
  if( (changedflags & SENDFLAG_MOVE) ){
    if( self.data_idx == UI_BUILDING_repair_bay ){
      WriteByte( MSG_ENTITY, self.cockpit.attack_state);
      WriteCoord( MSG_ENTITY, self.compAltOffset_x );
      WriteCoord( MSG_ENTITY, self.compAltOffset_y );
      WriteCoord( MSG_ENTITY, self.compAltOffset_z );
    }
  }
  
  return TRUE;
};
