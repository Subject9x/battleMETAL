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
  local entity this;
  local entity w_chain;
  local vector vel;
  local vector forg;
  
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
  
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }

  self.legs.c_ofs = self.mins;
  self.legs.c_alt_ofs = self.maxs;
  self.legs.think = self.legs.th_die;
  self.legs.nextthink = time + 0.05;

  if( self.ai_node_recall )
    remove(self.ai_node_recall);
  
  //fire triggers when dead
  trigger_event( self, self.trigOnDeath );
  
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
  droptofloor();
  mech_player_compdie(self.torsoCenter);
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.armLeft);
  mech_player_compdie(self.armRight);
  mech_player_compdie(self.cockpit);
  
  self.think = ai_mech_sk_die2;
  self.nextthink = time + 2;
};

//explode
void() ai_mech_sk_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = SUB_Null;
};