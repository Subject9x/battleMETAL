/*
battleMETAL 
Author: Peter Roohr
Date: 9/21/2018
Overview: ai unit
  Tank - Skirmisher
  kinda like a mech skirmisher but slower,
  a default tank
*/

void() ai_tank_sk_die;
void() ai_tank_sk_die1;
void() ai_tank_sk_die2;

void() ai_tank_sk_die={
  local entity w_chain;
  local vector v;
  local vector vel;

  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.1 0.1 0.1';
  self.attack_state = -1;
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  ai_sfx_dead();

  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  mech_player_compdie(self.e_tor_l);
  mech_player_compdie(self.e_tor_r);
  mech_player_compdie(self.e_tor_c);
  
  self.think = ai_tank_sk_die1;
  self.ai_action_time = time + 120;
  
  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
    
  //basically overkill damage will just remove the tank (nice and clean)
  if( self.health <= (self.max_health / 1.15) * -1 ){
    self.think = ai_tank_sk_die2;
  }
  
  vel = self.origin + (v_up * 2);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y /2)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
  }
  
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={
  local vector sm;
  
  self.deadflag = DEAD_DEAD;
  makevectors( world.v_angle );
  sm = world.v_angle + (v_forward * world.m_fspeed) + (v_right * world.m_fspeed) + (v_up * world.m_fspeed);
  te_smoke_test(self.origin, sm + '0 0 10', 2);
  
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = ai_tank_sk_die1;
    self.ai_action_time = time + 120;
  }
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die2={
  local vector v;
  
  self.deadflag = DEAD_DEAD;
  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 8, self.vec_size + 1);
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  Tank Macro Rebuild
*/
void() ai_tank_sk_stand1;
void() ai_tank_sk_patrol1;
void() ai_tank_sk_patrol_stand1;
void() ai_tank_sk_fight_prep;

/*
  rotate in place to self.ideal_yaw
*/
void() ai_tank_sk_rotate1;
void() ai_tank_sk_rotate2;
void() ai_tank_sk_rotate3;
void() ai_tank_sk_rotate4;
void() ai_tank_sk_rotate5;
void() ai_tank_sk_rotate6;
void() ai_tank_sk_rotate7;
void() ai_tank_sk_rotate8;
void() ai_tank_sk_rotate9;
void() ai_tank_sk_rotate10;

/*
  CHARGE
  self.ideal_yaw = enemy_yaw
  self.ai_dir = charge yaw
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_tank_sk_charge1;
void() ai_tank_sk_charge2;
void() ai_tank_sk_charge3;
void() ai_tank_sk_charge4;
void() ai_tank_sk_charge5;
void() ai_tank_sk_charge6;
void() ai_tank_sk_charge7;
void() ai_tank_sk_charge8;
void() ai_tank_sk_charge9;
void() ai_tank_sk_charge10;

/*
  tank attempts to move around the target
  can rotate in motion
  self.ai_dir setup before running this with the offset
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_tank_sk_flank1;
void() ai_tank_sk_flank2;
void() ai_tank_sk_flank3;
void() ai_tank_sk_flank4;
void() ai_tank_sk_flank5;
void() ai_tank_sk_flank6;
void() ai_tank_sk_flank7;
void() ai_tank_sk_flank8;

/*
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw
  self.ai_dir = self.ideal_yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_tank_sk_strafe1;  //rotate to ideal_yaw, is loopable
void() ai_tank_sk_strafe2;  //move in direction of ideal_yaw
void() ai_tank_sk_strafe3;
void() ai_tank_sk_strafe4;
void() ai_tank_sk_strafe5;
void() ai_tank_sk_strafe6;
void() ai_tank_sk_strafe7;
void() ai_tank_sk_strafe8;

/*
  tank attempts to quickly turn around if enemy is behind it
*/
void() ai_tank_sk_juke1;
void() ai_tank_sk_juke2;
void() ai_tank_sk_juke3;
void() ai_tank_sk_juke4;
void() ai_tank_sk_juke5;
void() ai_tank_sk_juke6;
void() ai_tank_sk_juke7;
void() ai_tank_sk_juke8;
void() ai_tank_sk_juke9;
void() ai_tank_sk_juke10;

