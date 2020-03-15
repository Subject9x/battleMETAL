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
  self.faction = ReadByte();
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
    }
    self.drawmask = MASK_ENGINE;
  }
  
};

void( float isNew, float entFlags ) data_map_object={

};
