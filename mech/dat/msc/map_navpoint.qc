/*
mech Mod
Author: Subject9x
Date: 03/25/2017
Overview: data file for map nav points
*/


float(entity ent, float changed) send_navpoint={
  WriteByte( MSG_ENTITY, E_NAV ); // Unique Identifier, I suggest you use enums to make it easy on yourself
  WriteByte( MSG_ENTITY, self.data_type);
  WriteByte( MSG_ENTITY, self.data_idx);
  WriteByte( MSG_ENTITY, self.i_faction);
  WriteByte( MSG_ENTITY, self.isActive);
  WriteCoord( MSG_ENTITY, self.origin_x); // Position X
  WriteCoord( MSG_ENTITY, self.origin_y); // Position Y
  WriteCoord( MSG_ENTITY, self.origin_z); // Position Z
  return TRUE;
};

void() nav_point_use={
  if(self.isActive == TRUE){
    self.isActive = FALSE;
  }else{
    self.isActive = TRUE;
  }
  self.SendFlags = 1;
};

void() nav_point_th={
  local entity e;
  if(self.isActive == TRUE){
    e = findradius(self.origin, 150);
    while(e){
      if((e.flags & FL_CLIENT)){
        if(e.i_faction == self.i_faction){
          self.enemy = e;
          self.isActive = FALSE;
          self.SendFlags = 1;
          multi_trigger();
        }
      }
      e = e.chain;
    }
  }
  self.think = nav_point_th;
  self.nextthink = time + 0.5;
};

/*QUAKED map_navpoint (0.2 0.8 0.2) (-10 -10 -10) (10 10 10)
"i_faction" : bitflags for faction, only visible to that faction
"data_idx" : number, 1 - 12, MUST BE UNIQUE
"isActive" : number, allow player to spawn here
  0 = FALSE
  1 = TRUE
*/
void() map_navpoint={
  self.classname = "data";
  self.data_type = DATA_NAVP;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.SendEntity = send_navpoint;
  self.SendFlags = 1;
  self.use = nav_point_use;
  self.think = nav_point_th;
  self.nextthink = time + 0.5;
}