/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
*/

void() ai_wreck_smoke={
  local vector v;
  
  v = self.origin + [0,0, self.maxs_z + 5] + WeatherDominator.wind;
  if( time > self.ai_action_time ){
    pointparticles( particleeffectnum("TE_WRECK_SMOKE_SM"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
  }
  else{
    pointparticles( particleeffectnum("TE_WRECK_SMOKE"), self.origin, normalize(v - self.origin) * 10, self.vec_size/2);
  }
  
  if( time > self.ai_viewtime ){
    self.think = SUB_Null;
  }
  else{
    self.think = ai_wreck_smoke;
  }
  self.nextthink = time + 0.1;
};

void() ai_wreck_vec={
  local entity wreck;
  local vector wreckOrg;
  
  wreck = spawn();
  
  if(!wreck){return;}
  
  wreck.vec_size = self.vec_size;
  wreck.movetype = MOVETYPE_NONE;
  wreck.solid = SOLID_NOT;
  wreck.colormod = '0.45 0.45 0.45';
  wreck.angles = self.angles;
  
  makevectors(wreck.angles);
  traceline(self.origin, self.origin - (v_up * 512), TRUE, self);
  wreckOrg = trace_endpos + (v_up * self.mins_z * -1 );
  GetAlignedSurfaceAngles(self);
  
  
  setmodel(wreck, self.legs_mdl);
  setsize(wreck, wreck.mins, wreck.maxs);
  setorigin(wreck, wreckOrg);
  
  
  wreck.ai_viewtime = time + 180 * (random() * 180);
  wreck.ai_action_time = time + 180;
  
  wreck.think = ai_wreck_smoke;
  wreck.nextthink = time + 0.1;
};

void() ai_tank_sk_die={
  local entity w_chain;
  
  if( self.deadflag > DEAD_NO ){
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
  
  self.enemy = world;
  self.th_pain = ai_NULL_pain;
  self.th_missile = ai_NULL_missile;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.attack_state = -1;
  
  ai_nodegraph_clear_locks();
  
  ai_wreck_vec();
  
  self.SendFlags = self.SendFlags | (SENDFLAG_DEAD | SENDFLAG_BURN | SENDFLAG_MOVE);
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};