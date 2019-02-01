/*
battleMETAL 
Author: Peter Roohr
Date: 7/20/2018
Overview: ai unit
  Mech - Skirmisher
  an on-ground, turreted, walking unit
  skirmishers play to engage targets at medium to close range
  they can strafe left and right against targets
*/

void() ai_mech_sk_stand;
void() ai_mech_sk_walk;

void() ai_mech_sk_run;
void() ai_mech_sk_run_strafe;
void() ai_mech_sk_run_charge;

void() ai_mech_sk_melee;

void() ai_mech_sk_missile;
void() ai_mech_sk_missile_strafe;

void() ai_mech_sk_hunt;

void() ai_mech_sk_pain;

void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die2;

//custom funcs
void() ai_mech_sk_turn;
void() ai_mech_sk_turn_back;

/*
          MECH SKIRMISH STAND
*/
void() ai_mech_sk_stand={
  //cons_logAString("[STATE]", "ai_mech_sk_stand");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov ) ){
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  else{
    ai_generic_stand();
  }
};

/*
          MECH SKIRMISH WALK
*/
void() ai_mech_sk_walk={
  //cons_logAString("[STATE]", "ai_mech_sk_walk");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, self.ai_fov ) ){
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  else{
    ai_generic_walk();
  }
};

/*
          MECH SKIRMISH RUN
*/
void() ai_mech_sk_run={
  //cons_logAString("[STATE]", "ai_mech_sk_run");  //DEBUG
  local float tyaw;
  if( ai_valid_target( self.enemy ) ){
    tyaw = vectoyaw( self.enemy.origin - self.origin );
    ai_turret_set_state( TR_TARG );
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis ){
      if( enemy_range <= 25 ){
        //too close back it up
        ai_mech_sk_turn_back();
        return;
      }
      if( enemy_range < ( 400 )){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            //better skirmishers rush the target
            ai_next_state( ST_RUN_CHARGE );
            ai_leg_frame( leg_walk1 );
            self.ai_action_time = self.ai_action_time + 4 + ( random() * 4 );
            self.lefty = 1;
            if( random() < 0.6 ){
              self.lefty = -1;
            }
            self.ideal_yaw = anglemod( tyaw + (self.lefty * 60) );
            return;
          }
          ai_next_state( ST_RUN_STRAFE );
          ai_leg_frame( leg_walk1 );
          self.ai_action_time = self.ai_action_time + 2 + ( random() * 4 );
          self.lefty = 1;
          if( random() < 0.6 ){
            self.lefty = -1;
          }
          self.ideal_yaw = anglemod( tyaw + (self.lefty * 90) );
          return;
        }
        if( self.ai_rank < AI_RANK_REG ){
          //injecting custom functions to subvert the state controller?
          //delightfully devilish, seymour
          if( self.ai_rank == AI_RANK_ACE ){
            ai_mech_sk_turn_back();
            return;
          }
          ai_mech_sk_turn();
          return;
        }
        ai_next_state( ST_STAND );
        ai_leg_frame( leg_stand1 );
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          //MECH SKIRMISH MELEE
          ai_next_state( ST_MELEE );
          tyaw = anglemod( tyaw + random() * 360 );
          self.ideal_yaw = tyaw;
          self.ai_action_time = self.ai_action_time + 3 + (random() * self.ai_rank);
          return;
        }
        if( self.ai_rank < AI_RANK_REG ){
          //better skirmishers rush the target
          ai_next_state( ST_RUN_CHARGE );
          ai_leg_frame( leg_walk1 );
          self.ai_action_time = self.ai_action_time + 4 + ( random() * 4 );
          self.lefty = 1;
          if( random() < 0.6 ){
            self.lefty = -1;
          }
          self.ideal_yaw = anglemod( tyaw + (self.lefty * 60) );
          return;
        }
        ai_mech_sk_turn_back();
        return;
      }
      if( enemy_range <= (self.ai_minrange * 2) ){
        if( enemy_infront ){
          if( self.ai_rank < AI_RANK_REG ){
            ai_next_state( ST_MISSILE_STRAFE );
            self.ai_action_time = self.ai_action_time + 5;
            return;
          }
        }
        if( self.ai_rank < AI_RANK_REG ){
          ai_next_state( ST_WALK );
          ai_leg_frame( leg_walk1 );
          return; 
        }
        ai_next_state( ST_STAND );
        ai_leg_frame( leg_stand1 );
        return;
      }
      movetogoal( self.m_fspeed * AI_RUN_SPD );
      ai_turret_set_state( TR_NORM );
      ai_leg_frame( leg_walk1 );
      return;
    }
  }
  else{
    ai_leg_frame( leg_stand1 );
    ai_turret_set_state( TR_NORM );
    ai_next_state( ST_STAND );
    return;
  }
};

