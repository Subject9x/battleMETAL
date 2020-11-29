/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Skirmisher
  Behavior - Death
    
  Setup
    
*/
/*
  TH_DIE
*/ 
void() ai_mech_sk_die={
  
  if( self.deadflag > DEAD_NO ){
    return; //double play prevention
  }
  
  ai_sfx_dead();
  self.th_pain = ai_NULL_pain;
  self.deadflag = DEAD_DEAD;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.colormod = '0.05 0.05 0.05';
  self.scale = 0.01;
  self.alpha = 0.01;
  self.attack_state = -1;
  self.enemy = world;
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
  droptofloor();
  
  // run weapon death animation
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    ctrl_unit_part_death(w_chain);
    w_chain = w_chain.w_slot;
  }

  self.legs.compOffset = self.mins;
  self.legs.compAltOffset = self.maxs;
  self.legs.think = self.legs.th_die;
  self.legs.nextthink = time + 0.05;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  if( self.moveState != MOVE_STAND ){
    ctrl_unit_part_death(self.torsoCenter);
    ctrl_unit_part_death(self.torsoLeft);
    ctrl_unit_part_death(self.torsoRight);
    ctrl_unit_part_death(self.armLeft);
    ctrl_unit_part_death(self.armRight);
  }
  ctrl_unit_part_death(self.cockpit);
  
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
  
  ai_alert_close( self.enemy );
  
  ai_nodegraph_clear_locks();
  
  self.SendFlags = self.SendFlags | (SENDFLAG_DEAD | SENDFLAG_MOVE);
  
  self.think = ai_mech_sk_die2;
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sk_die2={
  ctrl_unit_cleanup_mech();
  self.effects = self.effects | EF_LOWPRECISION;
  self.think = SUB_Remove;
  self.nextthink = time + 0.1;
};