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
  
  if( self.isActive != TRUE){
    return;
  }
  //nav points are a player-only thing
  if( !(other.flags & FL_CLIENT) ){
    return;
  }
  if( other.faction != self.faction ){
    return;
  }
  self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
  self.enemy = other;
  self.isActive = 2;

  // trigOnTarget is used specifically here to trigger an objective
  activator = other;
  trigger_event( other, self.target );
  
  if( (self.spawnflags & 2) ){
    self.isActive = 1;
  }
  if( (self.spawnflags & 4) ){
    self.isActive = -1;
  }
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
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
    self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
    self.isActive = TRUE;
    return;
  }
  
  if( self.isActive > FALSE ){
    //deactivate signal
    self.isActive = FALSE;
    trigger_event( other, self.trigOnDeath );
    self.SendFlags = self.SendFlags | SENDFLAG_TURRET;
    return;
  }
};


void() map_nav_point_th={
  
  self.think = map_nav_point_th;
  self.nextthink = time + 1;
};

void() map_nav_point_ini={
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
  self.think = map_nav_point_th;
  self.nextthink = time + 1;
};

/*QUAKED map_nav_point (0.431 0.788 0.753) (-32 -32 -75) (32 32 1) START_OFF VISIT_PER_CLIENT OFF_AFTER_USE
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
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;

  setmodel(self, "q3mdl/testball.md3");
  setsize( self, '-32 -32 -75', '32 32 1' ); // this is to make sure nav points
  setorigin( self, self.origin );                   // end up somewhere a player can reach
  
  //wild-  EF_NODEPTHTEST allows SendEnt to blast this through to all clients!
  self.effects = self.effects | (EF_LOWPRECISION | EF_NODEPTHTEST);
  self.alpha = 0.01;
  self.scale = 0.01;
  

  
  if( (self.spawnflags & 1) ){
    self.isActive = FALSE;
  }
  else{
    self.isActive = TRUE;
  }
  
  if( !self.faction ){
    self.faction = FACTION_ALL;
  }
  
  self.SendEntity = send_nav_point;
  self.use = nav_point_use;
  self.touch = nav_point_touch;
  self.think = map_nav_point_ini;
  self.nextthink = time + 0.1;
};


/*
  Nav points are capped at 21, so here's the navs as bespoke map ents?
*/
void() nav_alpha{
  self.data_idx = 1;
  map_nav_point();
}
void() nav_beta{
  self.data_idx = 2;
  map_nav_point();
}
void() nav_delta{
  self.data_idx = 3;
  map_nav_point();
}
void() nav_epsilon{
  self.data_idx = 4;
  map_nav_point();
}
void() nav_gamma{
  self.data_idx = 5;
  map_nav_point();
}
void() nav_iota{
  self.data_idx = 6;
  map_nav_point();
}
void() nav_kappa{
  self.data_idx = 7;
  map_nav_point();
}
void() nav_lambda{
  self.data_idx = 8;
  map_nav_point();
}
void() nav_mu{
  self.data_idx = 9;
  map_nav_point();
}
void() nav_nu{
  self.data_idx = 10;
  map_nav_point();
}
void() nav_omicron{
  self.data_idx = 11;
  map_nav_point();
}
void() nav_rho{
  self.data_idx = 12;
  map_nav_point();
}
void() nav_tau{
  self.data_idx = 13;
  map_nav_point();
}
void() nav_upsilon{
  self.data_idx = 14;
  map_nav_point();
}
void() nav_zeta{
  self.data_idx = 15;
  map_nav_point();
}
void() nav_eta{
  self.data_idx = 16;
  map_nav_point();
}
void() nav_theta{
  self.data_idx = 17;
  map_nav_point();
}
void() nav_xi{
  self.data_idx = 18;
  map_nav_point();
}
void() nav_phi{
  self.data_idx = 19;
  map_nav_point();
}
void() nav_omega{
  self.data_idx = 20;
  map_nav_point();
}


void() map_nav_point_remote_send={
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
};

void() map_nav_point_remote_query={
  local entity trg;
  if( self.data_idx != 0 ){
    for( trg = findchainfloat(data_type, DATA_NAVP); trg != world; trg = trg.chain ){
      if( trg.data_idx != self.data_idx ){
        continue;
      }
      self.faction = trg.faction;
      self.view_ofs = trg.origin;
      self.isActive = trg.isActive;
      self.think = map_nav_point_remote_send;
      self.nextthink = time + 0.1;
    } 
  }
  else{
     cons_logAString("Map Error: ", "Remote Nav Point has .data_idx value but cannot find entity!"); 
  }
};

//possibly deprecated by EF_NODEPTHTEST flag on nav points
/*QUAKED map_nav_point_remote (0.753 0.788 0.431) (-10 -10 -10) (10 10 10) - VISIT_PER_CLIENT OFF_AFTER_USE
REMOTE: quirk in server code means not all ents are sent to the player on-connect IF
they're not in the same BSP volume. IF nav points are not visible to [info_player_start]
when player joins, they WILL NOT be visible for use. This sub-entity fixes the issue.

USAGE: simply queries nav points for the right data_idx and pipes that info.

-------- KEYS -------- 
data_idx: <float>, each must be unique because this determines the 'name' of the nav point client-side

*/
void() map_nav_point_remote={
  
  setmodel(self, "q3mdl/testball.md3");
  setsize( self, '-10 -10 -10', '10 10 10' ); 
  setorigin( self, self.origin );
  
  self.SendEntity = send_nav_point;
  self.SendFlags = self.SendFlags | (SENDFLAG_NEWENT | SENDFLAG_MOVE | SENDFLAG_CRIT | SENDFLAG_TURRET);
  self.think = map_nav_point_remote_query;
  self.nextthink = time + 0.1;
};