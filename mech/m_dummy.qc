/*
mech Mod
Author: Subject9x
Date: 1/29/2017
Overview: spawn a target dummy
*/
void() dummyConnect;
void() putDummyInServer;
void() dummyDie;

void() dummyConnect = {
  
  local entity dummy, oself;
  oself = self;
  dummy = spawn();
  self = dummy;
  
  bprint(self.netname);
  bprint(" has deployed to the combat zone\n");
  
  self.p_class = P_MECH;
  self.p_class_next = P_MECH;
  self.nextVecChoice = 1;
  self.data_idx = 0;
  self.currentWeaponGroup = 1;
  self.faction = 2;
  self.en_cur = 0;
  self.en_max = 0;
  self.en_rate = 0;
  self.sh_cur = 0;
  self.sh_max = 0;
  self.sh_rate = 0;
  
  self.stat_trg_vid = -1;
  self.stat_trg_sh = -1;
  self.stat_trg_am = -1;
  self.stat_trg_dat = -1;
  
  self.radar_range = 100;
  self.radar_front = 0;
  
  putDummyInServer();
  
  self = oself;
};

void() putDummyInServer = {
  local entity spot;
  
  self.flags = FL_MONSTER;
  self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
  
  spot  = SelectSpawnPoint();
  
	self.origin = self.oldorigin = spot.origin + '0 0 24';	// 1998-07-21 Respawning where player died fix by Robert Field
  self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately
	
  self.classname = "player";
  
  DecodeLevelParms ();

	self.attack_finished = time;
	//self.th_pain = player_pain;
	self.th_die = dummyDie;
	self.deadflag = DEAD_NO;

// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	self.view_ofs = '0 0 1';
	
  if(self.p_class == P_OBS){
    mh_makeObserver(self);
  }
  else if(self.p_class == P_MECH){
    mh_makeMech(self);
  }
 
	if (deathmatch || coop)
	{
		makevectors(self.angles);
	}
  
  self.think = SUB_Null;
  self.nextthink = time;
};

void() dummyDie={
  local float f;
	if (self.deadflag)
	{
		bprint("warning: PlayerDie called twice\n");
		return;
	}
//	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.effects = 0;	// 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
  
	self.view_ofs = '0 0 1';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	
  if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;
  
	self.angles_x = 0;
	self.angles_z = 0;
  self.avelocity = '0 0 0';
  
  if(self.p_class == P_MECH){
    mech_player_die();
    return;
  }
};