/*
  custom: MECH SKIRMISH TURN
  
  mech walks forward while trying to turn to enemy
*/
void() ai_mech_sk_turn={
  //cons_logAString("[STATE]", "ai_mech_sk_turn");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    ai_move( self.angles_y, self.m_fspeed * AI_RUN_SPD );
  }
  else{
    ai_next_state( ST_STAND );
    ai_leg_frame( leg_stand1 );
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};
void() ai_mech_sk_turn_back={
  //cons_logAString("[STATE]", "ai_mech_sk_turn_back");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    ai_walk_back( self.m_fspeed * AI_RUN_SPD );
  }
  else{
    ai_next_state( ST_STAND );
    ai_leg_frame( leg_stand1 );
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};


/*
            MECH SKIRMISH RUN STRAFE
*/
void() ai_mech_sk_run_strafe={
  //cons_logAString("[STATE]", "ai_mech_sk_run_strafe");  //DEBUG
  ai_update_accuracy( TRUE );
  if( ai_valid_target( self.enemy ) ){
    if( util_checkAngNotIdeal( self.angles_y, self.ideal_yaw, 25) ){
      ai_move_turn();
    }
    else{
      local float moveSpeed;
      moveSpeed = self.m_fspeed / 3;
      moveSpeed = moveSpeed + self.m_sspeed ;
      moveSpeed = moveSpeed * AI_RUN_SPD;
      ai_move( self.angles_y, moveSpeed);
    }
  }
  else{
    ai_next_state( ST_STAND );
    ai_leg_frame( leg_stand1 );
    self.ai_action_time = self.ai_action_time + 1;
    ai_turret_set_state( TR_NORM );
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH RUN CHARGE
  more advanced skirmisher pilots will charge the player.
  the charge is at an offset, and the charge DOES NOT attempt to
  rotate with the player.
*/
void() ai_mech_sk_run_charge={
  //cons_logAString("[STATE]", "ai_mech_sk_run_charge");  //DEBUG
  ai_update_accuracy( TRUE );
  if( ai_valid_target( self.enemy ) ){
    if( util_checkAngNotIdeal( self.angles_y, self.ideal_yaw, 25) ){
      ai_move_turn();
    }
    else{
      local float moveSpeed;
      moveSpeed = self.m_fspeed / 3;
      moveSpeed = moveSpeed + self.m_sspeed ;
      moveSpeed = moveSpeed * AI_RUN_SPD;
      ai_move( self.angles_y, moveSpeed);
    }
    if( ai_attack() ){
      ai_next_state( ST_MISSILE_STRAFE );
      self.ai_action_time = self.ai_action_time + 2 + (random() * 2);
      return;
    }
  }
  else{
    if( self.ai_rank < AI_RANK_REG ){
      ai_next_state( ST_WALK );
      ai_turret_set_state( TR_NORM );
      ai_leg_frame( leg_walk1 );
      return;
    }
    ai_next_state( ST_STAND );
    ai_turret_set_state( TR_NORM );
    ai_leg_frame( leg_stand1 );
    return;
  }

  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH MELEE
*/
void() ai_mech_sk_melee={
  //cons_logAString("[STATE]", "ai_mech_sk_melee");  //DEBUG
  ai_update_accuracy( TRUE );
  if( ai_valid_target( self.enemy ) ){
    if( util_checkAngNotIdeal( self.angles_y, self.ideal_yaw, 35) ){
      ai_move_turn();
    }
    else{
      local float moveSpeed;
      moveSpeed = self.m_fspeed / 3;
      moveSpeed = moveSpeed + self.m_sspeed ;
      moveSpeed = moveSpeed * AI_WALK_SPD;
      ai_move( self.angles_y, moveSpeed);
    }
    if( ai_check_face( self.enemy, 0.97 ) ){
      if( self.ai_rank < AI_RANK_REG ){
        ai_next_state( ST_MISSILE_STRAFE );
        self.ai_action_time = self.ai_action_time + skill;
        return;
      }
      ai_next_state( ST_MISSILE );
      return;
    }
  }
  else{
    ai_next_state( ST_STAND );
    ai_turret_set_state( TR_NORM );
    ai_leg_frame( leg_stand1 );
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH MISSILE
  
*/
void() ai_mech_sk_missile={
  //cons_logAString("[STATE]", "ai_mech_sk_missile");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    ai_face_targ();
    if( ai_check_face( self.enemy, 0.97 ) ){
      if( ai_attack() ){
        ai_next_state( ST_RUN );
        return;
      }
    }
  }
  
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH MISSILE STRAFE
  if prev. state was strafe, this will strafe in that direction.
  if skill is high enough, ai should track target yaw
*/
void() ai_mech_sk_missile_strafe={
 // cons_logAString("[STATE]", "ai_mech_sk_missile_strafe");  //DEBUG
  ai_update_accuracy( FALSE );
  if( ai_valid_target( self.enemy ) ){
    if( (skill > 2) ){
      ai_face_targ();
    }
    ai_move( self.angles_y, self.m_sspeed * AI_WALK_SPD);
    if( ai_check_face( self.enemy, 0.97 ) ){
      if( ai_attack() ){
        ai_next_state( ST_WALK );
        ai_leg_frame( leg_walk1 );
        return;
      }
    }
    
  }
  else{
    if( self.ai_rank < AI_RANK_REG ){
      ai_next_state( ST_WALK );
      ai_turret_set_state( TR_NORM );
      ai_leg_frame( leg_walk1 );
      return;
    }
    ai_next_state( ST_STAND );
    ai_turret_set_state( TR_NORM );
    ai_leg_frame( leg_stand1 );
    return;
  }
  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH HUNT
*/
void() ai_mech_sk_hunt={
  //cons_logAString("[STATE]", "ai_mech_sk_hunt");  //DEBUG

  if( time > self.ai_action_time ){
    ai_next_state( ST_RUN );
    return;
  }
};

/*
            MECH SKIRMISH PAIN
*/
void() ai_mech_sk_pain={
  
};

/*
  TH_DIE
*/ 
void() ai_mech_sk_die={
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
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_arm_l);
  mech_player_compdie(self.e_arm_r);
  mech_player_compdie(self.e_cam);
  ai_leg_frame( leg_stand1 );
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.think = ai_mech_sk_die1;
  self.ai_action_time = time + 300;
  //basically overkill damage will just remove the mech (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.think = ai_mech_sk_die2;
  }
  self.nextthink = time + 0.1;
};

/*
  smoking wreck
*/
void() ai_mech_sk_die1={
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_fspeed) + (v_right * world.m_fspeed) + (v_up * world.m_fspeed);
  te_smoke_test(self.origin, sm + '0 0 5', 3);
  te_smoke_test(self.e_tor_l.origin, sm + '0 0 5', 1);
  te_smoke_test(self.e_tor_r.origin, sm + '0 0 5', 1);
  
  self.think = ai_mech_sk_die1;
  if( time > self.ai_action_time ){
    self.think = ai_mech_sk_die2;
  } 
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sk_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  SKIRMISHER MECH THINK FUNCTION
*/
void() ai_mech_sk_th={
  local entity wep;
  
  ctrl_updateCenterTorso();
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
  
  if( !(self.spawnflags & AI_SPAWNFLAG_DEBUG) ){
    if( !self.deadflag ){
      if( self.enemy ){
        if( ai_valid_target( self.enemy ) ){
          self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
          ai_wep_group_track(self.stat_trg_dist, self.w_group1, AI_RANGE_S); 
          ai_wep_group_track(self.stat_trg_dist, self.w_group2, AI_RANGE_M); 
          ai_wep_group_track(self.stat_trg_dist, self.w_group3, AI_RANGE_L);
          ai_lock_on();
        }
        else{ 
          self.enemy = world;
        }
      }  
      ai_ranged_attack();
      self.button0 = 0;
      
      ai_state_control( self.attack_state );
    }
  }
 self.v_angle = self.angles;
  if( (self.flags & FL_TURRET) ){
    ai_turret_control();
  }
  self.e_legs.angles_y = self.angles_y;
  if( !(self.flags & FL_SKIPTHINK) ){
    self.flags = self.flags - (self.flags & FL_SKIPTHINK);
    self.think = ai_mech_sk_th;
    self.nextthink = time + 0.05;
  }
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={
  
  ai_unit_ini_var();
  data_iniMech( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  if( (self.spawnflags & AI_SPAWNFLAG_RANDDOMSTART) ){ 
    ai_node_pick_rand( self.target );
  }
  trigger_event( self, trigOnSpawn); //event interface
    
  self.th_stand = ai_mech_sk_stand;
  self.th_walk = ai_mech_sk_walk;
  self.th_run = ai_mech_sk_run;
  self.th_run_strafe = ai_mech_sk_run_strafe;
  self.th_run_charge = ai_mech_sk_run_charge;
  self.th_missile = ai_mech_sk_missile;
  self.th_melee = ai_mech_sk_melee;
  self.th_missile_strafe = ai_mech_sk_missile_strafe;
  self.th_hunt = ai_mech_sk_hunt;
  self.th_pain = ai_mech_sk_pain;
  self.th_die = ai_mech_sk_die;
  
  ai_initialize_system( ST_STAND );
  
  droptofloor();
  
  if( (self.flags & FL_TURRET) ){
    util_setOffsetOrigin(self.e_tor_c, self, self.e_tor_c.c_ofs);
  }
  
  ai_walk_setup();
  
  self.think = ai_mech_sk_th;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};