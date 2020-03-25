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
    case DATA_MAP_DMG:
      data_map_damage( isNew, entFlags );
      break;
  }
};

float() predraw_navpoint={
  self.angles_y = anglemod(self.angles_y + 0.15);
  setorigin(self, self.origin);
  
  if( self.faction != CLIENT_faction ){
    self.alpha = 0;
  }
  
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
  
  if( entFlags & SENDFLAG_NEWENT ){
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
      DEPLOYPOINT = self; //first
    }
    self.drawmask = MASK_NORMAL;
  }
  
};

float() predraw_damage={

  return TRUE;
};

void() map_damage_zone_dlights={
  local vector spotlight;
  
  if( self.isActive ){
    if( (self.damageType & 1) ){
      //shield
      if( self.effect1.isActive == TRUE ){
        adddynamiclight2(  self.effect1.origin, 128, '0 1 0.8', 6, "", PFLAGS_NOSHADOW);
      }
    }
    if( (self.damageType & 2) ){
      //armor
      if( self.effect2.isActive == TRUE ){
        adddynamiclight2( self.effect2.origin, 12, '0.8 0.8 0', 3, "", PFLAGS_NOSHADOW);
      }
    }
    if( (self.damageType & 4) ){
      //energy
      if( self.effect3.isActive == TRUE ){
        adddynamiclight2( self.effect3.origin, 64, '1 0.4 0.6', 2, "", PFLAGS_NOSHADOW);
      }
    }
  }
};

void() map_damage_zone_think={
 
  if( self.isActive ){
    makevectors(self.angles);
    if( self.effect1 != world ){
      if( time > self.effect1.wait ){
        if( random() > 0.1 ){
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
        if( random() > 0.4 ){
          self.effect2.origin = randompos(self.effect2.absmin, self.effect2.absmax);
          self.effect2.isActive = TRUE;
          self.effect2.wait = time + random() * 5;
          te_field_rad(self.effect2.origin, normalize((self.effect2.origin + (v_up * 10)) - self.effect2.origin) * 7, 1);
          te_particlecube( self.absmin, self.absmax, '0 0 0', random() * 10, 176, FALSE, 10); 
        }
        else{
          self.effect2.isActive = FALSE;
          self.effect2.wait = time + random() * 3;
        }
      }
    }
    if( self.effect3 != world ){
      if( time > self.effect3.wait ){
        if( random() > 0.33 ){
          self.effect3.origin = randompos(self.effect3.absmin, self.effect3.absmax);
          self.effect3.isActive = TRUE;
          self.effect3.wait = time + 2;
          te_field_quantum( self.effect3.origin, randompos(self.effect3.absmin, self.effect3.absmax));
          te_particlecube( self.absmin, self.absmax, '0 0 0', random() * 4, 128, FALSE, 10); 
        }
        else{
          self.effect3.isActive = FALSE;
          self.effect3.wait = time + random() * 4;
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
    self.origin = self.absmin - self.absmax;
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
  }
};
