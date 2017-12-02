/*
mech Mod
Author: Peter Roohr
Date:05/17/2017
Overview: ai node used by the AI system
*/

/*QUAKED ai_node (.1 .2 .9) (-20 -20 -20) (20 20 20)
isActive = AI can use this? (mmm might not be workable atm)
  0 = FALSE
  1 = TRUE
i_faction = only is if faction matching //not impl yet
state_1 = impart new first order to an AI
   0 = Attack the .target
  1 = defend the .target
  2 = patrol the .target
  3 = stand at the .target
*/
void() ai_node={
  self.classname = "ai_node";
  self.data_type = DATA_NODE;
  setmodel(self, "q3mdl/testball.md3");
  setsize(self, '-15 -15 -59','15 15 1');
  droptofloor();
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.touch = ai_node_touch;
}

void() ai_node_touch={

};

void() ai_node_g1;
void() ai_node_g2;
void() ai_node_g3;
void() ai_node_g4;
void() ai_node_g5;
void() ai_node_g6;
void() ai_node_g7;
void() ai_node_g8;
void() ai_node_g9;
void() ai_node_g10;
void() ai_node_g11;
void() ai_node_g12;
void() ai_node_g13;
void() ai_node_g14;
void() ai_node_g15;
void() ai_node_g16;
void() ai_node_g17;
void() ai_node_g18;
void() ai_node_g19;
void() ai_node_g20;
void() ai_node_g21;
void() ai_node_g22;
void() ai_node_g23;
void() ai_node_g24;
void() ai_node_g25;
void() ai_node_g26;
void() ai_node_g27;
void() ai_node_g28;
void() ai_node_g29;
void() ai_node_g30;
void() ai_node_g31;
void() ai_node_g32;

void() ai_node_graph_touch={
  if((other.flags & FL_MONSTER)){
    local entity this;
    this = self;
    if(self.target){
      local entity t;
      t = find(world, targetname, self.target);
      if(t){
        self = other;
          self.oldgoal = self.goalentity;
          self.goalentity = t;
          //ai_update_statemove(ai_state_tonode, self.ai_next_move, FALSE); 
        self = this;
        return;
      }
      else{
        self = other;
          self.goalentity = world;
          //ai_update_statemove(ai_state_ready, ai_move_stand, FALSE);
        self = this;
        return;
      }
    }
    else if(this.node_id){
      if(self == other.oldgoal){
        self = other;
          self.goalentity = self.oldgoal;
          self.movetarget = world;
        self = this;
        return; 
      }
      else{
        local entity n;
        n = ai_query_graphnode(self, other.node_id);
        self = other; 
          self.goalentity = n;
        self = this;
        return; 
      }
    }
  }
  if(other.p_class != P_OBS){
    return;
  }
  else{
    return;
  }
};
/*QUAKED ai_node_g1 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g1={self.node_id = 1; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g2 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g2={self.node_id = 2; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g3 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g3={self.node_id = 3; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g4 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g4={self.node_id = 4; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g5 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g5={self.node_id = 5; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g6 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g6={self.node_id = 6; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g7 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g7={self.node_id = 7; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g8 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g8={self.node_id = 8; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g9 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g9={self.node_id = 9; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g10 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g10={self.node_id = 10; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g11 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g11={self.node_id = 11; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g12 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g12={self.node_id = 12; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g13 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g13={self.node_id = 13; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g14 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g14={self.node_id = 14; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g15 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g15={self.node_id = 15; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g16 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g16={self.node_id = 16; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g17 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g17={self.node_id = 17; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g18 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g18={self.node_id = 18; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g19 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g19={self.node_id = 19; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g20 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g20={self.node_id = 20; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g21 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g21={self.node_id = 21; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g22 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g22={self.node_id = 22; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g23 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g23={self.node_id = 23; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g24 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g24={self.node_id = 24; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g25 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g25={self.node_id = 25; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g26 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g26={self.node_id = 26; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g27 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g27={self.node_id = 27; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g28 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g28={self.node_id = 28; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g29 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g29={self.node_id = 29; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g30 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g30={self.node_id = 30; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g31 (.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g31={self.node_id = 31; ai_node(); self.touch = ai_node_graph_touch;};

/*QUAKED ai_node_g32(.1 .8 .9) (-20 -20 -39) (20 20 1)
*/
void() ai_node_g32={self.node_id = 32; ai_node(); self.touch = ai_node_graph_touch;};