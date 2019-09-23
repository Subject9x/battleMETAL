/*
battleMETAL 
Author: Peter Roohr
Date: 09/23/2018
Overview: ai unit
  Mech - Sniper
  Behavior - Die
  
  Setup
    
*/
/*
  TH_DIE
*/ 
void() ai_mech_sniper_die={
  local vector vel;
  local vector forg;
  
  ai_sfx_dead();
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.05 0.05 0.05';
  self.attack_state = -1;
  
  droptofloor();
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.armLeft);
  mech_player_compdie(self.armRight);
  mech_player_compdie(self.cockpit);
  
  otemp = self;
  self = self.legs;
    bot_leg_die1();
  self = otemp;
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.think = ai_mech_sniper_die1;
  self.ai_action_time = time + 300;
  //basically overkill damage will just remove the mech (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.think = ai_mech_sniper_die2;
  }
  self.nextthink = time + 0.1;
  
  makevectors( self.torsoCenter.angles );
  vel = self.origin + (v_up * 2);
  forg = self.origin + (v_up * (self.maxs_y / 2) ) + (v_forward * (self.mins_x / 1.5));
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
  }
};

/*
  smoking wreck
*/
void() ai_mech_sniper_die1={

  te_smoke_test(self.origin, 3);
  te_smoke_test(self.torsoLeft.origin, 1);
  te_smoke_test(self.torsoRight.origin, 1);
  
  self.think = ai_mech_sniper_die1;
  if( time > self.ai_action_time ){
    self.think = ai_mech_sniper_die2;
  } 
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sniper_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};
