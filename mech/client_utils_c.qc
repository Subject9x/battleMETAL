/*
mech Mod
Author: Peter Roohr
Date: 8/27/2016
Overview: client utility methods, pulled from client.qc
*/

float(entity ent, float changed) send_mech={
  WriteByte(MSG_ENTITY, E_MEC);
  WriteByte( MSG_ENTITY, num_for_edict(self.owner));
  WriteByte( MSG_ENTITY, self.owner.data_idx);
  WriteByte( MSG_ENTITY, self.owner.i_faction);
  WriteCoord( MSG_ENTITY, self.owner.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.owner.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.owner.origin_z ); // Position Z
  WriteByte( MSG_ENTITY, self.owner.stat_rdr_mode);
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self));
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self.e_legs));
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self.e_tor_l));
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self.e_tor_r));
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self.e_arm_l));
  WriteByte(MSG_ENTITY, csqc_updateCompStat(self.e_arm_r));
  return TRUE;
};

float(entity ent, float changed) send_vehicle={
  WriteByte(MSG_ENTITY, E_VEC);
  WriteByte( MSG_ENTITY, self.owner.data_idx);
  WriteByte( MSG_ENTITY, self.owner.i_faction);
  WriteCoord( MSG_ENTITY, self.owner.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.owner.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.owner.origin_z ); // Position Z
  return TRUE;
};

float(entity ent, float changed) send_building={
  WriteByte(MSG_ENTITY, E_BLD);
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteCoord( MSG_ENTITY, self.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.origin_z ); // Position Z
  WriteAngle( MSG_ENTITY, self.angles_x);
  WriteAngle( MSG_ENTITY, self.angles_y);
  WriteAngle( MSG_ENTITY, self.angles_z);
  return TRUE;
};

float(entity ent, float changed) send_ai_mech={
//super ugly hack, send ai's e_cam ent
  WriteByte( MSG_ENTITY, E_AIU ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.owner.data_idx);
  WriteByte( MSG_ENTITY, self.owner.sh_cur);
  WriteByte( MSG_ENTITY, self.owner.stat_rdr_mode);
  WriteByte( MSG_ENTITY, self.owner.i_faction);
  WriteCoord( MSG_ENTITY, self.owner.origin_x ); // Position X
  WriteCoord( MSG_ENTITY, self.owner.origin_y ); // Position Y
  WriteCoord( MSG_ENTITY, self.owner.origin_z ); // Position Z
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
    self.p_class_next = P_MECH;
    self.vec_size = stof(argv(2));
    self.nextVecChoice = stof(argv(3));
  }
  else if(argv(1) == "spawn"){
    if(self.p_class == P_OBS){
      spawnpoint_Random();
      player_unmakeObserver();
      player_makeMech();
    }
  }
  else if(argv(1) == "setgroup"){
    client_setWeaponGroup(str, tokens);
  }
  else if(argv(1) == "setnav"){
    client_setNavPoint(str, tokens);
  }
};  

/*
  
*/
void(string cmd, float tokens) client_setWeaponGroup={
  local float groupnum, groupval;
  groupnum = stof(argv(2));
  groupval = stof(argv(3));
  if(groupnum == 1){
    
    self.w_group1 = groupval;
  }
  else if(groupnum == 2){
    self.w_group2 = groupval;
  }
  else if(groupnum == 3){
    self.w_group3 = groupval;
  } 
  else if(groupnum == 4){
    self.w_group4 = groupval;
  }
  else if(groupnum == 5){
    self.w_group5 = groupval;
  }
};

void() client_sendAvailableLightMechs={
  local string cmd;
  cmd = strcat("mech list_light ",ftos(world.next_wepn4),"\n");
  stuffcmd(self, cmd);
};

void() client_sendAvailableMediumMechs={
  local string cmd;
  cmd = strcat("mech list_med ",ftos(world.next_wepn5),"\n");
  stuffcmd(self, cmd);
};

void() client_sendAvailableHeavyMechs={
  local string cmd;
  cmd = strcat("mech list_hvy ",ftos(world.next_wepn6),"\n");
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
  if(wslotid == WEAPON1){
    self.next_wepn1 = new_id;
  }
  else if(wslotid == WEAPON2){
    self.next_wepn2 = new_id;
  }
  else if(wslotid == WEAPON3){
    self.next_wepn3 = new_id;
  }
  else if(wslotid == WEAPON4){
    self.next_wepn4 = new_id;
  }
  else if(wslotid == WEAPON5){
    self.next_wepn5 = new_id;
  }
  else if(wslotid == WEAPON6){
    self.next_wepn6 = new_id;
  }
  else if(wslotid == WEAPON7){
    self.next_wepn7 = new_id;
  }
  else if(wslotid == WEAPON8){
    self.next_wepn8 = new_id;
  }
  else if(wslotid == WEAPON9){
    self.next_wepn9 = new_id;
  }
};


void() client_sendMissionFileName={
  local string cmd;
  cmd = strcat("mech msn_file ",world.msn_file,"\n");
  stuffcmd(self, cmd);
};

void(string cmd, float tokens) client_setNavPoint={
  local float nav_id;
  local entity nav;
  nav_id = stof(argv(2));
  nav = findfloat(world, nav_name, nav_id);
  if(nav != world){
    self.nav_name = nav_id;
  }
  else{
    self.nav_name = -1;
  }
};

void() respawn={ 
  if (coop){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);
    //
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);

		// set default spawn parms
		SetNewParms ();
    if(self.p_class == P_MECH){
      player_unmakeMech();
    }
		// respawn		
		PutClientInServer ();
	}
	else{	
  // restart the entire server
		localcmd ("restart\n");
	}
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
	if (coop)
	{
    lastspawn = find(lastspawn, classname, "info_player_coop");
    if (lastspawn == world)
      lastspawn = find (lastspawn, classname, "info_player_start");
    if (lastspawn != world)
      return lastspawn;
	}
	else if (deathmatch)
	{
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

void() spawnpoint_Random={
  local entity spot;
  //spot = SelectSpawnPoint();
  if(self.nav_name > 0){
    spot = mh_world_findData(self.nav_name, DATA_NAVP);
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
    local float delta;
    delta = e.en_cur / e.en_max;
    if(idx == 1){ 
      self.stat_w1_rel = delta;
    }
    else if(idx == 2){
      self.stat_w2_rel = delta;
    }
    else if(idx == 3){
      self.stat_w3_rel = delta;
    }
    else if(idx == 4){
      self.stat_w4_rel = delta;
    }
    else if(idx == 5){
      self.stat_w5_rel = delta;
    }
    else if(idx == 6){
      self.stat_w6_rel = delta;
    }
    else if(idx == 7){
      self.stat_w7_rel = delta;
    }
    else if(idx == 8){
      self.stat_w8_rel = delta;
    }
    else if(idx == 9){
      self.stat_w9_rel = delta;
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