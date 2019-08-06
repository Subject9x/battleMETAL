/*
battleMETAL
Author: Peter Roohr
Date: 08/05/2019
Overview: 
  This system processes HUD text messages, the text messages themselves are 
  based on client state-changes from the server. 
*/

/*

*/
void() text_hud_message_frame={  
  local float textLen;
  local float itr;
  local float prev;
  local string messageVal;
  if( time < TXT_TIME ){
    if( MESSAGE_QUEUE[0] != NULL_STRING ){
      hud_render_message( HUD_TXT_ORG, MESSAGE_QUEUE[0], HUD_TXT_SIZE, HUD_ALPHA, HUD_TXT_ALIGN) ;
    }
  }
  if(time > TXT_TIME_NEXT){
    if( MESSAGE_QUEUE[0] != NULL_STRING ){
      textLen = stringwidth( MESSAGE_QUEUE[0], 0, HUD_TXT_SIZE);
      TXT_TIME = time + (textLen / 100 ) + 0.05;
      TXT_TIME_NEXT = TXT_TIME + 0.1; 
    }
    else{
      TXT_TIME = -1;
      TXT_TIME_NEXT = time + 0.1;
    }
    itr = 1;
    while( itr < TXT_QSIZE ){
      prev = itr - 1;
      messageVal = MESSAGE_QUEUE[itr];
      MESSAGE_QUEUE[prev] = messageVal;
      MESSAGE_QUEUE[itr] = NULL_STRING;
      itr = itr + 1;
    }
  }

};

void( string textMessage, float limiter ) text_hud_message_enqueue={
  local float arrIdx;
  local float current;
  local float added;
  
  arrIdx = 0;
  while( arrIdx < TXT_QSIZE ){
    if( MESSAGE_QUEUE[arrIdx] == textMessage ){
      current = current + 1;
    }
    arrIdx = arrIdx + 1;
  }
  if( current < limiter ){
    added = FALSE;
    arrIdx = 1;
    while(arrIdx < TXT_QSIZE){
      if(MESSAGE_QUEUE[arrIdx] == NULL_STRING){
        if( !added ){
          MESSAGE_QUEUE[arrIdx] = textMessage;
          added = TRUE;
        }
      }
      arrIdx = arrIdx + 1;
    }
  }
};

void() text_hud_message_critical_left_arm={
  text_hud_message_enqueue( "Critical Hit: Left Arm.", 1 );
};

void() text_hud_message_critical_right_arm={
  text_hud_message_enqueue( "Critical Hit: Right Arm.", 1 );
};

void() text_hud_message_critical_left_torso={
  text_hud_message_enqueue( "Critical Hit: Left Torso.", 1 );
};

void() text_hud_message_critical_right_torso={
  text_hud_message_enqueue( "Critical Hit: Right Torso.", 1 );
};

void() text_hud_message_critical_legs={
  text_hud_message_enqueue( "Critical Hit: Legs", 1);
};

void() text_hud_message_critical_weapon={
  text_hud_message_enqueue( "Weapon destroyed.", 6 );
};

void() text_hud_message_powerup={
  text_hud_message_enqueue( "Reactor Online. All Sytems nominal.", 1 );
};

void() text_hud_message_nav_reached={
  text_hud_message_enqueue( "Nav Point reached.", 1 );
};

void() text_hud_message_objective_complete_prime={
  text_hud_message_enqueue( "Primary Objective complete.", 1 );
};

void() text_hud_message_objective_complete_second={
  text_hud_message_enqueue( "Secondary Objective complete.", 1 );
};

void() text_hud_message_objective_failed={
  text_hud_message_enqueue( "Objective Failed.", 1 );
};

void() text_hud_message_mission_complete={
  text_hud_message_enqueue( "Mission Successful.", 1 );
};

void() text_hud_message_mission_failed={
  text_hud_message_enqueue( "Mission Failed.", 1 );
};

void() text_hud_message_target_killed={
  text_hud_message_enqueue( "Target Destroyed.", 1 );
};