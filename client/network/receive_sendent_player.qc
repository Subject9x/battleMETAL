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
  
  if( vlen(self.origin - client_vis_org) >= PARTICLE_HAZ_DISTANCE / 2){
    return;
  }
  
  if( (self.unitModFlags & MOD_HAS_TOR_L) && (self.burnBits & M_TOR_LEFT) ){
    te_mech_crit( self.torL_org , '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) &&(self.burnBits & M_TOR_RIGHT) ){
    te_mech_crit( self.torR_org , '0 0 10');
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) &&(self.burnBits & M_ARM_LEFT) ){
    if( (self.unitModFlags & MOD_HAS_TOR_L) &&!(self.criticalHits & M_TOR_LEFT) ){
      te_mech_crit( self.armL_org , '0 0 10');
    }
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) &&(self.burnBits & M_ARM_RIGHT) ){
    if( (self.unitModFlags & MOD_HAS_TOR_R) &&!(self.criticalHits & M_TOR_RIGHT) ){
      te_mech_crit( self.armR_org , '0 0 10');
    }
  }
  if( (self.burnBits & M_LEGS) ){
    te_mech_crit( self.legs_org , '0 0 10');
  }
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
  local float wepItr;
  
  makevectors(self.angles);
  if(self.chaseActive){
    laserOrg = self.origin + (v_up * 22); //+ (v_forward * -96);
    traceline(self.origin, laserOrg, TRUE, self);
    laserOrg = trace_endpos;
  }
  else{
    laserOrg = self.origin + (v_up * self.cameraOffset_y);
  }
  laserHit = laserOrg + (v_forward * 10000);
  traceline(laserOrg, laserHit, FALSE, self);
  self.laser_sight_org = trace_endpos;
  
  particleDraw = vlen(client_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2 ){
    if( self.burnBits != 0 ){
      sendevent_player_burn();
    }
    if( self.moveState > MOVE_SPRINT ){
      if( vlen(self.origin2 - self.origin1) > 16 ){
        makevectors(self.legs_angl);
        boostLeft = boostRight = self.legs_org + (v_up * (self.mins_z * 0.75));
        boostLeft = boostLeft + (v_right * self.mins_x * 0.5);
        boostRight = boostRight + (v_right * self.maxs_x * 0.5);
        
        backLeft = backRight = self.legs_org + (v_forward * -16) + (v_up * (self.mins_z * 0.67));
        backLeft = backLeft + (v_right * self.mins_x * 0.5);
        backRight = backRight + (v_right * self.maxs_x * 0.5);
        
        if( self.vec_size == 3 ){
          te = "TE_FIRE_3";
        }
        else{
          te = "TE_FIRE_2";
        }
        
        if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
          trailparticles(world, particleeffectnum(te), boostLeft, backLeft);
          trailparticles(world, particleeffectnum(te), boostRight, backRight);
        }
      }
    }
  }
  
  if( self.clientServerNum == player_localentnum ){
    wepItr = 0;
    while( wepItr < self.hardpoint_cnt ){
      theWeapon = sendent_get_weapon( bitshift(1, wepItr ) );
      
      if( theWeapon.data_idx ){
        player_weapon_reload( theWeapon );
      }
      
      wepItr = wepItr + 1;
    }
    
    if(HUD_HEADLIGHT_ACTIVE){
      traceline(self.origin + (v_forward * 16), self.origin + (v_forward * 512), MOVE_MISSILE, self);
      self.unit_light_org = trace_endpos + (v_up * 32) + (v_forward * -16);
    }
    
  }
  else{
    if(self.headlight){
      //player networked headlighting.
      traceline(self.origin + (v_forward * 16), self.origin + (v_forward * 512), MOVE_MISSILE, self);
      self.unit_light_org = trace_endpos + (v_up * 32) + (v_forward * -16);
    }
  }
  
  self.think = player_think;
  self.nextthink = time + 0.01;
  if( time > self.legs_nextthink ){
    self.legs_nextthink = time + 0.1;
  }
};

