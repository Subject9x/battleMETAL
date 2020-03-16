/*
battleMETAL
Author: Peter Roohr
Date: 8/27/2016
Overview: extends the player's entity.
*/

//pulled from client.qc
void() SetChangeParms={
  if (self.health <= 0)
	{
		SetNewParms ();
		return;
	}

// remove items
	self.items = self.items - (self.items & 
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	
// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
    
	parm1 = self.faction;
	parm2 = 0;  //score
	parm3 = 0;
  parm4 = 0;
	/*if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = 0;//self.ammo_shells;*/
	parm5 = 0;//self.ammo_nails;
	parm6 = 0;//self.ammo_rockets;
	parm7 = 0;//self.ammo_cells;
	parm8 = 0;//self.weapon;
	parm9 = 0;//self.armortype * 100;
  
};
void() SetNewParms={
  parm1 = 0;  //faction
	parm2 = 0;  //score
	parm3 = 0;  //previous Mission Status
	parm4 = 0;  //previous mech
	parm5 = 0;  //previous Mission Time
	parm6 = 0;  //
	parm7 = 0;
	parm8 = 0;
	parm9 = 0;
};
void() DecodeLevelParms={
  //	if (serverflags)
	if (!deathmatch)	
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
	self.faction = parm1;
  
  
	//self.i_reserve = parm1;
	self.health = 100;
	//self.ammo_shells = parm4;
	//self.ammo_nails = parm5;
	//self.ammo_rockets = parm6;
	//self.ammo_cells = parm7;
	//self.weapon = parm8;
	//self.armortype = parm9 * 0.01;
};