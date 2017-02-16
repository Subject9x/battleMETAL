/*
mech Mod
Author: Subject9x
Date: 9/3/2016
Overview: I pulled the ImpulseCommands() function out to its own
file....
*/

//new commands
void() cycleWeaponGroup={};
void() cycleWeaponGroupReverse={};
void() switchFireMode={};
void() selectTarget={};
void() toggerRadar={};

void() playerAttack={
  local entity wep_chain;
  wep_chain = self.w_slot;
  while(wep_chain){
    local float wpgrp;
    wpgrp = wep_chain.w_group;
    if(self.currentWeaponGroup & wep_chain.w_group){
      if(wep_chain.w_isfire != 1){
        wep_chain.w_isfire = 1;
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};

void(float current, float toRemove) removeWeaponGroup={

  if(current & toRemove){
    current = current - toRemove;
  }

};

void() ImpulseCommands ={
	//if (self.impulse >= 1 && self.impulse <= 8)
    //if(self.deadflag == DEAD_DEAD)
      //respawn();
		//W_ChangeWeapon ();

	//if (self.impulse == 9){}
		//CheatCommand ();
	//if (self.impulse == 10){}
		//CycleWeaponCommand ();
	//if (self.impulse == 11){}
		//ServerflagsCommand ();
	//if (self.impulse == 12){}
		//CycleWeaponReverseCommand ();

	//if (self.impulse == 255){}
		//QuadCheat ();
  

  if(self.impulse == IMP_FGROUP){
    self.stat_plr_fir = FIRE_GROUP;
  }
  if(self.impulse == IMP_FCHAIN){
    self.stat_plr_fir = FIRE_CHAIN;
  }
  if(self.impulse == IMP_FSINGLE){
    self.stat_plr_fir = FIRE_SINGLE;
  }
  
  if(self.stat_plr_fir == FIRE_SINGLE){
    mpls_singleFire();
  }
  if(self.stat_plr_fir == IMP_FGROUP){
    mpls_groupFire();
  }

  local float change;
  change = 0;
  
  if(self.impulse == IMP_VECPREV){
    change = 1;
    self.nextVecChoice = self.nextVecChoice - 1;
  }
  
  if(self.impulse == IMP_VECNEXT){
    change = 1;
    self.nextVecChoice = self.nextVecChoice + 1;
  }
  
  if(self.impulse == IMP_SUICIDE){
    ClientKill();
  }
  
  if(self.impulse == IMP_TARGET){
    server_getTarget();
  }
  
  if(self.impulse == IMP_RADAR){
    if(self.stat_rdr_mode){
      self.stat_rdr_mode = FALSE;
    }
    else{
      self.stat_rdr_mode = TRUE;
    }
  }
  
  //abstract out into handler at some point

  if(self.nextVecChoice > 3){
    self.nextVecChoice = 0;
  }
  else if(self.nextVecChoice < 0){
    self.nextVecChoice = 3;
  }
	
  if(change == 1){
    if( self.nextVecChoice == 0){
      centerprint(self, "Spawn as Observer");
      self.p_class_next = P_OBS;
    }else{
      self.p_class_next = P_MECH;
      local entity e;
      e = mh_world_findData(self.nextVecChoice, DATA_MECH);
      centerprint(self, strcat("Spawn as ", e.vec_name));
    }
    change = 0;
  }



	self.impulse = 0;
};

void() mpls_singleFire={
  if(self.impulse == IMP_SWEAPON1){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON1;
  }
  if(self.impulse == IMP_SWEAPON2){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON2;
  }
  if(self.impulse == IMP_SWEAPON3){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON3;
  }
  if(self.impulse == IMP_SWEAPON4){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON4;
  }
  if(self.impulse == IMP_SWEAPON5){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON5;
  }
  if(self.impulse == IMP_SWEAPON6){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON6;
  }
  if(self.impulse == IMP_SWEAPON7){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON7;
  }
  if(self.impulse == IMP_SWEAPON8){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON8;
  }
  if(self.impulse == IMP_SWEAPON9){
    self.currentWeaponGroup = 0;
    self.currentWeaponGroup = WEAPON9;
  }
};

void() mpls_groupFire={
  if(self.impulse == IMP_WGROUP1){
    centerprint(self, "[Weapon Group 1]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group1;
  }
  if(self.impulse == IMP_WGROUP2){
    //21
    centerprint(self, "[Weapon Group 2]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group2;
  }
  if(self.impulse == IMP_WGROUP3){
    centerprint(self, "[Weapon Group 3]");
    self.currentWeaponGroup = self.currentWeaponGroup - (self.currentWeaponGroup & (self.w_group1 | self.w_group2 | self.w_group3));
    self.currentWeaponGroup = self.currentWeaponGroup + self.w_group3;
  }
};

/*
OLD Q1 STUFF
void() W_SetCurrentAmmo =
{
	//player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
			return IT_LIGHTNING;
	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};

============
W_ChangeWeapon

============

void() W_ChangeWeapon =
{
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}		
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;		
	W_SetCurrentAmmo ();
};


============
CycleWeaponCommand

Go to the next weapon with ammo
============

void() CycleWeaponCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};


============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
===========

void() CycleWeaponReverseCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

============
CheatCommand
============

void() CheatCommand =
{
	if (deathmatch)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

void() QuadCheat =
{
	if (deathmatch)
		return;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};
*/