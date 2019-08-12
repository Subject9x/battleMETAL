/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
mod: 9/11/2018 - rebuilt
Overview: client utility methods, pulled from client.qc
*/

/*
  primary info function set to CSQC. 
  This pushes client data to the owner, every PostPlayerThink() call.
*/
void() client_push_player_info={
  local entity wep;
  local float enm;
  local float targShield;
  local float weaponStateBit;
  
  self.ammo_rockets = self.flags;
  self.ammo_cells = self.faction;
  self.armorvalue = self.stat_plr_stt;

  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_CLIENT_INFO );

  WriteByte( MSG_ONE, self.deadflag );

  WriteCoord( MSG_ONE, self.origin_x );
  WriteCoord( MSG_ONE, self.origin_y );
  WriteCoord( MSG_ONE, self.origin_z );
  
  WriteLong( MSG_ONE, self.stat_rdr_rng );

  WriteByte( MSG_ONE, self.data_type ); //sync integrity
  if(self.data_type == DATA_MECH){
    WriteShort( MSG_ONE, (self.energy / self.energyMax) * 100 );
    WriteShort( MSG_ONE, (self.shield / self.shieldMax) * 100 );
    WriteByte( MSG_ONE, csqc_updateCompStat(self));
    WriteByte( MSG_ONE, csqc_updateCompStat(self.legs));
    WriteByte( MSG_ONE, csqc_updateCompStat(self.torsoLeft));
    WriteByte( MSG_ONE, csqc_updateCompStat(self.torsoRight));
    WriteByte( MSG_ONE, csqc_updateCompStat(self.armLeft));
    WriteByte( MSG_ONE, csqc_updateCompStat(self.armRight));
    
    WriteByte( MSG_ONE, self.hardpoint_cnt );
    wep = self;
    weaponStateBit = 0;
    while( wep ){
      wep = wep.w_slot;
      if( wep.deadflag == DEAD_NO ){
        weaponStateBit = weaponStateBit | wep.w_group;
      }
      WriteByte( MSG_ONE, wep.reloadValue );
    }

    WriteLong( MSG_ONE, weaponStateBit );

    enm = num_for_edict(self.enemy);
    WriteByte( MSG_ONE, enm );
    if( self.enemy != world ){
      WriteCoord( MSG_ONE, self.enemy.origin_x );
      WriteCoord( MSG_ONE, self.enemy.origin_y );
      WriteCoord( MSG_ONE, self.enemy.origin_z );
      //this is silly but precludes forcing the csqc to know the target's max shields
      targShield = self.enemy.shield;
      if( targShield <= 0 ){
        targShield = 0;
      }
      else{
        targShield = (self.enemy.shield / self.enemy.shieldMax) * 100;
      } 
      WriteByte( MSG_ONE, targShield );
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.legs));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.torsoLeft));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.torsoRight));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.armLeft));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.armRight));
      WriteShort( MSG_ONE, self.enemy.maxs_y * 2 );
      if( self.enemy.netname == "" ){
        self.enemy.netname = self.enemy.vec_name;
      }
      WriteString( MSG_ONE, self.enemy.netname );
    }
  }
};

void( entity targetClient ) server_push_player_info={
  local entity this;
  this = self;
  self = targetClient;
    client_push_player_info();
  self = this;
};

void( entity radarPing ) client_push_radar_ping={

  msg_entity = self;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_CLIENT_PING );
  
  WriteCoord( MSG_ONE, radarPing.origin_x );
  WriteCoord( MSG_ONE, radarPing.origin_y );
  WriteCoord( MSG_ONE, radarPing.origin_z );
  
  WriteLong( MSG_ONE, vlen(self.origin - radarPing.origin) );
  WriteByte( MSG_ONE, radarPing.data_type );
  WriteByte( MSG_ONE, radarPing.faction );
};

