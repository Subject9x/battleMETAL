/*
battleMETAL 
Author: Peter Roohr
Date: 9/21/2018
rebuild: 2/16/2019
Overview: ai unit
  Tank - Skirmisher
  kinda like a mech skirmisher but slower,
  a default tank
*/

void() ai_tank_sk_die;
void() ai_tank_sk_die1;

void() ai_tank_sk_die={
  local entity w_chain;
  local vector v;
  local vector vel;

  ai_sfx_dead();
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.33 0.33 0.33';
  self.attack_state = -1;
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  ai_sfx_dead();

  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.cockpit);
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.torsoCenter);
  
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  
  self.think = ai_tank_sk_die1;
  self.ai_action_time = time + 600;
  
  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
  
  vel = self.origin + (v_up * self.vec_size);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles,  self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y /2)), self.angles,  self.vec_size, self.vec_size * 1000, self.vec_size / 20); 
      break;
  }
  
  self.nextthink = time + 0.1;
};

void() ai_tank_sk_die1={

  self.deadflag = DEAD_DEAD;

  te_smoke_test(self.origin, 2);
  
  self.think = ai_tank_sk_die1;
  if ( time > self.ai_action_time ){
    self.think = SUB_Remove;
    self.ai_action_time = time + 7200;
  }
  self.nextthink = time + 0.1;
};

/*
  Tank Macro Rebuild
*/
void() ai_tank_sk_stand1;
void() ai_tank_sk_patrol1;
void() ai_tank_sk_fight_prep;
void( entity attacker ) ai_tank_sk_react1;
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

/*
  th_pain == 'panic'
*/
void(entity attacker) ai_tank_sk_panic1;
void() ai_tank_sk_panic2;
void() ai_tank_sk_panic3;
void() ai_tank_sk_panic4;
void() ai_tank_sk_panic5;
void() ai_tank_sk_panic6;
void() ai_tank_sk_panic7;
void() ai_tank_sk_panic8;
void() ai_tank_sk_panic9;
void() ai_tank_sk_panic10;

