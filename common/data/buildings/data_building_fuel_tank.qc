/*
battleMETAL
Author: Peter Roohr
Date: 5/13/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

//Death Animation - TODO - clientside
void() hfuel_death1 = [1, hfuel_death2]{
  
  if( self.deadflag > DEAD_NO ){
    return;
  }
  ai_alert_close(self.enemy);
};
void() hfuel_death2 = [2, hfuel_death3]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 1 );
};
void() hfuel_death3 = [3, hfuel_death4]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 5, 3 );
};
void() hfuel_death4 = [4, hfuel_death5]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 4, 2 );
};
void() hfuel_death5 = [5, hfuel_death6]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 1 );
};
void() hfuel_death6 = [6, hfuel_death7]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death7 = [7, hfuel_death8]{};
void() hfuel_death8 = [8, hfuel_death9]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death9 = [9, hfuel_death10]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death10 = [10, hfuel_death11]{
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (0.25 + (self.maxs_z * 0.5))) + (v_right * (crandom() * self.maxs_x)) + (v_forward * (crandom() * self.maxs_y));

  local vector shoot;
  shoot = randompos(self.origin, vfx);
  te_debris( shoot, normalize(vfx - self.origin) * 5, '0 0 0', 3, 2 );
};
void() hfuel_death11 = [11, hfuel_death12]{};
void() hfuel_death12 = [12, hfuel_death12]{
  building_die();
};

void() building_human_fuel={
  self.data_idx = self.nextVecChoice = UI_BUILDING_fuel_tank;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

  self.vec_name = "Fuel Tank";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 2;
  macro_set_collider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE)
  macro_set_model("q3mdl/buildings/fueltank/fueltank.obj", self.skin, 0)
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.scale = 1;
  self.deadflag = DEAD_NO;

  if( !self.health) {
    self.health = 100;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 250;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 0;
  }

  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);

  self.th_die = hfuel_death1;
  self.use = multi_trigger;
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  
  self.think = building_burn_th;
  self.nextthink = time + random() * 3;
};