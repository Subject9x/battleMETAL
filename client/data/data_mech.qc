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
  
  self.deadflag = DEAD_NO;
  self.critBits = 0;
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
  
  if( (self.unitModFlags & MOD_MODEL_ROOT_TOR_C) ){
    setmodel(self, self.model);
  }
  else{
    setmodel(self, self.torC_mdl);
  }
  
  self.takedamage = DAMAGE_AIM;
  setsize(self, self.cache_mins, self.cache_maxs);
  sendent_ini_interpolate();
  
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