void( entity targetClient ) client_push_hud_highlight={
  local entity this;
  this = self;
  self = targetClient;
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_UI_BOX );
    WriteCoord( MSG_ONE, this.movedir_x );
    WriteCoord( MSG_ONE, this.movedir_y );
    WriteCoord( MSG_ONE, this.movedir_z );
    
    WriteCoord( MSG_ONE, this.c_ofs_x );
    WriteCoord( MSG_ONE, this.c_ofs_y );
    WriteCoord( MSG_ONE, this.c_ofs_z );
    
    WriteCoord( MSG_ONE, this.color_x );
    WriteCoord( MSG_ONE, this.color_y );
    WriteCoord( MSG_ONE, this.color_z );

    WriteShort( MSG_ONE, this.data_lifetime );
  
  self = this;
}; 

void( entity navpoint ) client_send_navpoint={
  local float nactive;
  
  msg_entity = self;
  
  nactive = navpoint.isActive;
  if( navpoint.faction != self.faction ){
    nactive = FALSE;
  }
  
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_EVT_NAV );
  
  WriteByte( MSG_ONE, navpoint.data_idx);
  WriteByte( MSG_ONE, nactive);
  
  WriteCoord( MSG_ONE, navpoint.origin_x);
  WriteCoord( MSG_ONE, navpoint.origin_y);
  WriteCoord( MSG_ONE, navpoint.origin_z);
};

void( entity objective ) client_send_objective={
  msg_entity = self;
  local float nactive;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE,  TE_EVT_OBJ);
  
  WriteByte( MSG_ONE, objective.data_idx); 
  
  
  if( objective.faction != self.faction ){
    nactive = FALSE;
  }
  else{
    nactive = objective.isActive;
  }
  WriteByte( MSG_ONE, nactive); 
  WriteByte( MSG_ONE, objective.state_1);
};

void( entity deploy ) client_send_deploypoint={
  msg_entity = self;
  local float nactive;
  
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_EVT_DEP );
  
  WriteByte( MSG_ONE, deploy.data_idx);
  
  nactive = deploy.isActive;
  if( deploy.faction != self.faction ){
    nactive = FALSE;
  }
  WriteByte( MSG_ONE, nactive);
  
  WriteCoord( MSG_ONE, deploy.origin_x);
  WriteCoord( MSG_ONE, deploy.origin_y);
  WriteCoord( MSG_ONE, deploy.origin_z);
};

void( entity targetClient ) client_send_boundary_warning={
  local entity this;
  
  this = self;
  self = targetClient;
  msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY);
    WriteByte( MSG_ONE, TE_MSN_BOUND);
    WriteByte( MSG_ONE, this.isActive );
    WriteAngle( MSG_ONE, this.ai_dir );
  self = this;
};

void( entity targetClient ) client_send_enviro_warning={
  local entity this;
  
  this = self;
  self = targetClient;
  msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY);
    WriteByte( MSG_ONE, TE_MSG_ENV_WARN);
    WriteByte( MSG_ONE, 1 );
    WriteByte( MSG_ONE, this.damageType );
  self = this;
};

/*
  used by ClientConnect when client signs on.
  pushes map object info to client.
*/
void() client_push_mapobjects={
  local entity obj;
  obj = findchainflags( flags, FL_NODE );
  while( obj ){
    switch( obj.data_type ){
      case DATA_DEPL:
          client_send_deploypoint( obj );
        break;
      case DATA_NAVP:
          client_send_navpoint( obj );
        break;
      case DATA_OBJT:
          client_send_objective( obj );
        break;
    }
    obj = obj.chain;
  }
};

void( entity client ) client_send_critical_hit={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY);
  WriteByte( MSG_ONE, TE_CRITICAL_HIT );
  WriteByte( MSG_ONE, self.partTypeId);
};

/*
  Sends an AI voice sample to play for a specific client
  limiter = total copies of 'voiceMessage' that can sit in the voice queue.
*/
void( entity client, float voiceGroup, float voiceId, float limiter) client_send_ai_voice={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY);
  WriteByte( MSG_ONE, TE_AI_VOICE );
  WriteByte( MSG_ONE, voiceGroup);
  WriteByte( MSG_ONE, voiceId);
  WriteByte( MSG_ONE, limiter );
  WriteLong( MSG_ONE, num_for_edict(self) );
};