void() player_predraw={
  local vector entAng;
  local entity wep;
  local vector cacheOrg;
  local float lerpDiff;
  local float lerp;
  
  //cache
  local vector prevAngl;
  local vector prevOrg;
  local float prevAlph;
  local float prevScale;
  
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
    
    if(self.clientServerNum == player_localentnum ){
      CLIENT_lerp = self.lerpfrac;
    }
  
    self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
    
    if(self.clientServerNum == player_localentnum){
      cacheOrg = self.origin;
      self.origin = pmove_org;
    }
    
    traceline(self.origin, client_vis_org, FALSE, self);
  
    self.cl_lod_unit = TRUE;
    if( (trace_fraction != 1.0 && trace_ent == world) || vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
      self.cl_lod_unit = FALSE;
    }
    
    if(self.cl_lod_unit){
      self.cl_lod_weapon = TRUE;
      if( vlen(client_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE / 2 ){
        self.cl_lod_weapon = FALSE;
      }
      entAng = self.angles;
      entAng_x = 0;
      makevectors( entAng );
      
      prevAngl = self.angles;
      prevOrg = self.origin;
      
      setsize(self, self.cache_mins, self.cache_maxs);
      
      predraw_legs();
      self.origin = prevOrg;
      self.angles = prevAngl;
      
      if( !(self.criticalHits & M_TOR_CENTER) ){
        self.origin = prevOrg;
        self.torC_org = predraw_unit_part_and_angle(self.torC_compOffset, torC_angl); 
        if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
          self.torC_angl_x = self.angles_x * -1;
        }
        setmodel(self, self.torC_mdl);
        self.alpha = 1.0;
        self.scale = 1.0;
        self.angles = self.torC_angl;
        self.origin = self.torC_org;
        addentity(self);
        self.angles = prevAngl;
        self.origin = prevOrg;
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
        self.torL_org = predraw_unit_part_and_angle(self.torL_compOffset, torL_angl); 
        if( !(self.criticalHits & M_TOR_LEFT) ){
          if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_L) ){
             self.torL_angl_x = self.angles_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorLT];
          setmodel(self, self.torL_mdl);
          self.alpha = 1.0;
          self.scale = 1.0;
          self.angles = self.torL_angl;
          self.origin = self.torL_org;
          addentity(self);
          self.angles = prevAngl;
          self.origin = prevOrg;
        }
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
        self.torR_org = predraw_unit_part_and_angle(self.torR_compOffset, torR_angl); 
        if( !(self.criticalHits & M_TOR_RIGHT) ){
          if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
             self.torR_angl_x = self.angles_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorRT];
          setmodel(self, self.torR_mdl);
          self.alpha = 1.0;
          self.scale = 1.0;
          self.angles = self.torR_angl;
          self.origin = self.torR_org;
          addentity(self);
          self.angles = prevAngl;
          self.origin = prevOrg;
        }
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_L) && (self.unitModFlags & MOD_HAS_ARM_L) ){
        self.armL_org = predraw_unit_part_and_angle(self.armL_compOffset, armL_angl); 
        if( !(self.criticalHits & M_ARM_LEFT) ){
          if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
            self.armL_angl_x = self.angles_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorLA];
          setmodel(self, self.armL_mdl);
          self.alpha = 1.0;
          self.scale = 1.0;
          self.angles = self.armL_angl;
          self.origin = self.armL_org;
          addentity(self);
          self.angles = prevAngl;
          self.origin = prevOrg;
        }
      }
      
      if( (self.unitModFlags & MOD_HAS_TOR_R) && (self.unitModFlags & MOD_HAS_ARM_R) ){
        self.armR_org = predraw_unit_part_and_angle(self.armR_compOffset, armR_angl); 
        if( !(self.criticalHits & M_ARM_RIGHT) ){
          if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
            self.armR_angl_x = self.angles_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorRA];
          setmodel(self, self.armR_mdl);
          self.alpha = 1.0;
          self.scale = 1.0;
          self.angles = self.armR_angl;
          self.origin = self.armR_org;
          addentity(self);
          self.angles = prevAngl;
          self.origin = prevOrg;
        }
      }
      if(self.cl_lod_weapon){
        if(self.weaponEnt1.data_idx){
          predraw_unit_weapon(self.weaponEnt1);
        }
        if(self.weaponEnt2.data_idx){
          predraw_unit_weapon(self.weaponEnt2);
        }
        if(self.weaponEnt3.data_idx){
          predraw_unit_weapon(self.weaponEnt3);
        }
        if(self.weaponEnt4.data_idx){
          predraw_unit_weapon(self.weaponEnt4);
        }
        if(self.weaponEnt5.data_idx){
          predraw_unit_weapon(self.weaponEnt5);
        }
        if(self.weaponEnt6.data_idx){
          predraw_unit_weapon(self.weaponEnt6);
        }
        if(self.weaponEnt7.data_idx){
          predraw_unit_weapon(self.weaponEnt7);
        }
        if(self.weaponEnt8.data_idx){
          predraw_unit_weapon(self.weaponEnt8);
        }
        if(self.weaponEnt9.data_idx){
          predraw_unit_weapon(self.weaponEnt9);
        }
      }
      
      if(cacheOrg){
        self.origin = cacheOrg;
      }
      self.origin = self.origin;
      
      if(self.clientServerNum == player_localentnum){
        hud_model_cockpit_draw_frame();
        if( self.deadflag == DEAD_NO ){
          
          //apparently when menu running, these just get STACCCCCCKED and murder framerate.
          if(MENU_PROG_OFF && HUD_HEADLIGHT_ACTIVE){      
            self.unit_light_org1 = self.unit_light_org2;
            self.unit_light_org2 = self.unit_light_org;
            self.unit_light_org = self.unit_light_org1 + (self.unit_light_org2-self.unit_light_org1)*self.lerpfrac;
            particleDraw = vlen(self.origin - pmove_org);
            if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
              adddynamiclight2(self.unit_light_org, 150, '1.0 1.0 1.0', 0, "", PFLAGS_NOSHADOW);
            }
          }
        }
      }
      else{
        if(self.headlight && MENU_PROG_OFF && self.deadflag == DEAD_NO){
          self.unit_light_org1 = self.unit_light_org2;
          self.unit_light_org2 = self.unit_light_org;
          self.unit_light_org = self.unit_light_org1 + (self.unit_light_org2-self.unit_light_org1)*self.lerpfrac;
          particleDraw = vlen(self.origin - pmove_org);
          if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
            adddynamiclight2(self.unit_light_org, 150, '1.0 1.0 1.0', 0, "", PFLAGS_NOSHADOW);
          }
        }
      }
    }
    setsize(self, self.cache_mins, self.cache_maxs);  
  }
};


