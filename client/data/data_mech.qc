/*
battleMETAL
Author: Peter Roohr
Date: 03/18/2020
Overview: 
  CSQC-side ini function for synced vehicles.
*/


void( float dataID ) data_sync_new_mech_ai={

  initialize_data_mech_(dataID);

  self.data_type = DATA_MECH;
  self.skin =  self.faction - 1;
  self.movetype = MOVETYPE_STEP;
  self.solid = SOLID_SLIDEBOX;
  self.takedamage = DAMAGE_AIM;
    
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
  
  setsize(self, self.cache_mins, self.cache_maxs);
  setorigin(self, self.origin);
  sendent_ini_interpolate();
  

  self.interpolate_entity = interpolate_mech_ai;
  self.predraw = predraw_mech_ai;
  self.canTarget = TRUE;
  if( !self.ai_muted ){
    ai_voice_ini( TRUE );
    self.ai_voice_limit = 1;
  }
  
  self.legs_frame = 0;
  self.legs_nextthink = self.legs_frame1time = self.legs_frame2time = time + 0.1;
  if( !self.unit_legs ){
    self.unit_legs = spawn();
    self.unit_legs.skin = self.skin;
  }
};