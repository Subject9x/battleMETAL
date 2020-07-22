/*
battleMETAL 
Author: Peter Roohr
Date: 07/07/2020
Overview: 
  Skirmish mechs are the basic mech behavior type in the game.
  the _trail states are for pathfinding in the middle of a fight.
*/

/*
  STATE: ST_TRAIL_MOVE
*/
void() mech_sniper_trail_move={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_MOVE && self.ai_state_last != ST_TRAIL_MOVE ){

    self.ai_state_next = ST_STAND;
    self.pausetime = 5;
    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_BLOCK
*/
void() mech_sniper_trail_move_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){

    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBACK
*/
void() mech_sniper_trail_rollback={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBACK && self.ai_state_last != ST_TRAIL_ROLLBACK ){

    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBLOCK
*/
void() mech_sniper_trail_rollback_block={
  ai_attack();
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){

    return;
  }
 //------------------------------------------------------------------
};
