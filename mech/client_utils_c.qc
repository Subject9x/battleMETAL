/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: client utility methods, pulled from client.qc
*/

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
    self.nextVecChoice = stof(argv(2));
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
  //CopyToBodyQue (self);
  //setspawnparms (self);
  PutClientInServer ();
 
 /* if (coop){
		// make a copy of the dead body for appearances sake
    //
		// get the spawn parms as they were at level start
		//setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch){
		// make a copy of the dead body for appearances sake
    //CopyToBodyQue (self);

		// set default spawn parms
		//SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else{	
  // restart the entire server
		localcmd ("restart\n");
	}*/
};

entity() SelectSpawnPoint={
  local	entity spot;
	local	entity thing;
	local	float  pcount;
	
// testinfo_player_start is only found in regioned levels

  spot = find (world, classname, "testplayerstart");
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
  
  self.origin = self.oldorigin = spot.origin + '0 0 24';
  
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
    
    if(idx == 1){ 
      self.stat_w1_rel = client_incrementReload(self.stat_w1_rel, e.power_timer, e.w_reloadtime, self.stat_wep_rel, WEAPON1_REL);
    }
    else if(idx == 2){
      self.stat_w2_rel = client_incrementReload(self.stat_w2_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON2_REL);
    }
    else if(idx == 3){
      self.stat_w3_rel = client_incrementReload(self.stat_w3_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON3_REL);
    }
    else if(idx == 4){
      self.stat_w4_rel = client_incrementReload(self.stat_w4_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON4_REL);
    }
    else if(idx == 5){
      self.stat_w5_rel = client_incrementReload(self.stat_w5_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON5_REL);
    }
    else if(idx == 6){
      self.stat_w6_rel = client_incrementReload(self.stat_w6_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON6_REL);
    }
    else if(idx == 7){
      self.stat_w7_rel = client_incrementReload(self.stat_w7_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON7_REL);
    }
    else if(idx == 8){
      self.stat_w8_rel = client_incrementReload(self.stat_w8_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON8_REL);
    }
    else if(idx == 9){
      self.stat_w9_rel = client_incrementReload(self.stat_w9_rel, e.power_timer, e.w_reloadtime,  self.stat_wep_rel, WEAPON9_REL);
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