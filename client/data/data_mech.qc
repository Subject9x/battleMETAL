/*
battleMETAL
Author: Peter Roohr
Date: 03/18/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/


void( float dataID ) data_sync_new_mech_ai={
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

};

void() data_mech_balaket={
  
};

void() data_mech_matok={
  

};

void() data_mech_monitor={
  

};

void( entity setPart ) data_mech_setup_part={
  setPart.skin = setPart.owner.skin;
  setmodel(setPart, setPart.model);
  setPart.origin = self.origin + (v_right * setPart.compOffset_x) + (v_forward * setPart.compOffset_z) + (v_up * setPart.compOffset_y);
  setPart.angles = self.angles;
  setorigin(setPart, setPart.origin);
  setPart.drawmask = MASK_NORMAL;
};