/*
  poor workaround, OTHER player mechs aren't fully formed mech data, lack of interpolation.
  we just care about part offsets for special effects.
*/
void( float mech_id ) sendevent_player_mech={
  local vector minSave, maxSave;
  local entity item;
  local entity this;
  local float wepItr;
  
  self.deadflag = DEAD_NO;
  self.criticalHits = rint(0);
  
  initialize_data_mech_(mech_id);
  
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
  
  this = self;
  
  wepItr = 0;
  while( wepItr < self.hardpoint_cnt ){
    item = sendent_get_weapon( bitshift(1, wepItr ) );
    
    if( item.data_idx ){
      item.reloadValue = 100;
      item.wepFireOffsetCache = item.wepFireOffset;
    }
    
    wepItr = wepItr + 1;
  }
  
  if( (self.unitModFlags & MOD_MODEL_ROOT_TOR_C) ){
    self.skin = self.faction - 1;
    setmodel(self, self.model);
    self.alpha = 1.0;
    self.scale = 1.0;
  }
  self.solid = SOLID_BBOX;
  setsize(self, self.cache_mins, self.cache_maxs);
  
  //hud shenanigans
  if( self.clientServerNum == player_localentnum){
    //MODELS - COCKPIT
    hud_model_cockpit_ini();
    
    //MODELS - PLAYER ARMOR
    hud_model_armor_player_ini();
  }
  
  self.shieldEffectTime = 0;
  self.predraw = player_predraw;
  self.canTarget = TRUE;

};

/*
  HANDLE EVENT - player killed on this frame.
*/
void() mech_ai_die_stand1;
void() mech_ai_die_stand2;
void() mech_ai_die_stand3;
void() mech_ai_die_stand4;
void() mech_ai_die_stand5;
void() mech_ai_die_stand6;
void() mech_ai_die_stand7;
void() mech_ai_die_stand8;
void() mech_ai_die_stand9;
void() mech_ai_die_stand10;
void() sendevent_handle_player_death={
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  te_missile_explode( self.origin, self.vec_size + 1, '0.9 0.75 0.45', 0.0075 ) ;
  
  self.think = mech_ai_die_stand1;
  self.nextthink = time + 0.01;
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
  if(self.legs_compOffset != '0 0 0'){
    self.legs_nextthink = time + 0.1;
  }
};

