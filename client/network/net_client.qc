/*
battleMETAL
Author: Peter Roohr
Date: 1/10/2023
Overview: 
  one of the last cliffs to climb...resolving player SendEnt to be ON the client entity, no more
  junky work around....
  
*/
void(entity theWep) client_weapon_reload;

//events 
float SHLD_VFX_TIME;

void(float unitId) client_event_mech_spawn;
void() client_event_target_new;
void() client_event_handle_moveChange;
void() client_event_handle_faction;

float() remove_client={
  if( self.unit_legs && !wasfreed(self.unit_legs) ){
    remove(self.unit_legs);
  }
  remove(self);
  return TRUE;
};

float VFX_RAM_TIME;
float SFX_SHLD_TIME;

void() client_entity_think={
  local vector laserHit;
  local vector laserOrg;
  local entity theWeapon;
  local float wepItr;
  local vector v1, v2;
  
  self.think = client_entity_think;
  self.nextthink = time + 0.001;
  self.legs_nextthink = time + 0.001;

  if( self.data_type == DATA_POBS){
    return;
  }

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
  
  if( self.isLocalPlayer ){
    wepItr = 0;
    while( wepItr < self.hardpoint_cnt ){
      theWeapon = sendent_get_weapon( bitshift(1, wepItr ) );
      
      if( theWeapon.data_idx ){
        client_weapon_reload( theWeapon );

      }
      
      wepItr = wepItr + 1;
    }
    
    if(HUD_HEADLIGHT_ACTIVE){
      traceline(self.rootOrigin + (v_forward * 16), self.rootOrigin + (v_forward * 512), MOVE_MISSILE, self);
      self.unit_light_org = trace_endpos + (v_up * 32) + (v_forward * -16);
    }
  }
  else{
    if(self.headlight){
      //player networked headlighting.
      traceline(self.rootOrigin + (v_forward * 16), self.rootOrigin + (v_forward * 512), MOVE_MISSILE, self);
      self.unit_light_org = trace_endpos + (v_up * 32) + (v_forward * -16);
    }
  }

  if( !self.isLocalPlayer || self.chaseActive){
    if(time > SHLD_VFX_TIME && self.shieldHitFlag == 0){
      if(self.shield < 100.01 && self.shield > 0.0){
        v1 = self.rootOrigin + randomvec2() * self.cache_maxs_x;
       
        pointparticles(particleeffectnum("TE_SHIELD_ON"), v1 , '0 0 0', 1);
      }
      else if(self.shield > 100.0){
        v1 = randompos(self.rootOrigin + self.cache_mins, self.rootOrigin + self.cache_maxs); 
        v2 = randompos(self.rootOrigin + self.cache_mins, self.rootOrigin + self.cache_maxs); 
        
        trailparticles( self, particleeffectnum("TE_SHIELD_DOWN"), v1, v2) ;
      }
      SHLD_VFX_TIME = time + 0.1;
    }
  }
};


