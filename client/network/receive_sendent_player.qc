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
  
  if(self.entId == player_localentnum && cvar("chase_active") == FALSE){
    offset = offset + (v_forward * (item.compOffset_z - fabs(self.cockpit.compOffset_z) ));
  }
  else{
    offset = offset + (v_forward * item.compOffset_z);
  }
  item.origin = offset;
};

/*
  assumes you've already made a makevectors() call
*/
void(entity piece) player_part_predaw={
  local vector offset;
  
  offset = self.origin + (v_right * piece.compOffset_x) + (v_up * piece.compOffset_y);
  
  if(self.entId == player_localentnum && cvar("chase_active") == FALSE){
    offset = offset + (v_forward * (piece.compOffset_z - fabs(self.cockpit.compOffset_z) ));
  }
  else{
    offset = offset + (v_forward * piece.compOffset_z);
  }
  
  piece.origin = offset;
  
  piece.angles = self.angles;
  piece.angles_x = 0;
};

//merely exists to satisfy interpolation
void() player_think={
  self.think = player_think;
  self.nextthink = time + 0.1;
};

float() player_predraw={
  local vector offset;
  local vector entAng;
  local entity wep;
  local vector cacheOrg;
  
  if( self.data_type == DATA_MECH ){
  
    if (self.nextthink != self.frame1time){
      self.frame2time = self.frame1time;
      self.frame1time = self.nextthink;
      self.frame2 = self.frame1;
      self.frame1 = self.frame;
      self.origin2 = self.origin1;
      self.origin1 = self.origin;
      self.angle2 = self.angle1;
      self.angle1 = self.angles_y;
    }
    self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
    self.lerpfrac = 1-bound(0, self.lerpfrac, 1);
  
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    
    if(self.entId == player_localentnum){
      cacheOrg = self.origin;
      self.origin = pmove_org;
    }
    
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
      player_part_predaw(self.legs);
      
      if( time > self.legs.nextthink){
        wep = self;
        self = self.legs;
          if(self.think){
            self.think();
          }
        self = wep;
      }
      predraw_legs();
      
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
    if(cacheOrg){
      self.origin = cacheOrg;
    }
  }
  return FALSE;
};

/*
  poor workaround, OTHER player mechs aren't fully formed mech data, lack of interpolation.
  we just care about part offsets for special effects.
*/
void( float mech_id ) sendevent_player_mech={
  local vector minSave, maxSave;
  local entity weps;
  local entity this;
  
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  switch(mech_id){
    case UID_MECH_balaket:
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
  minSave = self.mins;
  maxSave = self.maxs;
  setmodel(self.torsoCenter, self.torsoCenter.model);
  setmodel(self.torsoLeft, self.torsoLeft.model);
  setmodel(self.torsoRight, self.torsoRight.model);
  setmodel(self.armLeft, self.armLeft.model);
  setmodel(self.armRight, self.armRight.model);
  setmodel(self.legs, self.legs.model);
  
  self.torsoCenter.colormod = self.colormod;
  self.torsoLeft.colormod = self.colormod;
  self.torsoRight.colormod = self.colormod;
  self.armLeft.colormod = self.colormod;
  self.armRight.colormod = self.colormod;
  self.legs.colormod = self.colormod;
  
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
      self.reloadValue = 100;
      self.icon = strzone(self.icon);
      setmodel(self, self.model);
    self = this;
    weps = weps.w_slot;
  }
  setsize(self, minSave, maxSave);
};

