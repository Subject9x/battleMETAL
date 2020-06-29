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
  self.flags = FL_MONSTER | FL_UNIT;
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
  
  data_ini_light_turret_();
  
  setmodel(self, self.model);

  
  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  self.vec_size = 1;
};

void() data_turret_heavy={
  local vector offset;
  
  data_ini_heavy_turret_();
  
  setmodel(self, self.model);

  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  self.vec_size = 2;
};

void() data_turret_missile={
  local vector offset;
  
  data_ini_missile_turret_();
  
  setmodel(self, self.model);

  self.torsoCenter.drawmask = MASK_NORMAL;
  setmodel(self.torsoCenter, self.torsoCenter.model);

  makevectors(self.angles);
  offset = self.origin + (v_up * self.torsoCenter.compOffset_y);
  setorigin(self.torsoCenter, offset);
  self.vec_size = 2;
};