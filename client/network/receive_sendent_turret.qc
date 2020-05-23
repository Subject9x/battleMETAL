/*
battleMETAL
Author: Peter Roohr
Date: 3/19/2020
Overview: 
  SendEnt impl for turret buildings, a unique form of building
  
  handles
    sv/main/controllers/ctrl_building.ctrl_send_turret()
*/

float() predraw_turret;

void() sendevent_turret_die={
  local entity weps;
  local entity this;
  local entity rem;
  
  makevectors(self.angles);
  setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
  self.colormod = '0.85 0.85 0.85';
  
  self.origin = self.origin + (v_up * (self.maxs_z * -0.5));
  setorigin(self, self.origin);
  if( self.torsoCenter != world ){
    rem = self.torsoCenter;
    self.torsoCenter = world;
    remove(rem);
  }
  weps = self.w_slot;
  while( weps ){
    rem = weps;
    weps = rem.w_slot;
    remove(rem);
  }
  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fx_boom.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  
};

/*
  SendEntity - Turret =======================================
*/
void( float isNew, float changeFlags) sendent_handle_turret={
  local vector turretAng;
  local entity weps;
  local entity this;
  local float prevShield;
  
  //EVENT - MOVE - for turrets, this means a general update tic.
  prevShield = self.shield;
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.shield = ReadShort();
  }
  
  //EVENT - faction changed
  if( (changeFlags & SENDFLAG_VELOCITY) ){     
    self.faction = ReadByte();
  }
  
  //EVENT - turret rotated
  if( (changeFlags & SENDFLAG_TURRET) ){
    turretAng = te_read_vector();
  }
  
  //EVENT - death
  if( (changeFlags & SENDFLAG_DEAD) ){ 
    self.deadflag = ReadByte();
    if( self.deadflag > DEAD_NO ){
      sendevent_turret_die() ;
    }
  }
  
  //EVENT - health dropped below threshold
  if( (changeFlags & SENDFLAG_BURN) ){
    self.w_group = ReadByte();
    if( (self.w_group & WEAPON1) && !self.effect1.count ){
      self.effect1 = te_building_fire_start( self );
      self.colormod = self.colormod * 0.85;
    }
    if( (self.w_group & WEAPON2) && !self.effect2.count ){
      self.effect2 = te_building_fire_start( self );
      self.colormod = self.colormod * 0.75;
    }
    if( (self.w_group & WEAPON3) && !self.effect3.count ){
      self.effect3 = te_building_fire_start( self );
      self.colormod = self.colormod * 0.67;
    }
  }
  
  //EVENT - New to player
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.angles_x = anglemod(ReadCoord());
    self.angles_y = anglemod(ReadCoord());
    self.angles_z = anglemod(ReadCoord());
    
    self.entId = ReadLong();
    self.data_idx = ReadByte();
    self.spawnflags = ReadLong();
    
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    if( isNew ){
      data_sync_new_turret(self.data_idx);
      self.flags = self.flags | (FL_MONSTER | FL_UNIT);
      self.data_type = DATA_BLD;
      self.colormod = '1 1 1';
      self.predraw = predraw_turret;
      self.drawmask = MASK_ENGINE;
      sendent_setup_weapons();
      setorigin( self, self.origin );
    }
  }
  
  //HANDLE EVENT - Shield explode
  sendevent_shield_explode( prevShield );
  
  //HANDLE EVENT - turret rotate
  sendevent_turret_update( turretAng );
};

float() predraw_turret={
  local entity weps; 
  makevectors(self.torsoCenter.angles);
  for( weps = self.w_slot; weps != world; weps = weps.w_slot ){
    weps.origin = self.origin + (v_forward * weps.compOffset_z) + (v_right * weps.compOffset_x) + (v_up * weps.compOffset_y);
    weps.angles = self.torsoCenter.angles;
  }
  return TRUE;
};