/*
battleMETAL 
Author: Peter Roohr
Date: 07/20/2020
Overview: 
  turrets are static buildings with rotating turrets,
    they're tanks treated like buildings.
    
  _cohas them rotate every once-and-a-while to do some scanning-like effect.
  
*/

void() turret_combat={
  if( self.ai_state == ST_COMBAT && self.ai_state_last != ST_COMBAT ){
  
    if( !ai_valid_target(self.enemy) ){
      self.enemy = world;
      self.ai_state_next = ST_PTR;
    }
  
    return;
  }
};

void() turret_com_moveStart={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_state_next = ST_COM_MOVE_EXEC;
    return;
  }
};

void() turret_com_moveExec={
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    self.ai_state_next = ST_COM_MOVE_END;
    return;
  }
};

void() turret_com_moveEnd={
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    self.ai_state_next = ST_COMBAT;
    return;
  }
};

void() turret_com_blocked={
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
  
    return;
  }
};