/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
mod: 9/11/2018 - rebuilt
Overview: client utility methods, pulled from client.qc
*/

/*

*/
void() client_push_player_info={
  
  self.ammo_rockets = self.flags;
  self.ammo_cells = self.i_faction;
  self.armorvalue = self.stat_plr_stt;
  
  if( (self.flags & FL_CLIENT) ){
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_CLIENT_INFO );

    WriteByte( MSG_ONE, num_for_edict(self) );
    
    WriteCoord( MSG_ONE, self.origin_x );
    WriteCoord( MSG_ONE, self.origin_y );
    WriteCoord( MSG_ONE, self.origin_z );
    
    WriteLong( MSG_ONE, self.stat_rdr_rng );
    WriteByte( MSG_ONE, self.data_type ); 
  
    if(self.data_type == DATA_MECH){
      WriteByte( MSG_ONE, (self.en_cur / self.en_max) * 100 );
      WriteByte( MSG_ONE, (self.sh_cur / self.sh_max) * 100 );
      WriteByte( MSG_ONE, csqc_updateCompStat(self));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.e_legs));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.e_tor_l));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.e_tor_r));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.e_arm_l));
      WriteByte( MSG_ONE, csqc_updateCompStat(self.e_arm_r));
      
      WriteByte( MSG_ONE, self.hardpoint_cnt );
      local entity wep;
      wep = self.w_slot;
      while( wep ){
        WriteByte( MSG_ONE, wep.rl_cur );
        wep = wep.w_slot;
      }
      
      local float enm;
      enm = num_for_edict(self.enemy);
      WriteByte( MSG_ONE, enm );
      if( enm != num_for_edict( world ) ){
        WriteCoord( MSG_ONE, self.enemy.origin_x );
        WriteCoord( MSG_ONE, self.enemy.origin_y );
        WriteCoord( MSG_ONE, self.enemy.origin_z );
        WriteByte( MSG_ONE, (self.enemy.sh_cur / self.enemy.sh_max) * 100 );
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy));
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.e_legs));
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.e_tor_l));
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.e_tor_r));
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.e_arm_l));
        WriteByte( MSG_ONE, csqc_updateCompStat(self.enemy.e_arm_r));
        WriteShort( MSG_ONE, self.enemy.maxs_y * 1.5 );
        if( self.enemy.netname == "" ){
          self.enemy.netname = self.enemy.vec_name;
        }
        WriteString( MSG_ONE, self.enemy.netname );
      }
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
  WriteByte( MSG_ONE, radarPing.i_faction );
  
};

void( entity targetClient ) client_push_hud_highlight={
  local entity this;
  this = self;
  self = targetClient;
    msg_entity = self;
    WriteByte( MSG_ONE, SVC_TEMPENTITY );
    WriteByte( MSG_ONE, TE_UI_BOX );
    WriteCoord( MSG_ONE, this.fx_origin_x );
    WriteCoord( MSG_ONE, this.fx_origin_y );
    WriteCoord( MSG_ONE, this.fx_origin_z );
    
    WriteCoord( MSG_ONE, this.c_alt_ofs_x );
    WriteCoord( MSG_ONE, this.c_alt_ofs_y );
    WriteCoord( MSG_ONE, this.c_alt_ofs_z );
    
    WriteCoord( MSG_ONE, this.c_ofs_x );
    WriteCoord( MSG_ONE, this.c_ofs_y );
    WriteCoord( MSG_ONE, this.c_ofs_z );

    WriteShort( MSG_ONE, this.wait );
  
  self = this;
}; 

float(entity ent, float changed) send_vehicle={
  WriteByte( MSG_ENTITY, DATA_VEHC);
  WriteByte( MSG_ENTITY, changed);
  if( (changed & SEND_FLAG_DATA_IDX) ){
    WriteByte( MSG_ENTITY, self.owner.data_idx );
    WriteByte( MSG_ENTITY, self.owner.vec_size );
  }
  if( (changed & SEND_FLAG_SHIELD_VAL) ){
    WriteByte( MSG_ENTITY, self.owner.sh_cur);
  }
  if( (changed & SEND_FLAG_RADAR_MODE) ){
    WriteByte( MSG_ENTITY, self.owner.stat_rdr_mode);
  }
  if( (changed & SEND_FLAG_FACTION) ){
    WriteByte( MSG_ENTITY, self.owner.i_faction );
  }
  if( (changed & SEND_FLAG_ORIGIN) ){
    WriteCoord( MSG_ENTITY, self.owner.origin_x );
    WriteCoord( MSG_ENTITY, self.owner.origin_y );
    WriteCoord( MSG_ENTITY, self.owner.origin_z );
  }
  return TRUE;
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
  }
  else if(argv(1) == "setmech"){
    self.vec_size = stof(argv(2));
    self.nextVecChoice = stof(argv(3));
  }
  else if(argv(1) == "spawn"){
    if(self.data_type == DATA_POBS){
      player_unmakeObserver();
      player_makeMech();
      spawnpoint_select();
      client_playTrack(world.sounds, TRUE);
    }
  }
  else if(argv(1) == "setgroup"){
    client_setWeaponGroup(str, tokens);
  }
  else if(argv(1) == "setnav"){
    client_setNavPoint(str, tokens);
  }
  else if(argv(1) == "setfaction"){
    self.i_faction = stof( argv(2) );
    mapfile_pvp_load(self.i_faction);
  }
  else if( argv(1) == "setmode" ){
    cvar_set("gamemode", argv(2) );
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

void(string mechs) client_sendAvailableLightMechs={
  local string cmd;
  cmd = strcat("mech list_light [", mechs,"]\n");
  stuffcmd(self, cmd);
};

void(string mechs) client_sendAvailableMediumMechs={
  local string cmd;
  cmd = strcat("mech list_med [", mechs,"]\n");
  stuffcmd(self, cmd);
};

void(string mechs) client_sendAvailableHeavyMechs={
  local string cmd;
  cmd = strcat("mech list_hvy [", mechs,"]\n");
  stuffcmd(self, cmd);
};

void(string itms) client_sendAvailableItems={
  local string cmd;
  cmd = strcat("mech list_items [", itms,"]\n");
  stuffcmd(self, cmd);
};

void(float mode) client_sendGameMode={
  local string cmd;
  cmd = strcat("mech gamemode ", ftos(mode),"\n");
  stuffcmd(self, cmd);
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
  local string cmd;
  cmd = strcat("mech msn_file ", world.msn_file, "\n");
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
      if(nav.i_faction == self.i_faction){
        if(nav.data_idx == nav_id){
          self.goalentity = nav;
        }
      }
    }
    nav = nav.chain;
  }
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
    if(locus.i_faction == self.i_faction){
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

entity() spawnpoint_single={
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
	self.fixangle = TRUE;	
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
	self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
};

void() client_updateWeaponReloads={
  local entity e;
  local float idx;
  idx = 1;
  e = self.w_slot;
  while(e){
    local float delta, wid;
    delta = e.rl_cur;
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