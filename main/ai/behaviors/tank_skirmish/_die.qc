/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
  
  Setup
    
*/

void() ai_tank_sk_die={
  local entity w_chain;
  local vector v;
  local vector vel;

  ai_sfx_dead();
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.colormod = '0.33 0.33 0.33';
  self.attack_state = -1;
  
  self.maxs = self.maxs * 0.75;
  self.mins_x = self.maxs_x * -1;
  self.mins_y = self.maxs_y * -1;
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  ai_sfx_dead();

  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.cockpit);
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.torsoCenter);
  
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  
  self.think = ai_tank_sk_die1;
  self.ai_action_time = time + 600;
  
  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
  
  vel = self.origin + (v_up * self.vec_size);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles,  self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y /2)), self.angles,  self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
  }
  
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={

  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_CORPSE;
  te_smoke_test(self.origin, 2);
  
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.ai_action_time = time + 7200;
  }
  self.nextthink = time + 0.1;
};