void() client_predraw={
  local entity wep;
  local float newLerp;
  
  local float flSuccess;
  local float frameItr;
  
  //prediction
  local vector vOldOrigin;
  local vector vOldVelocity;
  local float fOldPMoveFlags;
  
  local vector boostLeft, boostRight, backLeft, backRight, vfxVel;
  /*
    Credit:
      thanks, Marco “eukara” Hladik for tutorial!
  */
  if( self.isLocalPlayer ){
    // Prepare rollback
    vOldOrigin = self.origin;
    vOldVelocity = self.velocity;
    fOldPMoveFlags = self.pmove_flags;
    if(!MENU_PROG_OFF){
      for ( frameItr = servercommandframe + 1; frameItr < clientcommandframe; frameItr++ ) {
        flSuccess = getinputstate( frameItr );
  
        if ( flSuccess == FALSE ) {
            continue;
        }
  
        // Partial frames are the worst
        if ( input_timelength == 0 ) {
            break;
        }
        //runstandardplayerphysics( self );
        CS_PlayerPhysics();
      }
      vPlayerOrigin = [ self.origin_x, self.origin_y, vPlayerOriginOld_z ];
      vPlayerVelocity = self.velocity;
  
      // Time to roll back
      self.origin = vOldOrigin;
      setorigin( self, self.origin );
      self.velocity = vOldVelocity;
      self.pmove_flags = fOldPMoveFlags;
      self.angles = input_angles;
    }

    // Set renderflag for mirrors!
    //self.renderflags = RF_EXTERNALMODEL;
  }
  
  if(self.nextthink != self.frame1time ){
    self.frame2time = self.frame1time;
    self.frame1time = self.nextthink;
    
    self.origin2 = self.origin1;
    self.origin1 = self.origin;
    
    self.angles2 = self.angles1;
    self.angles1 = self.angles;

    self.viewAngle2 = self.viewAngle1;
    self.viewAngle1 = self.viewAngle;
    
    self.velocity2 = self.velocity1;
    self.velocity1 = self.velocity;
    
    self.laser_sight_org2 = self.laser_sight_org1;
    self.laser_sight_org1 = self.laser_sight_org;
    
    self.unit_light_org1 = self.unit_light_org2;
    self.unit_light_org2 = self.unit_light_org;
    
    if( self.isLocalPlayer ){
      if( self.data_type == DATA_MECH ){
        CLIENT_mech_torC_org2 = CLIENT_mech_torC_org1;
        CLIENT_mech_torC_org1 = self.torC_org;
        
        CLIENT_mech_torL_org2 = CLIENT_mech_torL_org1;
        CLIENT_mech_torL_org1 = self.torL_org;
        
        CLIENT_mech_torR_org2 = CLIENT_mech_torR_org1;
        CLIENT_mech_torR_org1 = self.torR_org;
        
        CLIENT_mech_armL_org2 = CLIENT_mech_armL_org1;
        CLIENT_mech_armL_org1 = self.armL_org;
        
        CLIENT_mech_armR_org2 = CLIENT_mech_armR_org1;
        CLIENT_mech_armR_org1 = self.armR_org;
      }
    }
  }

  newLerp = (time - self.frame2time) / (self.frame2time - self.frame1time);
  newLerp = bound(0, newLerp, 1);
  self.lerpfrac = newLerp;
  
  self.origin = self.origin + (self.origin2 - self.origin1) * self.lerpfrac;
  self.angles = self.angles + (self.angles2 - self.angles1) * self.lerpfrac;
  
  self.rootOrigin = self.origin;
  self.rootAngle = self.angles;
  
  if( self.isLocalPlayer ){
    CLIENT_lerp = self.lerpfrac;
  }

  if( self.data_type == DATA_POBS){
    self.alpha = 0.01;
    self.scale = 0.01;
    return;
  }

  if( self.data_type == DATA_MECH ){
    self.alpha = 1.0;
    self.scale = 1.0;
    if( self.deadflag == DEAD_NO ){
      self.effects = self.effects - (self.effects & (EF_FULLBRIGHT | EF_NOSHADOW) );  //just in case they creeped in?
      
      self.laser_sight_org = self.laser_sight_org1 + (self.laser_sight_org2 - self.laser_sight_org1 ) * self.lerpfrac;
      
      self.cl_lod_unit = TRUE;
      traceline(self.origin, CLIENT_vis_org, FALSE, self);
      if( (trace_fraction != 1.0 && trace_ent == world) || vlen(CLIENT_vis_org - self.origin) > PARTICLE_HAZ_DISTANCE){
        self.cl_lod_unit = FALSE;
      }
      
      if(self.cl_lod_unit){
        self.cl_lod_weapon = TRUE;
        if( vlen(self.origin - CLIENT_vis_org ) > PARTICLE_HAZ_DISTANCE / 2 ){
          self.cl_lod_weapon = FALSE;
        }
      }
        
      makevectors( [0, self.angles_y, self.angles_z] );
      
      setsize(self, self.cache_mins, self.cache_maxs);
      self.renderflags = 0;
      predraw_legs();
      self.origin = self.rootOrigin;
      self.angles = self.rootAngle;
      
      self.torC_angl = self.rootAngle;
      self.torC_org = predraw_unit_part_and_angle(self.torC_compOffset, torC_angl) + (CLIENT_mech_torC_org2 - CLIENT_mech_torC_org1) * self.lerpfrac;
      self.torC_angl = [0, self.rootAngle_y, 0];
      if((self.unitModFlags & MOD_MODEL_PITCH_TOR_C)){
        self.torC_angl_x = self.rootAngle_x * -1;
      }
      setmodel(self, self.torC_mdl);
      self.angles = self.torC_angl;
      self.origin = self.torC_org;
      self.colormod = CLR_PLAYER_LIST[self.unitColorCT] * (self.torC_hp / 100) * 2;
      if(self.cl_lod_unit){
        addentity(self);
      }
      
      if( !(self.criticalHits & M_TOR_LEFT) ){
        if( (self.unitModFlags & MOD_HAS_TOR_L) && !(self.unitModFlags & MOD_MODEL_NO_TOR_L) ){
          self.torL_org = predraw_unit_part_and_angle(self.torL_compOffset, torL_angl) + (CLIENT_mech_torL_org2 - CLIENT_mech_torL_org1) * self.lerpfrac; 
          self.torL_org = predraw_unit_part_and_angle(self.torL_compOffset, torL_angl); 
          self.torL_angl = [0, self.rootAngle_y, 0];
          if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_L) ){
              self.torL_angl_x = self.rootAngle_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorLT] * (self.armL_hp / 100) * 2;
          setmodel(self, self.torL_mdl);
          self.angles = self.torL_angl;
          self.origin = self.torL_org;
          if(self.cl_lod_unit){
            addentity(self);
          }
        }
      }
      
      if( !(self.criticalHits & M_TOR_RIGHT) ){
        if( (self.unitModFlags & MOD_HAS_TOR_R) && !(self.unitModFlags & MOD_MODEL_NO_TOR_R) ){
          self.torR_org = predraw_unit_part_and_angle(self.torR_compOffset, torR_angl) + (CLIENT_mech_torR_org2 - CLIENT_mech_torR_org1) * self.lerpfrac; 
          self.torR_angl = [0, self.rootAngle_y, 0];
          if( (self.unitModFlags & MOD_MODEL_PITCH_TOR_R) ){
              self.torR_angl_x = self.rootAngle_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorRT] * (self.torR_hp / 100) * 2;
          setmodel(self, self.torR_mdl);
          self.angles = self.torR_angl;
          self.origin = self.torR_org;
          if(self.cl_lod_unit){
            addentity(self);
          }
        }
      }
      
      if( !(self.criticalHits & M_ARM_LEFT) ){
        if( (self.unitModFlags & MOD_HAS_TOR_L) && (self.unitModFlags & MOD_HAS_ARM_L) ){
          self.armL_org = predraw_unit_part_and_angle(self.armL_compOffset, armL_angl) + (CLIENT_mech_armL_org2 - CLIENT_mech_armL_org1) * self.lerpfrac; 
          self.armL_angl = [0, self.rootAngle_y, 0];
          if((self.unitModFlags & MOD_MODEL_PITCH_ARM_L)){
            self.armL_angl_x = self.rootAngle_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorLA] * (self.armL_hp / 100)  * 2;
          setmodel(self, self.armL_mdl);
          self.angles = self.armL_angl;
          self.origin = self.armL_org;
          if(self.cl_lod_unit){
            addentity(self);
          }
        }
      }
        
      if( !(self.criticalHits & M_ARM_RIGHT) ){
        if( (self.unitModFlags & MOD_HAS_TOR_R) && (self.unitModFlags & MOD_HAS_ARM_R) ){
          self.armR_org = predraw_unit_part_and_angle(self.armR_compOffset, armR_angl) + (CLIENT_mech_armR_org2 - CLIENT_mech_armR_org1) * self.lerpfrac;
          self.armR_angl = [0, self.rootAngle_y, 0];
          if((self.unitModFlags & MOD_MODEL_PITCH_ARM_R)){
            self.armR_angl_x = self.rootAngle_x * -1;
          }
          self.colormod = CLR_PLAYER_LIST[self.unitColorRA] * (self.armR_hp / self.armR_hpMax)  * 2;
          setmodel(self, self.armR_mdl);
          self.angles = self.armR_angl;
          self.origin = self.armR_org;
          if(self.cl_lod_unit){
            addentity(self);
          }
        }
      }
      if(self.cl_lod_weapon){
        //client_event_burn();  //placing this here because weapon-LoD is a fairly tight radius.
        render_mech_effect_burning();
      }

      if(self.weaponEnt1.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt1, self.cl_lod_weapon);
      }
      if(self.weaponEnt2.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt2, self.cl_lod_weapon);
      }
      if(self.weaponEnt3.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt3, self.cl_lod_weapon);
      }
      if(self.weaponEnt4.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt4, self.cl_lod_weapon);
      }
      if(self.weaponEnt5.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt5, self.cl_lod_weapon);
      }
      if(self.weaponEnt6.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt6, self.cl_lod_weapon);
      }
      if(self.weaponEnt7.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt7, self.cl_lod_weapon);
      }
      if(self.weaponEnt8.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt8, self.cl_lod_weapon);
      }
      if(self.weaponEnt9.data_idx > 0){
        predraw_unit_weapon(self.weaponEnt9, self.cl_lod_weapon);
      }
      if( self.isLocalPlayer ){
        //apparently when menu running, these just get STACCCCCCKED and murder framerate.
        if(MENU_PROG_OFF && HUD_HEADLIGHT_ACTIVE){
          self.unit_light_org = self.unit_light_org1 + (self.unit_light_org2-self.unit_light_org1)*self.lerpfrac;
          particleDraw = vlen(self.rootOrigin - CLIENT_vis_org);
          if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
            adddynamiclight2(self.unit_light_org, 150, '1.0 1.0 1.0', 0, "", PFLAGS_NOSHADOW);
          }
        }
      }
      else{
        if(self.headlight && MENU_PROG_OFF){
          self.unit_light_org = self.unit_light_org1 + (self.unit_light_org2-self.unit_light_org1)*self.lerpfrac;
          particleDraw = vlen(self.rootOrigin - CLIENT_vis_org);
          if( particleDraw <= PARTICLE_HAZ_DISTANCE ){ 
            adddynamiclight2(self.unit_light_org, 150, '1.0 1.0 1.0', 0, "", PFLAGS_NOSHADOW);
          }
        }
      }
      //RAMSHOCKS EFFECT
      particleDraw = vlen(CLIENT_vis_org - self.origin);
      if( particleDraw <= PARTICLE_HAZ_DISTANCE / 2 ){
        if( self.moveState > MOVE_SPRINT ){
          makevectors(self.legs_angl);
          
          boostLeft = self.legs_org + (v_up * (self.cache_mins_z * 0.75)); 
          boostRight = self.legs_org + (v_up * (self.cache_mins_z * 0.75));
          
          boostLeft = self.legs_org + (v_right * self.cache_mins_x * 0.5);
          boostRight = self.legs_org + (v_right * self.cache_maxs_x * 0.5);
          
          traceline(boostLeft, boostLeft + (v_up * (self.cache_mins_z * 0.75)), TRUE, self);
          boostLeft = trace_endpos;

          traceline(boostRight, boostRight + (v_up * (self.cache_mins_z * 0.75)), TRUE, self);
          boostRight = trace_endpos;

          backLeft = boostLeft - (v_forward * 16);
          backRight = boostRight - (v_forward * 16);
          
          pointparticles(particleeffectnum("TE_RAM_MOVE"), boostLeft, normalize(backLeft - boostLeft) * 4, random()*2);
          pointparticles(particleeffectnum("TE_RAM_MOVE"), boostRight, normalize(backRight - boostRight) * 4, random()*2);
          
          vfxVel = self.legs_org + (v_forward * 64);
          vfxVel = normalize(vfxVel - (self.legs_org + (v_forward * -64)) );

          pointparticles(particleeffectnum("TE_RAM_RING"), self.rootOrigin + (v_up * self.cache_maxs_z/2) + (v_forward * self.cache_maxs_x), vfxVel , 1);

          traceline(self.legs_org, self.legs_org + (v_up * self.cache_mins_z * 2), TRUE, self);
          adddynamiclight2(trace_endpos + (v_up * 15), self.vec_size * 200, '0.50 2.0 1.25', 4, "", PFLAGS_NOSHADOW);
        }
      }
    }
    //cockpit draw needs to be distinct because its always on, even in-death.
    if( self.isLocalPlayer ){
      hud_model_cockpit_draw_frame();
    }
    self.origin = self.torC_org;
    self.angles = self.angles;
    setmodel(self, "models/testball.md3");
    self.mins = self.cache_mins;
    self.maxs = self.cache_maxs;
    self.origin = self.rootOrigin;
    self.angles = self.rootAngle;
  }
};

