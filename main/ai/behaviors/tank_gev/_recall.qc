/*
battleMETAL 
Author: Peter Roohr
Date: 10//06/2019
Overview: ai unit
  Tank - GEV
  Behavior - Recall
    gev falls back to hunt node
  Setup
    
*/
void() ai_gev_enter_recall={
  ai_turret_set_state( TR_NORM );
  ai_sfx_huntEnd();
  self.enemy = world;
  self.goalentity = self.ai_node_recall;
  
  macro_ai_frame(ai_gev_recall1)
};
void() ai_gev_recall1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall2);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall3);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall4);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall5);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall6);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall7);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall8);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall9);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall10);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};
void() ai_gev_recall10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  local float recallCheck;
  recallCheck = ai_recall_logic( self.data_speed_forward, ai_gev_recall1);
  if( !recallCheck ){
    //finished fall-through
    macro_ai_frame(ai_gev_enter_patrol)
  }
};