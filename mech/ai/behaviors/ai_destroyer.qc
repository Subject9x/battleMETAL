/*
battleMETAL 
Author: Peter Roohr
Date: 7/12/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank Destroyer
  an on-ground, turret-less vehicle
*/

void() ai_vec_dest_die;
void() ai_vec_dest_die1;
void() ai_vec_dest_die1a;
/*
  TH_DIE Main
*/
void() ai_vec_dest_die={
  local entity w_chain;
  local vector vel;
  local vector v;
  
  ai_sfx_dead();
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  self.attack_state = -1;
  
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.cockpit);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );

  self.think = ai_vec_dest_die1;
  self.ai_action_time = time + 600;
  
  makevectors( self.angles );  
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
   
  vel = self.origin + (v_up * 2);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
  }
  
  self.nextthink = time + 0.1;
};

/*
  Death animation - tank sits as a smoking wreck
*/
void() ai_vec_dest_die1={

  te_smoke_test(self.origin, 2);
  
  self.think = ai_vec_dest_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_vec_dest_die1a;
    self.ai_action_time = time + 0.05;
  }
  self.nextthink = time + 0.1;
};

//stops smoking
void() ai_vec_dest_die1a={
  self.think = ai_vec_dest_die1a;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.nextthink = time + 7200;
    return;
  }
  self.nextthink = time + 0.1;
};

/*
  Macro rebuild
*/
void() ai_spg_stand1;
void() ai_spg_walk1;
void() ai_spg_patrol1;
void() ai_spg_fight_prep;

/*
  rotate in place
*/
void() ai_spg_rotate1;
void() ai_spg_rotate2;
void() ai_spg_rotate3;
void() ai_spg_rotate4;
void() ai_spg_rotate5;
void() ai_spg_rotate6;
void() ai_spg_rotate7;
void() ai_spg_rotate8;

/*
  Turn in place, to ideal_yaw
*/
void() ai_spg_turn1;
void() ai_spg_turn2;
void() ai_spg_turn3;
void() ai_spg_turn4;

/*
  maintain yaw to enemy
  move backwards
*/
void() ai_spg_reverse1;
void() ai_spg_reverse2;
void() ai_spg_reverse3;
void() ai_spg_reverse4;
void() ai_spg_reverse5;
void() ai_spg_reverse6;
void() ai_spg_reverse7;
void() ai_spg_reverse8;
void() ai_spg_reverse9;
void() ai_spg_reverse10;

/*
  turn perpendicular and move for a tad
  
*/
void() ai_spg_strafe1;
void() ai_spg_strafe2;
void() ai_spg_strafe3;
void() ai_spg_strafe4;
void() ai_spg_strafe5;
void() ai_spg_strafe6;
void() ai_spg_strafe7;
void() ai_spg_strafe8;

/*
  turns to face target
  tries to line up shot when accurate
*/
void() ai_spg_snipe1;
void() ai_spg_snipe2;
void() ai_spg_snipe3;
void() ai_spg_snipe4;
void() ai_spg_snipe5;
void() ai_spg_snipe6;
void() ai_spg_snipe7;
void() ai_spg_snipe8;
void() ai_spg_snipe9;
void() ai_spg_snipe10;
void() ai_spg_snipe11;
void() ai_spg_snipe12;
void() ai_spg_snipe13;
void() ai_spg_snipe14;
void() ai_spg_snipe15;
void() ai_spg_snipe16;

/*
  charge forward a little bit
*/
void() ai_spg_charge1;
void() ai_spg_charge2;
void() ai_spg_charge3;
void() ai_spg_charge4;

/*
  Panic
  th_pain
*/
void(entity attacker) ai_spg_panic1;
void() ai_spg_panic2;
void() ai_spg_panic3;
void() ai_spg_panic4;
void() ai_spg_panic5;
void() ai_spg_panic6;
void() ai_spg_panic7;
void() ai_spg_panic8;
void() ai_spg_panic9;
void() ai_spg_panic10;

void() ai_spg_walk1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_spg_walk1)
};


void() ai_spg_stand1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_spg_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_spg_stand1)
};

void() ai_spg_patrol1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){    
    macro_ai_frame(ai_spg_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_spg_patrol1)
};

void() ai_spg_fight_prep={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 100 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            //rotate, go down fighting
            macro_ai_frame(ai_spg_rotate1)
            return;
          }
          //reverse, worse shot overall
          macro_ai_frame(ai_spg_reverse1)
          return;
        }
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            //snipe or strafe
            if( random() < 0.4){
              self.lefty = self.lefty * -1;
              self.ai_dir = 35 + ceil(random() * 60);
              self.ai_dir = self.ai_dir * self.lefty;
              self.ai_dir = anglemod( self.angles_y + self.ai_dir );
              macro_ai_frame(ai_spg_strafe1)
              return;
            }
          }
          macro_ai_frame(ai_spg_snipe1)
          return;
        }
      }
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            self.ai_action_time = ceil(self.ai_action_time * 1.25);
          }
          else{
            //creep forward halfheartedly
            self.ai_action_time = ceil(self.ai_action_time / 1.25);
          }
          macro_ai_frame(ai_spg_charge1)
          return;
        }
      }
    }
    if( enemy_vis == VIS_FRN ){
      self.lefty = self.lefty * -1;
      self.ai_dir = 35 + ceil(random() * 60);
      self.ai_dir = self.ai_dir * self.lefty;
      self.ai_dir = anglemod( self.angles_y + self.ai_dir );
      return;
    }
    //tank destroyers dont hunt
    macro_ai_frame(ai_spg_rotate1)
    return; 
  }

  macro_ai_frame(ai_spg_stand1)
};

