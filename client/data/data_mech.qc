/*
battleMETAL
Author: Peter Roohr
Date: 03/18/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/


void( float dataID ) data_sync_new_mech_ai={
  local vector maxSave, minSave;
  
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  switch( dataID ){
    case UID_MECH_balaket:
      data_ini_balaket_();
      break;
    case UID_MECH_matok:
      data_ini_matok_();
      break;
    case UID_MECH_monitor:
      data_ini_monitor_();
      break;
  }
  makevectors(self.angles);
  if( self.torsoCenter ){
    data_mech_setup_part( self.torsoCenter );
  }
  if( self.torsoLeft ){
    data_mech_setup_part( self.torsoLeft );
  }
  if( self.torsoRight ){
    data_mech_setup_part( self.torsoRight );
  }
  if( self.armLeft ){
    data_mech_setup_part( self.armLeft );
  }
  if( self.armRight ){
    data_mech_setup_part( self.armRight );
  }
  if( self.legs ){
    data_mech_setup_part( self.legs );
  }
  self.deadflag = DEAD_NO;
  self.critBits = 0;
  maxSave = self.maxs;
  minSave = self.mins;
  setmodel(self, "q3mdl/testball.md3");
  self.takedamage = DAMAGE_AIM;
  self.alpha = 0.001;
  self.scale = 0.001;
  setsize(self, minSave, maxSave);
  sendent_ini_interpolate();
  sendent_setup_weapons();
  self.solid = SOLID_BBOX;
};

void( entity setPart ) data_mech_setup_part={
  setPart.skin = setPart.owner.skin;
  setmodel(setPart, setPart.model);
  setPart.origin = self.origin + (v_right * setPart.compOffset_x) + (v_forward * setPart.compOffset_z) + (v_up * setPart.compOffset_y);
  setPart.angles = self.angles;
  setorigin(setPart, setPart.origin);
  setPart.drawmask = MASK_ENGINE;
};