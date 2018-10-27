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
void() ai_noncom_run_strafe;
void() ai_noncom_run_charge;
void() ai_noncom_melee;
void() ai_noncom_missile;
void() ai_noncom_missile_strafe;
void() ai_noncom_hunt;
void() ai_noncom_pain;

void() ai_noncom_die;
void() ai_noncom_th;


void() ai_noncom_stand={
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    ai_next_state( ST_MISSILE );
    return;
  }

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
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    ai_next_state( ST_MISSILE );
    return;
  }
  
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
  if( ai_valid_target( self.enemy ) ){
    local float friend_range;
    local entity friend;
    
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    friend = ai_find_friend( AI_RANGE_L );
    friend_range = -1;
    if( friend ){
      friend_range = ai_check_range( friend );
    }
    
    if( enemy_vis ){
      if( enemy_range < 400 ){
        if( friend_range < AI_RANGE_M ){
          //run to friend
          self.goalentity = friend;
          ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 4;
          return;
        }
        if( enemy_infront ){
          //run behind
          ai_next_state( ST_RUN_CHARGE );
          self.ai_action_time = self.ai_action_time + 6;
          return;
        }
      }
      if( enemy_range <= AI_RANGE_M ){
        if( friend_range <= AI_RANGE_M ){
          //run to friend
          ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 8;
          return;
        }
      }
      if( enemy_range > AI_RANGE_L ){
        if( friend_range <= AI_RANGE_M ){
          //run to friend
          ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 8;
          return;
        }
      }
      //flee to node
      ai_next_state( ST_MELEE );
      self.ai_action_time = self.ai_action_time + 8;
      return;
    }
    else{
      ai_next_state( ST_MELEE );
      self.ai_action_time = self.ai_action_time + ( self.ai_rank * 2 );
      return;
    }
  }
  ai_next_state( ST_WALK );
  return;
};

/*
  Run to the nearest friendly
*/
void() ai_noncom_run_strafe={
  local float rng;
 
  rng = vlen( self.goalentity.origin - self.origin );
  if( rng > 100 ){
    ai_walkgoal( AI_RUN_SPD );
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    if( ai_valid_target( self.enemy ) ){
      ai_next_state( ST_MISSILE );
      return;
    }
    return;
  }
};

/*
  Try to get behind Enemy
*/
void() ai_noncom_run_charge={
  
};
/*
  Non Com runs to the closest node
*/
void() ai_noncom_melee={

  ai_walkgoal( AI_RUN_SPD );

  if( time > self.ai_action_time ){
    ai_next_state( ST_WALK );
    if( ai_valid_target( self.enemy ) ){
      ai_next_state( ST_RUN );
    }
    return;
  }
};

/*
  Pass Enemy to allies
*/
void() ai_noncom_missile={
  if( ai_valid_target( self.enemy ) ){
    local entity friend;
    friend = ai_find_friend( AI_RANGE_S );
    if( (friend.flags & FL_MONSTER) ){
      ai_give_target( friend, self.enemy, TRUE ) ;
    }
    ai_next_state( ST_RUN );
    return;
  }
  ai_next_state( ST_WALK );
  return;
};

/*
  Run to scheduled node
*/
void() ai_noncom_missile_strafe={

};

void() ai_noncom_hunt={
  if( ai_valid_target( self.enemy ) ){
    local entity friend;
    friend = ai_find_friend( AI_RANGE_S );
    if( friend ){
      ai_give_target( friend, self.enemy, (self.enemy.flags & FL_CLIENT) ) ;
    }
    ai_next_state( ST_RUN );
    return;
  }
  ai_next_state( ST_WALK );
  return;
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
  trigger_event( self, trigOnDeath );

  self.think = BecomeExplosion;
  self.nextthink = time + 2;
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
  self.th_run_strafe = ai_noncom_run_strafe;
  self.th_run_charge = ai_noncom_run_charge;
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