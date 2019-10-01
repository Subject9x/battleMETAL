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
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.colormod = '0.05 0.05 0.05';
  self.scale = 0.01;
  self.alpha = 0.01;
  self.attack_state = -1;
  self.enemy = world;
  
  droptofloor();
  
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.torsoCenter);
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.armLeft);
  mech_player_compdie(self.armRight);
  mech_player_compdie(self.cockpit);

  self.legs.think = self.legs.th_die;
  self.legs.nextthink = time + 0.05;
  if( self.ai_node_recall )
    remove(self.ai_node_recall);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.think = ai_mech_sk_die1;
  self.ai_action_time = time + 600;
  self.nextthink = time + 0.05;
  
  makevectors( self.torsoCenter.angles );
  vel = self.origin + (v_up * 2);
  forg = self.origin + (v_up * (self.maxs_y / 2) ) + (v_forward * (self.mins_x / 1.5));
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20, world); 
      break;
    case 3:
      te_big_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20, world); 
      break;
    default:
      te_small_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20, world); 
      break;
  }
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin(self, self.origin);
};

/*
  smoking wreck
*/
void() ai_mech_sk_die1={
 
  self.think = ai_mech_sk_die1;
  if( time > self.ai_action_time )
    self.think = ai_mech_sk_die2;
 
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sk_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = SUB_Null;
};