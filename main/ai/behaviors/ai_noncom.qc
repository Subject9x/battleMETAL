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
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
    //ai_next_state( ST_MISSILE );
    return;
  }

  if( time > self.ai_action_time ){
    if( self.movetarget ){
     // ai_next_state( ST_WALK );
      return;
    }
   // ai_next_state( ST_STAND );
    return;
  }
};

void() ai_noncom_walk={
  //ai_walkgoal( AI_WALK_SPD ); DEPRECATED
  
  if( ai_check_scan( self.stat_rdr_mode ) == TRUE ){
   // ai_next_state( ST_MISSILE );
    return;
  }
  
  if( time > self.ai_action_time ){
    if( self.movetarget ){
      //ai_next_state( ST_WALK );
      return;
    }
    //ai_next_state( ST_STAND );
    return;
  }
};

void() ai_noncom_run={
  if( ai_valid_target( self.enemy ) ){
    local float friend_range;
    local entity friend;
    
    //enemy_vis = ai_check_vis( self.enemy );
    //enemy_range = self.stat_trg_dist;
    //enemy_infront = ai_check_face( self.enemy, self.ai_fov, FALSE);
    
    /*friend = ai_find_friend( AI_RANGE_L );
    friend_range = -1;
    if( friend ){
      friend_range = ai_check_range( friend );
    }
    
    if( enemy_vis ){
      if( enemy_range < 400 ){
        if( friend_range < AI_RANGE_M ){
          //run to friend
          self.goalentity = friend;
         // ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 4;
          return;
        }
        if( enemy_infront ){
          //run behind
         // ai_next_state( ST_RUN_CHARGE );
          self.ai_action_time = self.ai_action_time + 6;
          return;
        }
      }
      if( enemy_range <= AI_RANGE_M ){
        if( friend_range <= AI_RANGE_M ){
          //run to friend
         // ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 8;
          return;
        }
      }
      if( enemy_range > AI_RANGE_L ){
        if( friend_range <= AI_RANGE_M ){
          //run to friend
         // ai_next_state( ST_RUN_STRAFE );
          self.ai_action_time = self.ai_action_time + 8;
          return;
        }
      }
      //flee to node
      //ai_next_state( ST_MELEE );
      self.ai_action_time = self.ai_action_time + 8;
      return;
    }
    else{
      //ai_next_state( ST_MELEE );
      self.ai_action_time = self.ai_action_time + ( self.ai_rank * 2 );
      return;
    }
  }
  //ai_next_state( ST_WALK );*/
  return;
};

/*
  Run to the nearest friendly
*/
void() ai_noncom_run_strafe={
  local float rng;
 
  rng = vlen( self.goalentity.origin - self.origin );
  if( rng > 100 ){
    //ai_walkgoal( AI_RUN_SPD ); DEPRECATED
  }
  if( time > self.ai_action_time ){
   // ai_next_state( ST_RUN );
    if( ai_valid_target( self.enemy ) ){
     // ai_next_state( ST_MISSILE );
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

  //ai_walkgoal( AI_RUN_SPD ); DEPRECATED

  if( time > self.ai_action_time ){
    //ai_next_state( ST_WALK );
    if( ai_valid_target( self.enemy ) ){
      //ai_next_state( ST_RUN );
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
    //ai_next_state( ST_RUN );
  }
  //ai_next_state( ST_WALK );
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
    //ai_next_state( ST_RUN );
    return;
  }
  //ai_next_state( ST_WALK );
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
  trigger_event( self.enemy, self.trigOnDeath );

  self.think = BecomeExplosion;
  self.nextthink = time + 2;
};

void() ai_noncom_th={


  self.think = ai_noncom_th;
  self.nextthink = time + 0.05;
  
};

void() ai_noncom_tank={

  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, self.trigOnSpawn); //event interface
   
  ai_setup_patrol();
  
  droptofloor();
  
  self.th_die = ai_noncom_die;
 
  
  self.think = ai_noncom_th;
  if( (self.spawnflags & COLD_START) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};