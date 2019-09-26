/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Stand and fight
  
  Setup
    
*/
void() ai_mech_sk_stand_fight1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  self.legs.attack_state = TR_YAW;
  self.legs.think = bot_leg_stand1;
  self.legs.nextthink = time + 0.1;
  
  macro_ai_frame(ai_mech_sk_stand_fight2)
};

void() ai_mech_sk_stand_fight2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  ai_attack();

  macro_ai_frame(ai_mech_sk_stand_fight3)
};

void() ai_mech_sk_stand_fight3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  macro_ai_frame(ai_mech_sk_stand_fight4)
};

void() ai_mech_sk_stand_fight4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  ai_attack();

  macro_ai_frame(ai_mech_sk_stand_fight5)
};

void() ai_mech_sk_stand_fight5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  macro_ai_frame(ai_mech_sk_stand_fight6)
};

void() ai_mech_sk_stand_fight6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  ai_attack();

  macro_ai_frame(ai_mech_sk_stand_fight8)
};

void() ai_mech_sk_stand_fight8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  macro_ai_frame(ai_mech_sk_stand_fight9)
};

void() ai_mech_sk_stand_fight9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_attack();

  macro_ai_frame(ai_mech_sk_stand_fight10)
};

void() ai_mech_sk_stand_fight10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)

  if( self.ai_rank > AI_RANK_REG )
    ai_attack();

  macro_ai_frame(ai_mech_sk_fight_prep)
};