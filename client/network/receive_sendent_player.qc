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
  HANDLE EVENT - player mech pieces are dying
*/
void() sendevent_player_burn={
  if( (self.unitModFlags & MOD_HAS_TOR_L) && (self.burnBits & M_TOR_LEFT) ){
    te_mech_crit( self.torsoLeft.origin , '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) &&(self.burnBits & M_TOR_RIGHT) ){
    te_mech_crit( self.torsoRight.origin , '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) &&(self.burnBits & M_ARM_LEFT) ){
    if( (self.unitModFlags & MOD_HAS_TOR_L) &&!(self.criticalHits & M_TOR_LEFT) ){
      te_mech_crit( self.armLeft.origin , '0 0 10');
    }
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) &&(self.burnBits & M_ARM_RIGHT) ){
    if( (self.unitModFlags & MOD_HAS_TOR_R) &&!(self.criticalHits & M_TOR_RIGHT) ){
      te_mech_crit( self.armRight.origin , '0 0 10');
    }
  }
  if( (self.burnBits & M_LEGS) ){
    te_mech_crit( self.legs.origin , '0 0 10');
  }
};

/*
  Player weapons (usually in the arms) inherit their pitch from their parent piece.
  therefore, the weapon offsets for CLIENT is based on the PARENT offset:
    wep.origin = parent.origin + wep.offset 
      where parent.origin has already been calculated.
*/
void(entity item) predraw_player_weapon={
  local entity parent;
  local vector drawAng;
  local vector offset;
  local vector adjPartOffset;
  
  parent = util_getPartFromName( item.partParentId, self);
  
  adjPartOffset = item.compOffset - parent.compOffset;
  
  offset = parent.origin;
  drawAng = parent.angles;
  drawAng_x = drawAng_x *-1;
  makevectors( drawAng);
  offset = offset + (v_up * adjPartOffset_y) + (v_right * adjPartOffset_x) + (v_forward * adjPartOffset_z);
  //we ignore FPV z offset because player muzzle flash for view-tracking in FPV should match actual game coords.
  item.origin = offset;
  item.angles = parent.angles;
};

/*
  assumes you've already made a makevectors() call
*/
void(entity piece) player_part_predaw={
  local vector offset;
  if( (self.criticalHits & piece.partTypeId) ){
    return;
  }
  offset = self.origin + (v_right * piece.compOffset_x) + (v_up * piece.compOffset_y) + (v_forward * piece.compOffset_z);
  
  if(self.clientLocalId == player_localentnum && cvar("chase_active") == FALSE){
    offset = offset - (v_forward * self.cockpit.compOffset_z);
  }
  
  piece.origin = offset;
  piece.angles_y = self.angles_y;
  piece.angles_x = 0;
};

/*
  I'm not really sure when this runs because CSQC's time variable appears to be super-unreliable.
*/
void() player_think={
  local vector boostLeft, boostRight, backLeft, backRight;
  local string te;
  
  local vector laserHit;
  local vector laserOrg;
  
  local entity theWeapon;
  
  makevectors(self.angles);
  if(self.chaseActive){
    laserOrg = self.origin + (v_up * 22); //+ (v_forward * -96);
    traceline(self.origin, laserOrg, TRUE, self);
    laserOrg = trace_endpos;
  }
  else{
    laserOrg = self.origin + (v_up * self.cockpit.compOffset_y);
  }
  laserHit = laserOrg + (v_forward * 10000);
  traceline(laserOrg, laserHit, FALSE, self);
  self.laser_sight_org = trace_endpos;
  
  sendevent_player_burn();
  
  if( self.legs != world ){
    if( self.moveState > MOVE_SPRINT ){
      makevectors(self.legs.angles);
      boostLeft = boostRight = self.origin + (v_up * (self.mins_z * 0.75));
      boostLeft = boostLeft + (v_right * self.mins_x * 0.5);
      boostRight = boostRight + (v_right * self.maxs_x * 0.5);
      
      backLeft = backRight = self.origin + (v_forward * -32) + (v_up * (self.mins_z * 0.67));
      backLeft = backLeft + (v_right * self.mins_x * 0.5);
      backRight = backRight + (v_right * self.maxs_x * 0.5);
      
      switch(self.vec_size){
        case 3:
          te = "TE_FIRE_3";
          break;
        default:
          te = "TE_FIRE_2";
          break;
      }
      trailparticles(world, particleeffectnum(te), boostLeft, backLeft);
      trailparticles(world, particleeffectnum(te), boostRight, backRight);
    }
  }
  
  if( self.clientLocalId == player_localentnum ){
    theWeapon = self.w_slot;
    while( theWeapon ){
      player_weapon_reload( theWeapon );
      theWeapon = theWeapon.w_slot;
    }
  }
  self.think = player_think;
  self.nextthink = time + 0.01;
};

void() player_predraw={
  local vector entAng;
  local entity wep;
  local vector cacheOrg;
  local float lerpDiff;
  local float lerp;
  local vector hudAng;
  local vector strutOrg;
  local vector consOrg;
  
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
      self.laser_sight_org2 = self.laser_sight_org1;
      self.laser_sight_org1 = self.laser_sight_org;
    }
    lerpDiff = (time - self.frame2time) /(self.frame1time-self.frame2time);
    lerp = 1 - bound(0, lerpDiff, 1);
    self.lerpfrac = lerp;
    
    self.laser_sight_org = self.laser_sight_org1 + (self.laser_sight_org2-self.laser_sight_org1)*self.lerpfrac;
  
    if(self.clientLocalId == player_localentnum ){
      CLIENT_lerp = self.lerpfrac;
    }
  
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    
    if(self.clientLocalId == player_localentnum){
      cacheOrg = self.origin;
      self.origin = pmove_org;
    }
    
    if( self.deadflag == DEAD_NO ){
      self.torsoCenter.colormod = CLR_PLAYER_LIST[self.unitColorCT];
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
        self.torsoLeft.colormod = CLR_PLAYER_LIST[self.unitColorLT];
      }
      if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
        self.torsoRight.colormod = CLR_PLAYER_LIST[self.unitColorRT];
      }
      if( (self.unitModFlags & MOD_HAS_ARM_L) ){
        self.armLeft.colormod = CLR_PLAYER_LIST[self.unitColorLA];
      }
      if( (self.unitModFlags & MOD_HAS_ARM_R) ){
        self.armRight.colormod = CLR_PLAYER_LIST[self.unitColorRA];
      }
      
      self.legs.colormod = CLR_PLAYER_LIST[self.unitColorLG];
  
      entAng = self.angles;
      entAng_x = 0;
      makevectors( entAng );
      
      player_part_predaw(self.torsoCenter);
      if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
        self.torsoCenter.angles_x = self.angles_x * -1;
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
        player_part_predaw(self.torsoLeft);
        if((self.unitModFlags & MOD_MODEL_PITCH_TOR_L)){
          self.torsoLeft.angles_x = self.angles_x * -1;
        }
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
        player_part_predaw(self.torsoRight);
        if((self.unitModFlags & MOD_MODEL_PITCH_TOR_R)){
          self.torsoRight.angles_x = self.angles_x * -1;
        }
      }
      
      player_part_predaw(self.legs);
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
        player_part_predaw(self.armLeft);
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
          self.armLeft.angles_x = self.angles_x * -1;
        }
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
        player_part_predaw(self.armRight);
      
        if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
          self.armRight.angles_x = self.angles_x * -1;
        }
      }
      if( time > self.legs.nextthink){
        wep = self;
        self = self.legs;
          if(self.think){
            self.think();
          }
        self = wep;
      }
      predraw_legs();
      wep = self.w_slot;
      while( wep != world ){
        if( !(self.criticalHits & wep.partParentId) ){
          predraw_player_weapon(wep);
        }
        wep = wep.w_slot;
      }
    }
    
    if(cacheOrg){
      self.origin = cacheOrg;
    }
    setorigin(self, self.origin);
    
    if(self.clientLocalId == player_localentnum){
      if( self.deadflag == DEAD_NO ){
        if( CLIENT_player_state == PLAYER_POWERUP_BEGIN && cvar("chase_active") == FALSE){
          hudAng = HUD_FIXED_ANGLE;
          hudStruts.angles_y = HUD_FIXED_ANGLE_y;
          hudStruts.angles_x = 0;
          hudStruts.angles_z = 0;
          
          hudConsole.angles_y = HUD_FIXED_ANGLE_y;
          hudConsole.angles_x = 33;
          hudConsole.angles_z = 0;
        }
        else{
          hudAng = input_angles;
          hudAng_x = 0;
          
          hudStruts.angles_y = input_angles_y;
          hudStruts.angles_x = 0;
          hudStruts.angles_z = 0;
          
          hudConsole.angles_y = input_angles_y;
          hudConsole.angles_x = 33;
          hudConsole.angles_z = 0;
        }
        makevectors(hudAng);
        strutOrg = getpropertyvec(VF_ORIGIN) + (v_forward * self.hud_StrutsOffset_z)  + (v_right * self.hud_StrutsOffset_x)  + (v_up * self.hud_StrutsOffset_y);
        setorigin(hudStruts, strutOrg);
        
        consOrg = getpropertyvec(VF_ORIGIN) + (v_forward * 0.75) + (v_up * -1.55);
        setorigin(hudConsole, consOrg);
        if( cvar("chase_active") == FALSE ){
          addentity(hudStruts);
          addentity(hudConsole);
					//hudStruts.drawmask = -1;
					//hudConsole.drawmask = -1;
        }
      }
    }
  }
};


