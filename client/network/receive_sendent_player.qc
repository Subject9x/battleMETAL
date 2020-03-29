/*
battleMETAL
Author: Peter Roohr
Date: 3/25/2020
Overview: 
  SendEnt impl for turret buildings
  
  handles
    sv/main/sv/sv_client_api.send_client_data()
*/

/*
  poor workaround, OTHER player mechs aren't fully formed mech data, lack of interpolation.
  we just care about part offsets for special effects.
*/
void( float mech_id ) sendevent_player_mech={
  switch(mech_id){
    case UID_MECH_balaket:
      data_ini_balaket_offsets();
      break;
    case UID_MECH_matok:
      data_ini_matok_offsets();
      break;
    case UID_MECH_monitor:
      data_ini_monitor_offsets();
      break;
    default :
      cons_logAFloat("Error: failed to build mech with id", mech_id);
      break;
  }
};

/*
  HANDLE EVENT - player mech parts destroyed
*/
void( float critBits ) sendevent_player_critical={
  local vector offset;
  
  makevectors( self.angles );
  if( (critBits & M_TOR_LEFT) ){
    offset = self.origin + (v_forward * self.leftTorso_z) + (v_right * self.leftTorso_x) + (v_up * self.leftTorso_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (critBits & M_TOR_RIGHT) ){
    offset = self.origin + (v_forward * self.rightTorso_z) + (v_right * self.rightTorso_x) + (v_up * self.rightTorso_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (critBits & M_ARM_LEFT) ){
    offset = self.origin + (v_forward * self.leftArm_z) + (v_right * self.leftArm_x) + (v_up * self.leftArm_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (critBits & M_ARM_RIGHT) ){
    offset = self.origin + (v_forward * self.rightArm_z) + (v_right * self.rightArm_x) + (v_up * self.rightArm_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (critBits & M_LEGS) ){
    offset = self.origin + (v_forward * self.leg_z) + (v_right * self.leg_x) + (v_up * self.leg_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
};


/*
  HANDLE EVENT - player mech pieces are dying
*/
void( float critBits ) sendevent_player_burn={
  local vector offset;

  makevectors( self.angles );
  if( (critBits & M_TOR_LEFT) ){
    offset = self.origin + (v_forward * self.leftTorso_z) + (v_right * self.leftTorso_x) + (v_up * self.leftTorso_y);
    te_mech_crit( offset, '0 0 10');
  }
  if( (critBits & M_TOR_RIGHT) ){
    offset = self.origin + (v_forward * self.rightTorso_z) + (v_right * self.rightTorso_x) + (v_up * self.rightTorso_y);
    te_mech_crit( offset, '0 0 10');
  }
  if( (critBits & M_ARM_LEFT) ){
    if( !(self.damageValue & M_TOR_LEFT) ){
      offset = self.origin + (v_forward * self.leftArm_z) + (v_right * self.leftArm_x) + (v_up * self.leftArm_y);
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (critBits & M_ARM_RIGHT) ){
    if( !(self.damageValue & M_TOR_RIGHT) ){
      offset = self.origin + (v_forward * self.rightArm_z) + (v_right * self.rightArm_x) + (v_up * self.rightArm_y);
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (critBits & M_LEGS) ){
    offset = self.origin + (v_forward * self.leg_z) + (v_right * self.leg_x) + (v_up * self.leg_y);
    te_mech_crit( offset, '0 0 10');
  }
};

void( float isNew, float changeFlags) sendent_handle_player={
  local float prevShield;
  local float prevCrit;
  local float prevType;
  
  prevShield = self.shield;
  prevCrit = self.damageValue;
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
  
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
    setorigin(self, self.origin);
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.radar_range = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadByte();
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    self.targetEntId = ReadByte();
  }
  if( (changeFlags & SENDFLAG_TURRET) ){
    prevType = self.data_type;
    self.data_type = ReadByte();
    self.faction = ReadByte();
    self.vec_size = ReadByte();
    self.data_idx = ReadByte();
    if( prevType != self.data_type ){
      if( self.data_type == DATA_MECH ){
        sendevent_player_mech(self.data_idx);
      }
    }
  }
  
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.damageValue = ReadShort();
    if( prevCrit < self.damageValue ){
      prevCrit = self.damageValue - (self.damageValue & prevCrit);
      sendevent_player_critical( prevCrit );
    }
  }
  
  if( (changeFlags & SENDFLAG_BURN) ){
    self.w_group = ReadByte();
    if( self.w_group > 0 ){
      sendevent_player_burn( self.w_group );
    }
  }
  
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    if( self.deadflag == DEAD_DEAD ){
      te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
      self.flags = 0;
      self.origin = '0 0 0';
      self.damageValue = 0;
      self.data_type = 0;
      self.data_idx = 0;
    }
  }
  
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.data_type = ReadByte();
    self.vec_size = ReadByte();
    self.origin = te_read_vector();
    setorigin(self, self.origin);
    self.flags = ReadLong();
    self.faction = ReadByte();
    self.radar_range = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadByte();
    self.netname = strzone( ReadString() );
  }
};