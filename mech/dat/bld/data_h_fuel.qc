/*
mech Mod
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/


/*QUAKED building_fuel (.1 .1 .1) (-40 -40 -32) (40 40 32)
*/
void() building_fuel;

void() building_fuel={
  self.data_idx = ID_BLD_H_FUEL;
  self.data_type = DATA_BLD;
  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER;
  util_setModel(DAT_BLD_H_FUELTANK_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_FUELTANK_HP, DAT_BLD_H_FUELTANK_HP, 1, 100) ;
  util_setBoundBox('-40 -40 -32', '40 40 32');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_FUELTANK_SH_MAX;
  self.sh_rate = DAT_BLD_H_FUELTANK_SH_RATE;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  self.th_die = building_die;
  self.think = building_think;
  self.nextthink = time;
  self.use = multi_trigger;
  self.SendEntity = send_building;
  self.SendFlags = -1;
};