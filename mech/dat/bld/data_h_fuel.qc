/*
mech Mod
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

//Death Animation
void() hfuel_death1 = [1, hfuel_death2]{
  activator = self.enemy;
	SUB_UseTargets ();
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  multi_trigger();
  local vector exp;
  exp = randomvec();
  exp_x = exp_x * ( random() * (-self.mins_x + self.maxs_x));
  exp_y = exp_y * ( random() * (-self.mins_y + self.maxs_y));
  exp_z = exp_z * ( random() * (-self.mins_z + self.maxs_z));
  exp = self.origin + exp;
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, exp_x);
	WriteCoord (MSG_BROADCAST, exp_y);
	WriteCoord (MSG_BROADCAST, exp_z);
};
void() hfuel_death2 = [2, hfuel_death3]{};
void() hfuel_death3 = [3, hfuel_death4]{};
void() hfuel_death4 = [4, hfuel_death5]{
  local vector exp;
  exp = randomvec();
  exp_x = exp_x * ( random() * (self.maxs_x * 2));
  exp_y = exp_y * ( random() * (self.maxs_y * 2));
  exp_z = exp_z * ( random() * (self.maxs_z * 2));
  exp = self.origin + exp;
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, exp_x);
	WriteCoord (MSG_BROADCAST, exp_y);
	WriteCoord (MSG_BROADCAST, exp_z);
};
void() hfuel_death5 = [5, hfuel_death6]{};
void() hfuel_death6 = [6, hfuel_death7]{};
void() hfuel_death7 = [7, hfuel_death8]{
  local vector exp;
  exp = randomvec();
  exp_x = exp_x * ( random() * (self.maxs_x * 2));
  exp_y = exp_y * ( random() * (self.maxs_y * 2));
  exp_z = exp_z * ( random() * (self.maxs_z * 2));
  exp = self.origin + exp;
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, exp_x);
	WriteCoord (MSG_BROADCAST, exp_y);
	WriteCoord (MSG_BROADCAST, exp_z);
};
void() hfuel_death8 = [8, hfuel_death9]{};
void() hfuel_death9 = [9, hfuel_death10]{};
void() hfuel_death10 = [10, hfuel_death11]{
  local vector exp;
  exp = randomvec();
  exp_x = exp_x * ( random() * (self.maxs_x * 2));
  exp_y = exp_y * ( random() * (self.maxs_y * 2));
  exp_z = exp_z * ( random() * (self.maxs_z * 2));
  exp = self.origin + exp;
  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, exp_x);
	WriteCoord (MSG_BROADCAST, exp_y);
	WriteCoord (MSG_BROADCAST, exp_z);
};
void() hfuel_death11 = [11, hfuel_death12]{};
void() hfuel_death12 = [12, BecomeExplosion]{};

/*QUAKED building_fuel (.1 .1 .1) (-40 -40 -32) (40 40 32)
*/
void() building_fuel={
  self.data_idx = ID_BLD_H_FUEL;
  self.data_type = DATA_BLD;
  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  util_setModel(DAT_BLD_H_FUELTANK_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_FUELTANK_HP, DAT_BLD_H_FUELTANK_HP, 1, 100) ;
  util_setBoundBox('-40 -40 0', '40 40 40');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_FUELTANK_SH_MAX;
  self.sh_rate = DAT_BLD_H_FUELTANK_SH_RATE;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
   
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  
  self.th_die = hfuel_death1;
  self.th_stand = build_stand1;
  self.use = multi_trigger;
  self.SendEntity = send_building;
  self.SendFlags = -1;
  
  self.nextthink = self.nextthink + random()*0.5;
  self.think = self.th_stand;
};