/*
  Sends an AI voice sample to play to ALL Clients
  limiter = total copies of 'voiceMessage' that can sit in the voice queue.
*/
void( float voiceGroup, float voiceId, float limiter) client_send_ai_voice_all={
  WriteByte( MSG_ALL, SVC_TEMPENTITY);
  WriteByte( MSG_ALL, TE_AI_VOICE );
  WriteByte( MSG_ALL, voiceGroup);
  WriteByte( MSG_ALL, voiceId);
  WriteByte( MSG_ALL, limiter );
  WriteLong( MSG_ALL, num_for_edict(self) );
};

void( entity client ) client_send_hud_target_kill={
  local entity notClient;
  notClient = self;
  self = client;
    te_targ_kill();
  self = notClient;
};

void(entity client ) client_send_event_powerup={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_POWERUP );
};

void(entity client, float weaponsOnOff) client_send_event_weapons={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_WEAPONS_ON );
  WriteByte( MSG_ONE, weaponsOnOff );
};

void(entity client, float weaponsOnOff) client_send_event_repairs={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_REPAIRS_ON );
  WriteByte( MSG_ONE, weaponsOnOff );
};

void(entity client, string theMessage, float messageLifetime) client_send_info_message={
  msg_entity = client;
  WriteByte( MSG_ONE, SVC_TEMPENTITY );
  WriteByte( MSG_ONE, TE_MSG_INFO );
  WriteString( MSG_ONE, theMessage );
  WriteLong( MSG_ONE, messageLifetime );
};

/*
  client sends string 'cmd mech foo'
  where foo is the command, first parm must be 'mech'
  
  so - 'cmd mech foo'
*/
void(string str, float tokens) client_ParseMechCommand={
  
  if(argv(1) == "setwep"){
    if(self.deadflag >= DEAD_NO){
      client_setWeapon(str, tokens);
    }
    return;
  }
  
  if(argv(1) == "setmech"){
    self.vec_size = stof(argv(2));
    self.nextVecChoice = stof(argv(3));
    return;
  }
  
  if(argv(1) == "spawn"){
    if(self.data_type == DATA_POBS){
      player_unmakeObserver();
      spawnpoint_select();
      player_makeMech();
      
      client_playTrack( world.sounds, TRUE );
      client_sendMissionName();
    }
    return;
  }
  
  if(argv(1) == "setgroup"){
    client_setWeaponGroup(str, tokens);
    return;
  }
  
  //
  if(argv(1) == "setnav"){
    client_setNavPoint(str, tokens);
    return;
  }
  
  //changes player's .faction var
  if(argv(1) == "setfaction"){
    self.faction = stof( argv(2) );
    mapfile_pvp_load(self.faction);
    return;
  }
  
  if(argv(1) == "nextmission"){
    client_setMission(str, tokens);
    return;
  }
  
  if( argv(1) == "setmode" ){
    cvar_set("gamemode", argv(2) );
    return;
  }
  
  //player wants to skip an animatic
  if( argv(1) == "exitanim" ){
    if( self.stat_plr_stt == PLAYER_ANIM_STOP) {
      self.count2 = 0;
      self.velocity = '0 0 0';
      self.avelocity = '0 0 0';
    }
    return;
  }
  
  if( argv(1) == "rtexport" ){
    world_export_realtimelights( stof(argv(2)) );
    return;
  }
};  

void(string cmd, float tokens) client_setMission={
  self.stat_plr_stt = PLAYER_ACTIVE;
  self.view_ofs = '0 0 1';
  if( argv(2) == "1" ){ 
    //mission successful, next map
    if( cvar("gamemode") == GAMEMODE_CAMPAIGN){
      savefile_changemap(nextmap);
      savefile_append();
      savefile_save();
    }
    changelevel (nextmap);  //possibly altered by map_objective objects.
  }
  else{
    //mission failed
    changelevel (mapname);
  }
};
/*
  
*/
void(string cmd, float tokens) client_setWeaponGroup={
  local float groupnum, groupval;
  groupnum = stof(argv(2));
  groupval = stof(argv(3));
  
  switch(groupnum){
    case 1:
      self.w_group1 = groupval;
      break;
    case 2:
      self.w_group2 = groupval;
      break;
    case 3:
      self.w_group3 = groupval;
      break;
    case 4:
      self.w_group4 = groupval;
      break;
    case 5:
      self.w_group5 = groupval;
      break;
  }
};

