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
    bprint(strcat(str,"\n"));
    if(self.deadflag >= DEAD_NO){
      client_setWeapon(str, tokens);
    }
  }
};

//scope - self = weapon updating its owner
void(float w_id, float wslotid) client_updateWeaponIdStat={
  if(wslotid == WEAPON1){
    self.owner.stat_w1_id = w_id;
  }
  else if(wslotid == WEAPON2){
    self.owner.stat_w2_id = w_id;
  }
  else if(wslotid == WEAPON3){
    self.owner.stat_w3_id = w_id;
  }
  else if(wslotid == WEAPON4){
    self.owner.stat_w4_id = w_id;
  }
  else if(wslotid == WEAPON5){
    self.owner.stat_w5_id = w_id;
  }
  else if(wslotid == WEAPON6){
    self.owner.stat_w6_id = w_id;
  }
  else if(wslotid == WEAPON7){
    self.owner.stat_w7_id = w_id;
  }
  else if(wslotid == WEAPON8){
    self.owner.stat_w8_id = w_id;
  }
  else if(wslotid == WEAPON9){
    self.owner.stat_w9_id = w_id;
  }
};
/*
commmand string: cmd mech setwep X Y
  X = WEAPON bitflag id
  Y = weapon data_idx id
*/
void(string cmd, float tokens) client_setWeapon={
  local float wslotid, new_id;
  local entity e_wslot, oself, new_dat;
  oself = self;
  wslotid = stof(argv(2));
  new_id = stof(argv(3));
  new_dat = mh_world_findData(new_id, DATA_WEPN);
  if(new_dat == world){
    bprint(strcat("Error on command:",cmd,"\n","could not find weapon","\n"));
    return;
  }
  e_wslot = self.w_slot;
  while(e_wslot){
    if(e_wslot.w_group == wslotid){
      self = e_wslot;
        self.data_idx = new_id;
        new_dat.unit_ini();
        ctrl_weapon_addState(self, self.state_1);
        util_setModel(self.c_model, 0);
        client_updateWeaponIdStat(new_id, self.w_group);
      self = oself;
    }
    e_wslot = e_wslot.w_slot;
  }
};

void() respawn={
  if (coop){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch){
		// make a copy of the dead body for appearances sake
    CopyToBodyQue (self);

		// set default spawn parms
		//SetNewParms ();
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