/*
  poor workaround, OTHER player mechs aren't fully formed mech data, lack of interpolation.
  we just care about part offsets for special effects.
*/
void( float mech_id ) sendevent_player_mech={
  local vector minSave, maxSave;
  local entity weps;
  local entity this;
  
  self.flags = self.flags | FL_CLIENT | FL_TURRET;  //read-order fix
  self.deadflag = DEAD_NO;
  self.criticalHits = rint(0);
  
  initialize_data_mech_(mech_id);
  
  minSave = self.mins;
  maxSave = self.maxs;
  
  self.torsoCenter.colormod = CLR_PLAYER_LIST[self.unitColorCT];
  self.torsoCenter.skin = self.faction - 1;
  setmodel(self.torsoCenter, self.torsoCenter.model);
  self.torsoCenter.drawmask = MASK_NORMAL;
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
    self.torsoLeft.colormod = CLR_PLAYER_LIST[self.unitColorLT];
    self.torsoLeft.skin = self.faction - 1;
    setmodel(self.torsoLeft, self.torsoLeft.model);
    self.torsoLeft.drawmask = MASK_NORMAL;
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R)  ){
    self.torsoRight.colormod = CLR_PLAYER_LIST[self.unitColorRT];
    self.torsoRight.skin = self.faction - 1;
    setmodel(self.torsoRight, self.torsoRight.model);
    self.torsoRight.drawmask = MASK_NORMAL;
  }
  
  if( (self.unitModFlags & MOD_HAS_ARM_L) ){
    self.armLeft.colormod = CLR_PLAYER_LIST[self.unitColorLA];
    self.armLeft.skin = self.faction - 1;
    setmodel(self.armLeft, self.armLeft.model);
    self.armLeft.drawmask = MASK_NORMAL;
  }
  
  if( (self.unitModFlags & MOD_HAS_ARM_R) ){
    self.armRight.colormod = CLR_PLAYER_LIST[self.unitColorRA];
    self.armRight.skin = self.faction - 1;
    setmodel(self.armRight, self.armRight.model);
    self.armRight.drawmask = MASK_NORMAL;
  }
  
  self.legs.colormod = CLR_PLAYER_LIST[self.unitColorLG];
  self.legs.skin = self.faction - 1;
  setmodel(self.legs, self.legs.model);
  self.legs.drawmask = MASK_NORMAL;
  
  this = self;
  weps = self.w_slot;
  while( weps != world ){
    self = weps;
      sendent_set_weapon();
      if(self.data_idx != 0 && !(self.unitModFlags & MOD_MODEL_NONE)){
        initialize_data_item_(self.data_idx);
      }
      else{
        self.model = "q3mdl/testball.md3";
        self.alpha = 0.01;
        self.scale = 0.01;
      }
      self.reloadValue = 100;
      setmodel(self, self.model);
      self.drawmask = MASK_NORMAL;
      self.wepFireOffsetCache = self.wepFireOffset;
    self = this;
    weps = weps.w_slot;
  }
  if( (self.unitModFlags & MOD_MODEL_ROOT_TOR_C) ){
    self.colormod = CLR_PLAYER_LIST[self.unitColorCT];
    self.skin = self.faction - 1;
    setmodel(self, self.model);
    self.alpha = 1.0;
    self.scale = 1.0;
  }
  self.solid = SOLID_BBOX;
  setsize(self, minSave, maxSave);
  
  //hud shenanigans
  if( self.clientLocalId == player_localentnum ){
    CLIENT_server_ent = self;
    HUD_VIEW_CL_ANGLES = self.angles;
    HUD_VIEW_OFS = self.cockpit.compOffset_z;
    hudStruts = spawn();
    hudStruts.effects = hudStruts.effects | EF_NOSHADOW;
    setmodel(hudStruts, self.weaponmodel);
    setorigin(hudStruts, pmove_org);
    hudStruts.angles_y = input_angles_y;
    hudStruts.angles_x = 0;
    hudStruts.angles_z = 0;
    
    hudConsole = spawn();
    hudConsole.effects = hudConsole.effects | EF_NOSHADOW;
    setmodel(hudConsole, self.hud_model);
    setorigin(hudConsole, pmove_org);
    hudConsole.angles_y = input_angles_y;
    hudConsole.angles_x = 45;
    hudConsole.angles_z = 0;
    if( cvar("chase_active") ){
      if( (ENT_SERVER_INFO.serverFlags & SVFLAG_FPSONLY) ){
        HUD_EXTERNAL_CAM_ACTIVE = FALSE;
        cvar_set("chase_active", "0");
      }
      else{
        HUD_EXTERNAL_CAM_ACTIVE = TRUE;
      }
    }
    HUD_FIXED_ANGLE = self.angles;
  }
  
  self.shieldEffectTime = 0;
  self.predraw = player_predraw;
  self.canTarget = TRUE;
};

