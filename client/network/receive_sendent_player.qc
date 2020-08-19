/*
battleMETAL
Author: Peter Roohr
Date: 3/25/2020
Overview: 
  SendEnt impl for turret buildings
  
  handles
    sv/main/sv/sv_client_api.send_client_data()
*/


void(entity item) predraw_player_weapon={
  local entity this;
  local vector entAng;
  local vector drawAng;
  local vector offset;
  
  this = self;
  entAng = self.angles;
  drawAng = self.angles;
    drawAng_x = drawAng_x *-1;
  if(item.partParentId == M_ARM_LEFT || item.partParentId == M_ARM_RIGHT){
    if(item.partParentId == M_ARM_LEFT){
      offset = self.armLeft.origin;
    }
    else{
      offset = self.armRight.origin;
    }
    item.angles = drawAng;
  }
  else{
    entAng_x = 0;
    offset = self.origin;
    item.angles = entAng;
  }
  
  makevectors(entAng);
  offset = offset + (v_up * item.compOffset_y) + (v_right * item.compOffset_x);
  
  if(self.entId == player_localentnum){
    offset = offset + (v_forward * (item.compOffset_z - fabs(self.cockpit.compOffset_z) ));
  }
  else{
    offset = offset + (v_forward * item.compOffset_z);
  }
  item.origin = offset;
  if( (self.damageValue & item.partParentId) ){
    item.alpha = 0;
    item.drawmask = MASK_NORMAL;
  }
  else{
    item.alpha = 1;
    item.drawmask = MASK_ENGINE;
  }
};

/*
  assumes you've already made a makevectors() call
*/
void(entity piece) player_part_predaw={
  local vector offset;
  
  offset = self.origin + (v_right * piece.compOffset_x) + (v_up * piece.compOffset_y);
  
  if(self.entId == player_localentnum){
    offset = offset + (v_forward * (piece.compOffset_z - fabs(self.cockpit.compOffset_z) ));
  }
  else{
    offset = offset + (v_forward * piece.compOffset_z);
  }
  
  piece.origin = offset;
  piece.angles = self.angles;
  piece.angles_x = 0;
  if( (self.damageValue & piece.partTypeId) ){
    piece.alpha = 0;
    piece.drawmask = MASK_NORMAL;
  }
  else{
    piece.alpha = 1;
    piece.drawmask = MASK_ENGINE;
  }
};

float() player_predraw={
  local vector offset;
  local vector entAng;
  local entity wep;
  
  if( self.data_type == DATA_MECH ){
    if( self.deadflag == DEAD_NO ){
      entAng = self.angles;
      entAng_x = 0;
      makevectors( entAng );
      
      player_part_predaw(self.torsoCenter);
      player_part_predaw(self.torsoLeft);
      player_part_predaw(self.torsoRight);
      player_part_predaw(self.armLeft);
      self.armLeft.angles_x = self.angles_x * -1;
      player_part_predaw(self.armRight);
      self.armRight.angles_x = self.angles_x * -1;
      
      if( !(self.damageValue & M_LEGS) ){
        offset = self.origin + (v_forward * self.leg_z) + (v_right * self.leg_x) + (v_up * self.leg_y);
      }
      wep = self.w_slot;
      while( wep != world ){
        predraw_player_weapon(wep);
        wep = wep.w_slot;
      }
    }
    else{
    
    }
  }
  return FALSE;
};

/*
  poor workaround, OTHER player mechs aren't fully formed mech data, lack of interpolation.
  we just care about part offsets for special effects.
*/
void( float mech_id ) sendevent_player_mech={
  local entity weps;
  local entity this;
  
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(mech_id){
    case UID_MECH_balaket:
      //data_ini_balaket_offsets();
      data_ini_balaket_();
      break;
    case UID_MECH_matok:
      data_ini_matok_();
      break;
    case UID_MECH_monitor:
      data_ini_monitor_();
      break;
    default :
      cons_logAFloat("Error: failed to build mech with id", mech_id);
      break;
  }
  setmodel(self.torsoCenter, self.torsoCenter.model);
  setmodel(self.torsoLeft, self.torsoLeft.model);
  setmodel(self.torsoRight, self.torsoRight.model);
  setmodel(self.armLeft, self.armLeft.model);
  setmodel(self.armRight, self.armRight.model);
  
  self.torsoCenter.colormod = self.colormod;
  self.torsoLeft.colormod = self.colormod;
  self.torsoRight.colormod = self.colormod;
  self.armLeft.colormod = self.colormod;
  self.armRight.colormod = self.colormod;
  
  this = self;
  weps = self.w_slot;
  while( weps != world ){
    self = weps;
      sendent_set_weapon();
      if(self.data_idx != 0){
        initialize_data_item_(self.data_idx);
      }
      else{
        self.model = "q3mdl/testball.md3";
        self.alpha = 0.01;
        self.scale = 0.01;
      }
      setmodel(self, self.model);
    self = this;
    weps = weps.w_slot;
  }
};

