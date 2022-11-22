/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - GEV
  Behavior - Death
  
  Setup
    
*/

void() ai_gev_touch_death={
  if( other == world ){
    self.movetype = MOVETYPE_NONE;
    self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  }
  else{
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
  }
};

void() ai_gev_die={
  local entity w_chain;
  if( self.deadflag > DEAD_NO ){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
 
  // run weapon death animation
  w_chain = self.w_slot;
  while(w_chain){
    //ctrl_unit_part_death(w_chain);
    w_chain.think = SUB_Remove;
    w_chain.nextthink = time + 0.01;
    w_chain = w_chain.w_slot;
  }
  
  makevectors( self.angles );
  
  if( self.attack_state != ST_STAND ){
    self.velocity = normalize( (self.origin + (v_forward * 5)) - self.origin);
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
  ai_alert_close( self.enemy );
  
  self.attack_state = -1;
  self.th_pain = ai_NULL_pain;
  self.th_missile = ai_NULL_missile;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_NOT;
  self.enemy = world;
  
  te_debris( self.origin + (v_up * self.maxs_z * 0.33), self.angles, '0 0 0', rint(self.vec_size / 2 + (random() * self.vec_size+1)), self.vec_size );
  if( (self.flags & FL_TURRET) && self.vec_size > 1){
    te_vehicle_chunk( self.torC_mdl, self.torC_org, '0 0 0', self.torC_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
    
  ai_nodegraph_clear_locks();
  
  setorigin(self, self.origin + (v_up * 5));
  self.SendFlags = self.SendFlags | (SENDFLAG_DEAD | SENDFLAG_BURN | SENDFLAG_MOVE);
  self.touch = ai_gev_touch_death;
  self.think = SUB_Remove;
  self.nextthink = time + (random() * 500);
};