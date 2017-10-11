/*
mech Mod
Author: Subject9x
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
	parm1 = self.i_reserve;
	parm2 = self.health;
	parm3 = self.i_faction;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
  
};
void() SetNewParms={
  parm1 = 0; //i_reserve -> make it difficulty based
	parm2 = 1;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = world.next_wepn3;
	parm7 = world.next_wepn4;
	parm8 = world.next_wepn5;
	parm9 = world.next_wepn6;
};
void() DecodeLevelParms={
  //	if (serverflags)
	if (!deathmatch)	
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
	
	self.i_reserve = parm1;
	self.health = parm2;
	self.i_faction = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
  
};