/*
  HANDLE EVENT - player killed on this frame.
*/
void() sendevent_handle_player_death={
  local entity wep, nextWep;
  
  te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
  self.flags = 0;
  self.origin = '0 0 0';
  self.damageValue = 0;
  self.data_type = 0;
  self.data_idx = 0;
  
  self.damageValue = self.damageValue | (M_TOR_CENTER | M_TOR_LEFT | M_TOR_RIGHT | M_ARM_LEFT | M_ARM_RIGHT);
  
  remove(self.torsoCenter);
  remove(self.torsoLeft);
  remove(self.torsoRight);
  remove(self.armLeft);
  remove(self.armRight);
  remove(self.cockpit);
  
  wep = self.w_slot;
  while( (wep != world) ){
    nextWep = wep;
    nextWep = nextWep.w_slot;
    remove(wep);
    wep = nextWep;
  }
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
void( float criticalBits ) sendevent_player_critical={
  local vector offset;
  local entity wep;
  
  makevectors( self.angles );
  if( (criticalBits & M_TOR_LEFT) ){
    offset = self.origin + (v_forward * self.leftTorso_z) + (v_right * self.leftTorso_x) + (v_up * self.leftTorso_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_TOR_RIGHT) ){
    offset = self.origin + (v_forward * self.rightTorso_z) + (v_right * self.rightTorso_x) + (v_up * self.rightTorso_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_ARM_LEFT) ){
    offset = self.origin + (v_forward * self.leftArm_z) + (v_right * self.leftArm_x) + (v_up * self.leftArm_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_ARM_RIGHT) ){
    offset = self.origin + (v_forward * self.rightArm_z) + (v_right * self.rightArm_x) + (v_up * self.rightArm_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_LEGS) ){
    offset = self.origin + (v_forward * self.leg_z) + (v_right * self.leg_x) + (v_up * self.leg_y);
    te_missile_explode( offset, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  
  wep = self.w_slot;
  while( wep != world ){
    if( (criticalBits & wep.partParentId) ){
      wep.alpha = 0;
    }
    wep = wep.w_slot;
  }
};


/*
  HANDLE EVENT - player mech pieces are dying
*/
void( float criticalBits ) sendevent_player_burn={
  local vector offset;

  makevectors( self.angles );
  if( (criticalBits & M_TOR_LEFT) ){
    offset = self.origin + (v_forward * self.leftTorso_z) + (v_right * self.leftTorso_x) + (v_up * self.leftTorso_y);
    te_mech_crit( offset, '0 0 10');
  }
  if( (criticalBits & M_TOR_RIGHT) ){
    offset = self.origin + (v_forward * self.rightTorso_z) + (v_right * self.rightTorso_x) + (v_up * self.rightTorso_y);
    te_mech_crit( offset, '0 0 10');
  }
  if( (criticalBits & M_ARM_LEFT) ){
    if( !(self.damageValue & M_TOR_LEFT) ){
      offset = self.origin + (v_forward * self.leftArm_z) + (v_right * self.leftArm_x) + (v_up * self.leftArm_y);
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (criticalBits & M_ARM_RIGHT) ){
    if( !(self.damageValue & M_TOR_RIGHT) ){
      offset = self.origin + (v_forward * self.rightArm_z) + (v_right * self.rightArm_x) + (v_up * self.rightArm_y);
      te_mech_crit( offset, '0 0 10');
    }
  }
  if( (criticalBits & M_LEGS) ){
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
  
  prevShield = self.shield;
  prevCrit = self.damageValue;
  prevKills = self.kills;
  prevFaction = self.faction;
  prevDeadFlag = self.deadflag;
  
  self.ping = stof( getplayerkeyvalue(self.entId - 1, "ping") );
  self.kills = stof( getplayerkeyvalue(self.entId - 1, "frags") );
  self.netname = getplayerkeyvalue(self.entId - 1, "name");
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
    self.next_wepn1 = ReadByte();
    self.next_wepn2 = ReadByte();
    self.next_wepn3 = ReadByte();
    self.next_wepn4 = ReadByte();
    self.next_wepn5 = ReadByte();
    self.next_wepn6 = ReadByte();
    self.next_wepn7 = ReadByte();
    self.next_wepn8 = ReadByte();
    self.next_wepn9 = ReadByte();
    self.colormod = te_read_vector();
    if( self.data_type == DATA_MECH ){
      if( prevType != self.data_type ){
        self.deadflag = DEAD_NO;
        self.damageValue = rint(0);
        sendevent_player_mech(self.data_idx);
        self.predraw = player_predraw;
      }
      else{
        //debug - do player ent cleanup?
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
      if( self.entId != player_localentnum ){
        sendevent_player_critical( prevCrit );
      }
    }
  }
  
  /*
    EVENT - pieces of player mech are low on health and burning
  */
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadByte();
    if( self.burnBits > 0 ){
      sendevent_player_burn( self.burnBits );
    }
  }
  
  /*
    EVENT - DEAD
  */  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    SV_MISSIONSTATUS = ReadByte();
    
    if( self.entId == player_localentnum ){
      CLIENT_player_deadflag = self.deadflag;
    }
    if( (self.deadflag == DEAD_DYING) && (prevDeadFlag != DEAD_DYING) ){
      sendevent_handle_player_death();
      cons_logAFloat("sendevent_handle_player_death();", 1);  //debug
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