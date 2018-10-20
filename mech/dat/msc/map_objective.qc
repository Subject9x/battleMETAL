/*
mech Mod
Author: Peter Roohr
Date: 03/25/2017
Overview: data file for map objectives
*/

/*
  The game has sent a trigger call to the Objective.
  what does the Objective do when triggered?
*/
void() map_objective_use={
  if( self.isActive ){
    //objective is 'active' and now firing from the trigger call
    self.count = 1;
    self.isActive = -1;
  }else{
    //objective wasn't active, so flip it to active
    //this means a second trigger call is needed to change it
    self.isActive = TRUE;
    self.count = 0;
  }
};

void() map_objective_th={
  if(self.isActive == 2){
    //multi_trigger();
    local entity player;
    player = findchainflags( flags, FL_CLIENT );
    while( player ){
      if( player.i_faction == self.i_faction ){
        stemp = self;
        self = player;
          client_send_objective( stemp );
        self = stemp;
      }
      player = player.chain;
    }
    self.isActive = 0;
  }
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_objective (0.99 0.8 0) (-10 -10 -10) (10 10 10)
"data_idx" : float, must match a number in the msn_file
"isActive" : float, does this start active? 0 = hidden/inactive, 1 = active, 2 = complete, -1 = failed
"i_faction": float, faction for this objective
"target"   : string, target another ent, usually a counter
"state_1"  : float, 1 = primary objective, 2 = secondary, 3 = tertiary
*/
void() map_objective={
  self.classname = "data";
  self.flags = self.flags | FL_NODE;
  self.data_type = DATA_OBJT;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = map_objective_use;
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
}