void(string mechs) client_sendAvailable_Mechs={
  local string cmd;
  cmd = strcat("mech list_mechs [", mechs, "]\n");
  stuffcmd(self, cmd);
};

void(string itms) client_sendAvailableItems={
  local string cmd;
  cmd = strcat("mech list_items [", itms,"]\n");
  stuffcmd(self, cmd);
};

void() client_sendMissionUnlocks={
  local string cmd;
  cmd = strcat("mech unlock mechs [", world.unlockMechs,"] items [", world.unlockEquip, "]", "\n");
  stuffcmd(self, cmd);
};

void(float mode) client_sendGameMode={
  local string cmd;
  cmd = strcat("mech gamemode ", ftos(mode),"\n");
  stuffcmd(self, cmd);
};

/*
  client Mapping = client_event_mission_name();
*/
void() client_sendMissionName={
  if( world.message ){
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY);
    WriteByte( MSG_ONE, TE_MISSION_NAME );
    WriteString( MSG_ONE, strcat(world.message,"\n"));
  }
};

/*
commmand string: cmd mech setwep X Y
  X = WEAPON bitflag id
  Y = weapon data_idx id
*/
void(string cmd, float tokens) client_setWeapon={
  local float wslotid, new_id;
  local entity oself;
  oself = self;
  wslotid = stof(argv(2));
  new_id = stof(argv(3));
  
  switch(wslotid){
    case WEAPON1:
      self.next_wepn1 = new_id;
      break;
    case WEAPON2:
      self.next_wepn2 = new_id;
      break;
    case WEAPON3:
      self.next_wepn3 = new_id;
      break;
    case WEAPON4:
      self.next_wepn4 = new_id;
      break;
    case WEAPON5:
      self.next_wepn5 = new_id;
      break;
    case WEAPON6:
      self.next_wepn6 = new_id;
      break;
    case WEAPON7:
      self.next_wepn7 = new_id;
      break;
    case WEAPON8:
      self.next_wepn8 = new_id;
      break;
    case WEAPON9:
      self.next_wepn9 = new_id;
      break;
  }
};

void(float track, float loop) client_playTrack={
  local string cmd;
  cmd = "cd ";
  if( loop ){
    cmd = strcat(cmd, "loop ");
  }
  else{
    cmd = strcat(cmd, "play ");
  }
  cmd = strcat(cmd, ftos(track), "\n");
  stuffcmd(self, cmd);
};

void() client_sendMissionFileName={
  local string cmd, msnFile;
  
  msnFile = mapname;
  if( world.missionFile ){
    msnFile = world.missionFile;
  }
  
  cmd = strcat("mech missionFile ", msnFile, "\n");
  stuffcmd(self, cmd);
};

void(string fileName) client_sendAnimaticFileName={
  local string cmd;
  cmd = strcat("mech anm_file ", fileName, "\n");
  stuffcmd(self, cmd);
};

void(string cmd, float tokens) client_setNavPoint={
  local float nav_id;
  local entity nav;
  nav_id = stof(argv(2));
  nav = findchainfloat(data_type, DATA_DEPL);
  while(nav){
    if(nav.isActive){
      if(nav.faction == self.faction){
        if(nav.data_idx == nav_id){
          self.goalentity = nav;
        }
      }
    }
    nav = nav.chain;
  }
};

/*
  scope agnostic means of sending 'fog' settings and cmd to the client
*/
void(entity client, float fogDense, vector fogColor, float fogAlpha, vector fogDist, float fogFade) client_sendFog={
  local string fogCmd;
  
  fogCmd = "fog ";
  fogCmd = strcat( fogCmd, ftos(fogDense), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_x), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_y), " " );
  fogCmd = strcat( fogCmd, ftos(fogColor_z), " " );
  fogCmd = strcat( fogCmd, ftos(fogAlpha), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_x), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_y), " " );
  fogCmd = strcat( fogCmd, ftos(fogDist_z), " " );
  fogCmd = strcat( fogCmd, ftos(fogFade), "\n" );
  stuffcmd( client, fogCmd );
};

