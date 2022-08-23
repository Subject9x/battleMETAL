/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced buildings.
*/


void() building_anim_death_norm9={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  
};
void() building_anim_death_norm8={
  
  self.think = building_anim_death_norm9;
  self.nextthink = time + 0.1*frametime;
};
void() building_anim_death_norm7={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
  if( self.vec_size > 2 ){
    self.think = building_anim_death_norm8;
    self.nextthink = time + 0.1*frametime;
  }
};
void() building_anim_death_norm6={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
  
  self.think = building_anim_death_norm7;
  self.nextthink = time + 0.1*frametime;
};

void() building_anim_death_norm5={

  self.think = building_anim_death_norm6;
  self.nextthink = time + 0.1*frametime;
};

void() building_anim_death_norm4={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
  if( self.vec_size > 1 ){
    self.think = building_anim_death_norm5;
    self.nextthink = time + 0.1*frametime;
  }
};
void() building_anim_death_norm3={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
  self.think = building_anim_death_norm4;
  self.nextthink = time + 0.1*frametime;
};


void() building_anim_death_norm2={

  self.think = building_anim_death_norm3;
  self.nextthink = time + 0.1*frametime;
};

void() building_anim_death_norm1={
  local vector vfx;
  makevectors(self.angles);
  vfx = self.origin + (v_up * (self.maxs_z * 0.5)) + (v_forward * self.maxs_y) + (v_right * (crandom() * (self.maxs_x * 0.25)));

  te_missile_explode( vfx, 1, '1 0.67 0.67', 0.01 );
  
  building_sound_explode();
  
  self.think = building_anim_death_norm2;
  self.nextthink = time + 0.1*frametime;
};


void() sendent_building_settle={
  self.solid = SOLID_BSP;
  self.movetype = MOVETYPE_NONE;
  setsize(self, self.mins, self.maxs);
  self.cache_mins = self.mins;
  self.cache_maxs = self.maxs;
};


/*
  client_main.CSQC_ent_update()->Ent Type == building, SENDFLAG_NEWENT
  scope = self
  self is building
*/
void( float dataID ) data_sync_new_building={
  
  makevectors(self.angles);
  
  self.colormod = '1 1 1';
  self.scale = 1.0;
  self.alpha = 1.0;
  self.angle = self.angles_y; //compatability for SVQC
  
  switch(dataID){
    case UI_BUILDING_radar:
      building_radar();
      break;
    case UI_BUILDING_shield_generator:
      building_shield();
      break;
    case UI_BUILDING_power_plant:
      building_power();
      break;
    case UI_BUILDING_hangar_large:
      building_hangar_mech();
      break;
    case UI_BUILDING_fuel_tank:
      building_fuel_tank();
      break;
    case UI_BUILDING_repair_bay:
      building_repair_bay();
      break;
    case UI_BUILDING_hangar_med:
      building_hangar_vehicle();
      break;
    case UI_BUILDING_guard_tower:
      data_building_guard();
      break;
    case UI_BUILDING_barracks:
      building_barracks();
      break;
    case UI_BUILDING_supply_depot:
      building_supply_depot();
      break;
  }
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if( self.th_walk ){
    self.th_walk();
  }
  self.think = sendent_building_settle;
  self.nextthink = time + 0.01;
};

void() data_building_radar={
  building_radar();
  self.th_walk = radar_post_th;
  self.th_die = radar_post_die1;
  self.render_dlights = radar_post_dlights;
  self.compOffset = self.origin + (v_up * 38) + (v_forward * -15) + (v_right * 18); //dlight origin
  self.partTypeId = 0;  //dlight style
  self.compAltOffsetCache = '0 0 0';  //dlight color
  
};

void() data_building_shield={
  building_shield();
  self.th_die = shield_gen_die1;
  self.th_walk = shield_gen_active;
  //local vfx
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * self.mins_x) + (v_forward * self.mins_y);
  self.compAltOffset = self.origin + (v_up * self.maxs_z) + (v_right * (self.mins_x * 0.15)) + (v_forward * (self.mins_y * 0.15));
};