/*
  Less advanced tanks will attempt to reverse turn 
  to face a foe behind them
*/
void() ai_tank_sk_reverse1;
void() ai_tank_sk_reverse2;
void() ai_tank_sk_reverse3;
void() ai_tank_sk_reverse4;
void() ai_tank_sk_reverse5;
void() ai_tank_sk_reverse6;
void() ai_tank_sk_reverse7;
void() ai_tank_sk_reverse8;
void() ai_tank_sk_reverse9;
void() ai_tank_sk_reverse10;
void() ai_tank_sk_reverse11;
void() ai_tank_sk_reverse12;

/*
  hunting behavior
*/
void() ai_tank_sk_hunt1;
void() ai_tank_sk_hunt2;
void() ai_tank_sk_hunt3;
void() ai_tank_sk_hunt4;
void() ai_tank_sk_hunt5;
void() ai_tank_sk_hunt6;
void() ai_tank_sk_hunt7;
void() ai_tank_sk_hunt8;
void() ai_tank_sk_hunt9;
void() ai_tank_sk_hunt10;

void() ai_tank_sk_fight_prep={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, FALSE);
    
    if( enemy_vis == VIS_FRAC){
      if( enemy_range <= 200 ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_tank_sk_flank1)
            return;
          }
          self.lefty = self.lefty *-1;
          self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
          self.ideal_yaw = anglemod( self.ideal_yaw + ( self.lefty * ( 30 + (random() * 30) + (random() * 30))));
          macro_ai_frame(ai_tank_sk_strafe1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_tank_sk_juke1)
          return;
        }
        self.lefty = self.lefty * -1;
        ai_face_targ();
        self.ai_dir = anglemod( self.ideal_yaw + (45 * self.lefty));
        macro_ai_frame(ai_tank_sk_reverse1)
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            if( random() < 0.5 ){
              self.lefty = self.lefty * -1;
              macro_ai_frame(ai_tank_sk_charge1)
              return;
            }
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_tank_sk_flank1)
            return;
          }
          if( random() < 0.25 ){
            self.lefty = self.lefty *-1;
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ideal_yaw = anglemod( self.ideal_yaw + ( self.lefty * ( 30 + (random() * 30) + (random() * 30))));
            macro_ai_frame(ai_tank_sk_strafe1)
            return;
          }
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_tank_sk_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( random() < 0.25 ){        
            self.lefty = self.lefty * -1;
            ai_face_targ();
            self.ai_dir = anglemod( self.ideal_yaw + (45 * self.lefty));
            macro_ai_frame(ai_tank_sk_reverse1)
            return;
          }
          macro_ai_frame(ai_tank_sk_juke1)
          return;
        }
        ai_face_targ();
        macro_ai_frame(ai_tank_sk_rotate1)
        return;
      }
      
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_tank_sk_flank1)
            return;
          }
          self.lefty = self.lefty * -1;
          macro_ai_frame(ai_tank_sk_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_tank_sk_juke1)
          return;
        }
        ai_face_targ();
        macro_ai_frame(ai_tank_sk_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      self.lefty = self.lefty *-1;
      self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
      self.ideal_yaw = anglemod( self.ideal_yaw + ( self.lefty * ( 30 + (random() * 30) + (random() * 30))));
      macro_ai_frame(ai_tank_sk_strafe1)
      return;
    }
    if( !self.ai_node_recall ){
      ai_sfx_huntStart();
      node_recall_setup();
      self.goalentity = self.enemy;
      macro_ai_frame(ai_tank_sk_hunt1)
      return;
    }
    self.goalentity = self.ai_node_recall;
    macro_ai_frame(ai_tank_sk_hunt1)
    return;
  }
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_tank_sk_patrol1)
    return;
  }
  macro_ai_frame(ai_tank_sk_stand1)
};

