/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Tank - Skirmish
  Behavior - Skirmish
  
  Setup
    
*/

void() ai_tank_sk_clean={
  ctrl_unit_cleanup_tank();
 
  self.effects = self.effects | EF_LOWPRECISION;
  
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
  
  //self.think = ai_tank_sk_die1;
  //self.nextthink = time + 0.25;  
};

void() ai_tank_sk_die={
  if( self.deadflag > DEAD_NO ){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  self.th_react = SUB_Null;
  self.th_pain = SUB_Null;
  self.th_missile = SUB_Null;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  //self.colormod = '0.33 0.33 0.33'; ->CSQC
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

  // run weapon death animation
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  ctrl_unit_part_death(self.cockpit);
  ctrl_unit_part_death(self.torsoLeft);
  ctrl_unit_part_death(self.torsoRight);
  ctrl_unit_part_death(self.torsoCenter);  

  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  self.ai_action_time = time + 600;

  ai_alert_close( self.enemy );

  te_debris( self.origin + (v_up * self.maxs_z * 0.33), self.angles, '0 0 0', rint(self.vec_size / 2 + (random() * self.vec_size+1)), self.vec_size );
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;

  self.think = ai_tank_sk_clean;
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={

  
  /*self.SendFlags = self.SendFlags | SENDFLAG_BURN;
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.ai_action_time = time + 7200;
  }
  self.nextthink = time + 0.1;*/
};