void() data_building_power={
  //FIXME
  building_power();
  self.th_die = power_plant_die1;
  self.th_walk = power_plant_active;
  //local vfx - green ball
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.8)) + (v_right * self.mins_x * 0.85) + (v_forward * (self.mins_y * 0.65));
  self.compAltOffset = self.origin + (v_up * (self.maxs_z * 0.85)) + (v_right * (self.mins_x * 0.67)) + (v_forward * (self.mins_y * 0.45));
  //local vfx - blue vent front
  self.wepFireOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.maxs_y * 0.9);
  self.wepFireOffsetCache = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.maxs_y * 0.9);
  //local vfx - blue vent front
  self.cockpitOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * 0) + (v_forward * self.mins_y * 0.9);
  self.w_adj_ang = self.origin + (v_up * (self.maxs_z * 0.45)) + (v_right * (self.maxs_x * 0.25)) + (v_forward * self.mins_y * 0.9);
};

void() data_building_fuel={
  building_fuel_tank();
  self.deadflag = DEAD_NO; 
  self.th_die = fuel_tank_die1;
};

void() data_building_repair={   
  building_repair_bay();
  self.th_walk = repair_bay_active;
  self.th_die = repair_bay_die1;
  self.render_dlights = repair_bay_dlights;
  self.w_firetime = 0;
  self.compOffset = self.origin + (v_up * 40) + (v_forward * -16);
  self.compAltOffset = self.origin;
};

void() data_building_guard={
  building_guard_tower();
  self.th_walk = guard_post_th;
  self.th_die = guard_post_die1;
  self.render_dlights = guard_post_dlights;
  self.compOffset = self.origin + (v_up * 36);
  self.w_adj_ang =  self.angles;
};

/*
  ANIMATION - Death
*/
void() data_building_death1={

  te_missile_explode( self.origin + (v_up * self.maxs_z), self.vec_size + 1, '0.9 0.67 0.33', 0.01 ) ;
  
  self.think = data_building_death2;
  self.nextthink = time + (0.1 * frametime);
};

void() data_building_death2={
  
  building_sound_explode();
  
  self.think = data_building_death1;
  self.nextthink = time + (0.1 * frametime);
};

void() data_building_death_end={
};


void() building_floor_th={
  local vector checkOrg;
  
  makevectors(self.owner.angles);
  checkOrg = self.owner.origin + (v_up * self.owner.mins_z);
  
  if( self.origin != checkOrg ){
    self.origin = checkOrg;
  }
  
  self.think = building_floor_th;
  self.nextthink = time + 1;
};


void() building_sound_explode={
  local float sizeMod;
  
  sizeMod = self.vec_size / 10;
  sizeMod = 1.0 - (1.0 - (sizeMod * 2) / 2);
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (sizeMod + (random() * sizeMod)) * 90, 0 );
};




/*
  Taken from server, this should be clientside too.
*/
void() data_building_generate_foundation={
  local vector v;
  local entity foundation;
  local entity notSelf;
  
  foundation = spawn();
  foundation.owner = self;
  
  makevectors(self.angles);
  v = self.origin + (v_up * self.mins_z);
  
  notSelf = self;
  self = foundation;
    self.classname = "map_terrain";
    switch( notSelf.vec_size ){
      case 1:
        self.model = "q3mdl/map/plats/plat_small.obj";
        break;
      case 2:
        self.model = "q3mdl/map/plats/plat_medium.obj";
        break;
      case 3:
        self.model = "q3mdl/map/plats/plat_large.obj";
        break;
    }
    self.solid = SOLID_NOT; //just for placement
    self.movetype = MOVETYPE_NONE;
    setmodel( self, self.model );
    setsize(self, self.mins, self.maxs);
    setorigin(self, v);
    self.solid = SOLID_BSP; //lock it in.
    self.drawmask = MASK_NORMAL;
  self = notSelf;
};
