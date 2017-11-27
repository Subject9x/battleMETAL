/*
mech Mod
Author: Peter Roohr
Date: 03/25/2017
Overview: data file for map objectives
*/

float(entity ent, float changed) send_objective={
  WriteByte( MSG_ENTITY, E_OBJ ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteByte( MSG_ENTITY, self.isActive);
  return TRUE;
};

void() map_objective_use={
  if(self.isActive){
    self.count = 1;
    self.isActive = FALSE;
  }else{
    self.isActive = TRUE;
    self.count = 0;
  }
  self.SendFlags = 1;
};

void() map_objective_th={
  if(self.isActive == FALSE){
    if(self.count > 0){
      self.count = 0;
      multi_trigger();
    }
  }
  self.think = map_objective_th;
  self.nextthink = time + 0.5;
};


/*QUAKED map_objective (0.99 0.8 0) (-10 -10 -10) (10 10 10)
"data_idx" : float, must match a number in the msn_file
    use value -1 for 'mission successful'
    use value -2 for 'mission failed'
"isActive" : float, does this start active?
"i_faction": float, faction for this objective
"target"   : string, target another ent, usually a counter
*/
void() map_objective={
  self.count = 0;
  self.classname = "data";
  self.data_type = DATA_OBJT;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = map_objective_use;
  self.SendEntity = send_objective;
  self.SendFlags = 1;
  self.think = map_objective_th;
  self.nextthink = time + 0.5;
}