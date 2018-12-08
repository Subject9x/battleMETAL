/*
battleMETAL 
Author: Peter Roohr
Date: 12/08/2018
Overview:
  Mission Boundaries are an entity that warns the player they're walking out of the playable area.
  Usually these placed in front of killboxe (PSC takes a dim view to wayward DEAD_HANDS)
  
  [INPUTS]
    .ai_dir   <float> [angle] angle to point the player back to the mission area
    
  .spawnflags
    none
  
*/

void() mission_boundary_touch={
  
  if( (other.flags & FL_CLIENT) ){
    if( self.isActive ){
      client_send_boundary_warning( other );
    }
  }    
  if( (other.flags & FL_MONSTER) ){
    //find shortest way out -> back up?
  }

};

void() mission_boundary_th={
  //simple oscillator
  // isActive is sent to clients
  
  self.isActive = !self.isActive;

  self.think = mission_boundary_th;
  self.nextthink = time + 0.1;
};

void() func_mission_boundary={

  InitTrigger();
  
  self.isActive = TRUE;
  self.touch = mission_boundary_touch;
  self.think = mission_boundary_th;
  self.nextthink = time + ( random() * 0.5); //spread thinks, and no player starts inside the warning so....
};