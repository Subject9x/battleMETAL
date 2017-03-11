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
  else if(argv(1) == "setmech"){
    self.p_class_next = P_MECH;
    self.nextVecChoice = stof(argv(2));
  }
  else if(argv(1) == "spawn"){
    player_unmakeObserver();
    player_makeMech();
    spawnpoint_Random();
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
  spot = SelectSpawnPoint();
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