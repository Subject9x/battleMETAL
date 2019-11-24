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
  
  if( self.deadflag >= DEAD_DYING ){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  self.th_react = SUB_Null;
  self.th_pain = SUB_Null;
  self.th_missile = SUB_Null;
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.colormod = '0.33 0.33 0.33';
  self.attack_state = -1;
  self.enemy = world;
  self.maxs = self.maxs * 0.85;
  self.mins = self.mins * 0.85;
  setsize(self, self.mins, self.maxs);
  makevectors( self.angles );  
  setorigin(self, self.origin - (v_up * self.maxs_z * 0.15) );
  droptofloor();
  
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );

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
  self.ai_action_time = time + 600;

  ai_alert_close( self.enemy );
  
  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
  
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, 1, 240, 0.5, 600); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, 1, 180, 0.75, 600); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, 1, 120, 1, 600); 
      break;
  }

  self.think = ai_tank_sk_die1;
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={
  self.deadflag = DEAD_DEAD;
  te_smoke(self.origin, 1);
  
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.ai_action_time = time + 7200;
  }
  self.nextthink = time + 0.1;
};