/*
  HANDLE EVENT - player mech parts destroyed
*/
void( float criticalBits ) sendevent_player_critical={

  if( (self.unitModFlags & MOD_HAS_TOR_L) && (criticalBits & M_TOR_LEFT) ){
    te_missile_explode( self.torL_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) && (criticalBits & M_TOR_RIGHT) ){
    te_missile_explode( self.torR_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) && (criticalBits & M_ARM_LEFT) ){
    te_missile_explode( self.armL_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) && (criticalBits & M_ARM_RIGHT) ){
    te_missile_explode( self.armR_org, self.vec_size, '0.9 0.75 0.45', 0.01 ) ;
  }
  if( (criticalBits & M_LEGS) ){
    te_missile_explode( self.legs_org, self.vec_size * 1.25, '0.9 0.75 0.45', 0.01 ) ;
  }
  if(self.clientServerNum != player_localentnum){
    return;
  }
};

/*
  HANDLE EVENT - Player Critical notifying everyone
*/
void( float playerEntId, float playerCritFlags ) client_handle_crit={
  local entity playerMech;
  local entity nonSelf;
  
  playerMech = findfloat(world, clientServerNum, playerEntId);
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
  if( (repairValue & M_TOR_CENTER) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_CENTER);
  }
  if(  (self.unitModFlags & MOD_HAS_TOR_L) && (repairValue & M_TOR_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_LEFT);
  }
  if(  (self.unitModFlags & MOD_HAS_TOR_R) && (repairValue & M_TOR_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_TOR_RIGHT);
  }
  if(  (self.unitModFlags & MOD_HAS_ARM_L) && (repairValue & M_ARM_LEFT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_LEFT);
  }
  if(  (self.unitModFlags & MOD_HAS_ARM_R) && (repairValue & M_ARM_RIGHT) ){
    self.burnBits = self.burnBits - (self.burnBits & M_ARM_RIGHT);
  }
  
  if(self.clientServerNum != player_localentnum){
    return;
  }
  //FIX ME - weapons being repaired.
};


