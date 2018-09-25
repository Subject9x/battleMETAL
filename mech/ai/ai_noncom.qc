/*
battleMETAL 
Author: Peter Roohr
Date: 9/24/2018
Overview: ai unit
  Civvie Unit
    has no guns, generally panics and tries to avoid fire
*/

void() ai_noncom_stand;
void() ai_noncom_walk;
void() ai_noncom_run;
void() ai_noncom_melee;
void() ai_noncom_missile;
void() ai_noncom_missile_strafe;
void() ai_noncom_hunt;
void() ai_noncom_pain;

void() ai_noncom_die;
void() ai_noncom_th;


void() ai_noncom_stand={
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};

void() ai_noncom_walk={
  ai_walkgoal( AI_WALK_SPD );
  
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      ai_next_state( ST_WALK );
      return;
    }
    ai_next_state( ST_STAND );
    return;
  }
};

void() ai_noncom_run={

};

void() ai_noncom_melee={

};

void() ai_noncom_missile={

};

void() ai_noncom_missile_strafe={

};

void() ai_noncom_hunt={

};

void() ai_noncom_pain={

};


void() ai_noncom_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();

  self.think = BecomeExplosion;
  self.nextthink = time + 0.1;
};

void() ai_noncom_th={

  ai_state_control( self.attack_state );

  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_noncom_th;
    self.nextthink = time + 0.05;
  }
};

void() ai_noncom_tank={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_noncom_tank - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats( self.ai_rank );
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  droptofloor();
  
  self.th_stand = ai_noncom_stand;
  self.th_walk = ai_noncom_walk;
  self.th_run = ai_noncom_run;
  self.th_run_strafe = ai_generic_run_strafe;
  self.th_missile = ai_noncom_missile;
  self.th_melee = ai_noncom_melee;
  self.th_missile_strafe = ai_noncom_missile_strafe;
  self.th_hunt = ai_noncom_hunt;
  self.th_pain = ai_noncom_hunt;
  self.th_die = ai_noncom_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();
  
  self.colormod = '0.55 1 0'; //DEBUG
  
  self.think = ai_noncom_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};