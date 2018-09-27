/*
battleMETAL 
Author: Peter Roohr
Date: 9/25/2018
Overview: ai unit
  VTOL Unit
    no turret
    flies around
    can actually hunt its target
*/

void() ai_vtol_stand;
void() ai_vtol_walk;
void() ai_vtol_run;
void() ai_vtol_run_strafe;
void() ai_vtol_run_charge;
void() ai_vtol_melee;
void() ai_vtol_missile;
void() ai_vtol_missile_strafe;
void() ai_vtol_hunt;
void() ai_vtol_pain;

void() ai_vtol_die;
void() ai_vtol_th;

void() ai_vtol_stand={
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov ) ){
      ai_next_state( ST_RUN );
      return;
    }
  }
  else{
    ai_generic_stand();
  }
};

void() ai_vtol_walk={
  ai_walkgoal();
  
};

void() ai_vtol_run={

};

void() ai_vtol_run_strafe={

};

void() ai_vtol_run_charge={

};

void() ai_vtol_melee={

};

void() ai_vtol_missile={

};

void() ai_vtol_missile_strafe={

};

void() ai_vtol_hunt={

};

void() ai_vtol_pain={

};

void() ai_vtol_die={
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_CORPSE;
  self.flags = self.flags - (self.flags & FL_FLY);
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  
  //fire triggers when dead
  self.target = self.target_die;
  self.enemy = self.ladder_entity;
  activator = self.enemy;
  SUB_UseTargets ();
};

void() ai_vtol_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
    
  if( !self.deadflag ){
    if( self.enemy ){
      if( ai_valid_target( self.enemy ) ){
        self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
        ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
        ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
      }
      else{ 
        self.enemy = world;
      }
    } 
    ai_ranged_attack();
    self.button0 = 0;
  }

  ai_state_control( self.attack_state );
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_vtol_th;
    self.nextthink = time + 0.05;
  }
};


/*
  AI SPAWN FUNCTION
*/
void() ai_vtol={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_vtol - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats( self.ai_rank );
  
  self.th_stand = ai_vtol_stand;
  self.th_walk = ai_vtol_walk;
  self.th_run = ai_vtol_run;
  self.th_run_strafe = ai_vtol_run_strafe;
  self.th_run_charge = ai_vtol_run_charge;
  self.th_missile = ai_vtol_missile;
  self.th_melee = ai_vtol_melee;
  self.th_missile_strafe = ai_vtol_missile_strafe;
  self.th_hunt = ai_vtol_hunt;
  self.th_pain = ai_vtol_pain;
  self.th_die = ai_vtol_die;
  
  ai_initialize_system( ST_STAND );
  
  ai_walk_setup();
  
  self.think = ai_vtol_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};