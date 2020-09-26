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
  if( (self.burnBits & M_TOR_LEFT) ){
    te_mech_crit( self.torsoLeft.origin , '0 0 10');
  }
  if( (self.burnBits & M_TOR_RIGHT) ){
    te_mech_crit( self.torsoRight.origin , '0 0 10');
  }
  if( (self.burnBits & M_ARM_LEFT) ){
    if( !(self.damageValue & M_TOR_LEFT) ){
      te_mech_crit( self.armLeft.origin , '0 0 10');
    }
  }
  if( (self.burnBits & M_ARM_RIGHT) ){
    if( !(self.damageValue & M_TOR_RIGHT) ){
      te_mech_crit( self.armRight.origin , '0 0 10');
    }
  }
  if( (self.burnBits & M_LEGS) ){
    te_mech_crit( self.legs.origin , '0 0 10');
  }
};

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
  
  if( self.entId == player_localentnum && !cvar("chase_active") ){
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
  if( (self.damageValue & piece.partTypeId) ){
    return;
  }
  addentity(piece);
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
  piece.colormod = self.colormod;
};

/*
  I'm not really sure when this runs because CSQC's time variable appears to be super-unreliable.
*/
void() player_think={
  local vector boostLeft, boostRight, backLeft, backRight;
  local string te;
  
  local vector laserHit;
  local vector laserOrg;
  
  makevectors(self.angles);
  if(self.chaseActive){
    laserOrg = self.origin + (v_up * 20) + (v_forward * -96);
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
  
  /*
    Horrible things done to get targeting working again, although I fixed the multi-copy CSQC ent issue...it broke
    this part of the code quite completely.
  */
  if( self.getTarget == TRUE ){
    makevectors(self.angles);
    traceline(laserOrg,laserOrg + (v_forward * CLIENT_radar_range), FALSE, self);
    local entity hunt, targ;
    local float testDist;
    local float entDist;
    if( trace_ent.data_type == DATA_MECH || trace_ent.data_type == DATA_VEHC || trace_ent.data_type == DATA_BLD){
      targ = trace_ent;
    }
    else{
      hunt = findradius(trace_endpos, 64);
      testDist = vlen(trace_endpos - self.origin);
      while( hunt != world ){
        if( hunt.data_type == DATA_MECH || hunt.data_type == DATA_VEHC || hunt.data_type == DATA_BLD){
          entDist = vlen(hunt.origin - trace_endpos);
          if( entDist <= testDist ){
            testDist = entDist;
            targ = hunt;
          }
        }
        hunt = hunt.chain;
      }
    }
    if( self.entId == player_localentnum && targ != world){
      CLIENT_target_ent = targ;
      CLIENT_target_origin = CLIENT_target_ent.origin;
      if( CLIENT_target_ent != world ){
        CLIENT_stat_trg_ddflg_prev = CLIENT_target_ent.deadflag;
      }
    }
    else{
      CLIENT_target_ent = world;
    }
    self.getTarget = FALSE;
  }
  
  self.think = player_think;
  self.nextthink = time + 0.01;
};

float() player_predraw={
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
      self.laser_sight_org2 =   self.laser_sight_org1;
      self.laser_sight_org1 =   self.laser_sight_org;
    }
    self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
    self.lerpfrac = 1-bound(0, self.lerpfrac, 1);
    
    self.laser_sight_org = self.laser_sight_org1 + (self.laser_sight_org2-self.laser_sight_org1)*self.lerpfrac;
  
    if(self.entId == player_localentnum ){
      CLIENT_lerp = self.lerpfrac;
    }
  
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
      wep = self.w_slot;
      while( wep != world ){
        predraw_player_weapon(wep);
        addentity(wep);
        wep = wep.w_slot;
      }
    }
    
    if(cacheOrg){
      self.origin = cacheOrg;
    }
    setorigin(self, self.origin);
    
    if(self.entId == player_localentnum){
      if( self.deadflag == DEAD_NO ){
        local vector hudAng;
        local vector strutOrg;
        local vector consOrg;
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
        }
      }
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
      cons_logAFloat("client.receive_sendent_player.sendevent_player_mech()-Error: failed to build mech with id", mech_id);
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
  self.solid = SOLID_BBOX;
  setsize(self, minSave, maxSave);
  
  //hud shenanigans
  if( self.entId == player_localentnum ){
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
      if( (SV_SERVERFLAGS & SVFLAG_FPSONLY) ){
        HUD_EXTERNAL_CAM_ACTIVE = FALSE;
        cvar_set("chase_active", "0");
      }
      else{
        HUD_EXTERNAL_CAM_ACTIVE = TRUE;
      }
    }
  }
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
  if(self.entId == player_localentnum){
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
  
  if( (criticalBits & M_TOR_LEFT) ){
    te_missile_explode( self.torsoLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_TOR_RIGHT) ){
    te_missile_explode( self.torsoRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_ARM_LEFT) ){
    te_missile_explode( self.armLeft.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_ARM_RIGHT) ){
    te_missile_explode( self.armRight.origin, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_LEGS) ){
    te_missile_explode( self.legs.origin, self.vec_size * 1.25, '0.9 0.75 0.45', 0.01 ) ;
  }
  
  wep = self.w_slot;
  while( wep != world ){
    if( (criticalBits & wep.partParentId) ){
      if(self.entnum == player_localentnum){
        CLIENT_weapon_state = CLIENT_weapon_state - (CLIENT_weapon_state & wep.w_group);
      }
    }
    wep = wep.w_slot;
  }
};