void() ai_tank_sk_fight_prep={
  local entity nodeRecall;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, FALSE);
    enemy_hunt = FALSE;
    
    if( enemy_vis == VIS_FRAC){
      if( enemy_range <= 200 ){
        if( enemy_infront){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * ( 25 + (random() * 30));
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
            self.ai_dir = self.lefty * ( 25 + (random() * 30));
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
            self.ai_dir = self.lefty * ( 25 + (random() * 30));
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
    if( enemy_vis == VIS_FAIL ){
      if( self.ai_rank > AI_RANK_REG ){
        if( util_getMechHpAverage(self) > 0.45){
          enemy_hunt = TRUE;
        }
        if( util_getMechHpAverage(self.enemy) <= 0.25 ){
          enemy_hunt = TRUE;
        }
      }
      if( util_getMechHpAverage(self) > 0.75 ){
        if( self.enemy.vec_size < self.vec_size ){
          enemy_hunt = TRUE;
        }
      }
      if( util_getMechHpAverage(self.enemy) <= 0.25 ){
        if( self.enemy.vec_size < self.vec_size ){
          enemy_hunt = TRUE;
        }
      }
    }
  }
  if( enemy_hunt ){
    if( !(self.ai_node_recall.flags & FL_NODE) ){
      ai_sfx_huntStart();
      nodeRecall = node_recall_setup();
      self.ai_node_recall = nodeRecall;
      self.goalentity = self.enemy;
        self.ai_action_time = (0 - self.ai_action_mod) * -1;
      if( self.stat_rdr_mode ){
        self.ai_action_time = ceil(self.ai_action_time * 8);
      }
      else{
        self.ai_action_time = ceil(self.ai_action_time * 4);
      }
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

/*
  TH_WALK - Patrol
*/
void() ai_tank_sk_patrol1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){    
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_tank_sk_patrol1)
};

/*
  TH_STAND - Stand1
*/
void() ai_tank_sk_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_tank_sk_fight_prep)
    return;
  }
  
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_tank_sk_patrol1)
      return;
    }
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
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
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
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge3)
};
void() ai_tank_sk_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge4)
};
void() ai_tank_sk_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge5)
};
void() ai_tank_sk_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge6)
};
void() ai_tank_sk_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge7)
};
void() ai_tank_sk_charge7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }
  ai_attack();

  macro_ai_frame(ai_tank_sk_charge8)
};
void() ai_tank_sk_charge8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
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
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
  }

  macro_ai_frame(ai_tank_sk_charge10)
};
void() ai_tank_sk_charge10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.data_speed_forward ) ;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.data_speed_backward ) ;
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
  
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank2)
};
void() ai_tank_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_flank3)
};
void() ai_tank_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_tank_sk_flank4)
};
void() ai_tank_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_tank_sk_flank5)
};
void() ai_tank_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_flank6)
};
void() ai_tank_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_flank7)
};
void() ai_tank_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_tank_sk_flank8)
};
void() ai_tank_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
    
  self.ideal_yaw = vectoyaw( self.enemy.origin - self.origin );
  self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir );
  ai_move_turn();
  walkmove( self.angles_y, self.data_speed_forward );
  
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
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe3)
};  
void() ai_tank_sk_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe4)
};
void() ai_tank_sk_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
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
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe6)
};
void() ai_tank_sk_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe7)
};
void() ai_tank_sk_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
  }
  
  macro_ai_frame(ai_tank_sk_strafe8)
};
void() ai_tank_sk_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)

  if( self.lefty > 0 ){
    ai_move( self.angles_y, self.data_speed_forward );
  }
  else{
    ai_move( anglemod(self.angles_y + 180), self.data_speed_backward );
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
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke2)
};
void() ai_tank_sk_juke2={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke3)
};
void() ai_tank_sk_juke3={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke4)
};
void() ai_tank_sk_juke4={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke5)
};
void() ai_tank_sk_juke5={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke6)
};
void() ai_tank_sk_juke6={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke7)
};
void() ai_tank_sk_juke7={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame(ai_tank_sk_juke8)
};
void() ai_tank_sk_juke8={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_juke9)
};
void() ai_tank_sk_juke9={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_juke10)
};
void() ai_tank_sk_juke10={
  ai_update_accuracy(TRUE);
  macro_ai_update(ctrl_updateTank)
  
  ai_face_targ();
  walkmove( self.angles_y, self.data_speed_forward * AI_RUN_FACTOR );
  
  ai_attack();
  
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
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse3)
};
void() ai_tank_sk_reverse3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse4)
};
void() ai_tank_sk_reverse4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse5)
};
void() ai_tank_sk_reverse5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse6)
};
void() ai_tank_sk_reverse6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse7)
};
void() ai_tank_sk_reverse7={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_reverse8)
};
void() ai_tank_sk_reverse8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_tank_sk_reverse9)
};
void() ai_tank_sk_reverse9={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse10)
};
void() ai_tank_sk_reverse10={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  macro_ai_frame(ai_tank_sk_reverse11)
};
void() ai_tank_sk_reverse11={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)

  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
  
  ai_attack();
  
  macro_ai_frame(ai_tank_sk_reverse12)
};
void() ai_tank_sk_reverse12={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  
  ai_attack();
  ai_move_turn();
  walkmove( self.ai_dir, self.data_speed_backward  );
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
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
   
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
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
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt2)
};
void() ai_tank_sk_hunt2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt3)
};
void() ai_tank_sk_hunt3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt4)
};
void() ai_tank_sk_hunt4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt5)
};
void() ai_tank_sk_hunt5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt6)
};
void() ai_tank_sk_hunt6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt7)
};
void() ai_tank_sk_hunt7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt8)
};
void() ai_tank_sk_hunt8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt9)
};
void() ai_tank_sk_hunt9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_tank_sk_hunt10)
};
void() ai_tank_sk_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame_count(ai_tank_sk_hunt1)

  ai_sfx_huntEnd();
  
  if( self.movetarget ){
    ai_turret_set_state( TR_NORM );
    local float dist1, dist2;
    dist1 = vlen( self.movetarget.origin - self.origin );
    dist2 = vlen( self.ai_node_recall.origin - self.origin );
    if( dist1 < dist2 ){
      self.goalentity = self.movetarget;
      macro_ai_frame(ai_tank_sk_patrol1)
      remove(self.ai_node_recall);
      return;
    }
  }
  //the recall portion of hunting
  if( self.ai_node_recall && (self.goalentity != self.ai_node_recall) ){
    ai_turret_set_state( TR_NORM );
    self.goalentity = self.ai_node_recall;
    self.ai_action_time = (0 - self.ai_action_mod) * -1;
    self.ai_action_time = ceil(self.ai_action_time * 4);
    macro_ai_frame(ai_tank_sk_hunt1)
    return;
  }
  remove(self.ai_node_recall);
  self.ai_node_recall = world;
  self.enemy = world;
  macro_ai_frame(ai_tank_sk_stand1)
};

