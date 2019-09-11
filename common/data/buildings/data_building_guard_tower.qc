/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building
*/

void() building_guard_tower={
  self.data_idx = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;
  self.vec_name = "Guard Tower";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 1;
  util_setModel("", self.skin, 0);
  util_setCollider(DAMAGE_YES, SOLID_BSP, MOVETYPE_NONE);
  util_setHealthArmor(200, 200, 1, 100);
  setsize(self, '-16 -16 0', '16 16 32');
  self.shield = 0;
  self.shieldMax = 100;
  self.shieldRate = 1;
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  
};