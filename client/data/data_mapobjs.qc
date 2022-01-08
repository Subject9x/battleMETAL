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
  
  self.data_type = ReadByte();
  switch( self.data_type ){
    case DATA_NAVP:
      data_nav_point( isNew, entFlags );
      break;
    case DATA_PCL_CUBE:
      data_particle_cube_meta( isNew, entFlags );
      break;
    case DATA_OBJT:
      data_objective( isNew, entFlags );
      break;
    case DATA_DEPL:
      data_deploy( isNew, entFlags );
      break;
    case DATA_MAP_DMG:
      data_map_damage( isNew, entFlags );
      break;
    case DATA_MAP_RULES:
      world_rules_readEntity( isNew, entFlags);
      break;
  }
};

void() predraw_navpoint={
  if( self.faction != CLIENT_faction ){
    self.alpha = 0;
    self.effects = 0;
    self.scale = 0.01;
  }
  else{
    self.effects = self.effects | (EF_DOUBLESIDED | EF_NOSHADOW | EF_NODEPTHTEST | EF_FULLBRIGHT);
    self.angles_y = anglemod(self.angles_y + 0.025);
    self.alpha = 0.2;
    self.scale = 1;
  }
};

/*
  OBJECT - Nav Point
*/
void( float isNew, float entFlags ) data_nav_point={
  local float prevState;
  
  //EVENT - Nav isActive change
  if( (entFlags & SENDFLAG_TURRET) ){
    prevState = self.isActive;
    self.isActive = ReadByte();
  }
  
  //EVENT - Nav Set Origin
  if( (entFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  //EVENT - Nav Change Faction
  if( (entFlags & SENDFLAG_CRIT) ){
    self.faction = ReadByte();
    if( CLIENT_faction != self.faction ){
      self.effects = self.effects - (self.effects & (EF_NODEPTHTEST | EF_FULLBRIGHT | EF_DOUBLESIDED));
      self.alpha = 0;
    }
    else{
      self.alpha = 0.33;
      self.effects = self.effects | (EF_NODEPTHTEST | EF_FULLBRIGHT);
    }
  }
  
  //EVENT - new to player
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
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
    
    self.vec_name = NAVNAMES[self.data_idx];
    setmodel(self, "q3mdl/map/nav_point.obj");
    setsize( self, '-32 -32 -75', '32 32 1' ); // this is to make sure nav points
    setorigin( self, self.origin ); 
    setorigin(self, self.origin);
    self.effects = self.effects | (EF_DOUBLESIDED | EF_NOSHADOW | EF_NODEPTHTEST | EF_FULLBRIGHT);
    self.predraw = predraw_navpoint;
    self.colormod = '0 1 0';
    self.drawmask = MASK_ENGINE;
  }
  //HANDLE - nav point reched?
  if( (prevState == TRUE) && (self.isActive == 2) ){
    //previous state was 'active unvisit' and next state is 'active and visit'
    //play sound
    hud_event_enqueue( HUD_EVENT_NAV_REACHED, 1 );  
    self.alpha = 0.2;
    self.colormod = '0.15 0.15 0.15';
    self.effects = self.effects - ( self.effects & (EF_DOUBLESIDED | EF_NOSHADOW | EF_FULLBRIGHT | EF_NODEPTHTEST)); 
  }
  if( (prevState == 2) && (self.isActive == 1) ){
    //previous state was 'active and visit' and next state is 'active unvisit'
    //ignore state change for this clients
  }  
};


entity( float objId ) data_objective_find={
  local entity t;
  local entity e;
  for( t = nextent(world); t != world; t = nextent(t) ){
    if( t.data_type != DATA_OBJT ){
      continue;
    }
    if( t.data_idx != objId ){
      continue;
    }
    e = t;
  }
  
  return e;
};

/*
  OBJECT - Mission Objective
*/
void( float isNew, float entFlags ) data_objective={
  local float prevState;
  
  prevState = self.isActive;
 //EVENT - isActive change
  if( (entFlags & SENDFLAG_TURRET) ){
    self.isActive = ReadByte();
    self.aState = ReadByte();
    OBJECTIVES[self.data_idx] = self.isActive;
  }
  
  //EVENT - Set Origin
  if( (entFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  //EVENT - Change Faction
  if( (entFlags & SENDFLAG_CRIT) ){
    self.faction = ReadByte();
  }
  
  //EVENT - new to player
  if( entFlags & SENDFLAG_NEWENT ){
    self.data_idx = ReadByte();
    self.data_type = DATA_OBJT;
  }
  
  if( isNew ){
    self.effects = self.effects | (EF_NODEPTHTEST | EF_NOSHADOW);
    setmodel(self, "q3mdl/testball.md3");
    setorigin(self, self.origin);
    self.alpha = 0.01;
  }
  //HANDLE EVENT - objective status
  if( self.faction == CLIENT_faction ){
    if( (prevState == OBJECTIVE_ACTIVE) && (self.isActive == OBJECTIVE_WIN) ){
      switch( self.aState ){
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
    }
    //objective has been failed
    if( (prevState == OBJECTIVE_ACTIVE) && (self.isActive == OBJECTIVE_FAIL) ){
      hud_event_enqueue( HUD_EVENT_OBJECTIVE_FAILED, 1 );
    }
  }
};


/*
  Reorganize client's deploy point list
*/
void( entity dep , float prevFac ) data_deploy_changeFaction={
  
  //deploy point was removed from player's deploy queue
  if( prevFac == CLIENT_faction && dep.faction != CLIENT_faction ){
    if( dep.prevPoint.data_idx ){
      dep.prevPoint.nextPoint = dep.nextPoint;
      dep.nextPoint.prevPoint = dep.prevPoint;
    }
    else{
      FACTION_DEPLOY = dep.nextPoint;
    }
    return;
  }
  
  //deploy point was added to player's queue
  if( prevFac != CLIENT_faction && dep.faction == CLIENT_faction ){
    if(FACTION_DEPLOY){
      FACTION_DEPLOY.prevPoint = dep;
      dep.nextPoint = FACTION_DEPLOY;
      FACTION_DEPLOY = dep;
    }
    else{
      FACTION_DEPLOY = dep;
    }
  }
};

/*
  OBJECT - Deploy Point
*/
void( float isNew, float entFlags ) data_deploy={
  local float prevState;
  local float prevFaction;
  
  prevState = self.isActive;
  prevFaction = self.faction;
 //EVENT - isActive change
  if( (entFlags & SENDFLAG_TURRET) ){
    self.isActive = ReadByte();
  }
  
  //EVENT - Set Origin
  if( (entFlags & SENDFLAG_MOVE) ){
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  
  //EVENT - Change Faction
  if( (entFlags & SENDFLAG_CRIT) ){
    self.faction = ReadByte();
    if( prevFaction != self.faction && self.faction != FACTION_ALL ){
      data_deploy_changeFaction(self, prevFaction);
    }
  }
  
  //EVENT - new to player
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
  }
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
    if( DEPLOY_POINTS.data_idx ){
      DEPLOY_POINTS.partNext = self;
      self.partPrev = DEPLOY_POINTS;
      DEPLOY_POINTS = self;
    }
    else{
      //first deploy point received.
      DEPLOY_POINTS = self;
      DEPLOYPOINT = self; //first
    }
  }
};


/*
  OBJECT - Weather Data
*/
//void( float isNew, float entFlags ) data_weather;


/*
  OBJECT - Damage Zone
*/
void() map_hazard_rad_dlights={
  makevectors(self.angles);
  //adddynamiclight2( self.origin + (v_up * (self.maxs_z * 0.85)), 25, '0.8 0.8 0', 0, "", 0);
};
void() map_hazard_stat_dlights={
  makevectors(self.angles);
  //adddynamiclight2( self.origin + (v_up * (self.maxs_z * 0.85)), 33, '0 1 0.8', 0, "", 0);
};

void() hazard_rad_think={
  local vector partclPoint;
  local vector adj;
  local vector rando;
  
  makevectors(self.angles);  
  
  adj = self.origin;
  adj = adj + (v_up * (self.maxs_z * 0.15));
  
  rando = randomvec();
  partclPoint = self.origin;
  partclPoint = partclPoint + (v_up * (self.maxs_z * 0.5));
  partclPoint_x = partclPoint_x + (self.maxs_x * rando_x);
  partclPoint_y = partclPoint_y + (self.maxs_x * rando_y);
  
  if( random() > 0.9 ){
    te_field_rad(partclPoint, normalize((partclPoint + (v_up * 5)) - self.origin) * 2, 1);
  }
  
  te_particlecube( adj + self.mins, adj + self.maxs,  normalize((self.origin + (v_up * 10)) - self.origin) * 1, 1, 176, FALSE, 5); 
   
  if( self.isActive ){
    if( vlen(pmove_org - self.origin) <= (self.maxs_x * 3) ){
      client_event_environment();
      HUD_WARN_ENV_TYPES = HUD_WARN_ENV_TYPES | 2;
    }
    self.think = hazard_rad_think;
    self.nextthink = servertime + (random() * (self.wait * 2));
  }
};

void() hazard_crs_think={
  local vector partclPoint;
  local vector adj;
  local vector rando;
  
  makevectors(self.angles);  
  
  adj = self.origin;
  adj = adj + (v_up * (self.maxs_z * 0.15));
  
  rando = randomvec();
  partclPoint = self.origin;
  partclPoint = partclPoint + (v_up * (self.maxs_z * 0.5));
  partclPoint_x = partclPoint_x + ((self.maxs_x * 2) * rando_x);
  partclPoint_y = partclPoint_y + ((self.maxs_y * 2) * rando_y);

  if( random() > 0.9 ){
    te_field_mineral(partclPoint, normalize((partclPoint + (v_up * 5)) - self.origin) * 25, 1);
  }
  
  //te_particlecube( adj + self.mins, adj + self.maxs,  normalize((self.origin + (v_up * 10)) - self.origin) * 1, 1, 244, FALSE, 15); 
   
  if( self.isActive ){
    if( vlen(pmove_org - self.origin) <= (self.maxs_x * 4) ){
      client_event_environment();
      HUD_WARN_ENV_TYPES = HUD_WARN_ENV_TYPES | 1;
    }
    self.think = hazard_crs_think;
    self.nextthink = servertime + (random() * (self.wait * 2));
  }
};


void() hazard_quant_think={
  local vector partclPoint;
  local vector adj;
  local vector rando;
  
  makevectors(self.angles);  
  
  adj = self.origin;
  adj = adj + (v_up * (self.maxs_z * 0.15));
  
  rando = randomvec();
  partclPoint = self.origin;
  partclPoint = partclPoint + (v_up * (self.maxs_z * 0.5));
  partclPoint_x = partclPoint_x + ((self.maxs_x * 2) * rando_x);
  partclPoint_y = partclPoint_y + ((self.maxs_y * 2) * rando_y);

  if( random() > 0.9 ){
    te_field_quantum( partclPoint, randompos((self.origin+self.mins), (self.origin+self.maxs)) );
  }
  //te_particlecube( adj + self.mins, adj + self.maxs, '0 0 0', random() * 4, 128, FALSE, 2); 
  
  if( self.isActive ){
    if( vlen(pmove_org - self.origin) <= (self.maxs_x * 4) ){
      client_event_environment();
      HUD_WARN_ENV_TYPES = HUD_WARN_ENV_TYPES | 4;
    }
    self.think = hazard_quant_think;
    self.nextthink = servertime + (random() * (self.wait * 2));
  }
};

/*
  Setup new damage filed
    
    dlight - Crystal - pulse in center + z height
    effects - double sided | no shadow
    
    dlight - Quantum - rando flicker
    effects - double sided | no shadow

*/
void(float dataIdx) hazard_ini_rad={
  switch( dataIdx ){
    case 2:
      self.model = "q3mdl/map/rads/rad_base_md.obj";
      setmodel(self, self.model);
      setsize( self, '-40 -40 0', '40 40 25' );
      break;
    case 3:
      self.model = "q3mdl/map/rads/rad_base_lg.obj";
      setmodel(self, self.model);
      setsize( self, '-48 -48 0', '48 48 30' );
      break;
    default:
      self.model = "q3mdl/map/rads/rad_base_sm.obj";
      setmodel(self, self.model);
      setsize( self, '-25 -25 0', '25 25 20' );
      break;
  }
  self.effects = self.effects | (EF_NOSHADOW);
  if( self.isActive ){
    self.think = hazard_rad_think;
    self.nextthink = servertime + (random() * self.wait);
    self.render_dlights = map_hazard_rad_dlights;
  }
};


void(float dataIdx) hazard_ini_static={
  switch( dataIdx ){
    case 2:
      self.model = "q3mdl/map/rads/min_base_md.obj";
      setmodel(self, self.model);
      setsize( self, '-30 -30 0', '30 30 40' );
      break;
    case 3:
      self.model = "q3mdl/map/rads/min_base_lg.obj";
      setmodel(self, self.model);
      setsize( self, '-40 -40 0', '40 40 52' );
      break;
    default:
      self.model = "q3mdl/map/rads/min_base_sm.obj";
      setmodel(self, self.model);
      setsize( self, '-20 -20 0', '20 20 25' );
      break;
  }
  self.effects = self.effects | (EF_NOSHADOW | EF_BLUE);
  if( self.isActive ){
    self.think = hazard_crs_think;
    self.nextthink = servertime + (random() * self.wait);
    self.render_dlights = map_hazard_stat_dlights;
  }
};

void(float dataIdx) hazard_ini_quant={
  switch( dataIdx ){
    case 2:
      self.model = "q3mdl/map/rads/qtm_base_md.obj";
      setmodel(self, self.model);
      setsize( self, '-30 -30 0', '30 30 40' );
      break;
    case 3:
      self.model = "q3mdl/map/rads/qtm_base_lg.obj";
      setmodel(self, self.model);
      setsize( self, '-40 -40 0', '40 40 52' );
      break;
    default:
      self.model = "q3mdl/map/rads/qtm_base_sm.obj";
      setmodel(self, self.model);
      setsize( self, '-20 -20 0', '20 20 25' );
      break;
  }
  self.effects = self.effects | EF_DOUBLESIDED;
  self.alpha = 0.75;
  if( self.isActive ){
    self.think = hazard_quant_think;
    self.nextthink = servertime + (random() * self.wait);
  }
};


void( float isNew, float entFlags ) data_map_damage={
  local float prevActive;
  local float crit;
  
  prevActive = self.isActive;
  
  if( (entFlags & SENDFLAG_BURN) ){
    //use to adjust isActive, toggling the field
    //if( self.isActive ){
      //hazard_rad_think();
    //}
  }
      
  if( (entFlags & SENDFLAG_DEAD) ){
    self.isActive = ReadByte();
    if( self.damageType == 3 ){
      self.effects = self.effects | EF_DOUBLESIDED;
    }
  }
  
  if( (entFlags & SENDFLAG_CRIT) ){
    crit = ReadByte();
    if( self.damageType == 3 ){
      self.effects = self.effects | EF_DOUBLESIDED;
    }
  }
  
  if( (entFlags & SENDFLAG_MOVE) ){
    self.origin = te_read_vector();
  }
  if( (entFlags & SENDFLAG_ANGLE) ){
    self.angles_x = anglemod(ReadAngle());
    self.angles_y = anglemod(ReadAngle());
    self.angles_z = anglemod(ReadAngle());
  }
  
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
    self.spawnflags = ReadCoord();
    self.damageType = ReadByte();
    self.alpha = ReadShort();
    self.wait = ReadCoord();
  }
  if( isNew ){
    self.drawmask = MASK_ENGINE;
    self.predraw = predraw_dmg_zone;
    self.effects = self.effects - (self.effects & EF_NODEPTHTEST);
    self.renderflags = self.renderflags - (self.renderflags & RF_DEPTHHACK);
    setorigin(self, self.origin);
    if( self.isActive ){
      self.nextthink = time + 0.1;
    }
    self.solid = SOLID_BBOX;
    switch( self.damageType ){
      case 1:
        hazard_ini_rad( self.data_idx );
        break;
      case 2:
        hazard_ini_static( self.data_idx );
        break;
      case 3:
        hazard_ini_quant( self.data_idx );
        break;
    }
    if( (self.spawnflags & IS_MAPKEY) ){
      if( lastMapKeyObject ){
        //build linked list backwards for later forward iteration.
        lastMapKeyObject.w_slot = self;
        lastMapKeyObject = self;
      }
      else{
        //start chain
        mapKeyObject = self;
        lastMapKeyObject = self;
      }
    }
    setorigin(self, self.origin);
  }
};


void() predraw_dmg_zone={
  setorigin(self, self.origin);
  interpolate_angle();
  if(self.damageType == 3 ){
    self.angles_y = anglemod(self.angles_y + (frametime * (random() * 25)));
  }
  //self.render_dlights();
};

/*
  OBJECT - Particle Cube Meta Data
*/
void( float isNew, float entFlags ) data_particle_cube_meta={

  if(isNew){
    if( particleCubeMetaData ){
      particleCubeMetaData.w_slot = self;
      particleCubeMetaData = self;
    }
    else{
      particleCubeMetaDataList = self;
      particleCubeMetaData = self;
    }
  }
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.absmin = te_read_vector();
    self.absmax = te_read_vector();
    self.origin = self.absmax - self.absmin;
    self.mins = self.absmax - self.origin;
    self.maxs = self.absmin +  self.origin;
  }
};