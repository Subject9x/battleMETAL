/*
battleMETAL 
Author: Peter Roohr
Date: 7/16/2018
Overview: ai unit
  Stock Turret Unit
  an on-ground, static vehicle
*/

void() ai_turret={
  ai_unit_ini_var();
  
  initialize_data_turret_( self.nextVecChoice );
  
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, self.trigOnSpawn); //event interface

  self.th_pain = ai_turret_react;
  self.th_die = ai_turret_die;
  self.touch = ai_turret_touch;
  
  self.SendEntity = ctrl_send_turret;
  self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_NEWENT);
  
  local entity wep;
  for(wep = self.w_slot; wep != world; wep = wep.w_slot){
    wep.effects = wep.effects | EF_NODRAW;
  }  
  self.torsoCenter.effects = self.torsoCenter.effects | EF_NODRAW;
  
  self.ai_state_last = 0;
  self.ai_state_next = ST_PTR;
  self.ai_move_last = 0;
  self.ai_move_next = MOVE_STAND;
  self.ai_movewait = 0;
  
  self.ai_unit_update = ctrl_updateTank;
  
  //ai state interface--------------------------------------------------------  
  self.ai_run_state_now = SUB_Null;
  self.ai_state_patrol = turret_patrol;
  self.ai_state_patrol_pause = turret_patrol_pause;
  self.ai_state_patrol_travel_node = turret_patrol_travel;
  self.ai_state_patrol_travel_blocked = turret_patrol_travel_block;
  
  self.ai_state_combat = turret_combat;
  self.ai_state_combat_moveStart = turret_com_moveStart;
  self.ai_state_combat_moveExec = turret_com_moveExec;
  self.ai_state_combat_moveEnd = turret_com_moveEnd;
  self.ai_state_combat_blocked = turret_com_blocked;
  //--------------------------------------------------------------------------
  
  self.think = ai_state_frame;
  self.nextthink = time + (random() * 0.5);
};

void() ai_turret_touch={
  local float touch_front;
  
  if( other.faction != self.faction ){
    if( !ai_valid_target(self.enemy) ){
      self.oldenemy = self.enemy;
      self.enemy = other;
      if(self.ai_state_next != ST_COMBAT){
        self.ai_state_next = ST_COMBAT;
      }
      return; 
    }
    touch_front = ai_check_targ_infront( other, self.ai_fov, TRUE);
    if( touch_front ){
      self.oldenemy = self.enemy;
      self.enemy = other;
      if(self.ai_state_next != ST_COMBAT){
        self.ai_state_next = ST_COMBAT;
      }
      return;
    }
  }
};

/*
  TH_PAIN
    what to do when hit by fire
*/
void( entity attacker ) ai_turret_react={  
  local float enemyvis;

  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
  //AI currently has no target
  if( (!ai_valid_target(self.enemy)) ){
    self.ai_react_buffer = time + self.ai_react_time * 5;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = TR_TARG;
    self.torsoCenter.enemy = self.enemy;
    if(!self.ai_state_next == ST_COMBAT){
      self.ai_state_next = ST_COMBAT;
    }
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.ai_react_buffer = time + self.ai_react_time * 5;
    if(!self.ai_state_next == ST_COMBAT){
      self.ai_state_next = ST_COMBAT;
    }
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov, TRUE) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.ai_react_buffer = time + self.ai_react_time * 5;
    if(!self.ai_state_next == ST_COMBAT){
      self.ai_state_next = ST_COMBAT;
    }
    return;
  }
  
  self.ai_react_buffer = time + self.ai_react_time * 2;
};