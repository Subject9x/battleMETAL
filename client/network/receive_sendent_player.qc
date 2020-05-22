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
  HANDLE EVENT - player killed on this frame.
*/
void() sendevent_handle_player_death={
  te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
  self.flags = 0;
  self.origin = '0 0 0';
  self.damageValue = 0;
  self.data_type = 0;
  self.data_idx = 0;
};

/*
  HANDLE EVENT - player has changed factions during a team game.
*/
void( float prevFac, float newFaction ) sendevent_handle_faction={
  if( prevFac == FACTION_SURVEST ){
    TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL - 1;
  }
  else if( prevFac == FACTION_MILITAR ){
    TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL - 1;
  }
  if( newFaction == FACTION_SURVEST ){
    TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
  }
  else if( newFaction == FACTION_MILITAR ){
    TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
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
  local float prevTarget; 
  local float prevKills;
  local float prevFaction;
  local float prevDeadFlag;
  local float msnStat;
  
  prevShield = self.shield;
  prevCrit = self.damageValue;
  prevKills = self.kills;
  prevFaction = self.faction;
  prevDeadFlag = self.deadflag;
  
  self.ping = ReadShort();
  
  /*
    EVENT - per-frame update
  */
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
    
    self.flags = ReadLong();
    self.radar_range = ReadLong();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadShort();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
  }
  
  /*
    EVENT - player target info change
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    prevTarget = self.targetEntId;
    self.targetEntId = ReadLong();
    if( self.targetEntId != 0 ){
      self.enemy = findfloat(world, entId, self.targetEntId);
    }
    else{
      self.enemy = world;
    }
  }
  
  /*
    EVENT - player info change 
  */
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
  
  /*
    EVENT - pieces of player mech is blown off
  */
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.damageValue = ReadShort();
    if( prevCrit < self.damageValue ){
      prevCrit = self.damageValue - (self.damageValue & prevCrit);
      sendevent_player_critical( prevCrit );
    }
  }
  
  /*
    EVENT - pieces of player mech are low on health and burning
  */
  if( (changeFlags & SENDFLAG_BURN) ){
    self.w_group = ReadByte();
    if( self.w_group > 0 ){
      sendevent_player_burn( self.w_group );
    }
  }
  
  /*
    EVENT - DEAD
  */
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    SV_MISSIONSTATUS = ReadByte();
    
    if( self.entId == player_localentnum ){
      CLIENT_player_deadflag = self.deadflag;
    }
    if( (self.deadflag == DEAD_DEAD) && (prevDeadFlag != self.deadflag) ){
      sendevent_handle_player_death();
    }
  }
  
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.entId = ReadLong();
    self.data_type = ReadByte();
    self.origin = te_read_vector();
    self.faction = ReadByte();
    self.flags = ReadLong();
    self.kills = stof( getplayerkeyvalue(self.entId - 1, "frags") );
    self.netname = strzone( getplayerkeyvalue(self.entId - 1, "name") );
    setmodel(self, "q3mdl/testball.md3");
    setorigin(self, self.origin);
    self.alpha = 0.01;
    self.scale = 0.01;
    if( isNew ){
      //addentity(self);
      scoreboard_push( self.entId, self.kills );
      scoreboard_sort();
    }
  }
  
  /*
    EVENT - second data rider used for non-critical stuff
  */
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.kills = stof(getplayerkeyvalue(self.entId - 1, "frags"));
    //TODO
    self.particleCubeFlag = ReadByte();
    
    if( prevKills != self.kills ){
      scoreboard_push( self.entId, self.kills );
      scoreboard_sort();
    }
    
    if( self.particleCubeFlag == 0 ){
      //remove cube
    }
    else if( self.particleCubeFlag && isNew ){
      //if( player_localentnum == self.data_idx ){
        //add cube
      //}
    }
  }
  
  /*
    HANDLE - Update Faction totals
  */
  if( prevFaction != self.faction ){
    sendevent_handle_faction( prevFaction, self.faction );
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
};