/*
  HANDLE EVENT - player killed on this frame.
*/
void() sendevent_handle_player_death={
  local entity wep, nextWep;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
  self.origin = '0 0 0';
  self.criticalHits = 0;
  self.data_type = 0;
  self.data_idx = 0;
  
  self.criticalHits = self.criticalHits | (M_TOR_CENTER | M_TOR_LEFT | M_TOR_RIGHT | M_ARM_LEFT | M_ARM_RIGHT);
  
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
  if(self.clientLocalId == player_localentnum){
    remove(hudConsole);
    remove(hudStruts);
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
  if( self.data_type == DATA_MECH ){
    self.torsoCenter.skin = self.faction - 1;
    
    if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
      self.torsoLeft.skin = self.faction - 1;
    }
    if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
      self.torsoRight.skin = self.faction - 1;
    }
    if( (self.unitModFlags & MOD_HAS_ARM_L) ){
      self.armLeft.skin = self.faction - 1;
    }
    if( (self.unitModFlags & MOD_HAS_ARM_R) ){
      self.armRight.skin = self.faction - 1;
    }
    
    self.legs.skin = self.faction - 1;
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
  local entity wep;
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) && (criticalBits & M_TOR_LEFT) ){
    te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.torsoLeft.drawmask = 0;
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) && (criticalBits & M_TOR_RIGHT) ){
    te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.torsoRight.drawmask = 0;
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) && (criticalBits & M_ARM_LEFT) ){
    te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.armLeft.drawmask = 0;
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) && (criticalBits & M_ARM_RIGHT) ){
    te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
    self.armRight.drawmask = 0;
  }
  if( (criticalBits & M_LEGS) ){
    te_missile_explode( self.legs.origin, self.vec_size * 1.25, '0.9 0.75 0.45', 0.01 ) ;
  }
  if(self.clientLocalId != player_localentnum){
    return;
  }
  wep = self.w_slot;
  while( wep != world ){
    if( (criticalBits & wep.partParentId) ){
      CLIENT_weapon_state = CLIENT_weapon_state - (CLIENT_weapon_state & wep.w_group);
      wep.drawmask = 0;
    }
    wep = wep.w_slot;
  }
};

