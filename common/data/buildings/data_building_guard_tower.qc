/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building
*/

void() guard_tower_think={
  building_burn();
  self.think = guard_tower_think;
  self.nextthink = time + 0.1;
};

void() guard_tower_die={
  
  building_die();
};

void() building_guard_tower={
  self.data_idx = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;
  self.vec_name = "Guard Tower";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 1;
  util_setModel("q3mdl/buildings/towersmall/guardtower.obj", self.skin, 0);
  util_setCollider(DAMAGE_YES, SOLID_BSP, MOVETYPE_NONE);
  util_setHealthArmor(200, 200, 1, 100);
  setsize(self, '-24 -24 0', '24 24 48');
  self.shield = 0;
  self.shieldMax = 100;
  self.shieldRate = 1;
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  self.th_die = building_die;
  self.think = guard_tower_think;
  self.nextthink = time + 0.1;
  
  if( util_cornerSlopeCheck(self, 1) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  if( !(self.spawnflags & 2097152) ){
    if( !self.style ){
      self.style = 0;
    }
    local vector lightOrg;
    makevectors(self.angles);
    lightOrg = self.origin + (v_up * 36);
    world_make_dlight( (lightOrg + (v_forward * 18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_forward * -18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_right * 18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_right * -18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    
  }
};