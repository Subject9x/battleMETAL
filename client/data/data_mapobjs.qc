/*
battleMETAL
Author: Peter Roohr
Date: 03/13/2020
Overview: 
  CSQC-side ini function for synced map objects    
    + objective entities.
    + nav points.
    + deploy points.
    + hazard zones.
    
*/

void( float isNew, float entFlags ) sendent_handle_map={

  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  
  self.data_type = ReadByte();
  self.data_idx = ReadByte();
  switch( self.data_type ){
    case DATA_NAVP:
      data_nav_point( isNew, entFlags );
      break;
    case DATA_OBJT:
      data_objective( isNew, entFlags );
      break;
    case DATA_DEPL:
      data_deploy( isNew, entFlags );
      break;
    case DATA_MAP_OBJ:
      //data_objective( isNew, entFlags );
      break;
  }
};

float() predraw_navpoint={
  self.angles_y = anglemod(self.angles_y + 0.33);
  setorigin(self, self.origin);
  return TRUE;
};

void( float isNew, float entFlags ) data_nav_point={
  local float prevState;
  self.faction = ReadByte();
  
  prevState = self.isActive;
  self.isActive = ReadByte();
  
  if( (prevState == TRUE) && (self.isActive == 2) ){
    //previous state was 'active unvisit' and next state is 'active and visit'
    //play sound
    //
    hud_event_enqueue( HUD_EVENT_NAV_REACHED, 1 );  
    self.alpha = 0.2;
    self.colormod = '0.15 0.15 0.15';
    self.effects = self.effects - ( self.effects & (EF_DOUBLESIDED | EF_NOSHADOW | EF_FULLBRIGHT | EF_NODEPTHTEST)); 
  }
  if( (prevState == 2) && (self.isActive == 1) ){
    //previous state was 'active and visit' and next state is 'active unvisit'
    //ignore state change for this client
    return;
  }
  
  if( entFlags & SENDFLAG_MOVE ){
    setorigin(self, self.origin);
  }
  
  if( isNew ){
    if( MENU_NAV_LIST ){
      MENU_NAV_LIST.partNext = self;
      self.partPrev = MENU_NAV_LIST;
      MENU_NAV_LIST = self;
    }
    else{
      MENU_NAV_LIST = self;
    }
  
    self.effects = self.effects | (EF_DOUBLESIDED | EF_NOSHADOW | EF_NODEPTHTEST | EF_FULLBRIGHT);
    self.alpha = 0.33;
    self.colormod = '0 1 0';
    self.vec_name = NAVNAMES[self.data_idx];
    setmodel(self, "q3mdl/map/nav_point.obj");
    setsize( self, '-32 -32 -75', '32 32 1' ); // this is to make sure nav points
    setorigin( self, self.origin );                   // end up somewhere a player can reach
    self.movetype = MOVETYPE_FLY;
    droptofloor();
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_TRIGGER;
    setorigin(self, self.origin);
    self.predraw = predraw_navpoint;
    self.drawmask = MASK_NORMAL; 
  }
};

void( float isNew, float entFlags ) data_objective={
  local float prevState;
  local float type;
  
  self.faction = ReadByte();
  
  prevState = self.isActive;
  self.isActive = ReadByte();
  OBJECTIVES[self.data_idx] = self.isActive;
  
  type = ReadByte();  // Primary, secondary, tertiary objective

  if( isNew ){
    setmodel(self, "q3mdl/testball.md3");
    setorigin(self, self.origin);
    self.alpha = 0.01;
    self.drawmask = MASK_ENGINE;
  }
  else{
    //objective has been won
    if( self.faction == CLIENT_faction ){
      if( (prevState == OBJECTIVE_ACTIVE) && (self.isActive == OBJECTIVE_WIN) ){
        switch( type ){
          case 1:
            hud_event_enqueue( HUD_EVENT_OBJECTIVE_COMPLETE_PRIME, 1 ); 
            break;
          case 2:
            hud_event_enqueue( HUD_EVENT_OBJECTIVE_COMPLETE_SECOND, 1 ); 
            break;
          case 3:
            hud_event_enqueue( HUD_EVENT_OBJECTIVE_COMPLETE_SECOND, 1 ); 
            break;
        }
        return;
      }
      //objective has been failed
      if( (prevState == OBJECTIVE_ACTIVE) && (self.isActive == OBJECTIVE_FAIL) ){
        hud_event_enqueue( HUD_EVENT_OBJECTIVE_FAILED, 1 ); 
      }
      return;
    }
  }
};

void( float isNew, float entFlags ) data_deploy={
  local float prevState;
  self.faction = ReadByte();
  
  prevState = self.isActive;
  self.isActive = ReadByte();

  if( isNew ){
    if( cvar("developer") ){
      self.alpha = 0.9;
      self.scale = 1;
    }
    else{
      self.alpha = 0.01;
      self.scale = 0.01;
    }
    
    setmodel(self, "q3mdl/testball.md3");
    setorigin(self, self.origin);
    if( DEPLOY_POINTS ){
      self.partPrev = DEPLOY_POINTS;
      DEPLOY_POINTS.partNext = self;
      DEPLOY_POINTS = self;
    }
    else{
      //first deploy point received.
      DEPLOY_POINTS = self;
      DEPLOYPOINT = self;
    }
    self.drawmask = MASK_NORMAL;
  }
  
};

float() predraw_damage={
  
  return TRUE;
};


