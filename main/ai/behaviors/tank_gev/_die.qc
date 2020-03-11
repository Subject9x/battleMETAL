/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Death
  
  Setup
    
*/

void() ai_gev_die1={
  self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  self.think = ai_gev_die1;
  if( time > self.ai_action_time ){
    self.ai_action_time = time + (random() * 7200);
    self.think = SUB_Remove;
  }
  self.nextthink = time + 0.1;
};

/* quick garbage collect before rest of death funcs */
void() ai_gev_die_clean={
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
  ctrl_unit_cleanup_tank();
  self.think = ai_gev_die1;
  self.nextthink = time + 0.1;
};

void() ai_gev_touch_death={
  local vector vel;
  if( other == world ){
    self.movetype = MOVETYPE_NONE;
    self.SendFlags = self.SendFlags | SENDFLAG_BURN;
    self.touch = SUB_Null;
  }
};

void() ai_gev_die={
  local vector v;
  local vector t;
  t = '0 0 0';
  
  if( self.deadflag >= DEAD_DYING ){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  self.th_react = SUB_Null;
  self.th_pain = SUB_Null;
  self.th_missile = SUB_Null;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_NOT;
  setsize(self, self.mins * 0.35, self.maxs * 0.35);
  setorigin(self, self.origin);
  self.enemy = world;
  
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );
 
  // run weapon death animation
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  ctrl_unit_part_death(self.cockpit);
  
  if( (self.flags & FL_TURRET) ){
    ctrl_unit_part_death(self.torsoCenter);
  }
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  
  t_y = self.ideal_yaw;
  
  makevectors( self.angles );

  v = self.origin + (v_forward * 2) + (v_right * (crandom() * 3)) + (v_up * 3);
 // te_debris( self.origin, self.angles, normalize(v - self.origin) * 100, self.vec_size + (random() * 5), self.vec_size);
  
  if( self.attack_state != ST_STAND ){
    self.velocity = normalize( v - self.origin);
    self.velocity = self.velocity * 200;
    self.gravity = 0.25;
    self.avelocity_x = crandom() * 150;
    self.avelocity_y = crandom() * 300; 
    self.avelocity_z = crandom() * 400;
  }
  else{
    self.velocity = normalize( (self.origin + (v_up * -2)) - self.origin);
    self.velocity_z = self.velocity_z - 10;
    self.gravity = 0.25;
  }
  self.attack_state = -1;
  self.think = ai_gev_die_clean;
  self.nextthink = time + 0.1;
  self.ai_action_time = time + (random() * 500);
  self.attack_state = -1;
  self.touch = ai_gev_touch_death;
  ai_alert_close( self.enemy );
  
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  self.SendFlags = self.SendFlags | SENDFLAG_MOVE;
};