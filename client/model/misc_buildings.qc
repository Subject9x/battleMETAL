/*
battleMETAL
Author: Peter Roohr
Date: 11/17/20200
Overview: 
  modelindex appears to be unreliable, and why bind the client and server so tightly?
  
*/

void() model_misc_building_set={
  
  self.movetype = MOVETYPE_NONE;
  switch( self.data_idx ){
    default:
      //building_misc_apartment
      setmodel(self, "q3mdl/buildings/misc/misc_apt_sm.obj");
      break;
    case 2:
      //building_misc_factory_med
      setmodel(self, "q3mdl/buildings/misc/misc_fact_med.obj");
      break;
    case 3:
      //building_misc_lodge
      setmodel(self, "q3mdl/buildings/misc/misc_lodge.obj");
      break;
    case 4:
      //building_misc_off_pyra
      setmodel(self, "q3mdl/buildings/misc/misc_off_pyramid.obj");
      break;
    case 5:
      //building_misc_off_large
      setmodel(self, "q3mdl/buildings/misc/misc_off_large.obj");
      break;
    case 6:
      //building_misc_off_small
       setmodel(self, "q3mdl/buildings/misc/misc_off_sm.obj");
      break;
    case 7:
      //building_misc_fact_steam
      setmodel(self, "q3mdl/buildings/misc/misc_fact_steam.obj");
      break;
    case 8:
      //building_misc_apt_larg
      setmodel(self, "q3mdl/buildings/misc/misc_apt_larg.obj");
      break;
  }
  setorigin(self, self.origin);
};


void() model_misc_building_ruins_set={
  self.scale = 1;
  self.alpha = 1;
  self.colormod = '1 1 1' * (random() * 0.5);
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;

  switch(self.vec_size){
    case 2:
      setmodel( self, "q3mdl/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel( self, "q3mdl/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel( self, "q3mdl/map/ruins/ruin_small.obj");
      break;
  }
  
  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
};

/*
  EVENT - Death
*/
void() model_misc_building_die={
  local float zmid;
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  self.solid = SOLID_NOT; //make sure to override so that particles won't trip.
  self.scale = 1; //just in case you altered scale during other deaths anim, <cough>
  self.alpha = 1; //just in case you altered alpha during other deaths anim, <cough>
  self.colormod = '1 1 1' * (random() * 0.5);
  
  switch( self.vec_size ){
    case 2:
      setmodel(self, "q3mdl/map/ruins/ruin_medium.obj");
      break;
    case 3:
      setmodel(self, "q3mdl/map/ruins/ruin_large.obj");
      break;
    default:
      setmodel(self, "q3mdl/map/ruins/ruin_small.obj");
      break;
  }
  
  sendent_handle_remove(self.effect1);
  sendent_handle_remove(self.effect2);
  sendent_handle_remove(self.effect3);
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  self.think = SUB_Null;
  self.nextthink = time + 0.01;
};