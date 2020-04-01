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
    case DATA_OBJT:
      data_objective( isNew, entFlags );
      break;
    case DATA_DEPL:
      data_deploy( isNew, entFlags );
      break;
    case DATA_MAP_OBJ:
      //data_objective( isNew, entFlags );
      break;
    case DATA_MAP_DMG:
      data_map_damage( isNew, entFlags );
      break;
  }
};

float() predraw_navpoint={
  if( self.faction != CLIENT_faction ){
    self.alpha = 0;
    self.effects = 0;
    self.scale = 0.01;
  }
  else{
    self.effects = self.effects | (EF_DOUBLESIDED | EF_NOSHADOW | EF_NODEPTHTEST | EF_FULLBRIGHT);
    self.angles_y = anglemod(self.angles_y + 0.025);
    self.alpha = 0.33;
    self.scale = 1;
  }
  return TRUE;
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
      self.drawmask = MASK_NORMAL;
      self.colormod = '0 1 0';
    }
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

/*
  OBJECT - Mission Objective
*/
void( float isNew, float entFlags ) data_objective={
  local float prevState;
  
 //EVENT - isActive change
  if( (entFlags & SENDFLAG_TURRET) ){
    prevState = self.isActive;
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
    if( isNew ){
      setmodel(self, "q3mdl/testball.md3");
      setorigin(self, self.origin);
      self.alpha = 0.01;
      self.drawmask = MASK_ENGINE;
    }
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
    FACTION_DEPLOY.prevPoint = dep;
    dep.nextPoint = FACTION_DEPLOY;
    FACTION_DEPLOY = dep;
  }
};

/*
  OBJECT - Deploy Point
*/
void( float isNew, float entFlags ) data_deploy={
  local float prevState;
  local float prevFaction;
  
 //EVENT - isActive change
  if( (entFlags & SENDFLAG_TURRET) ){
    prevState = self.isActive;
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
    prevFaction = self.faction;
    self.faction = ReadByte();
    if( prevFaction != self.faction && self.faction != FACTION_ALL ){
      data_deploy_changeFaction(self, prevFaction);
    }
  }
  
  //EVENT - new to player
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.data_idx = ReadByte();
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
      self.drawmask = MASK_NORMAL;
    }
  }
};


/*
  OBJECT - Weather Data
*/
void( float isNew, float entFlags ) data_weather;


/*
  OBJECT - Damage Zone
*/
void() map_damage_zone_dlights={
  local vector spotlight;
  
  if( self.isActive ){
    if( (self.damageType & 1) ){
      //shield
      if( self.effect1.isActive == TRUE ){
        adddynamiclight2(  self.effect1.origin, 150, '0 1 0.8', 6, "", 0);
      }
    }
    if( (self.damageType & 2) ){
      //armor
      if( self.effect2.isActive == TRUE ){
        adddynamiclight2( self.effect2.origin, 96, '0.8 0.8 0', 3, "", 0);
      }
    }
    if( (self.damageType & 4) ){
      //energy
      if( self.effect3.isActive == TRUE ){
        adddynamiclight2( self.effect3.origin, 128, '1 0.4 0.6', 2, "", 0);
      }
    }
  }
};

void() map_damage_zone_think={
 
  if( self.isActive ){
    makevectors(self.angles);
    if( self.effect1 != world ){
      if( time > self.effect1.wait ){
        if( random() > 0.5 ){
          self.effect1.origin = randompos(self.effect1.absmin, self.effect1.absmax);
          self.effect1.isActive = TRUE;
          self.effect1.wait = time + random() * 2;
          te_field_mineral( self.effect1.origin, normalize((self.effect1.origin + (v_up * 10)) - self.effect1.origin) * 25, 5);
          te_particlecube( self.absmin, self.absmax, normalize((self.effect1.origin + (v_up * 10)) - self.effect1.origin) * 25, random() * 6, 244, FALSE, 32); 
        }
        else{
          self.effect1.isActive = FALSE;
          self.effect1.wait = time + random() * 5;
        }
      }
    }
    if( self.effect2 != world ){
      if( time > self.effect2.wait ){
        if( random() > 0.5 ){
          self.effect2.origin = randompos(self.effect2.absmin, self.effect2.absmax);
          self.effect2.isActive = TRUE;
          self.effect2.wait = time + random() * 2;
          te_field_rad(self.effect2.origin, normalize((self.effect2.origin + (v_up * 10)) - self.effect2.origin) * 7, 1);
          te_particlecube( self.absmin, self.absmax, '0 0 0', random() * 10, 176, FALSE, 10); 
        }
        else{
          self.effect2.isActive = FALSE;
          self.effect2.wait = time + random() * 1;
        }
      }
    }
    if( self.effect3 != world ){
      if( time > self.effect3.wait ){
        if( random() > 0.5 ){
          self.effect3.origin = randompos(self.effect3.absmin, self.effect3.absmax);
          self.effect3.isActive = TRUE;
          self.effect3.wait = time + 1 + random()* 4;
          te_field_quantum( self.effect3.origin, randompos(self.effect3.absmin, self.effect3.absmax));
          te_particlecube( self.absmin, self.absmax, '0 0 0', random() * 4, 128, FALSE, 10); 
        }
        else{
          self.effect3.isActive = FALSE;
          self.effect3.wait = time + random() * 2;
        }
      }
    }
  }
  
  //otherwise do nothing else
  self.think = map_damage_zone_think;
  self.nextthink = time + 0.1;
};

void( .entity efx ) data_map_damage_effect={
  if( self.efx == world ){
    self.efx = spawn();
    self.efx.drawmask = MASK_NORMAL;
    self.efx.origin =  self.origin;
    self.efx.absmax = self.absmax;
    self.efx.absmin = self.absmin;
    self.efx.isActive = TRUE;
    self.efx.wait = 0;
    addentity(self.efx);
  }
};

void( float isNew, float entFlags ) data_map_damage={
  local float funcFlag;
  
  if( (entFlags & SENDFLAG_MOVE) ){
    //changes damage types / boundary size
    self.absmin = te_read_vector();
    self.absmax = te_read_vector();
    
    self.damageType = ReadByte();
    self.count = ReadByte();
    self.count1 = ReadByte();

    self.compAltOffset = te_read_vector();
    self.dest = te_read_vector();
  }
  
  if( (entFlags & SENDFLAG_BURN) ){
    //use to adjust isActive, toggling the field
    self.isActive = ReadByte();
    if( self.isActive ){
      self.nextthink = time + 0.1;
    }
  }
  
  if( (entFlags & SENDFLAG_NEWENT) ){
    self.spawnflags = ReadLong();
    self.origin_x = ReadCoord();
    self.origin_y = ReadCoord();
    self.origin_z = ReadCoord();
  }
  if( isNew ){
    self.drawmask = MASK_NORMAL;
    self.alpha = 0.01;
    self.render_dlights = map_damage_zone_dlights;
    self.think = map_damage_zone_think;
    if( self.isActive ){
      self.nextthink = time + 0.1;
    }
    
    if( (self.damageType & 1) ){
      if( self.effect1 == world ){
        //shields();
        data_map_damage_effect( effect1 );
      }
    }
    if( (self.damageType & 2) ){
      //armor();
      if( self.effect2 == world ){
        data_map_damage_effect( effect2 );
      }
    }
    if( (self.damageType & 4) ){
      //energy();
      if( self.effect3 == world  ){
        data_map_damage_effect( effect3 );
      }
    }
    
    if( (self.spawnflags & 4194304) ){
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
  }
};
