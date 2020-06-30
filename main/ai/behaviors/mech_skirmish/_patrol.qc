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