/*
battleMETAL 
Author: Peter Roohr
Date: 10/06/2019
Overview: ai unit
  Tank - Skirmisher
  Behavior - Recall
    post-hunting behavior
*/

void() ai_tank_sk_enter_recall={
  self.torsoCenter.attack_state = TR_GOAL;
  ai_sfx_huntEnd();
  self.enemy = world;
  self.goalentity = self.ai_node_recall;
  
  macro_ai_frame(ai_tank_sk_recall1)
};
void() ai_tank_sk_recall1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall2);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall3);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall4);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall5);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall6);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall7);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall8);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall9);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall10);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};
void() ai_tank_sk_recall10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_tank_sk_recall1);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_tank_sk_enter_patrol)
  }
};