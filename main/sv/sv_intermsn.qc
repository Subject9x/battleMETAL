/*
Quake 1**
Author: iD Software
Overview: 
  Implementation of Intermission function header. Game mostly
  modfies and extends existing quake code.
  
 ** - this has been modified to be incorporated into battleMETAL and is not compatible with
      other code bases.
*/

entity() FindIntermission={
  local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	
	return world;
};
void() GotoNextMap={
  if( time > self.count ){
    
    if (cvar("samelevel")){	// if samelevel is set, stay on same level
      changelevel (mapname);
    }
    else{  
      changelevel (sv_nextmap);
    }  
  }
};

void() ExitIntermission={
  // skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

/**
//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		}

		GotoNextMap();
	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		if ( (serverflags&15) == 15)
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
		
	}
  */

	GotoNextMap();
};
void() IntermissionThink={
  if (time < intermission_exittime){
    return;
  }
  
	if (!self.button0 && !self.button1 && !self.button2){
		return;
  }
	ExitIntermission ();
};
void() execute_changelevel={
  local entity	pos;
	
  intermission_running = 1;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + self.count;
	else
		intermission_exittime = time + self.count;

  //TODO - intermission track (probably just hangar track, eh?)
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 2);
	
	pos = FindIntermission ();
	other = find (world, classname, "player");
  local entity this;
  this = self;
	while (other != world)
	{
    self = other;
      if(self.data_type == DATA_MECH){
        player_unmakeMech();
        player_makeObserver();
      }
      self.view_ofs = '0 0 0';
      self.flags = self.flags - FL_FLY;
      self.angles = self.v_angle = pos.mangle;
      self.fixangle = TRUE;		// turn this way immediately
      self.takedamage = DAMAGE_NO;
      self.solid = SOLID_NOT;
      self.movetype = MOVETYPE_NONE;
      self.modelindex = 0;
      setorigin (self, pos.origin);
      if( world.animaticOnly == FALSE ){
        self.playerState = PLAYER_INTERMSN;  //TEST
        client_push_mapobjects();
        if(self.clientData != world ){
          self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS;
        }
      }
    this = self;
		other = find (other, classname, "player");
  }
	WriteByte (MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch={

	if (other.classname != "player")
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
  
	sv_nextmap = self.map;
  
	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (deathmatch == FALSE) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;

// we can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*
copied the changelevel_touch
so that the level can do a map switch without needing 
to touch the changelevel trigger
*/
void() changelevel_use={
  local entity client;
  if( world.animaticOnly ){
    if(strstrofs(self.map, "menu", 0) != -1){
      client = find(world, classname, "player");
      while(client != world){
        stuffcmd(client, "disconnect;togglemenu;\n");
        client = client.chain;
      }
      return;
    }
    sv_nextmap = self.map;
		GotoNextMap();
		return;
  }
  if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}
  
  if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
  sv_nextmap = self.map;
  
	SUB_UseTargets ();
  
  if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
  
  self.think = execute_changelevel;
	self.nextthink = time + self.delay;
};