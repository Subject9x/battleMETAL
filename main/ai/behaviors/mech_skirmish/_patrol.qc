/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Patrol
    Patrol frames,
    16 for frame binding at 2 ai : 1 leg anim frame
  Setup
    
*/

/*
  STATE : PATROL START
*/
void() ai_mech_sk_patrol={
  ai_update_accuracy( TRUE );
  if( self.ai_state == ST_PTR && self.ai_state_last != ST_PTR ){
    cons_logAString("new state", "sk_patrol"); //debug
    self.ai_state_next = ST_PTR_TRAVEL_NODE;
    self.goalentity = self.movetarget;
    self.legs.attack_state = TR_GOAL;
    self.legs.think = bot_leg_walk1;
    self.legs.nextthink = time + 0.1;
    self.torsoCenter.attack_state = TR_GOAL;
    cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODE]",  self.ai_state_next); //debug
    return;
  }
  else{
    cons_logAString("running--------", "sk_patrol"); //debug
  }
};
/*
  STATE : PATROL PAUSE
*/
void() ai_mech_sk_ptr_pause={
  ai_update_accuracy( FALSE );
  
  //entered pause state
  if( self.ai_state == ST_PTR_PAUSE && self.ai_state_last != ST_PTR_PAUSE ){
    cons_logAString("new state", "sk_patrol_pause"); //debug
    self.legs.attack_state = TR_YAW;
    self.legs.angles_y = self.angles_y;
    self.legs.think = bot_leg_stand1;
    self.legs.nextthink = time + 0.1;
    ai_trail_clear(); //clear out any previous trail pattern.
    return;
  }
  //--------------------------
  
  
  if( time > self.pausetime ){
    if( self.movetarget != world ){
      self.ai_state_next = ST_PTR;
      cons_logAFloat("ENTER[ST_PTR]",  self.ai_state_next); //debug
    }
    else{
      self.ai_state_next = ST_STAND;
      cons_logAFloat("ENTER[ST_STAND]",  self.ai_state_next); //debug
    }
  }
};
/*
  STATE : PATROL TRAVEL TO NODE
*/
void() ai_mech_sk_ptr_travel_node={
  ai_update_accuracy( TRUE );
  local float patrolState;
  
  cons_logAString("running--------", "ai_mech_sk_ptr_travel_node"); //debug
  patrolState = ai_patrol_frame(ai_mech_sk_patrol1, ai_mech_sk_enter_stand);
  cons_logAFloat("running--------patrolState", patrolState); //debug
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //prepare for war....
    self.ai_state_next = ST_COMBAT;
    cons_logAFloat("ENTER[ST_COMBAT]",  self.ai_state_next); //debug
    return;
  }
  
  if( patrolState == PATROL_PAUSE ){
    self.ai_state_next = ST_PTR_PAUSE;
    cons_logAFloat("ENTER[ST_PTR_PAUSE]",  self.ai_state_next); //debug
    return;
  }
  
  if( patrolState == PATROL_BLOCK ){
    self.ai_state_next = ST_PTR_TRAVEL_NODEBLOCK;
    cons_logAFloat("ENTER[ST_PTR_TRAVEL_NODEBLOCK]",  self.ai_state_next); //debug
    return;
  }
};
/*
  STATE : PATROL TRAVEL TO NODE BLOCKED
*/
void() ai_mech_sk_ptr_travel_blocked={
  if( self.ai_state == ST_PTR_TRAVEL_NODEBLOCK && self.ai_state_last != ST_PTR_TRAVEL_NODEBLOCK ){
    cons_logAString("new state", "ai_mech_sk_ptr_travel_blocked"); //debug
    self.tetherOrg = self.movetarget.origin;
    self.ai_state_next = ST_PTR;
    return;
  }
};

/*
  STATE : PATROL USE TETHER
*/
void() ai_mech_sk_ptr_tether={
  if( self.ai_state == ST_PTR_TETHER && self.ai_state_last != ST_PTR_TETHER ){
    cons_logAString("new state", "ai_mech_sk_ptr_tether"); //debug
    return;
  }
};

/*
  STATE : PATROL USE TETHER BLOCKED
*/
void() ai_mech_sk_ptr_tether_blocked={
  if( self.ai_state == ST_PTR_TETHER_BLOCK && self.ai_state_last != ST_PTR_TETHER_BLOCK ){
    cons_logAString("new state", "ai_mech_sk_ptr_tether_blocked"); //debug
    return;
  }
};



//=====================================================================================



void() ai_mech_sk_patrol1={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)

  self.goalentity = self.movetarget;
  self.legs.attack_state = TR_GOAL;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  self.torsoCenter.attack_state = TR_GOAL;
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  ai_patrol_frame(ai_mech_sk_patrol2, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol2={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol3, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol4, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol4={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol5, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol5={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol6, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol7, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol8, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol8={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol9, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol9={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol10, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol11, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol12, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol12={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol13, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol13={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol14, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol15, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol16, ai_mech_sk_enter_stand);
};
void() ai_mech_sk_patrol16={ 
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  ai_patrol_frame(ai_mech_sk_patrol1, ai_mech_sk_enter_stand);
};