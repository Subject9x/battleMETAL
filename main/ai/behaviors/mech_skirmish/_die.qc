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

  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );
  
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
  droptofloor();
  ctrl_unit_part_death(self.torsoCenter);
  ctrl_unit_part_death(self.torsoLeft);
  ctrl_unit_part_death(self.torsoRight);
  ctrl_unit_part_death(self.armLeft);
  ctrl_unit_part_death(self.armRight);
  ctrl_unit_part_death(self.cockpit);
  
  self.think = ai_mech_sk_die2;
  self.nextthink = time + 1;
};

//explode
void() ai_mech_sk_die2={
  ctrl_unit_cleanup_tank();
  self.think = SUB_Remove;
  self.nextthink = time + 1;
};