/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Destroyer
  Behavior - Sniper
*/

void() ai_vec_dest_die={
  local entity w_chain;
  
  if( self.deadflag > DEAD_NO  && self.deadflag != DEAD_RAMMED){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  makevectors( self.angles ); 
  
  // run weapon death animation
  w_chain = self.w_slot;
  while(w_chain){
    w_chain.think = SUB_Remove;
    w_chain.nextthink = time + 0.01;
    w_chain = w_chain.w_slot;
  }
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );

  ai_alert_close( self.enemy );
  te_debris( self.origin + (v_up * self.maxs_z * 0.33), self.angles, '0 0 0', rint(self.vec_size / 2 + (random() * self.vec_size+1)), self.vec_size );
  if( (self.flags & FL_TURRET) ){
    te_vehicle_chunk( self.torC_mdl, self.torC_org, '0 0 0', self.torC_angl, particleeffectnum("TE_DEBRIS_TRAIL_MED"), 30, (self.vec_size / 10) + 0.25 );
  }
  
  ai_wreck_vec();
  
  self.enemy = world;
  self.th_pain = ai_NULL_pain;
  self.th_missile = ai_NULL_missile;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.attack_state = -1;
  
  ai_nodegraph_clear_locks();
  
  
  self.SendFlags = self.SendFlags | (SENDFLAG_DEAD | SENDFLAG_BURN | SENDFLAG_MOVE);
  self.ai_unit_update = SUB_Null;
  self.think = ai_tank_dead_frame;
  self.nextthink = time + 0.1;
};
