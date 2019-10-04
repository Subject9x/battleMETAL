/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Hunt
  
  Setup
    
*/
void() ai_mech_sk_enter_hunt={
  local entity nodeRecall;
  self.attack_state = ST_HUNT;
  ai_sfx_huntStart();
  nodeRecall = node_recall_setup();
  self.ai_node_recall = nodeRecall;
  self.goalentity = self.enemy;
  self.ai_action_time = (0 - self.ai_action_mod) * -1;
  if( self.stat_rdr_mode ){
    self.ai_action_time = ceil(self.ai_action_time * 6);
  }
  else{
    self.ai_action_time = ceil(self.ai_action_time * 4);
  }
  
  ai_face_targ();
  ai_turret_set_state(TR_TARG);
  
  self.legs.ai_dir = TR_GOAL;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_hunt1)
};
void() ai_mech_sk_hunt1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
    
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt2)
};
void() ai_mech_sk_hunt2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt3)
};
void() ai_mech_sk_hunt3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt4)
};
void() ai_mech_sk_hunt4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt5)
};
void() ai_mech_sk_hunt5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt6)
};
void() ai_mech_sk_hunt6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt7)
};
void() ai_mech_sk_hunt7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt8)
};
void() ai_mech_sk_hunt8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt9)
};
void() ai_mech_sk_hunt9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt10)
};
void() ai_mech_sk_hunt10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt11)
};
void() ai_mech_sk_hunt11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt12)
};
void() ai_mech_sk_hunt12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt13)
};
void() ai_mech_sk_hunt13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt14)
};
void() ai_mech_sk_hunt14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt15)
};
void() ai_mech_sk_hunt15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame(ai_mech_sk_hunt16)
};
void() ai_mech_sk_hunt16={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  movetogoal( self.data_speed_forward );
  macro_ai_frame_count(ai_mech_sk_hunt1)

  ai_sfx_huntEnd();
  
  if( self.movetarget ){
    ai_turret_set_state( TR_NORM );
    local float dist1, dist2;
    dist1 = vlen( self.movetarget.origin - self.origin );
    dist2 = vlen( self.ai_node_recall.origin - self.origin );
    if( dist1 < dist2 ){
      self.goalentity = self.movetarget;
      macro_ai_frame(ai_mech_sk_patrol1)
      remove(self.ai_node_recall);
      return;
    }
  }
  //the recall portion of hunting
  if( self.ai_node_recall && self.goalentity != self.ai_node_recall ){
    ai_turret_set_state( TR_NORM );
    self.goalentity = self.ai_node_recall;
    self.ai_action_time = (0 - self.ai_action_mod) * -1;
    self.ai_action_time = ceil(self.ai_action_time * 4);
    macro_ai_frame(ai_mech_sk_hunt1)
    return;
  }
  remove(self.ai_node_recall);
  self.ai_node_recall = world;
  self.enemy = world;
  macro_ai_frame(ai_mech_sk_stand1)
};