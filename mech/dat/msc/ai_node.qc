/*
mech Mod
Author: Subject9x
Date:05/17/2017
Overview: ai node used by the AI system
*/

void() ai_node_touch;

/*QUAKED ai_node (.1 .2 .9) (-20 -20 -40) (20 20 40)
*/
void() ai_node;
void() ai_node={
  //self.obj_status = 1;
  //self.controllingFaction = 0;
  //self.isActive = TRUE;
  //self.navId = 1;
  //self.nav_name = "Alpha";
  self.isActive = TRUE;
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  setmodel(self, "q3mdl/testball.md3");
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_TRIGGER;
  self.touch = ai_node_touch;
  droptofloor();
}

void() ai_node_touch={
  if(self.isActive){
    if((other.flags & FL_MONSTER)){
      if(other.enemy == world){
        //no target so continue on as normal
        if(self.target){
          //checks for patrol style ai_node'
          local entity ge;
          ge = find(world, targetname, self.target);
          if(other.goalentity != ge){
            other.goalentity = ge;
            other.pausetime = time + self.pausetime;
          }
          return;
        }
        else{
          other.goalentity = world;
          other.ai_next_state = ai_state_ready;
          other.ai_next_move = ai_move_stand;
          return;
        }
      }
    }
  }
  if(other.p_class != P_OBS){
    return;
  }
};