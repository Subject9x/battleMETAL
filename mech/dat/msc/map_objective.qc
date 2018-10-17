/*
mech Mod
Author: Peter Roohr
Date: 03/25/2017
Overview: data file for map objectives
*/

void() map_objective_use={
  if(self.isActive){
    self.count = 1;
    self.isActive = -1;
  }else{
    self.isActive = TRUE;
    self.count = 0;
  }
};

void() map_objective_th={
  if(self.isActive == FALSE){
    if(self.count > 0){
      self.count = 0;
      multi_trigger();
    }
  }
  self.think = map_objective_th;
  self.nextthink = time + 0.1;
};


/*QUAKED map_objective (0.99 0.8 0) (-10 -10 -10) (10 10 10)
"data_idx" : float, must match a number in the msn_file
"isActive" : float, does this start active?
"i_faction": float, faction for this objective
"target"   : string, target another ent, usually a counter
*/
void() map_objective={
  self.count = 0;
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