/*
  HANDLE EVENT - Player Critical notifying everyone
*/
void( float playerEntId, float playerCritFlags ) client_handle_crit={
  local entity playerMech;
  local entity nonSelf;
  
  playerMech = findfloat(world, clientLocalId, playerEntId);
  if( playerMech ){
    nonSelf = self;
    self = playerMech;
      sendevent_player_critical(playerCritFlags);
    self = nonSelf;
  }
};

/*
  HANDLE EVENT - player mech pieces are being repair
*/
void(float repairValue) sendevent_player_repair={
  local entity wep;
  
  if( (repairValue & M_TOR_CENTER) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_CENTER);
    self.torsoCenter.drawmask = MASK_NORMAL;
  }
  if(  (self.unitModFlags & MOD_HAS_TOR_L) && (repairValue & M_TOR_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_LEFT);
    self.torsoLeft.drawmask = MASK_NORMAL;
  }
  if(  (self.unitModFlags & MOD_HAS_TOR_R) && (repairValue & M_TOR_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_RIGHT);
    self.torsoRight.drawmask = MASK_NORMAL;
  }
  if(  (self.unitModFlags & MOD_HAS_ARM_L) && (repairValue & M_ARM_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_LEFT);
    self.armLeft.drawmask = MASK_NORMAL;
  }
  if(  (self.unitModFlags & MOD_HAS_ARM_R) && (repairValue & M_ARM_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_RIGHT);
    self.armRight.drawmask = MASK_NORMAL;
  }
  
  if(self.clientLocalId != player_localentnum){
    return;
  }
  wep = self.w_slot;
  while( wep != world ){
    if( !(repairValue & wep.partParentId) ){
      CLIENT_weapon_state = CLIENT_weapon_state | wep.w_group;
      wep.drawmask = MASK_NORMAL;
    }
    wep = wep.w_slot;
  }
};

