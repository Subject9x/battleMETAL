/*
battleMETAL 
Author: Peter Roohr
Date: 10/06/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Recall
    spun out recall post-hunt to its own code
    
  Setup
    AI has a self.ai_node_recall
    
*/
void() ai_mech_sk_enter_recall={
  self.goalentity = self.ai_node_recall;
  ai_sfx_huntEnd();
  self.enemy = world;
  self.torsoCenter.attack_state = TR_GOAL;
  self.legs.attack_state = TR_GOAL;
  self.legs.think = bot_leg_walk1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_recall1)
};
void() ai_mech_sk_recall1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall2);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall3);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall4);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall5);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall6);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall7);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall8);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall9);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall10);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall11);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall12);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall13);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall14);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall15);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall16);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};
void() ai_mech_sk_recall16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ai_ctrl_update_mechplayer)
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_mech_sk_recall1);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_mech_sk_patrol1)
  }
};