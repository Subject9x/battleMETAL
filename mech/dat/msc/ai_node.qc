/*
mech Mod
Author: Subject9x
Date:05/17/2017
Overview: ai node used by the AI system
*/

void() ai_node_touch;

/*QUAKED ai_node (.1 .2 .9) (-20 -20 -20) (20 20 20)
*/
void() ai_node;
void() ai_node={
  //self.obj_status = 1;
  //self.controllingFaction = 0;
  //self.isActive = TRUE;
  //self.navId = 1;
  //self.nav_name = "Alpha";
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-1 -1 -1', '1 1 1');
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;
  self.touch = ai_node_touch;
  
}

void() ai_node_touch={
  if(other.p_class != P_OBS){
    return;
  }
  else{
    bprint(strcat(self.classname,"\n")); // DEBUG
  }
};