void( float isNew, float changeFlags) sendent_handle_player={
  local entity controlPlayer;
  local entity thisSelf;
  local vector prevOrg;
  local float prevShield;
  local float prevType;
  local float prevKills;
  local float prevFaction;
  local float prevDeadFlag;
  local float prevAttackFlag;
  local float prevMoveState;
  local float prevBurn;
  local float newCrits;
  local float frameItr;
  
  prevBurn = self.burnBits;
  prevShield = self.shield;
  prevKills = self.kills;
  prevFaction = self.faction;
  prevDeadFlag = self.deadflag;
  prevAttackFlag = self.attackFlag;
  prevMoveState = self.moveState;
  prevOrg = self.origin;
  prevType = self.data_type;
  
  /*
    EVENT - per-frame update
  */
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
    self.moveState = ReadByte();
    self.legDir = anglemod(ReadShort());
    self.ai_dir = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
  }
  
  if( (changeFlags & SENDFLAG_RADAR) ){
    self.stat_rdr_mode = ReadByte();
  }
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_ENERGY) ){
    self.energy = ReadByte();
  }
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadCoord();
  }
  if( (changeFlags & SENDFLAG_CAMERA) ){
    self.chaseActive = ReadByte();
  }
  
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.entId = self.entnum;
    self.clientLocalId = ReadByte();
    self.clientLocalNum = self.clientLocalId - 1;
  }
  
  /*
    EVENT - Player has taken fire
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = ReadByte();
  }
  /*
    HANDLE - Update Faction totals
  */
  if( prevFaction != self.faction ){
    sendevent_handle_faction( prevFaction, self.faction );
  }
  
  /*
    EVENT - player info change 
  */
  if( (changeFlags & SENDFLAG_NEWUNIT) ){
    self.data_type = ReadByte();
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
    if( self.data_type == DATA_MECH ){
      if( prevType != self.data_type ){
        sendevent_player_mech(self.data_idx);
      }
    }
    cvar_set("cl_forwardspeed", ftos(ReadCoord()));
    cvar_set("cl_sidespeed", ftos(ReadCoord()));
    cvar_set("cl_backspeed", ftos(ReadCoord()));
    cvar_set("cl_movespeedkey", ftos(ReadCoord()));
  }
  
  if( (changeFlags & SENDFLAG_COLORS) ){
    self.unitColorCT = ReadByte();
    self.unitColorLT = ReadByte();
    self.unitColorRT = ReadByte();
    self.unitColorLA = ReadByte();
    self.unitColorRA = ReadByte();
    self.unitColorLG = ReadByte();
  }
  
  /*
    EVENT - pieces of player mech is blown off
  */
  newCrits = 0;
  if( (changeFlags & SENDFLAG_CRIT) ){
    self.critBits = ReadShort();
    if( self.critBits != 0 ){
      newCrits = newCrits | self.critBits;
      if( (self.critBits & M_REPAIR) ){
        //handle repair event
        self.critBits =  self.critBits - (self.critBits & M_REPAIR);
        self.criticalHits = self.criticalHits - (self.criticalHits & self.critBits);
      }
      else{
        self.criticalHits = self.criticalHits | self.critBits;
      }
    }
  }
  
  /*
    EVENT - pieces of player mech are low on health and burning
  */
  if( (changeFlags & SENDFLAG_BURN) ){
    self.burnBits = ReadLong();
    if( self.burnBits < prevBurn ){
      self.burnBits = self.burnBits - (self.burnBits & prevBurn);
    }
  }
  
  /*
    EVENT - DEAD
  */ 
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    
    ENT_SERVER_INFO.missionStatus = ReadByte();
    
    if( self.clientLocalId == player_localentnum ){
      CLIENT_player_deadflag = self.deadflag;
    }
    if( (self.deadflag == DEAD_DYING) && (prevDeadFlag != DEAD_DYING) ){
      sendevent_handle_player_death();
      self.canTarget = FALSE;
    }
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    //self.velocity_x = ReadCoord();
    //self.velocity_y = ReadCoord();
    //self.velocity_z = ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_EFLAGS) ){
    self.flags = self.flags | ReadCoord();
  }
  
  if( (changeFlags & SENDFLAG_TARGET) ){
    //player has tried to acquire target
    self.getTarget = fabs(rint(ReadLong()));
    if( self.getTarget != 0 && self.getTarget != -0 ){
      self.enemy = findfloat(world, entnum, self.getTarget);
    }
    else{
      self.enemy = world;
    }
  }
  
  self.ping = stof( getplayerkeyvalue(self.clientLocalNum, "ping") );
  
  self.netname = getplayerkeyvalue(self.clientLocalNum, "name");
  
  controlPlayer = findfloat(world, entnum, self.clientLocalId);
  if( controlPlayer != world ){
    controlPlayer.sequence = servercommandframe;
    if( self.origin != controlPlayer.origin ){
      self.origin = controlPlayer.origin;
    }
  }
  
  if( isNew ){
    if(self.data_type != DATA_MECH){
      self.data_type = DATA_POBS;
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, '-4 -4 -4', '4 4 4');
      setorigin(self, self.origin);
      self.alpha = 0.01;
      self.scale = 0.01;
    }
    self.think = player_think;
    self.nextthink = time + 0.01;
    self.t_remove = remove_client;
    if( controlPlayer != world && controlPlayer.entnum == self.clientLocalId ){
      controlPlayer.clientData = self;
    }
  }
  else{
    if( controlPlayer != world ){
      for (frameItr = controlPlayer.sequence+1; frameItr <= servercommandframe; frameItr = frameItr + 1) {
        if (!getinputstate(frameItr)){
            break;  //erk?... too old?
        }
        input_sequence = frameItr;
        thisSelf = self;
        self = controlPlayer;
          runstandardplayerphysics();
        self = thisSelf;
        self.origin = controlPlayer.origin;
      }
    }
  }
  
  //Shield strike event
  if( self.shieldHitFlag != 0 && time > self.shieldEffectTime){
    if( (self.shieldHitFlag < SHIELD_HIT_EXP) && (self.shield > 0 && self.shield < 100.01) ){
      self.shieldEffectTime = time + 0.5;
      te_shield_hit();
    }
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
  
  //if( (self.attackFlag != 0) && (prevAttackFlag != self.attackFlag) ){
  if( self.attackFlag != 0 ){
    sendevent_handle_weaponfire();
    self.attackFlag = 0;
  }
  
  if( newCrits != 0 ){
    if( (newCrits & M_REPAIR) ){
      sendevent_player_repair( newCrits );
    }
    else{
      sendevent_player_critical( newCrits );
    }
  }
  
  if( prevMoveState != self.moveState ){
    sendevent_handle_moveChange();
  }
  
  self.kills = stof(getplayerkeyvalue(self.clientLocalNum, "frags"));
  
  //perform data binds
  if( self.clientLocalId == player_localentnum ){
    if(isNew){
      CLIENT_flags = 0;
      CLIENT_flags_prev = 0;
    }
    CLIENT_stat_rdr_mode = self.stat_rdr_mode;
    CLIENT_flags_prev = CLIENT_flags;
    CLIENT_flags = self.flags;
    CLIENT_player_deadflag = self.deadflag;
    CLIENT_faction = self.faction;
    CLIENT_data_type = self.data_type;
    CLIENT_data_idx = self.data_idx;
    CLIENT_move_state = self.moveState;
    CLIENT_shield = self.shield;
    if( self.shield > 0 ){
      CLIENT_shield = self.shield;
    }
    else{
      CLIENT_shield = 0;
    }
    
    if( self.energy > 0 ){
      CLIENT_energy = self.energy;
      CLIENT_energy_total = (self.energy / 100) * self.energyMax;
    }
    else{
      CLIENT_energy = 0;
    }
    CLIENT_target_ent = self.enemy;
    sendevent_player_accuracy( (prevOrg != self.origin) );
  }
};

