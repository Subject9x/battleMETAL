/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced turrets.
*/

/*
  client_main.CSQC_ent_update()->Ent Type == building, SENDFLAG_NEWENT
  scope = self
  self is building
*/
void( float dataID ) data_sync_new_turret={
  switch( dataID ){
    case UID_TURRET_light_turret:
      data_turret_light();
      break;
      
    case UID_TURRET_missile_turret:
      data_turret_missile();
      break;
      
    case UID_TURRET_heavy_turret:
      data_turret_heavy();
      break;
  }
}

void() data_turret_light={
  local vector offset;
  self.vec_size = 1;
  self.vec_name = "Light Turret";
  self.max_health = 350;
  setmodel(self, "q3mdl/buildings/turret_light/mdl_bld_h_ltur_base.md3");
  self.torsoCenter = spawn();
  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, "q3mdl/buildings/turret_light/mdl_bld_h_ltur.md3");
  self.torsoCenter.compOffset = '0 8 0';
  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  self.shieldMax  = 100;
};

void() data_turret_heavy={
  local vector offset;
  self.vec_size = 2;
  self.vec_name = "Heavy Turret";
  self.max_health = 581;
  setmodel(self, "q3mdl/buildings/turret_heavy/mdl_turret_heavy_base.obj");
  self.torsoCenter = spawn();
  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, "q3mdl/buildings/turret_heavy/mdl_turret_heavy_turret.obj");
  self.torsoCenter.compOffset = '0 20 0';
  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  
  self.shieldMax  = 150;
};

void() data_turret_missile={
  local vector offset;
  self.vec_size = 1;
  self.vec_name = "Missile Turret";
  self.max_health = 465;
  setmodel(self, "q3mdl/buildings/turret_missile/mdl_turret_missile_base.obj");
  self.torsoCenter = spawn();
  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, "q3mdl/buildings/turret_missile/mdl_turret_missile_turret.md3");
  self.torsoCenter.compOffset = '0 -12 0';
  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  
  self.shieldMax  = 100;
};