/*
  HANDLE EVENT - player killed on this frame.
*/
void() sendevent_handle_player_death={
  local entity wep, nextWep;
  
  te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
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
  remove(self.legs);
  
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
  HANDLE EVENT - player has changed factions during a team game.
*/
void() sendevent_handle_moveChange={
  if(self.legs!=world){
    self.legs.nextthink = time + 0.1;
  }
};

/*
  HANDLE EVENT - player mech parts destroyed
*/
void( float criticalBits ) sendevent_player_critical={
  local vector offset;
  local entity wep;
  
  if( (criticalBits & M_TOR_LEFT) ){
    te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.torsoLeft.drawmask = 0;
  }
  if( (criticalBits & M_TOR_RIGHT) ){
    te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.torsoRight.drawmask = 0;
  }
  if( (criticalBits & M_ARM_LEFT) ){
    te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.armLeft.drawmask = 0;
  }
  if( (criticalBits & M_ARM_RIGHT) ){
    te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.armRight.drawmask = 0;
  }
  if( (criticalBits & M_LEGS) ){
    te_missile_explode( self.legs.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  
  wep = self.w_slot;
  while( wep != world ){
    if( (criticalBits & wep.partParentId) ){
      wep.drawmask = 0;
      if(self.entId == player_localentnum){
        CLIENT_weapon_state = CLIENT_weapon_state - (CLIENT_weapon_state & wep.w_group);
      }
    }
    wep = wep.w_slot;
  }
};

/*
  HANDLE EVENT - player mech pieces are dying
*/
void(float repairValue) sendevent_player_repair={
  local entity wep;
  
  if( !(repairValue & M_TOR_LEFT) ){
    self.torsoLeft.drawmask = MASK_ENGINE;
  }
  if( !(repairValue & M_TOR_RIGHT) ){
    self.torsoRight.drawmask = MASK_ENGINE;
  }
  if( !(repairValue & M_ARM_LEFT) ){
    self.armLeft.drawmask = MASK_ENGINE;
  }
  if( !(repairValue & M_ARM_RIGHT) ){
    self.armRight.drawmask = MASK_ENGINE;
  }
  
  wep = self.w_slot;
  while( wep != world ){
    if( !(repairValue & wep.partParentId) ){
      wep.drawmask = MASK_ENGINE;
      if(self.entId == player_localentnum){
        CLIENT_weapon_state = CLIENT_weapon_state | wep.w_group;
      }
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
  local vector prevOrg;
  local float prevShield;
  local float prevCrit;
  local float prevType;
  local float prevTarget; 
  local float prevKills;
  local float prevFaction;
  local float prevDeadFlag;
  local float prevAttackFlag;
  local float prevMoveState;
  
  prevShield = self.shield;
  prevCrit = self.damageValue;
  prevKills = self.kills;
  prevFaction = self.faction;
  prevDeadFlag = self.deadflag;
  prevAttackFlag = self.attackFlag;
  prevMoveState = self.moveState;
  prevOrg = self.origin;
  
  self.ping = stof( getplayerkeyvalue(self.entId - 1, "ping") );
  self.kills = stof( getplayerkeyvalue(self.entId - 1, "frags") );
  
  self.netname = getplayerkeyvalue(self.entId - 1, "name");
  
  /*
    EVENT - per-frame update
  */
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
    self.stat_rdr_mode = ReadByte();
    self.shield = ReadByte();
    self.energy = ReadByte();
    
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
    
    self.attackFlag = ReadLong();
    self.moveState = ReadByte();
  }
  
  /*
    EVENT - Track player move state?
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.legDir = anglemod(ReadShort());
    self.ai_dir = ReadShort();
  }
  
  /*
    EVENT - player info change 
  */
  if( (changeFlags & SENDFLAG_TURRET) ){
    prevType = self.data_type;
    self.data_type = ReadByte();
    self.faction = ReadByte();
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
        self.think = player_think;
        self.nextthink = time + 0.1;
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
      sendevent_player_critical( prevCrit );
    }
    else if( prevCrit > self.damageValue){
      //handle repair event
      sendevent_player_repair( self.damageValue );
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
  */ 
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    SV_MISSIONSTATUS = ReadByte();
    
    if( self.entId == player_localentnum ){
      CLIENT_player_deadflag = self.deadflag;
    }
    if( (self.deadflag == DEAD_DYING) && (prevDeadFlag != DEAD_DYING) ){
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
    setmodel(self, "q3mdl/testball.md3");
    setorigin(self, self.origin);
    self.alpha = 0.01;
    self.scale = 0.01;
  }
  
  /*
    EVENT - second data rider used for non-critical stuff
  */
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    prevTarget = self.targetEntId;
    self.kills = stof(getplayerkeyvalue(self.entId - 1, "frags"));
    
    self.particleCubeFlag = ReadByte();
    self.targetEntId = ReadLong();
    
    if( prevKills != self.kills ){
      scoreboard_sort();
    }
    
    if( self.targetEntId > 0 ){
      self.enemy = findfloat(world, entId, self.targetEntId);
    }
    else{
      self.enemy = world;
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
  
  if( (self.attackFlag != 0) && (prevAttackFlag != self.attackFlag) ){
    sendevent_handle_weaponfire();
  }
  
  if( prevMoveState != self.moveState ){
    sendevent_handle_moveChange();
  }
  if( isNew ){
    scoreboard_push( self.entId, self.kills );
    scoreboard_sort();
  }
  
  //perform data binds
  if( self.entId == player_localentnum ){
    CLIENT_flags = self.flags;
    CLIENT_player_deadflag = self.deadflag;
    CLIENT_faction = self.faction;
    CLIENT_data_type = self.data_type;
    CLIENT_data_idx = self.data_idx;
    CLIENT_move_state = self.moveState;
    CLIENT_shield = self.shield;
    if( self.energy > 0 ){
      CLIENT_energy = self.energy;
    }
    else{
      CLIENT_energy = 0;
    }
    
    if( self.targetEntId > 0 ){
      CLIENT_stat_trg_ddflg_prev = CLIENT_stat_trg_ddflg;
      CLIENT_stat_trg_ddflg = self.enemy.deadflag;
      if(CLIENT_stat_trg_ddflg > DEAD_NO ){
        self.enemy = world;
        CLIENT_stat_trg_ent_id = 0;
        CLIENT_stat_trg_dataidx = 0;
        return;
      }
      CLIENT_stat_trg_ent_id_prev = CLIENT_stat_trg_ent_id;
      CLIENT_stat_trg_ent_id = self.enemy.entId;
      CLIENT_stat_trg_dataidx = self.enemy.data_idx;
      CLIENT_stat_trg_face = getstati(STAT_TRG_FACE);
      CLIENT_target_datatype_prev = CLIENT_target_datatype;
      CLIENT_target_datatype = self.enemy.data_type;
      CLIENT_target_faction = self.enemy.faction;
      CLIENT_target_origin_x = self.enemy.origin_x;
      CLIENT_target_origin_y = self.enemy.origin_y;
      CLIENT_target_origin_z = self.enemy.origin_z;
      CLIENT_target_vecsize = self.enemy.vec_size;
      if( self.enemy.shield <= 0 ){
        CLIENT_target_shield = 0;
      }
      else{
        CLIENT_target_shield = self.enemy.shield;
      }
      CLIENT_target_dist_prev = CLIENT_target_dist;
      CLIENT_target_dist = vlen(self.enemy.origin - self.origin);
      CLIENT_target_size_x = self.enemy.maxs_x;
      CLIENT_target_size_y = self.enemy.maxs_y;
      CLIENT_target_size_z = self.enemy.maxs_z;
    }
    else{
      CLIENT_stat_trg_ent_id = 0;
      CLIENT_stat_trg_dataidx = 0;
      CLIENT_target_origin = '0 0 0';
      CLIENT_target_faction = 0;
      CLIENT_target_shield = 0;
      CLIENT_target_vecsize = 0;
    }
  }
};