void( float hasMoved ) sendevent_player_accuracy={
  local float rate;
  
  rate = self.spreadDefault_z;
  //accuracy / spread mechanics
  if( hasMoved ) {
    //unit is moving, increase spread factor
    if( !self.stat_rdr_mode ){
      rate = rate + ( rate * 0.5 );
    }
    rate = rate - self.accuracyMod;
    self.accuracy = self.accuracy + rate;
    if( self.accuracy > self.spreadDefault_y ){
      self.accuracy = self.spreadDefault_y;
    }
  }
  else{
    //standing still, lessen the spread
    if( self.stat_rdr_mode ){
      rate = rate + (rate * 0.25);
    }
    rate = rate + self.accuracyMod;
    self.accuracy = self.accuracy - rate;
    if( self.accuracy < self.spreadDefault_x ){
      self.accuracy = self.spreadDefault_x;
    }
  }
  CLIENT_accuracy = self.accuracy;
};

float() remove_client={
  local entity weps;
  local entity next;
  local entity rem;

  if( self.data_type == DATA_MECH ){
    weps = self.w_slot;
    while( weps.data_idx ){
      next = weps.w_slot;
      rem = weps;
      weps = next;
      if( rem ){
        remove(rem);
      }
    }
    if( self.torsoCenter ){
      remove(self.torsoCenter);
    }
    if( self.torsoLeft ){
      remove(self.torsoLeft);
    }
    if( self.torsoRight ){
      remove(self.torsoRight);
    }
    if( self.armLeft ){
      remove(self.armLeft);
    }
    if( self.armRight ){
      remove( self.armRight);
    }
    if( self.legs ){
      remove(self.legs );
    }
  }
  remove(self);
  return TRUE;
};

/*
  Updates a player's Weapon reload value.
  
  This was a conscious reversion to older logic, why?
    1) standing up ANY weapon reload logic on the clientside was a lot of extra work.
    2) given how diverse a weapon's reload logic COULD be, its better just to send 1
      single state value.
    3) only alternative would be to add more data sent for player's SENDFLAG_ATTACK
      Writes, and that isn't really a big gain.
*/
void( entity aWeapon ) player_weapon_reload={
  if( (aWeapon.damageType & DMG_MSC) ){
    return;
  }
  switch( aWeapon.w_group ){
    case WEAPON1:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_1);
      break;
    case WEAPON2:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_2);
      break;
    case WEAPON3:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_3);
      break;
    case WEAPON4:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_4);
      break;
    case WEAPON5:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_5);
      break;
    case WEAPON6:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_6);
      break;
    case WEAPON7:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_7);
      break;
    case WEAPON8:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_8);
      break;
    case WEAPON9:
      aWeapon.reloadValue = getstati(STAT_WEAPON_RELOAD_9);
      break;
  }
};