/*
  HANDLE EVENT - player mech pieces are being repair
*/
void(float repairValue) sendevent_player_repair={
  local entity wep;
  
  if( !(repairValue & M_TOR_CENTER) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_CENTER);
  }
  if( !(repairValue & M_TOR_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_LEFT);
  }
  if( !(repairValue & M_TOR_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_RIGHT);
  }
  if( !(repairValue & M_ARM_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_LEFT);
  }
  if( !(repairValue & M_ARM_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_RIGHT);
  }
  
  wep = self.w_slot;
  while( wep != world ){
    if( !(repairValue & wep.partParentId) ){
      if(self.entId == player_localentnum){
        CLIENT_weapon_state = CLIENT_weapon_state | wep.w_group;
      }
    }
    wep = wep.w_slot;
  }
};

void( float isNew, float changeFlags) sendent_handle_player={
  local vector prevOrg;
  local vector targetOrg;
  local float prevShield;
  local float prevCrit;
  local float prevType;
  local float prevTarget; 
  local float prevKills;
  local float prevFaction;
  local float prevDeadFlag;
  local float prevAttackFlag;
  local float prevMoveState;
  local float prevBurn;
  local float prevGetTarg;
  
  prevBurn = self.burnBits;
  prevShield = self.shield;
  prevCrit = self.damageValue;
  prevKills = self.kills;
  prevFaction = self.faction;
  prevDeadFlag = self.deadflag;
  prevAttackFlag = self.attackFlag;
  prevMoveState = self.moveState;
  prevOrg = self.origin;
  prevType = self.data_type;
  prevGetTarg = self.getTarget;
    
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
    self.angles_z = 0;
    
    self.attackFlag = ReadLong();
    self.moveState = ReadByte();
    //Track player move state?
    self.legDir = anglemod(ReadShort());
    self.ai_dir = ReadShort();
    self.chaseActive = ReadByte();
  }
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.entId = ReadLong();
    self.flags = ReadShort();
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
  }
  /*
    EVENT - Player has taken fire
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    local float nextHit;
    nextHit = ReadByte();
    if( self.shieldHitFlag == 0 || nextHit == 3){
      self.shieldHitFlag = nextHit;
    }
  }
  
  /*
    EVENT - player info change 
  */
  if( (changeFlags & SENDFLAG_TURRET) ){
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
    self.colormod_x = ReadCoord();
    self.colormod_y = ReadCoord();
    self.colormod_z = ReadCoord();
    if( self.data_type == DATA_MECH ){
      if( prevType != self.data_type ){
        self.deadflag = DEAD_NO;
        self.damageValue = rint(0);
        sendevent_player_mech(self.data_idx);
        self.shieldEffectTime = 0;
        self.predraw = player_predraw;
        if(self.entId == player_localentnum){
          HUD_FIXED_ANGLE = self.angles;
        }
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
    self.burnBits = ReadShort();
    self.burnBits = self.burnBits | prevBurn;
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
      scoreboard_sort();
    }
  }
  
  self.clientLocalId = max(0,self.entId - 1);
  self.faction = rint(stof(getplayerkeyvalue(self.clientLocalId, "colors")));
  self.ping = stof( getplayerkeyvalue(self.clientLocalId, "ping") );
  self.netname = getplayerkeyvalue(self.clientLocalId, "name");
  
  /*
    EVENT - second data rider used for non-critical stuff
  */
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.getTarget = ReadByte();
    //self.particleCubeFlag = ReadByte();
    self.flags = ReadShort();
    if( self.getTarget == TRUE && prevGetTarg != FALSE ){
      self.getTarget = FALSE; // flag for getting target clientside.
    }
    /*
      Particle Cubes are disable by Beta 2 v1.0.0 - will require a patch to get working again.
    if( self.particleCubeFlag == 0 ){
      //remove cube
    }
    else if( self.particleCubeFlag && isNew ){
      //if( player_localentnum == self.data_idx ){
        //add cube
      //}
    }*/
  }
  
  /*
    HANDLE - Update Faction totals
  */
  if( prevFaction != self.faction ){
    sendevent_handle_faction( prevFaction, self.faction );
  }
  
  //Shield strike event
  if(servertime > self.shieldEffectTime ){
    if( self.shieldHitFlag == 1 && (self.shield > 0 && self.shield < 100.01)){
      te_shield_hit();
    }
  }
  
  //Shield Explode event
  sendevent_shield_explode( prevShield );
  
  if( (self.attackFlag != 0) && (prevAttackFlag != self.attackFlag) ){
    sendevent_handle_weaponfire();
  }
  
  if( prevMoveState != self.moveState ){
    sendevent_handle_moveChange();
  }
  
  self.kills = stof(getplayerkeyvalue(self.clientLocalId, "frags"));
  scoreboard_sort();
  
  //perform data binds
  if( self.entId == player_localentnum ){
    if(isNew){
      CLIENT_flags = 0;
      CLIENT_flags_prev = 0;
    }
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
  }
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