/*
  scope agnostic means of sending CD track changes to the client
*/
void(entity client, float trackNum, float entFlags) client_sendMusic={

  otemp = self;
  self = client;
    client_playTrack( trackNum, (entFlags & 2) );
  self = otemp;
};

/*
  client Mapping = client_event_debrief_active();
*/
void(entity client, float missionSuccessCheck) client_sendEndMission={
  local entity notSelf;
  
  notSelf = self;
  self = client;
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_MISSION_END );
    WriteLong( MSG_ONE, time );
    WriteLong( MSG_ONE, self.frags );
    WriteByte( MSG_ONE, missionSuccessCheck );
    WriteShort( MSG_ONE, MISSION_TOTAL_PSC );
    WriteShort( MSG_ONE, MISSION_TOTAL_SURVEST );
    WriteShort( MSG_ONE, MISSION_TOTAL_MILITAR );
    switch( self.faction ){
      case FACTION_PSC:
        WriteShort( MSG_ONE, MISSION_LOSSES_MILITAR );
        break;
      case FACTION_SURVEST:
        WriteShort( MSG_ONE, MISSION_LOSSES_MILITAR );
        break;
      case FACTION_MILITAR:
        WriteShort( MSG_ONE, MISSION_LOSSES_MILITAR );
        break;
      default:
        WriteShort( MSG_ONE, 0 );
        break;
    }
  self = notSelf;
};

void(entity client ) client_send_mapKeyObjects={
  local entity objects;
  
  objects = findchainflags( spawnflags, 4194304);
  while( objects ){
    msg_entity = client;  
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_MAPKEY_DATA );
    WriteByte( MSG_ONE, objects.data_type );
    WriteLong( MSG_ONE, objects.origin_x );
    WriteLong( MSG_ONE, objects.origin_y );
    WriteByte( MSG_ONE, objects.faction);
    objects = objects.chain;
  }
};


void(float fwd, float side, float bck, string accel, string roll) client_update_moveSpeed={
  local string comd;
  
  comd = strcat("cl_forwardspeed ", ftos(fwd), " \n ");
  comd = strcat( comd, strcat("cl_sidespeed ", ftos(side), " \n ") );
  comd = strcat( comd, strcat("cl_backspeed ", ftos(bck), " \n ") );
  comd = strcat( comd, strcat("cl_movespeedkey ", accel, " \n ") );
  comd = strcat( comd, strcat("cl_rollangle ", roll, " \n") );
  
  stuffcmd(self, comd);
};

void(string bob, string cycle, string up) client_update_viewBob={
  local string comd;
  
  comd = strcat("cl_bob ", bob, " \n ");
  comd = strcat(comd, "cl_bobcycle ", cycle, " \n ");
  comd = strcat(comd, "cl_bobup ", up, " \n");
  
  stuffcmd(self, comd );
};
void(string bobmodel, string side, string bmod_speed) client_update_modelBob={
  local string comd;
  
  comd = strcat("cl_bobmodel ", bobmodel,  " \n ");
  comd = strcat(comd, "cl_bobmodel_side ", side,  " \n ");
  comd = strcat(comd, "cl_bobmodel_speed ", bmod_speed,  " \n");
  
  stuffcmd(self, comd );
};

void(float p_min, float p_max) client_update_viewPitch={
  local string comd;
  
  comd = strcat("in_pitch_max ", ftos(p_max), " \n ");
  comd = strcat(comd, "in_pitch_min ", ftos(p_min), " \n");
  
  stuffcmd(self, comd);
};


void() respawn={ 
  if (coop){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);
    //
		// get the spawn parms as they were at level start
		//setspawnparms (self);
    if(self.data_type == DATA_MECH){
      player_unmakeMech();
      player_makeObserver();
    }
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);

		// set default spawn parms
		SetNewParms ();
    if(self.data_type == DATA_MECH){
      player_unmakeMech();
      player_makeObserver();
    }
		// respawn		
		PutClientInServer ();
	}
	else{	
  // restart the entire server
		localcmd ("restart\n");
	}
};

