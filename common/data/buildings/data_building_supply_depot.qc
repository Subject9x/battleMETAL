/*
battleMETAL
Author: Peter Roohr
Date: 05/08/2020
Overview: data file for building
  
  type: Supply Depot
  faction: any
  func: 
    Decoration, mostly an aesthetics building used to fill-out base areas.
*/
void() hangar_depot_die2;
void() hangar_depot_die3;
void() hangar_depot_die4;
void() hangar_depot_die5;
void() hangar_depot_die6;
void() hangar_depot_die7;
void() hangar_depot_die8;
void() hangar_depot_die9;
void() hangar_depot_die10;
void() hangar_depot_die11;
void() hangar_depot_die12;
void() hangar_depot_die13;
void() hangar_depot_die14;
void() hangar_depot_die15;

void() hangar_depot_die1=[0, hangar_depot_die2]{
  if( self.deadflag > DEAD_NO ){
    return;
  }
  
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
  ai_alert_close(self.enemy);
};
void() hangar_depot_die2=[0, hangar_depot_die3]{

};
void() hangar_depot_die3=[0, hangar_depot_die4]{
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.mins_y) + (v_right * (crandom() * (self.maxs_x * 0.15)));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
};
void() hangar_depot_die4=[0, hangar_depot_die5]{

};
void() hangar_depot_die5=[0, hangar_depot_die6]{
  local vector vfx;
  
  makevectors(self.angles);
  vfx = self.origin + (v_up * self.maxs_z) + (v_forward * (self.mins_y * 0.18)) + (v_right * (self.mins_x * 0.15));

  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 6, 3 );
};
void() hangar_depot_die6=[0, hangar_depot_die7]{

};
void() hangar_depot_die7=[0, hangar_depot_die8]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
};
void() hangar_depot_die8=[0, hangar_depot_die9]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 2 );
};
void() hangar_depot_die9=[0, hangar_depot_die10]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 2 );
};
void() hangar_depot_die10=[0, hangar_depot_die11]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 2, 2 );
};
void() hangar_depot_die11=[0, hangar_depot_die12]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 3, 1 );
};
void() hangar_depot_die12=[0, hangar_depot_die13]{

};
void() hangar_depot_die13=[0, hangar_depot_die14]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 4, 1 );
};
void() hangar_depot_die14=[0, hangar_depot_die15]{

};
void() hangar_depot_die15=[0, SUB_Null]{
  local vector vfx;

  vfx = randompos(self.absmin, self.absmax);
  te_debris( vfx, normalize(vfx - self.origin) * 6, '0 0 0', 5,1 );
  building_die();
};

void() building_supply_depot={

  self.data_idx = self.nextVecChoice = UI_BUILDING_supply_depot;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();

  self.vec_name = "Supply Depot";
  self.flags = self.flags | FL_MONSTER ;
  self.vec_size = 2;
  macro_set_collider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE)
  macro_set_model("q3mdl/buildings/depot/building_depot.obj", self.skin, 0)
  setsize(self, self.mins, self.maxs);
  
  self.th_die = hangar_depot_die1;
  self.use = multi_trigger;
  
  if( !self.health) {
    self.health = 350;
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
    self.energyMax = 100;
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