/*
  rotate in place,
  SPG's can dial their accuracy in when rotating
*/
void() ai_spg_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate2)
};
void() ai_spg_rotate2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate3)
};
void() ai_spg_rotate3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate4)
};
void() ai_spg_rotate4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  macro_ai_frame(ai_spg_rotate5)
};
void() ai_spg_rotate5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_rotate6)
};
void() ai_spg_rotate6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_rotate7)
};
void() ai_spg_rotate7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_rotate8)
};
void() ai_spg_rotate8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  Turn in place, to ideal_yaw
*/
void() ai_spg_turn1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  macro_ai_frame(ai_spg_turn2)
};
void() ai_spg_turn2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  macro_ai_frame(ai_spg_turn3)
};
void() ai_spg_turn3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_turn4)
};
void() ai_spg_turn4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  ai_attack();
  
  macro_ai_frame_count(ai_spg_turn1)
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  maintain yaw to enemy
  move backwards
*/
void() ai_spg_reverse1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_spg_reverse2)
};
void() ai_spg_reverse2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_reverse3)
};
void() ai_spg_reverse3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_spg_reverse4)
};
void() ai_spg_reverse4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_reverse5)
};
void() ai_spg_reverse5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );

  macro_ai_frame(ai_spg_reverse6)
};
void() ai_spg_reverse6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse7)
};
void() ai_spg_reverse7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse8)
};
void() ai_spg_reverse8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );

  macro_ai_frame(ai_spg_reverse9)
};
void() ai_spg_reverse9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_reverse10)
};
void() ai_spg_reverse10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  turn perpendicular and move for a tad
  
*/
void() ai_spg_strafe1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = self.ai_dir;
  //ok now its getting silly
  self.ai_action_time = ceil(self.ai_action_time * 1.5);
  ai_move_turn();
  ai_attack();
  
  macro_ai_frame(ai_spg_strafe2)
};
void() ai_spg_strafe2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  ai_attack();
  
  macro_ai_frame(ai_spg_strafe3)
};
void() ai_spg_strafe3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_strafe4)
};
void() ai_spg_strafe4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  macro_ai_frame(ai_spg_strafe5)
};
void() ai_spg_strafe5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  macro_ai_frame(ai_spg_strafe6)
};
void() ai_spg_strafe6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  
  macro_ai_frame(ai_spg_strafe7)
};
void() ai_spg_strafe7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  walkmove( self.angles_y, self.data_speed_forward);
  macro_ai_frame_count(ai_spg_strafe7)
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_spg_strafe8)
};
void() ai_spg_strafe8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  turns to face target
  tries to line up shot when accurate
*/
void() ai_spg_snipe1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe2)
};
void() ai_spg_snipe2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe3)
};
void() ai_spg_snipe3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe4)
};
void() ai_spg_snipe4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe5)
};
void() ai_spg_snipe5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe6)
};
void() ai_spg_snipe6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe7)
};
void() ai_spg_snipe7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe8)
};
void() ai_spg_snipe8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
 
  macro_ai_frame(ai_spg_snipe9)
};
void() ai_spg_snipe9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe10)
};
void() ai_spg_snipe10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe11)
};
void() ai_spg_snipe11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe12)
};
void() ai_spg_snipe12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe13)
};
void() ai_spg_snipe13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_spg_snipe14)
};
void() ai_spg_snipe14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe15)
};
void() ai_spg_snipe15={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
 
  macro_ai_frame(ai_spg_snipe16)
};
void() ai_spg_snipe16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  charge forward a little bit
*/
void() ai_spg_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_spg_charge2)
};
void() ai_spg_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_spg_charge3)
};
void() ai_spg_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_spg_charge4)
};
void() ai_spg_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame_count(ai_spg_charge1)
  
  macro_ai_frame(ai_spg_fight_prep)
};

/*
  th_pain == 'panic'
  unit runs to its nearest node or ally
  if either are lacking, it'll just run in a rando direction
*/
void(entity attacker) ai_spg_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend( self.ai_view );
  if( friend ){
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    self.goalentity = world;
    //would we really know the difference?
  }
  
  macro_ai_frame( ai_spg_panic2 )
};
void() ai_spg_panic2={
  local float low, high, tyaw;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  high = anglemod( self.angles_y + 45 );
  low = anglemod( self.angles_y - 45 );
  tyaw = vectoyaw( self.goalentity.origin - self.origin );
  
  if( (tyaw > high) || (tyaw < low) ){
    self.ideal_yaw = tyaw;
    ai_move_turn();
    macro_ai_frame( ai_spg_panic2 )
    return;
  }
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic3 )
};
void() ai_spg_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic4 )
};
void() ai_spg_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic5 )
};
void() ai_spg_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic6 )
};
void()  ai_spg_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame(  ai_spg_panic7 )
};
void() ai_spg_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic8 )
};
void() ai_spg_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic9 )
};
void() ai_spg_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_spg_panic10 )
};
void() ai_spg_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  macro_ai_frame_count( ai_spg_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_spg_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_spg_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_spg_stand1 )
};

/*
  AI SPAWN FUNCTION
*/
void() ai_vec_dest={

  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  trigger_event( self, trigOnSpawn ); //event interface
  
  self.th_stand = ai_spg_stand1;
  self.th_walk = ai_spg_patrol1;
  self.th_missile = ai_spg_fight_prep;
  self.th_pain = ai_spg_panic1;
  self.th_die = ai_vec_dest_die;
  self.touch = ai_touch;

  self.think = ai_setup_patrol;
  self.nextthink = time + random()*1; //spread out thinks
};