entity() spawnpoint_coop={
  local entity locus;
  locus = findchainfloat(data_type, DATA_INFO_COOP);
  while(locus){
    if(locus.faction == self.faction){
      if(locus.target == self.goalentity.targetname){
        if(locus.data_idx == self.client_num){
          self.goalentity = locus;
        }
      }
    }
    locus = locus.chain;
  }
  return self.goalentity;
};

entity() SelectSpawnPoint={
  local	entity spot;
	local	entity thing;
	local	float  pcount;
	
// testinfo_player_start is only found in regioned levels

  spot = find (world, classname, "testinfo_player_start");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point
  if (deathmatch)
	{
    if(self.data_type != DATA_POBS){
      spot = lastspawn;
      while (1)
      {
        spot = find(spot, classname, "info_player_deathmatch");
        if (spot != world)
        {
          if (spot == lastspawn)
            return lastspawn;
          pcount = 0;
          thing = findradius(spot.origin, 32);
          while(thing)
          {
            if (thing.classname == "player")
              pcount = pcount + 1;
            thing = thing.chain;
          }
          if (pcount == 0)
          {
            lastspawn = spot;
            return spot;
          }
        }
      }
    }
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
  
  spot = find (world, classname, "info_player_start");
  
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");

	return spot;
};

void() spawnpoint_select={
  local entity spot;

  if(self.goalentity){
    if( coop ){
      spot = spawnpoint_coop();
    }
    else{
      spot = self.goalentity;
    }
  }
  else{
    spot = SelectSpawnPoint();
  }
  
  self.origin = self.oldorigin = spot.origin + '0 0 12';
  
  self.angles = spot.angles;
  
  //haha, cache angles for powerup sequence.
  self.wind_x = 0;
  self.wind_y = self.angles_y;
  self.wind_z = self.angles_z;
  
	self.fixangle = TRUE;
  self.trigOnSpawn = spot.trigOnSpawn;
  self.trigOnDeath = spot.trigOnDeath;
  self.trigOnAttack = spot.trigOnAttack;
  self.trigOnDamage = spot.trigOnDamage;
  self.trigOnPanic = spot.trigOnPanic;
  self.trigOnTarget = spot.trigOnTarget;
};

void() spawnpoint_Random={
  local entity spot;
  
  if(self.goalentity){
    spot = self.goalentity;
  }
  else{
    spot = SelectSpawnPoint();
  }
  
  self.origin = self.oldorigin = spot.origin + '0 0 12';
  
  self.angles = spot.angles;
	self.fixangle = TRUE;	
};

void() legacy_PlayerDie={
	//self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	//self.invisible_finished = 0;
	//self.invincible_finished = 0;
	//self.super_damage_finished = 0;
	//self.radsuit_finished = 0;
};

void() client_updateWeaponReloads={
  local entity e;
  local float idx;
  idx = 1;
  e = self.w_slot;
  while(e){
    local float delta, wid;
    delta = e.reloadValue;
    wid = e.data_idx;
    switch(idx){
      case 1: 
        self.stat_w1_id = wid;
        break;
      case 2:
        self.stat_w2_id = wid;
        break;
      case 3:
        self.stat_w3_id = wid;
        break;
      case 4:
        self.stat_w4_id = wid;
        break;
      case 5:
        self.stat_w5_id = wid;
        break;
      case 6:
        self.stat_w6_id = wid;
        break;
      case 7:
        self.stat_w7_id = wid;
        break;
      case 8:
        self.stat_w8_id = wid;
        break;
      case 9:
        self.stat_w9_id = wid;
        break;
    }
    idx = idx + 1;
    e = e.w_slot;
  }
};

float(entity piece) csqc_updateCompStat={
  local float perc;

  if(piece){
    if(piece.health){
      perc = (piece.health / piece.max_health)*100;
      return perc;
    }
  }
  return 0;
};
