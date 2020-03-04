/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
  
  Setup
    
*/

/* quick garbage collect before rest of death funcs */
void() ai_vec_dest_clean={
  ctrl_unit_cleanup_tank();
  self.think = ai_vec_dest_die1;
  self.nextthink = time + 0.5;
};

void() ai_vec_dest_die={
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
  
  // run weapon death animation
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  ctrl_unit_part_death(self.cockpit);
  
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );

  self.think = ai_vec_dest_clean;
  self.ai_action_time = time + 600;

  ai_alert_close( self.enemy );
  
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
  
  self.nextthink = time + 0.1;
};

/*
  Death animation - tank sits as a smoking wreck
*/
void() ai_vec_dest_die1={
  self.deadflag = DEAD_DEAD;
  te_smoke(self.origin, 1);
  self.think = ai_vec_dest_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_vec_dest_die1a;
    self.ai_action_time = time + 0.05;
  }
  self.nextthink = time + 0.1;
};

//stops smoking
void() ai_vec_dest_die1a={
  self.deadflag = DEAD_DEAD;
  self.think = ai_vec_dest_die1a;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.nextthink = time + 7200;
    return;
  }
  self.nextthink = time + 0.1;
};