void() map_damage_zone_particles_shields={
  local vector velocityOffset, particleOffset;
  
  velocityOffset = self.dest + (v_up * 16);
  te_particlerain( self.absmin, self.absmax, normalize(velocityOffset - self.dest) * 50, floor(self.compAltOffset_x / self.count), 244); 

  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.compAltOffset_x;
    particleOffset_z = crandom() * self.compAltOffset_y;
    particleOffset_y = random() * (self.compAltOffset_z * 0.25);
    
    particleOffset = self.dest + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    if( random() < 0.8){
      te_field_mineral(particleOffset, normalize(velocityOffset - self.dest) * 25, 5);
    }
    
    te_field_mineral_light(particleOffset, 1);
    if( self.compAltOffset_x > 128){
      te_field_mineral_light(particleOffset, 1);
      if( self.compAltOffset_x > 256){
        te_field_mineral_light(particleOffset, 1);
        if( self.compAltOffset_x > 512){
          te_field_mineral_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_particles_armor={
  local vector velocityOffset, particleOffset;
  
  velocityOffset = self.dest + (v_up * 16);
  te_particlecube( self.absmin, self.absmax, normalize(velocityOffset - self.dest) * 5, floor(self.compAltOffset_x / self.count), 176, FALSE, 1); 

  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.compAltOffset_x;
    particleOffset_z = crandom() * self.compAltOffset_y;
    particleOffset_y = random() * (self.compAltOffset_z / 2);
    
    particleOffset = self.dest + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    if( random() < 0.2){
      te_field_rad(particleOffset, normalize(velocityOffset - self.dest) * 4, 1);
    }
    te_field_rad_light(particleOffset, 1);
    if( self.compAltOffset_x > 256){
      te_field_rad_light(particleOffset, 1);
      if( self.compAltOffset_x > 512){
        te_field_rad_light(particleOffset, 1);
        if( self.compAltOffset_x > 1024){
          te_field_rad_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_particles_energy={
  local vector velocityOffset, particleOrigin, particleOffset;
  
  velocityOffset = self.dest + (v_up * 2);
  te_particlecube( self.absmin, self.absmax, '0 0 0', floor(self.compAltOffset_x / self.count), 128, FALSE, 10); 
  
  if( time > self.count1 ){
    self.count1 = time + (random() * 0.5);
    
    particleOffset_x = crandom() * self.compAltOffset_x;
    particleOffset_z = crandom() * self.compAltOffset_y;
    particleOffset_y = random() * (self.compAltOffset_z / 2);
    
    particleOffset = self.dest + (v_right * particleOffset_x) + (v_forward * particleOffset_z) + (v_up * particleOffset_y);
    
    if( random() <= 0.8 ){
      particleOrigin_x = crandom() * self.compAltOffset_x;
      particleOrigin_z = crandom() * self.compAltOffset_y;
      particleOrigin_y = random() * self.compAltOffset_z;
      particleOrigin = self.dest + (v_right * particleOrigin_x) + (v_forward * particleOrigin_z) + (v_up * particleOrigin_y);
      te_field_quantum(particleOffset, particleOrigin);
    }
    
    te_field_quantum_light(particleOffset, 1);
    if( self.compAltOffset_x > 256){
      te_field_quantum_light(particleOffset, 1);
      if( self.compAltOffset_x > 512){
        te_field_quantum_light(particleOffset, 1);
        if( self.compAltOffset_x > 1024){
          te_field_quantum_light(particleOffset, 1);
        }
      }
    }
  }
};

void() map_damage_zone_think={
  
  makevectors(self.angles);
  if( (self.damageType & 1) )
    map_damage_zone_particles_shields();
  
  if( (self.damageType & 2) )
    map_damage_zone_particles_armor();
  
  if( (self.damageType & 4) )
    map_damage_zone_particles_energy();
  
  if( (self.spawnflags & 8) ){
    //spawnflags 8 = remove after first lifetime countdown
    self.think = SUB_Remove;
    self.nextthink = time + 0.001;
    return;
  }
  
  if( (self.spawnflags & 4) ){
    //reactivate damage zone after timer
    self.think = map_damage_zone_cool;
    self.nextthink = time + self.wait;
    return;
  }
  
  //otherwise do nothing else
  self.think = map_damage_zone_think;
  self.nextthink = time + 0.1;
};

void() map_damage_zone_cool={
  self.isActive = TRUE;
  if( (self.spawnflags & 2) ){
    self.think = map_damage_zone_think;
    self.nextthink = time + self.data_lifetime;
  }
};

void( float isNew, float entFlags ) data_map_damage={
  local vector min, max;
  local float funcFlag;
  self.mins = te_read_vector();
  self.maxs = te_read_vector();
  if( isNew ){
    self.damageValue = ReadByte();
    self.damageType = ReadByte();
    self.spawnflags = ReadByte();
    self.count = ReadByte();
    self.count1 = ReadByte();
    self.compAltOffset = te_read_vector();
    
    self.solid = SOLID_TRIGGER;
    self.movetype = MOVETYPE_NONE;
    self.alpha = 0.01;
    self.colormod = '0 0 0';
    
    funcFlag = ReadByte();
    if( funcFlag ){
      setmodel( self, modelnameforindex(ReadByte()));
      setsize(self, self.mins, self.maxs);
    }
    else{
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, self.mins, self.maxs);
    }
    setorigin(self, self.origin);
    self.think = map_damage_zone_think;
    self.nextthink = time + 0.1;
    self.drawmask = MASK_ENGINE;
  }
};
