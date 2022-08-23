/*
battleMETAL
Author: Peter Roohr
Date: 11/17/2020
Overview: 
  modelindex appears to be unreliable, and why bind the client and server so tightly?
  
*/

void() model_misc_building_set={
  
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_BSP;
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
  setsize(self, self.mins, self.maxs);
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
void() misc_build_die8={

  local vector xOrg;
  xOrg_x = (crandom() * self.maxs_x) * (random() * 0.5);
  xOrg_y = (crandom() * self.maxs_y) * (random() * 0.5);
  xOrg_z = (crandom() * self.maxs_z) * (random() * 0.5);
  te_missile_explode( self.origin + xOrg, self.vec_size, CLR_DEF_RED, 0.01 );
  
  model_misc_building_ruins_set();
  pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
  self.origin = self.origin;
  self.solid = SOLID_NOT;
};
void() misc_build_die7={
  
  self.think  = misc_build_die8;
  self.nextthink = time + 0.25;
};
void() misc_build_die6={
  local vector xOrg;
  xOrg_x = (crandom() * self.maxs_x) * (random() * 0.5);
  xOrg_y = (crandom() * self.maxs_y) * (random() * 0.5);
  xOrg_z = (crandom() * self.maxs_z) * (random() * 0.5);
  te_missile_explode( self.origin + xOrg, self.vec_size, CLR_DEF_RED, 0.01 );
  
  if( self.vec_size > 2 ){
    self.think = misc_build_die7;
  self.nextthink = time + 0.25;
  }
  else{
    model_misc_building_ruins_set();
    pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    self.origin = self.origin;
    self.solid = SOLID_NOT;
  }
};

void() misc_build_die5={
  
  self.think = misc_build_die6;
  self.nextthink = time + 0.25;
};

void() misc_build_die4={
  local vector xOrg;
  xOrg_x = (crandom() * self.maxs_x) * (random() * 0.5);
  xOrg_y = (crandom() * self.maxs_y) * (random() * 0.5);
  xOrg_z = (crandom() * self.maxs_z) * (random() * 0.5);
  te_missile_explode( self.origin + xOrg, self.vec_size, CLR_DEF_RED, 0.01 );
  
  self.think = misc_build_die5;
  self.nextthink = time + 0.25;
};
void() misc_build_die3={
  
  if( self.vec_size > 1 ){
    self.think = misc_build_die4;
  self.nextthink = time + 0.25;
  }
  else{
    model_misc_building_ruins_set();
    pointsound(self.origin + (v_up * self.maxs_z * 0.67), "sound/fire/debris1.ogg", 0.33 + (random() * 0.67) , ATTN_NORM);
    self.origin = self.origin;
    self.solid = SOLID_NOT;
  }
};

void() misc_build_die2={
  local vector xOrg;
  xOrg_x = (crandom() * self.maxs_x) * (random() * 0.5);
  xOrg_y = (crandom() * self.maxs_y) * (random() * 0.5);
  xOrg_z = (crandom() * self.maxs_z) * (random() * 0.5);
  te_missile_explode( self.origin + xOrg, self.vec_size, CLR_DEF_RED, 0.01 );
  
  self.think = misc_build_die3;
  self.nextthink = time + 0.25;
};

void() misc_build_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  
  self.think = misc_build_die2;
  self.nextthink = time + 0.25;
};

void() model_misc_building_die={
    cons_logAFloat("model_misc_building_die!?", self.deadflag);  //debug
  local vector xOrg;
  xOrg_x = (crandom() * self.maxs_x) * (random() * 0.5);
  xOrg_y = (crandom() * self.maxs_y) * (random() * 0.5);
  xOrg_z = (crandom() * self.maxs_z) * (random() * 0.5);
  te_missile_explode( randompos(self.origin + self.mins, self.origin + self.maxs), self.vec_size, CLR_DEF_RED, 0.01 );
  
  if(self == CLIENT_target_ent){
    hud_event_enqueue( HUD_EVENT_TARGET_KILLED, 1) ;
  }
  
  self.think = misc_build_die1;
  self.nextthink = time + 0.25;
};