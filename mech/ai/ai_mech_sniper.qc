/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
Overview: ai unit
  Mech - Sniper
  an on-ground, turreted, walking unit
  snipers try to work the mid and long range
  close-up they're kinda useless, only should attack at longer ranges
*/

/*
float ST_STAND              = 1;  //th_stand
float ST_WALK               = 2;  //th_walk
float ST_RUN                = 4;  //th_run
float ST_RUN_STRAFE         = 5;  //th_run_strafe
float ST_RUN_CHARGE         = 6;  //th_run_charge
float ST_MISSILE            = 7;  //th_missile
float ST_MELEE              = 8;  //th_melee
float ST_MISSILE_STRAFE     = 9;  //th_missile_strafe
float ST_HUNT               = 10; //th_hunt
float ST_RADAR              = 11; //TODO, th_radar, - turn to face target even if LoS is lost
float ST_HUNT_START         = 12; //TODO
float ST_PAIN               = 13; //TODO - a fun holdover from Quake, this 'staggers' the target
*/
void() ai_mech_snipe_stand;
void() ai_mech_snipe_walk;
void() ai_mech_snipe_run;
void() ai_mech_snipe_run_strafe;
void() ai_mech_snipe_run_charge;
void() ai_mech_snipe_melee;
void() ai_mech_snipe_missile;
void() ai_mech_snipe_missile_strafe;
void() ai_mech_snipe_hunt;
void() ai_mech_snipe_pain;

void() ai_mech_snipe_die;
void() ai_mech_snipe_die1;
void() ai_mech_snipe_die2;

//custom funcs
void() ai_mech_snipe_turn;
void() ai_mech_snipe_turn_back;


void() ai_mech_snipe_stand={};
void() ai_mech_snipe_walk={};
void() ai_mech_snipe_run={};
void() ai_mech_snipe_run_strafe={};
void() ai_mech_snipe_run_charge={};
void() ai_mech_snipe_melee={};
void() ai_mech_snipe_missile={};
void() ai_mech_snipe_missile_strafe={};
void() ai_mech_snipe_hunt={};
void() ai_mech_snipe_pain={};

/*
  SNIPER MECH THINK FUNCTION
*/
void() ai_mech_snipe_th={  
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
    
    ai_state_control( self.attack_state );
    self.v_angle = self.angles;
    if( (self.flags & FL_TURRET) ){
      ai_turret_control();
    }
    self.e_legs.angles_y = self.angles_y;
  }
  
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_mech_snipe_th;
    self.nextthink = time + 0.05;
  }
}

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={
  if( ai_spawn_clean(cvar("gamemode")) == FALSE ){
		objerror ("ai_mech_snipeirmish - outside of game mode");
    remove(self);
    return;
  }
  
  ai_unit_ini_var();
  data_iniMech( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  
  self.th_stand = ai_mech_snipe_stand;
  self.th_walk = ai_generic_walk;
  self.th_run = ai_mech_snipe_run;
  self.th_run_strafe = ai_mech_snipe_run_strafe;
  self.th_run_charge = ai_mech_snipe_run_charge;
  self.th_missile = ai_mech_snipe_missile;
  self.th_melee = ai_mech_snipe_melee;
  self.th_missile_strafe = ai_mech_snipe_missile_strafe;
  self.th_hunt = ai_mech_snipe_hunt;
  self.th_pain = ai_mech_snipe_pain;
  self.th_die = ai_mech_snipe_die;
  
  ai_initialize_system( ST_STAND );
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  droptofloor();
  
  ai_walk_setup();
  
  self.think = ai_mech_snipe_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};