void() ai_tank_sk_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_tank_sk_stand1)
};

/*
  CHARGE
  self.ideal_yaw = enemy_yaw
  self.ai_dir = charge yaw
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_tank_sk_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_charge2)
};
void() ai_tank_sk_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_tank_sk_charge3)
};
void() ai_tank_sk_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_tank_sk_charge4)
};
void() ai_tank_sk_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge5)
};
void() ai_tank_sk_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }

  macro_ai_frame(ai_tank_sk_charge6)
};
void() ai_tank_sk_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }

  macro_ai_frame(ai_tank_sk_charge7)
};
void() ai_tank_sk_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge8)
};
void() ai_tank_sk_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_tank_sk_charge9)
};
void() ai_tank_sk_charge9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }

  macro_ai_frame(ai_tank_sk_charge10)
};
void() ai_tank_sk_charge10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed ) ;
  }
  
  macro_ai_frame_count(ai_tank_sk_charge1)
  
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  tank attempts to move around the target
  can rotate in motion
  self.ai_dir setup before running this with the offset
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_tank_sk_flank1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank2)
};
void() ai_tank_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank3)
};
void() ai_tank_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank4)
};
void() ai_tank_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank5)
};
void() ai_tank_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank6)
};
void() ai_tank_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank7)
};
void() ai_tank_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank8)
};
void() ai_tank_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  ai_yaw_move( self.ai_dir, self.m_fspeed * AI_RUN_FACTOR);
  ai_attack();
  
  macro_ai_frame_count(ai_tank_sk_flank1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw - set before move
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
//rotate to ideal_yaw, is loopable
void() ai_tank_sk_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  ai_move_turn();
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame(ai_tank_sk_strafe2)
    return;
  }
  macro_ai_frame(ai_tank_sk_strafe1)
};
//move in direction of ideal_yaw
void() ai_tank_sk_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
 
  ai_attack();
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe3)
};  
void() ai_tank_sk_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe4)
};
void() ai_tank_sk_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe5)
};
void() ai_tank_sk_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe6)
};
void() ai_tank_sk_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe7)
};
void() ai_tank_sk_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame(ai_tank_sk_strafe8)
};
void() ai_tank_sk_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  ai_attack();
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.m_fspeed );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.m_bspeed );
  }
  
  macro_ai_frame_count(ai_tank_sk_strafe1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  tank attempts to quickly turn around if enemy is behind it
*/
void() ai_tank_sk_juke1={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke2)
};
void() ai_tank_sk_juke2={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke3)
};
void() ai_tank_sk_juke3={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke4)
};
void() ai_tank_sk_juke4={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke5)
};
void() ai_tank_sk_juke5={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke6)
};
void() ai_tank_sk_juke6={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke7)
};
void() ai_tank_sk_juke7={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke8)
};
void() ai_tank_sk_juke8={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke9)
};
void() ai_tank_sk_juke9={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke10)
};
void() ai_tank_sk_juke10={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.m_fspeed * AI_RUN_FACTOR );
  
  if( ai_check_targ_infront(self.enemy, self.ai_fov, FALSE) ){
    macro_ai_frame(ai_tank_sk_fight_prep)
  }
  
  macro_ai_frame_count(ai_tank_sk_juke1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  Less advanced tanks will attempt to reverse turn 
  to face a foe behind them
*/
void() ai_tank_sk_reverse1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  self.ideal_yaw = anglemod( self.ai_dir + 180);
  ai_move_turn();
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame(ai_tank_sk_reverse2)
    return;
  }
  macro_ai_frame(ai_tank_sk_reverse1)
};
void() ai_tank_sk_reverse2={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse3)
};
void() ai_tank_sk_reverse3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse4)
};
void() ai_tank_sk_reverse4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse5)
};
void() ai_tank_sk_reverse5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse6)
};
void() ai_tank_sk_reverse6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse7)
};
void() ai_tank_sk_reverse7={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse8)
};
void() ai_tank_sk_reverse8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse9)
};
void() ai_tank_sk_reverse9={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse10)
};
void() ai_tank_sk_reverse10={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse11)
};
void() ai_tank_sk_reverse11={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)

  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame(ai_tank_sk_reverse12)
};
void() ai_tank_sk_reverse12={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ai_move_turn();
  walkmove( self.ai_dir, self.m_bspeed  );
  
  macro_ai_frame_count(ai_tank_sk_reverse1)
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  rotate in place to self.ideal_yaw
*/
void() ai_tank_sk_rotate1={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate2)
};
void() ai_tank_sk_rotate2={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate3)
};
void() ai_tank_sk_rotate3={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate4)
};
void() ai_tank_sk_rotate4={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate5)
};
void() ai_tank_sk_rotate5={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  macro_ai_frame(ai_tank_sk_rotate6)
};
void() ai_tank_sk_rotate6={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_rotate7)
};
void() ai_tank_sk_rotate7={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_rotate8)
};
void() ai_tank_sk_rotate8={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
 
  macro_ai_frame(ai_tank_sk_rotate9)
};
void() ai_tank_sk_rotate9={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_rotate10)
};
void() ai_tank_sk_rotate10={
  local float tempYaw;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  tempYaw = self.yaw_speed;  //tanks be slow on stationary turning;
  self.yaw_speed = self.yaw_speed * 0.67;
  ai_face_targ();
  self.yaw_speed = tempYaw;
  
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  hunting behavior
*/
void() ai_tank_sk_hunt1={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt2)
};
void() ai_tank_sk_hunt2={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt3)
};
void() ai_tank_sk_hunt3={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt4)
};
void() ai_tank_sk_hunt4={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt5)
};
void() ai_tank_sk_hunt5={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt6)
};
void() ai_tank_sk_hunt6={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt7)
};
void() ai_tank_sk_hunt7={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt8)
};
void() ai_tank_sk_hunt8={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt9)
};
void() ai_tank_sk_hunt9={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt10)
};
void() ai_tank_sk_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  if( !ai_check_vis( self.enemy ) ){
    if( self.stat_rdr_mode ){
      macro_ai_frame_count(ai_tank_sk_hunt5)
    }
  }
  
  ai_sfx_huntEnd();
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_tank_sk_patrol1)
    remove(self.ai_node_recall);
    return;
  }
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  macro_ai_frame(ai_tank_sk_fight_prep)
};

/*
  AI SPAWN FUNCTION
*/
void() ai_tank_skirmish={

  //DEBUG
  self.ai_voice_dead = "sound/voice/bot/bot_dying.ogg";
  self.ai_voice_warn=" sound/voice/bot/bot_warn.ogg";
  self.ai_voice_spot="sound/voice/bot/bot_spotted.ogg";
  self.ai_voice_huntStart="sound/voice/bot/bot_huntStart.ogg";
  self.ai_voice_huntEnd="sound/voice/bot/bot_huntEnd.ogg";
  self.ai_voice_dying="sound/voice/bot/bot_dying.ogg";
  self.ai_voice_dead="sound/voice/bot/bot_dead.ogg";
  self.ai_voice_kill="sound/voice/bot/bot_kill.ogg";
  self.ai_voice_roger="sound/voice/bot/bot_roger.ogg";
  self.ai_voice_help="sound/voice/bot/bot_help.ogg";
  // /DEBUG

  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_tank_sk_stand1;
  self.th_walk = ai_tank_sk_patrol1;
  self.th_missile = ai_tank_sk_fight_prep;
  self.th_die = ai_tank_sk_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};