/*
  th_pain == 'panic'
  unit runs to its nearest node or ally
  if either are lacking, it'll just run in a rando direction
*/
void(entity attacker) ai_tank_sk_panic1={
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
  
  macro_ai_frame( ai_tank_sk_panic2 )
};
void() ai_tank_sk_panic2={
  local float low, high, tyaw;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  high = anglemod( self.angles_y + 45 );
  low = anglemod( self.angles_y - 45 );
  tyaw = vectoyaw( self.goalentity.origin - self.origin );
  
  if( (tyaw > high) || (tyaw < low) ){
    self.ideal_yaw = tyaw;
    ai_move_turn();
    macro_ai_frame( ai_tank_sk_panic2 )
    return;
  }
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic3 )
};
void() ai_tank_sk_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
    movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  macro_ai_frame( ai_tank_sk_panic4 )
};
void() ai_tank_sk_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic5 )
};
void() ai_tank_sk_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic6 )
};
void() ai_tank_sk_panic6={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame( ai_tank_sk_panic7 )
};
void() ai_tank_sk_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic8 )
};
void() ai_tank_sk_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic9 )
};
void() ai_tank_sk_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_tank_sk_panic10 )
};
void() ai_tank_sk_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_updateTank )
  
  macro_ai_frame_count( ai_tank_sk_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_tank_sk_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_tank_sk_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_tank_sk_stand1 )
};

/*
  TH_REACT - react to damage
*/
void( entity attacker ) ai_tank_sk_react1={
  local float my_hp;
  local float enemy_hp, enemy_size;
  local float atk_hp, atk_size;
  local float react_vis;
  local float react_face;

  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
    
  if( (self.flags & FL_DISARMED) ){
    self.ai_react_buffer = time + self.ai_react_time * 2;
    self.th_pain( attacker );
    return;
  }
  
  //AI currently has no target
  if( !self.enemy ){
    self.ai_react_buffer = time + self.ai_react_time * 3;
    self.enemy = attacker;
    self.th_missile();
    return;
  }
  
  my_hp = util_getMechHpAverage(self);
  atk_hp = util_getMechHpAverage(attacker);
  atk_size = attacker.vec_size;
  react_vis = ai_check_vis(attacker);
  react_face = ai_check_face(attacker, self.ai_fov);
  
  if( self.enemy ){  
    if( react_vis == VIS_FAIL ){
      self.ai_react_buffer = time + self.ai_react_time;
      return;
    }
    if( (attacker.flags & FL_CLIENT) ){
      //prioritize players
      if( self.ai_rank > AI_RANK_REG ){
        self.oldenemy = self.enemy;
        self.enemy = attacker;
        self.ai_react_buffer = time + self.ai_react_time * 2;
        self.th_missile();
        return;
      }
      if( react_face ){
        self.oldenemy = self.enemy;
        self.enemy = attacker;
        self.ai_react_buffer = time + self.ai_react_time * 2;
        self.th_missile();
        return;
      }
      return;
    }
    enemy_hp = util_getMechHpAverage(self.enemy);
    enemy_size = self.enemy.vec_size;
    if( self.ai_rank > AI_RANK_REG ){
      if( atk_hp < enemy_hp ){
        if( ai_check_range(attacker) < ai_check_range(self.enemy) ){
          self.oldenemy = self.enemy;
          self.enemy = attacker;
          self.ai_react_buffer = time + self.ai_react_time * 3;
          self.th_missile();
          return;
        }
        return;
      }
      if( atk_size > enemy_size ){
        if( atk_hp < enemy_hp ){
          self.oldenemy = self.enemy;
          self.enemy = attacker;
          self.ai_react_buffer = time + self.ai_react_time * 3;
          self.th_missile();
          return;
        }
        return;
      }
    }
    else{
      if( atk_size < enemy_size ){
        if( react_face ){
          //lesser bots usually panic
          self.oldenemy = self.enemy;
          self.enemy = attacker;
          self.ai_react_buffer = time + self.ai_react_time * 3;
          self.th_missile();
          return;
        }
        return;
      }
    }
  }
  //do nothing;
  return;
};

/*
  AI SPAWN FUNCTION
*/
void() ai_tank_skirmish={

  ai_unit_ini_var();
  initialize_data_vehicle_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_tank_sk_stand1;
  self.th_walk = ai_tank_sk_patrol1;
  self.th_missile = ai_tank_sk_fight_prep;
  self.th_pain = ai_tank_sk_panic1;
  self.th_react = ai_tank_sk_react1;
  self.th_die = ai_tank_sk_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};