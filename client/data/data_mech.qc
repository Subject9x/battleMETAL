/*
battleMETAL
Author: Peter Roohr
Date: 03/18/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/


void( float dataID ) data_sync_new_mech_ai={
  local vector maxSave, minSave;
  
  setorigin(self, self.origin);
    
  initialize_data_mech_(dataID);

  self.data_type = DATA_MECH;
  self.skin =  self.faction - 1;
  self.movetype = MOVETYPE_STEP;
    
  makevectors(self.angles);
  if( self.torsoCenter ){
    data_mech_setup_part( self.torsoCenter );
  }
  if( (self.unitModFlags & MOD_HAS_TOR_L) && self.torsoLeft ){
    data_mech_setup_part( self.torsoLeft );
  }
  if( (self.unitModFlags & MOD_HAS_TOR_R) && self.torsoRight ){
    data_mech_setup_part( self.torsoRight );
  }
  if( (self.unitModFlags & MOD_HAS_ARM_L) && self.armLeft ){
    data_mech_setup_part( self.armLeft );
  }
  if( (self.unitModFlags & MOD_HAS_ARM_R) && self.armRight ){
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
  if( (self.flags & FL_CLIENT) ){
    self.solid = SOLID_BBOX;
  }
  else{
    self.solid = SOLID_SLIDEBOX;
  } 
  self.interpolate_entity = interpolate_mech_ai;
  self.drawmask = MASK_ENGINE;
  self.predraw = predraw_mech_ai;
  self.canTarget = TRUE;
  if( !self.ai_muted ){
    ai_voice_ini( TRUE );
    self.ai_voice_limit = 1;
  }
};

void( entity setPart ) data_mech_setup_part={
  setPart.skin = setPart.owner.skin;
  setmodel(setPart, setPart.model);
  setPart.origin = self.origin + (v_right * setPart.compOffset_x) + (v_forward * setPart.compOffset_z) + (v_up * setPart.compOffset_y);
  setPart.angles = self.angles;
  setorigin(setPart, setPart.origin);
	setPart.drawmask = MASK_NORMAL;
};