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
      return;
    }
    self.ai_state_next = ST_COM_MOVE_START;
    /*
      Combat Frame State Checks
    */
    enemy_vis = ai_check_vis( self.enemy );
    
    if( enemy_vis == VIS_FAIL ){
      self.ai_state_next = ST_COM_MOVE_BLOCK;
      return;
    }
    
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    enemy_dist = self.stat_trg_dist / self.ai_minrange;
    //target out of range
    if( enemy_dist > 1.0 ){
      //go to 'hold state' for a few seconds
      self.ai_state_next = ST_COM_MOVE_BLOCK;
    }
    
    if( enemy_vis == VIS_FRN ){
      self.ai_state_next = ST_COM_MOVE_BLOCK;
    }
    return;
  }
};

void() turret_com_moveStart={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    if( !ai_valid_target(self.enemy) ){
      self.enemy = world;
      self.ai_state_next = ST_PTR;
      return;
    }
    self.torsoCenter.attack_state = TR_TARG;
    self.ai_state_next = ST_COM_MOVE_EXEC;
    ai_attack();
    self.ai_movewait = time + (self.ai_rank * 1.25);
    return;
  }
};

void() turret_com_moveExec={
  if( self.ai_state == ST_COM_MOVE_EXEC && self.ai_state_last != ST_COM_MOVE_EXEC ){
    if( !ai_valid_target(self.enemy) ){
      self.enemy = world;
      self.ai_state_next = ST_PTR;
      return;
    }
    ai_attack();
    return;
  }
  ai_attack();
  if(time > self.ai_movewait ){
    self.ai_state_next = ST_COM_MOVE_END;
  }
};

void() turret_com_moveEnd={
  if( self.ai_state == ST_COM_MOVE_END && self.ai_state_last != ST_COM_MOVE_END ){
    if( !ai_valid_target(self.enemy) ){
      self.enemy = world;
      self.ai_state_next = ST_PTR;
      return;
    }
    
    self.ai_state_next = ST_COMBAT;
    return;
  }
};

void() turret_com_blocked={
  if( self.ai_state == ST_COM_MOVE_BLOCK && self.ai_state_last != ST_COM_MOVE_BLOCK ){
    self.ai_movewait = time + (self.ai_rank * 1.15);
    return;
  }
  if(time > self.ai_movewait){
    enemy_vis = ai_check_vis( self.enemy );
    if(enemy_vis == VIS_FRN || enemy_vis == VIS_FRAC){
      if(self.ai_state_next != ST_COMBAT){
        self.ai_state_next = ST_COMBAT;
      }
      return;
    }
    self.enemy = world;
    self.ai_state_next = ST_PTR;
    return;
  }
};