void( float isNew, float changeFlags ) sendent_handle_client={
  local float eventSpawnUnit;
  
  local float lastFlags;
  
  eventSpawnUnit = FALSE;
  
  //state frame delta
  lastFlags = self.flags;
  self.prevShield = self.shield;
  self.prevkills = self.kills;
  self.prevFaction = self.faction;
  self.prevDeadFlag = self.deadflag;
  self.prevAttackFlag = self.attackFlag;
  self.prevMoveState = self.moveState;
  self.prevDataType = self.data_type;
  self.critBits = 0;
  
  //Receive from server
  self.data_type = ReadByte();  //Always received, important switch value.

  self.clientServerNum = self.entnum;
  self.clientLocalNum = self.entnum - 1;
  self.isLocalPlayer = FALSE;
  if( self.entnum == player_localentnum ){
    self.isLocalPlayer = TRUE;
  }
  
  /*EVENT - Client is new to receiver */
  if( (changeFlags & SENDFLAG_UPDATE_FULL) ){
    self.data_idx = ReadByte();
    self.deadflag = ReadByte();

    if( self.deadflag == DEAD_NO ){
      if( self.data_type != DATA_POBS ){
        self.next_wepn1 = ReadByte();
        self.next_wepn2 = ReadByte();
        self.next_wepn3 = ReadByte();
        self.next_wepn4 = ReadByte();
        self.next_wepn5 = ReadByte();
        self.next_wepn6 = ReadByte();
        self.next_wepn7 = ReadByte();
        self.next_wepn8 = ReadByte();
        self.next_wepn9 = ReadByte();
        
        client_event_mech_spawn( self.data_idx );

        handle_existing_crits(isNew, ReadLong());
        handle_existing_hp(isNew, ReadByte(), ReadByte(),ReadByte(),ReadByte(),ReadByte(),ReadByte());
      }
    }
  }

  if(isNew){
    self.flags = self.flags | FL_CLIENT;
    if( self.isLocalPlayer ){
      CLIENT_server_ent = self;
    }
    if( self.data_type == DATA_POBS ){
      self.moveFlags = self.moveFlags - (self.moveFlags | PMF_ONGROUND);
      self.movetype = MOVETYPE_FLY;
      self.solid = SOLID_SLIDEBOX;
      self.flags = self.flags | FL_FLY;
      self.data_type = DATA_POBS;
      setmodel(self, "models/testball.md3");
      setsize(self, '-4 -4 -4', '4 4 4');
      setorigin(self, self.origin);
      self.alpha = 0.01;
      self.scale = 0.01;
      self.deadflag = DEAD_NO;
      if( self.isLocalPlayer ){
        cvar_set( "cl_forwardspeed", ftos(400) );
        cvar_set( "cl_sidespeed", ftos(400) );
        cvar_set( "cl_backspeed", ftos(400) );
        cvar_set( "cl_movespeedkey", ftos(2) );
      }
    }
    self.think = client_entity_think;
    self.nextthink = time + 0.001;
    self.frame1time = time;
    self.frame2time = time;
    self.predraw = client_predraw;
    self.drawmask = MASK_ENGINE;
    self.t_remove = remove_client;
  }


  /* EVENT - Send client.flags total value*/
  if( (changeFlags & SENDFLAG_EFLAGS) ){
    self.flags = ReadLong();
    if(lastFlags != self.flags){
      if( (lastFlags & FL_ONGROUND) && !(self.flags & FL_ONGROUND) ){
        self.moveFlags = self.moveFlags - (self.moveFlags | PMF_ONGROUND);
      }
      else if( !(lastFlags & FL_ONGROUND) && (self.flags & FL_ONGROUND) ){
        self.moveFlags = self.moveFlags | PMF_ONGROUND;
      }
    }
  }
  
  /* EVENT - Client .faction has changed. */
  if( (changeFlags & SENDFLAG_FACTION) ){
    self.faction = ReadByte();
  }
  
  /* EVENT - Client .deadflag changed value.*/
  if( (changeFlags & SENDFLAG_DEAD) ){
    self.deadflag = ReadByte();
    //mission status?
  }
  
  /*EVENT - per-frame updates*/
  if( (changeFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
    
    self.moveState = ReadByte();
    self.legDir = ReadAngle();
    self.ai_dir = ReadFloat();
  }
  
  if( (changeFlags & SENDFLAG_VELOCITY) ){
    self.velocity_x = ReadFloat();
    self.velocity_y = ReadFloat();
    self.velocity_z = ReadFloat();
  }
  
  if( (changeFlags & SENDFLAG_TURRET) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
  }
  
  /* EVENT - Client sends extra data "EXDATA"*/
  if( (changeFlags & SENDFLAG_EXDATA) ){
    self.nextVecChoice = ReadByte();
  }
  
  /* EVENT - Client has spawned into a vehicle */
  if( (changeFlags & SENDFLAG_NEWUNIT) ){
    self.data_speed_forward = ReadFloat();
    self.data_speed_strafe = ReadFloat();
    self.data_speed_backward = ReadFloat();
    self.data_speed_sprint = ReadFloat();
      //genuine spawn event.
      if( self.isLocalPlayer ){
        self.classname = "UI_ITEM"; //hack, investigate
        cvar_set( "cl_forwardspeed", ftos(self.data_speed_forward) );
        cvar_set( "cl_sidespeed", ftos(self.data_speed_strafe) );
        cvar_set( "cl_backspeed", ftos(self.data_speed_backward) );
        cvar_set( "cl_movespeedkey", ftos(self.data_speed_sprint) );

        //MODELS - COCKPIT
        hud_model_cockpit_ini();
        
        //MODELS - PLAYER ARMOR
        hud_model_armor_player_ini();
      }
  }
  
  /* EVENT - Client has changed their unit color settings.*/
  if( (changeFlags & SENDFLAG_COLORS) ){
    self.unitColorCT = ReadByte();
    self.unitColorLT = ReadByte();
    self.unitColorRT = ReadByte();
    self.unitColorLA = ReadByte();
    self.unitColorRA = ReadByte();
    self.unitColorLG = ReadByte();
  }
  
  //update [PlayerKey] values.
  self.ping = stof( getplayerkeyvalue(self.clientLocalNum, "ping") );
  self.netname = getplayerkeyvalue(self.clientLocalNum, "name");
  self.kills = stof(getplayerkeyvalue(self.clientLocalNum, "frags"));
  //===========================================================================================
  
  if( self.prevFaction != self.faction ){
    client_event_handle_faction();
  }

  //WARN! - this is why we send .data_type on EVERY packet!
  if( self.data_type != DATA_POBS ){
    /* EVENT - Client switch Camera mode or headlights. */
    if( (changeFlags & SENDFLAG_CAMERA) ){
      self.chaseActive = ReadByte();
      self.headlight = ReadByte();
    }
    
    /* EVENT - Client toggled radar. */
    if( (changeFlags & SENDFLAG_RADAR) ){
      self.stat_rdr_mode = ReadByte();
    }
    
    /* EVENT - Client .shields has changed value */
    if( (changeFlags & SENDFLAG_SHIELD) ){
      self.shield = ReadByte();
    }
    
    /* EVENT - Client .energy changed value */
    if( (changeFlags & SENDFLAG_ENERGY) ){
      self.energy = ReadByte();
    }
    
    /* EVENT - Client has made an attack, input reached server.*/
    if( (changeFlags & SENDFLAG_ATTACK) ){
      self.attackFlag = fabs(rint(ReadLong()));
    }
    
    /* EVENT - Client has taken ranged hits. */
    if( (changeFlags & SENDFLAG_IMPACT) ){
      self.shieldHitFlag = ReadByte();
      self.torC_hp = ReadByte();
      self.torL_hp = ReadByte();
      self.torR_hp = ReadByte();
      self.armL_hp = ReadByte();
      self.armR_hp = ReadByte();
      self.legs_hp = ReadByte();
    }
    
    /* EVENT - pieces of player mech is blown off */
    if( (changeFlags & SENDFLAG_CRIT) ){
      self.critBits = ReadLong();
    }
    
    /* EVENT - Client has acquired a new target. */
    if( (changeFlags & SENDFLAG_TARGET) ){
      self.targetEntId = ReadLong();
    }
  
    if( (self.deadflag == DEAD_DYING) && (self.prevDeadFlag != DEAD_DYING) ){
      //sendevent_handle_player_death();
      //TODO
      self.canTarget = FALSE;
    }
  
    if( self.prevMoveState != self.moveState ){
      client_event_handle_moveChange();
    }
    
    //HANDLE EVENT - Shield explode
    if( self.shield > 100 && (self.prevShield <= 100 && self.prevShield != 0) ){
      if( time > self.shieldExplodeCool ){
        te_shield_explode( self.origin, self.vec_size);
        self.shieldExplodeCool = time + self.vec_size;
      }
    }
    else{
      //HANDLE EVENT - Shield hit
      if( self.shieldHitFlag != 0 && time > self.shieldEffectTime){
        if( (self.shieldHitFlag < SHIELD_HIT_EXP) && (self.shield > 0 && self.shield < 100.01) ){
          self.shieldEffectTime = time + 0.5;
          te_shield_hit();
        }
      }
    }
    
    //non-observer events.
    if( self.attackFlag != 0 ){
      sendevent_handle_weaponfire();
      self.attackFlag = 0;
    }
    
    if( self.critBits != 0 ){
      if( (self.critBits & M_REPAIR) ){
        self.critBits = self.critBits - (self.critBits & M_REPAIR);
        self.criticalHits = self.criticalHits - (self.criticalHits & self.critBits);
      }
      else{
        sendevent_mech_crit(self.critBits);
        self.criticalHits = self.criticalHits | self.critBits;
      }
      self.critBits = 0;
    }
  }
  
  //CLIENT -> Local Player Ent
  if( self.isLocalPlayer ){
    if(isNew){
      CLIENT_flags = 0;
      CLIENT_flags_prev = 0;
    }
    CLIENT_flags_prev = rint(CLIENT_flags);
    CLIENT_flags = rint(self.flags);
   
    CLIENT_player_deadflag = self.deadflag;
    CLIENT_faction = self.faction;
    CLIENT_data_type = self.data_type;  
    CLIENT_data_idx = self.data_idx;

    if( self.data_type == DATA_MECH && self.deadflag == DEAD_NO ){
      CLIENT_stat_rdr_mode = self.stat_rdr_mode;
      CLIENT_move_state = self.moveState;
      CLIENT_shield = self.shield;
      if( self.shield > 0 ){
        CLIENT_shield = self.shield;
      }
      else{
        CLIENT_shield = 0;
      }
      if( self.shieldHitFlag > SHIELD_HIT_EMP){
        if( servertime > SFX_SHLD_TIME){
          SFX_SHLD_TIME = servertime + soundlength("sound/fx_shld_down.ogg") + 3;
          pointsound(CLIENT_vis_org, SND_HUD_SHLD_DN, 0.5, ATTN_NONE);
          PointSound_Dynamic(CLIENT_vis_org, SND_HUD_SHLD_DN_SFX, 1.0, ATTN_NONE, SOUNDFLAG_DYNAMIC_INT);
        }
      }
      else if( self.prevShield == 101) {
        if(servertime > SFX_SHLD_TIME){
          SFX_SHLD_TIME = servertime + soundlength("sound/fx_shld_up.ogg");
          PointSound_Dynamic(CLIENT_vis_org, SND_HUD_SHLD_UP_SFX, 1.0, ATTN_NONE, SOUNDFLAG_DYNAMIC_INT);
        }
      }
      
      if( self.energy > 0 ){
        CLIENT_energy = self.energy;
        CLIENT_energy_total = (self.energy / 100) * self.energyMax;
      }
      else{
        CLIENT_energy = 0;
      }
      
      if( (changeFlags & SENDFLAG_TARGET) ){
        client_event_target_new();
      }
    }
  }
  self.shieldHitFlag = 0;
};


/*
  EVENT - Client has initiated spawning into a new mech.
*/
void( float unit_id ) client_event_mech_spawn={
  local vector minSave, maxSave;
  local entity item;
  local entity this;
  local float wepItr;
  
  
  self.movetype = MOVETYPE_WALK;
  self.solid = SOLID_SLIDEBOX;
  self.flags = self.flags - (self.flags & FL_FLY);
  self.flags = self.flags | FL_TURRET;
  
  self.criticalHits = -1;
  self.criticalHits = 0;
  
  initialize_data_mech_(unit_id);
  
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
  
  setsize(self, self.cache_mins, self.cache_maxs);
  
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
  setsize(self, self.cache_mins, self.cache_maxs);
  setorigin(self, self.origin);
  
  //hud shenanigans
  // if( self.isLocalPlayer ){
    // //MODELS - COCKPIT
    // hud_model_cockpit_ini();
    
    // //MODELS - PLAYER ARMOR
    // hud_model_armor_player_ini();
  // }
  
  self.shieldEffectTime = 0;
  self.predraw = client_predraw;
  self.canTarget = TRUE;

  if( self.unit_legs == world){
    self.unit_legs = spawn();
  }

  self.unit_legs.skin = self.skin;
  
  self.fixangle = TRUE;

  self.torC_hp = 100.0;
  self.torL_hp = 100.0;
  self.torR_hp = 100.0;
  self.armL_hp = 100.0;
  self.armR_hp = 100.0;
  self.legs_hp = 100.0;
};

/*
  Client started moving / or stopped moving, update legs.
*/
void() client_event_handle_moveChange={
  if(self.legs_compOffset != '0 0 0'){
    self.legs_nextthink = time + 0.1;
  }
};

/*
  Player acquired a new target, findthe type and config the 3D Model
*/
void() client_event_target_new={
  local entity oSelf;
  
  local float notarg;

  notarg = FALSE;

  //check against world
  if( self.targetEntId == num_for_edict(world)){
    notarg = TRUE;
  }

  //check against self-player
  if( self.targetEntId == player_localentnum){
    notarg = TRUE;
  }

  if(notarg){
    CLIENT_target_ent = world;
    self.enemy = world;
    return;
  }
  
  pointsound(CLIENT_vis_org, SND_HUD_TRG_NEW, 1, ATTN_NONE);

  self.enemy = findfloat(world, clientServerNum, self.targetEntId);
  CLIENT_target_ent = self.enemy;
  CLIENT_stat_trg_ent_id = self.targetEntId;
  
  oSelf = self;
  self = HUD_MODEL_ARMOR_GRAPH_TARGET;
    self.data_idx = CLIENT_target_ent.data_idx;
    self.data_type = CLIENT_target_ent.data_type;
    self.flags = CLIENT_target_ent.flags - (CLIENT_target_ent.flags & FL_MONSTER) - (CLIENT_target_ent.flags & FL_UNIT); //ensures that player radar and regular addentity() calls don't pick this up.
    self.unitModFlags = 0 | CLIENT_target_ent.unitModFlags;
    self.cache_mins = CLIENT_target_ent.cache_mins;
    self.cache_maxs = CLIENT_target_ent.cache_maxs;
    self.skin = 0;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.takedamage = DAMAGE_NO;
    self.drawmask = 0;
    self.effects = 0 | EF_FULLBRIGHT | EF_NOSHADOW;
    self.interpolate_entity = SUB_Null;
  self = oSelf;
};


/*
  HANDLE EVENT - player has changed factions during a team game.
*/
void() client_event_handle_faction={
  if( self.prevFaction == FACTION_SURVEST ){
    TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL - 1;
  }
  else if( self.prevFaction == FACTION_MILITAR ){
    TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL - 1;
  }
  if( self.faction == FACTION_SURVEST ){
    TEAM_SURVEST_TOTAL = TEAM_SURVEST_TOTAL + 1;
  }
  else if( self.faction == FACTION_MILITAR ){
    TEAM_MILITAR_TOTAL = TEAM_MILITAR_TOTAL + 1;
  }
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
void( entity aWeapon ) client_weapon_reload={
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