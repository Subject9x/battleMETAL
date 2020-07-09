/*
battleMETAL 
Author: Peter Roohr
Date: 07/06/2020
Overview: 

  tank snipers are basically missile / tank hunter vehicles.
*/

/*
  STATE: ST_TRAIL_MOVE
*/
void() spg_trail_move={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_MOVE && self.ai_state_last != ST_TRAIL_MOVE ){
    cons_logAString("new state", "spg_trail_move"); //debug

    return;
  }
 //------------------------------------------------------------------

};

/*
  STATE: ST_TRAIL_BLOCK
*/
void() spg_trail_move_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_BLOCK && self.ai_state_last != ST_TRAIL_BLOCK ){
    cons_logAString("new state", "spg_trail_move_block"); //debug    

    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBACK
*/
void() spg_trail_rollback={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBACK && self.ai_state_last != ST_TRAIL_ROLLBACK ){

    return;
  }
 //------------------------------------------------------------------
};

/*
  STATE: ST_TRAIL_ROLLBLOCK
*/
void() spg_trail_rollback_block={
  //ENTER STATE------------------------------------------------------------------
  if( self.ai_state == ST_TRAIL_ROLLBLOCK && self.ai_state_last != ST_TRAIL_ROLLBLOCK ){
    cons_logAString("new state", "spg_trail_rollback_block"); //debug
    return;
  }
 //------------------------------------------------------------------
};