//quick ref
void() sendevent_player_target;

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
    self.legDir = ReadShort();
    self.ai_dir = ReadShort();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = 0;
  }
  
  if( (changeFlags & SENDFLAG_RADAR) ){
    self.stat_rdr_mode = fabs(ReadByte());
  }
  if( (changeFlags & SENDFLAG_SHIELD) ){
    self.shield = ReadByte();
  }
  if( (changeFlags & SENDFLAG_ENERGY) ){
    self.energy = ReadByte();
  }
  if( (changeFlags & SENDFLAG_ATTACK) ){
    self.attackFlag = ReadLong();
  }
  if( (changeFlags & SENDFLAG_CAMERA) ){
    self.chaseActive = fabs(ReadByte());
    self.headlight = fabs(ReadByte());
  }
  
  /*
    EVENT - Client Data is new/spawned
  */
  if( (changeFlags & SENDFLAG_NEWENT) ){
    self.entId = self.entnum;
    //clientServerNum = player entity ID on server.
    //clientLocalNum = this is player-entity only, local id for some reason is ServerNum-1?
    self.clientServerNum = fabs(ReadByte());
    self.clientLocalNum = fabs(self.clientServerNum - 1);
    //cons_logAFloat("CS - RECEIVE - player.entnum/clientServerNum", self.clientServerNum); //debug
    //cons_logAFloat("CS - RECEIVE - player.clientData.entnum", self.entnum); //debug
    //cons_logAFloat("CS - LOCAL - player_localentnum", player_localentnum); //debug
  }
  
  /*
    EVENT - Player has taken fire
  */
  if( (changeFlags & SENDFLAG_IMPACT) ){
    self.shieldHitFlag = ReadByte();
  }
  
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = fabs(ReadByte());
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
    self.data_type = fabs(ReadByte());
    self.data_idx = fabs(ReadByte());
    self.next_wepn1 = fabs(ReadByte());
    self.next_wepn2 = fabs(ReadByte());
    self.next_wepn3 = fabs(ReadByte());
    self.next_wepn4 = fabs(ReadByte());
    self.next_wepn5 = fabs(ReadByte());
    self.next_wepn6 = fabs(ReadByte());
    self.next_wepn7 = fabs(ReadByte());
    self.next_wepn8 = fabs(ReadByte());
    self.next_wepn9 = fabs(ReadByte());
    if( self.data_type == DATA_MECH ){
      if( prevType != self.data_type ){
        if( self.clientServerNum == player_localentnum ){
          self.classname = "UI_ITEM";
        }
        sendevent_player_mech(self.data_idx);
      }
    }
    cvar_set("cl_forwardspeed", ftos(ReadLong()));
    cvar_set("cl_sidespeed", ftos(ReadLong()));
    cvar_set("cl_backspeed", ftos(ReadLong()));
    cvar_set("cl_movespeedkey", ftos(ReadLong()));
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
    self.critBits = ReadLong();
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
      self.critBits = 0;
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
    self.deadflag = fabs(ReadByte());
    
    ENT_SERVER_INFO.missionStatus = ReadByte();
    
    if( self.clientServerNum == player_localentnum ){
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
    self.flags = rint(ceil(ReadLong()));
  }
  
  if( (changeFlags & SENDFLAG_TARGET) ){
    //player has tried to acquire target
    self.getTarget = ReadLong();
    if( self.getTarget != 0 ){
      self.enemy = findfloat(world, entnum, self.getTarget);
    }
    else{
      self.enemy = world;
    }
  }
  
  if( (changeFlags & SENDFLAG_EXDATA) ){
    self.nextVecChoice = rint(ReadByte());
  }
  
  self.ping = stof( getplayerkeyvalue(self.clientLocalNum, "ping") );
  
  self.netname = getplayerkeyvalue(self.clientLocalNum, "name");
  
  controlPlayer = findfloat(world, entnum, self.clientServerNum);
  if( controlPlayer != world ){
    controlPlayer.sequence = servercommandframe;
    if( self.origin != controlPlayer.origin ){
      self.origin = controlPlayer.origin;
    }
  }
  
  if( isNew ){
    if(self.data_type != DATA_MECH){
      self.data_type = DATA_POBS;
      setmodel(self, "models/testball.md3");
      setsize(self, '-4 -4 -4', '4 4 4');
      setorigin(self, self.origin);
      self.alpha = 0.01;
      self.scale = 0.01;
    }
    self.think = player_think;
    self.nextthink = servertime + 0.01;
    self.t_remove = remove_client;
    if( controlPlayer != world && controlPlayer.entnum == self.clientServerNum ){
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
  if( self.clientServerNum == player_localentnum ){
    if(isNew){
      CLIENT_flags = 0;
      CLIENT_flags_prev = 0;
    }
    CLIENT_stat_rdr_mode = self.stat_rdr_mode;
    
    CLIENT_flags_prev = rint(CLIENT_flags);
    CLIENT_flags = rint(self.flags);
   
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
    
    if( (changeFlags & SENDFLAG_TARGET) ){
      if( self.enemy != world ){
        CLIENT_target_ent = self.enemy;
        sendevent_player_target();
      }
    }
    
    CLIENT_mech_self = self;
    sendevent_player_accuracy( (prevOrg != self.origin) );
  }
};

/*
  Player target - clean up model;
*/


/*
  Player acquired a new target, findthe type and config the 3D Model
*/
void() sendevent_player_target={
  local entity oSelf;
  local entity cleanUp;
  local entity nextEnt;
  
  oSelf = self;
  self = HUD_MODEL_ARMOR_GRAPH_TARGET;
    self.data_idx = CLIENT_target_ent.data_idx;
    self.data_type = CLIENT_target_ent.data_type;
    self.flags = self.flags - (self.flags & FL_MONSTER) - (self.flags & FL_UNIT); //ensures that player radar and regular addentity() calls don't pick this up.
    self.unitModFlags = 0 | CLIENT_target_ent.unitModFlags;
    self.mins = CLIENT_target_ent.mins;
    self.maxs = CLIENT_target_ent.maxs;
    self.skin = 0;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.takedamage = DAMAGE_NO;
    self.drawmask = 0;
    self.effects = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
    self.interpolate_entity = SUB_Null;
  self = oSelf;
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