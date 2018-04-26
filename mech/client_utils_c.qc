/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: client utility methods, pulled from client.qc
*/


void(entity client) client_data_ini={
  local entity clientdata, this;
  clientdata = spawn();
  this = self;
  self = clientdata;
    self.classname = "client";
    self.flags = self.flags | FL_CLIENTDATA;
    self.owner = client;
    this.node = self;
    self.stat_eid = num_for_edict(client);
    setmodel(self, "q3mdl/testball.md3");
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_NOT;
    setsize(self, '-0.05 -0.05 -0.05', '0.05 0.05 0.05');
    setorigin(self, self.owner.origin);
    self.SendEntity = client_data_sendEnt;
    self.SendFlags = self.SendFlags | 1;
    self.think = client_data_think;
    self.nextthink = time + 0.01;
  self = this; 
};

void() client_data_think={
  local entity client;
  client = self.owner;
  setorigin(self, client.origin );
  self.SendFlags = self.SendFlags | 1;
  self.data_type = client.data_type;
  self.i_faction = client.i_faction;
  self.cl_flags = client.flags;
  self.SendFlags = self.SendFlags | 2;
  if(self.data_type == DATA_MECH){
    self.netname  = client.netname;
    self.vec_size = client.vec_size;
    self.data_idx = client.data_idx;
    self.stat_rdr_mode = client.stat_rdr_mode;
    self.stat_rdr_rng = client.stat_rdr_rng;
  self.SendFlags = self.SendFlags | 4;
  }
  self.think = client_data_think;
  self.nextthink = time + 0.01;
};

//SendEnt

float(entity ent, float sendFlags) client_data_sendEnt={   
  WriteByte( MSG_ENTITY, DATA_INFO_START);
  WriteShort( MSG_ENTITY, self.stat_eid );
  WriteByte( MSG_ENTITY, self.data_type);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteByte( MSG_ENTITY, self.cl_flags);
  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y );
  WriteCoord( MSG_ENTITY, self.origin_z );
  
  if(self.data_type == DATA_MECH){
    WriteString( MSG_ENTITY, self.netname);
    WriteByte( MSG_ENTITY, self.data_idx);
    WriteByte( MSG_ENTITY, self.vec_size);  
    WriteByte( MSG_ENTITY, self.stat_rdr_mode);
    WriteLong( MSG_ENTITY, self.stat_rdr_rng);
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner));
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner.e_legs));
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner.e_tor_l));
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner.e_tor_r));
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner.e_arm_l));
    WriteByte( MSG_ENTITY, csqc_updateCompStat(self.owner.e_arm_r));
    WriteByte( MSG_ENTITY, (self.owner.en_cur / self.owner.en_max)*100);
    WriteByte( MSG_ENTITY, (self.owner.sh_cur / self.owner.sh_max)*100);
    
    WriteLong( MSG_ENTITY, self.owner.currentWeaponGroup);
    WriteByte( MSG_ENTITY, self.owner.stat_wep_rel);
    WriteByte( MSG_ENTITY, self.owner.hardpoint_cnt);
  }
  return TRUE;
};

float(entity ent, float changed) send_vehicle={
  WriteByte(MSG_ENTITY, DATA_VEHC);
  WriteByte( MSG_ENTITY, self.owner.data_idx );
  WriteByte( MSG_ENTITY, self.owner.vec_size );
  WriteByte( MSG_ENTITY, self.owner.i_faction );
  WriteCoord( MSG_ENTITY, self.owner.origin_x );
  WriteCoord( MSG_ENTITY, self.owner.origin_y );
  WriteCoord( MSG_ENTITY, self.owner.origin_z );
  return TRUE;
};

float(entity ent, float changed) send_building={
  WriteByte(MSG_ENTITY, DATA_BLD);
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteCoord( MSG_ENTITY, self.origin_x );
  WriteCoord( MSG_ENTITY, self.origin_y ); 
  WriteCoord( MSG_ENTITY, self.origin_z );
  WriteAngle( MSG_ENTITY, self.angles_x);
  WriteAngle( MSG_ENTITY, self.angles_y);
  WriteAngle( MSG_ENTITY, self.angles_z);
  return TRUE;
};

float(entity ent, float changed) send_ai_mech={
//super ugly hack, send ai's e_cam ent
  WriteByte( MSG_ENTITY, DATA_MECH_AI );
  WriteByte( MSG_ENTITY, self.owner.data_idx);
  WriteByte( MSG_ENTITY, self.owner.vec_size);
  WriteByte( MSG_ENTITY, self.owner.sh_cur);
  WriteByte( MSG_ENTITY, self.owner.stat_rdr_mode);
  WriteByte( MSG_ENTITY, self.owner.i_faction);
  WriteCoord( MSG_ENTITY, self.owner.origin_x );
  WriteCoord( MSG_ENTITY, self.owner.origin_y );
  WriteCoord( MSG_ENTITY, self.owner.origin_z );
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

void(string mode) client_sendGameMode={
  local string cmd;
  cmd = strcat("mech gamemode ", mode,"\n");
  stuffcmd(self, cmd);
};

/*
commmand string: cmd mech setwep X Y
  X = WEAPON bitflag id
  Y = weapon data_idx id
*/
void(string cmd, float tokens) client_setWeapon={
  local float wslotid, new_id;
  local entity oself, new_dat;
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
        self.stat_w1_rel = delta;
        break;
      case 2:
        self.stat_w2_id = wid;
        self.stat_w2_rel = delta;
        break;
      case 3:
        self.stat_w3_id = wid;
        self.stat_w3_rel = delta;
        break;
      case 4:
        self.stat_w4_id = wid;
        self.stat_w4_rel = delta;
        break;
      case 5:
        self.stat_w5_id = wid;
        self.stat_w5_rel = delta;
        break;
      case 6:
        self.stat_w6_id = wid;
        self.stat_w6_rel = delta;
        break;
      case 7:
        self.stat_w7_id = wid;
        self.stat_w7_rel = delta;
        break;
      case 8:
        self.stat_w8_id = wid;
        self.stat_w8_rel = delta;
        break;
      case 9:
        self.stat_w9_id = wid;
        self.stat_w9_rel = delta;
        break;
    }
    idx = idx + 1;
    e = e.w_slot;
  }
};

float(float val, float rel, float wpn_rel, float rdy, float bit) client_incrementReload={
  if((rdy & bit)){
    local float t;
    t = time;
    val = (rel - t);
    val = val / wpn_rel;
    val = (1 - val);
    if(val <= 0){
      val = 0;
    }
  }
  else{
    val = 1;
  }
  return val;
};

//highlights a part of the hud over X number of seconds, useful for tutorials
void(float timer, vector pos, vector bsize, vector clr, entity client) client_HighlightHUDRec={
  local entity this;
  if((client.flags & FL_CLIENT)){
    this = self;
    self = client;
      self.ui_box_time = timer;
      self.ui_box_pos = pos;
      self.ui_box_sz = bsize;
      self.ui_box_clr = clr;
    self = this;
  }
};