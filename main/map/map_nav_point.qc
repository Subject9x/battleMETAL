/*
battleMETAL
Author: Peter Roohr
Date: 03/25/2017
mod: 11/15/2018
Overview: 
  Nav Points are points of interest marked on Player maps. Players interact with them by visiting them, 
  which can then fire triggers to additional game logic. 
*/

/*
  Nav points only apply to Clients, therefore only Clients
  can affect the state of a navpoint.
*/
void() nav_point_touch={
  local entity this;
  local entity that;
  
  if(self.isActive == TRUE){
    //nav points are a player-only thing
    if( !(other.flags & FL_CLIENT) ){
      return;
    }
    if( other.faction == self.faction ){
      self.enemy = other;
      self.isActive = 2;
      this = self;
      self = other;
        client_send_navpoint( this );
      self = this;
      that = other;
      
      // trigOnTarget is used specifically here to trigger an objective
      trigger_event( that, self.target );
      self.effects = self.effects - ( self.effects &(EF_DOUBLESIDED | EF_NOSHADOW | EF_FULLBRIGHT)); 
      self.alpha = 0.2;
      self.colormod = '0.15 0.15 0.15';
      //multi_trigger();
      if( (self.spawnflags & 2) ){
        self.isActive = 1;
      }
      if( (self.spawnflags & 4) ){
        self.isActive = -1;
      }
      self.solid = SOLID_NOT;
    }
  }
};

/*
  nav is being called by another trigger.
  all this really does is short-circuit the 'trigger on visit' 
  to be fired on-demand right now by another trigger.
*/
void() nav_point_use={
  //nav point is inactive, activate
  if( !self.isActive ){
    trigger_event( activator, self.trigOnSpawn );
    self.isActive = TRUE;
    return;
  }
  
  if( self.isActive > FALSE ){
    //deactivate signal
    self.isActive = FALSE;
    trigger_event( other, self.trigOnDeath );
    return;
  }
};

void() map_nav_point_th={

  self.angles_y = anglemod(self.angles_y + 1);

  self.think = map_nav_point_th;
  self.nextthink = time + 0.1;
};

/*QUAKED map_nav_point (0.431 0.788 0.753) (-32 -32 -75) (32 32 1) - VISIT_PER_CLIENT OFF_AFTER_USE
Nav Points are points of interest marked on Player maps. 
Players interact with them by visiting them, which can then fire triggers to additional game logic.
For best results, place manually as close to ground as possible!
-------- KEYS -------- 
faction: float defines which factions this Nav Point belongs to
data_idx: float enum  1 to 21, each must be unique because this determines the 'name' of the nav point client-side
isActive: float enum  1 active unvisit active, faction hasn't visited that nav yet
                             2 active visit  active, faction has been here
                             0 hidden  this means hidden from other factions
                             -1 inactive  hidden from everyone
trigOnSpawn:string ent  fire this map object when activated
target: string ent  fire this map object when visited
trigOnTarget: string ent fire this OBJECTIVE when visited (special event channel for objectives)
trigOnDeath: string ent  fire this ENTITY when nav point isActive is false off the use function

-------- SPAWNFLAGS -------- 
VISIT_PER_CLIENT 2: only updates visited state per client
OFF_AFTER_USE 4: deactivate after use
*/
void() map_nav_point={

  self.flags = self.flags | FL_NODE;

  self.data_type = DATA_NAVP;
  
  precache_model("q3mdl/map/nav_point.obj");
  setmodel(self, "q3mdl/map/nav_point.obj");
  
  setsize( self, '-32 -32 -75', '32 32 1' ); // this is to make sure nav points
  setorigin( self, self.origin );                   // end up somewhere a player can reach
  self.movetype = MOVETYPE_FLY;
  droptofloor();
  self.effects = self.effects | (EF_DOUBLESIDED | EF_NOSHADOW | EF_NODEPTHTEST | EF_FULLBRIGHT); 
  self.alpha = 0.33;
  self.colormod = '0 1 0';
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;
  self.use = nav_point_use;
  self.touch = nav_point_touch;
  self.isActive = TRUE;
  self.think = map_nav_point_th;
  self.nextthink = time + 0.1;
};