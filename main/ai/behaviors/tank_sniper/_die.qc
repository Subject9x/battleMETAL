/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
  
  Setup
    
*/
/*
  TH_DIE Main
*/
void() ai_vec_dest_die={
  local entity w_chain;
  local vector vel;
  local vector v;
  
  ai_sfx_dead();
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  self.maxs = self.maxs * 0.75;
  self.mins_x = self.maxs_x * -1;
  self.mins_y = self.maxs_y * -1;
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.cockpit);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );

  self.think = ai_vec_dest_die1;
  self.ai_action_time = time + 600;
  
  makevectors( self.angles );  
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
   
  vel = self.origin + (v_up * 2);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
  }
  
  self.nextthink = time + 0.1;
};

/*
  Death animation - tank sits as a smoking wreck
*/
void() ai_vec_dest_die1={

  te_smoke_test(self.origin, 2);
  
  self.think = ai_vec_dest_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_vec_dest_die1a;
    self.ai_action_time = time + 0.05;
  }
  self.nextthink = time + 0.1;
};

//stops smoking
void() ai_vec_dest_die1a={
  self.think = ai_vec_dest_die1a;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.nextthink = time + 7200;
    return;
  }
  self.nextthink = time + 0.1;
};