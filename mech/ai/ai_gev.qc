/*
battleMETAL 
Author: Peter Roohr
Date: 9/25/2018
Rebuild - 02/16/2019
Overview: ai unit
  VTOL Unit
    flies around
    can actually hunt its target
*/
void() ai_gev_pain={
  //TODO - finish
  ai_update_accuracy( TRUE );
  if( ai_valid_target( self.goalentity ) ){
    self.ideal_yaw = vectoyaw( self.goalentity.origin - self.origin );
    ai_move_turn();
    ai_move( self.ideal_yaw, self.m_fspeed * AI_RUN_SPD);
  }
  
  if( time > self.ai_action_time ){
    //ai_next_state( ST_RUN );
    return;
  }
  
};

void() ai_gev_die2={
  self.think = ai_gev_die2;
  if( time > self.ai_action_time ){
    self.think = SUB_Remove;
  }
  self.nextthink = time + 1;
};

void() ai_gev_die1={
  self.deadflag = DEAD_DEAD;
  te_smoke_test(self.origin, '1 1 10', 4) ;
  
  self.think = ai_gev_die1;
  if( time > self.ai_action_time ){
    self.ai_action_time = time + (random() * 2000);
    self.think = ai_gev_die2;
  }
  self.nextthink = time + 0.5;
};

void() ai_gev_touch_death={
  local vector vel;
  if( other == world ){
    self.movetype = MOVETYPE_NONE;
    makevectors( self.angles );
    vel = self.origin + (v_up * 2);
    switch( self.vec_size ){
      case 2:
        te_med_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
      case 3:
        te_big_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
      default:
        te_small_flame_start( self.origin + (v_up * (self.maxs_y / 1.5)), self.angles, normalize( vel - self.origin ) * 8, self.vec_size, self.vec_size * 1000, self.vec_size / 50); 
        break;
    }
    self.touch = SUB_Null;
  }
  self.think = ai_gev_die2;
  self.nextthink = time + 0.05;
};

void() ai_gev_die={
  local entity w_chain;
  local vector v;
  local vector t;
  
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_BBOX;
  self.colormod = '0.1 0.1 0.1'; 
  setsize(self, self.mins * 0.35, self.maxs * 0.35);
  setorigin(self, self.origin);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  ai_sfx_dead();
 
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.e_cam);
  if( (self.flags & FL_TURRET) ){
    mech_player_compdie(self.e_tor_c);
  }
  
  t_y = self.ideal_yaw;
  
  makevectors( self.angles );

  v = self.origin + (v_forward * 2) + (v_right * (crandom() * 3)) + (v_up * 3);
  te_debris( self.origin, self.angles, normalize(v - self.origin) * 100, self.vec_size + (random() * 5), self.vec_size);
  
  if( self.attack_state != ST_STAND ){
    self.velocity = normalize( v - self.origin);
    self.velocity = self.velocity * 200;
    self.gravity = 0.25;
    self.avelocity_x = crandom() * 150;
    self.avelocity_y = crandom() * 300; 
    self.avelocity_z = crandom() * 400;
  }
  else{
    self.velocity = normalize( (self.origin + (v_up * -2)) - self.origin);
    self.velocity_z = self.velocity_z - 10;
    self.gravity = 0.25;
  }
  self.attack_state = -1;
  self.think = ai_gev_die1;
  self.nextthink = time + 0.01;
  self.ai_action_time = time + (random() * 500);
  self.attack_state = -1;
  self.touch = ai_gev_touch_death;
};

/*
  GEV Macro Rebuild
*/
void() ai_gev_stand1;
void() ai_gev_walk1;

void() ai_gev_patrol1;

void() ai_gev_fight_prep;

/*
  FLANK
  self.ideal_yaw = rand45 to  enemy yaw
  self.ai_dir = enemy yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_flank1;
void() ai_gev_flank2;
void() ai_gev_flank3;
void() ai_gev_flank4;
void() ai_gev_flank5;
void() ai_gev_flank6;

/*
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw
  self.ai_dir = self.ideal_yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_strafe1;
void() ai_gev_strafe2;
void() ai_gev_strafe3;
void() ai_gev_strafe4;
void() ai_gev_strafe5;
void() ai_gev_strafe6;
void() ai_gev_strafe7;
void() ai_gev_strafe8;
void() ai_gev_strafe9;
void() ai_gev_strafe10;
void() ai_gev_strafe11;
void() ai_gev_strafe12;

/*
  CHARGE
  self.ideal_yaw = enemy_yaw
  self.ai_dir = charge yaw
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_gev_charge1;
void() ai_gev_charge2;
void() ai_gev_charge3;
void() ai_gev_charge4;
void() ai_gev_charge5;
void() ai_gev_charge6;

//rotates towards self.enemy for t=6x0.05 
void() ai_gev_rotate1;
void() ai_gev_rotate2;
void() ai_gev_rotate3;
void() ai_gev_rotate4;
void() ai_gev_rotate5;
void() ai_gev_rotate6;

/*
  HUNT
  attempt to walkmove to target for a little bit
*/
void() ai_gev_hunt1;
void() ai_gev_hunt2;
void() ai_gev_hunt3;
void() ai_gev_hunt4;
void() ai_gev_hunt5;
void() ai_gev_hunt6;
void() ai_gev_hunt7;
void() ai_gev_hunt8;
void() ai_gev_hunt9;
void() ai_gev_hunt10;
void() ai_gev_hunt11;
void() ai_gev_hunt12;

void() ai_gev_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1 );
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  macro_ai_frame(ai_gev_stand1)
};

void() ai_gev_walk1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1 );
  
  macro_ai_frame(ai_gev_walk1)
};

void() ai_gev_patrol1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_gev_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_gev_patrol1)
};

void() ai_gev_fight_prep={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  if( ai_valid_target(self.enemy)){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range <= 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_gev_flank1)
            return;
          }
          self.lefty = -1;
          macro_ai_frame(ai_gev_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = -1;
          macro_ai_frame(ai_gev_charge1)
          return;
        }
        macro_ai_frame(ai_gev_rotate1)
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( random() < 0.4 ){
            self.lefty = self.lefty * -1;
          }
          if( self.ai_rank > AI_RANK_REG ){
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_gev_flank1)
            return;
          }
          if( random() < 0.25 ){
            self.ai_dir = self.lefty * ( 35 + (random() * 45));
            macro_ai_frame(ai_gev_flank1)
            return;
          }
          self.ai_dir = anglemod( self.ideal_yaw + (90 * self.lefty));
          macro_ai_frame(ai_gev_strafe1)
          return;
        }
        macro_ai_frame(ai_gev_rotate1)
        return;
      }
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          macro_ai_frame(ai_gev_charge1)
          return;
        }
        macro_ai_frame(ai_gev_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      self.lefty = self.lefty * -1;
      self.ai_dir = anglemod( self.ideal_yaw + (90 * self.lefty));
      macro_ai_frame(ai_gev_strafe1)
      return;
    }
    //goto hunting
    macro_ai_frame_hunt(ai_gev_hunt1)
  }
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_gev_patrol1)
    return;
  }
  macro_ai_frame(ai_gev_stand1)
};

void() ai_gev_rotate1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_rotate2)
};
void() ai_gev_rotate2={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_gev_rotate3)
};
void() ai_gev_rotate3={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_rotate4)
};
void() ai_gev_rotate4={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_gev_rotate5)
};
void() ai_gev_rotate5={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_rotate6)
};
void() ai_gev_rotate6={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_gev_fight_prep)
};

/*
  STRAFE
  self.ideal_yaw = 90deg to enemy_yaw -> locked on pre-state
  self.ai_dir = self.ideal_yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_strafe1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();
    
  macro_ai_frame(ai_gev_strafe2)
};
void() ai_gev_strafe2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe3)
};
void() ai_gev_strafe3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe4)
};
void() ai_gev_strafe4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe5)
};
void() ai_gev_strafe5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe6)
};
void() ai_gev_strafe6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe7)
};
void() ai_gev_strafe7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe8)
};
void() ai_gev_strafe8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_gev_strafe9)
};
void() ai_gev_strafe9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_strafe10)
};
void() ai_gev_strafe10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();
  
  macro_ai_frame(ai_gev_strafe11)
};
void() ai_gev_strafe11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  ai_attack();

  macro_ai_frame(ai_gev_strafe12)
};
void() ai_gev_strafe12={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_move_turn();
  ai_move( self.ai_dir, self.m_sspeed );
  
  macro_ai_frame_count(ai_gev_strafe1)
  macro_ai_frame(ai_gev_fight_prep)
};

/*
  CHARGE
  self.ideal_yaw = enemy_yaw
  self.ai_dir = charge yaw
  self.lefty = 1 FORWARD || -1 BACKWARD
*/
void() ai_gev_charge1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
  ai_attack();

  macro_ai_frame(ai_gev_charge2)
};
void() ai_gev_charge2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  macro_ai_frame(ai_gev_charge3)
};
void() ai_gev_charge3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
  
  ai_attack();
  
  macro_ai_frame(ai_gev_charge4)
};
void() ai_gev_charge4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  macro_ai_frame(ai_gev_charge5)
};
void() ai_gev_charge5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
    
  ai_attack();

  macro_ai_frame(ai_gev_charge6)
};
void() ai_gev_charge6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  if( self.lefty > 0 ){
    ai_yaw_move( 0, self.m_fspeed ) ;
  }
  else{
    ai_yaw_move( 180, self.m_bspeed ) ;
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  macro_ai_frame_count(ai_gev_strafe1)
  
  if( ai_check_face( self.enemy, self.ai_fov )){
    if( (self.lefty > 0) && (self.ai_rank > AI_RANK_REG )){
      if( random() < 0.45){
        macro_ai_frame(ai_gev_charge1)
        return;
      }
    }
  }
  
  macro_ai_frame(ai_gev_fight_prep)
};

/*
  FLANK
  self.ideal_yaw = rand45 to  enemy yaw
  self.ai_dir = enemy yaw
  self.lefty = 1 LEFT || -1 RIGHT
*/
void() ai_gev_flank1={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  ai_attack();
  
  macro_ai_frame(ai_gev_flank2)
};
void() ai_gev_flank2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  
  macro_ai_frame(ai_gev_flank3)
};
void() ai_gev_flank3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  ai_attack();
  
  macro_ai_frame(ai_gev_flank4)
};
void() ai_gev_flank4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_flank5)
};
void() ai_gev_flank5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_gev_flank6)
};
void() ai_gev_flank6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);

  ai_face_targ();
  ai_yaw_move( self.ai_dir, (self.m_sspeed + self.m_fspeed)/2);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  macro_ai_frame_count(ai_gev_strafe1)
  macro_ai_frame(ai_gev_fight_prep)
};


/*
  HUNT
  attempt to walkmove to target for a little bit
*/
void() ai_gev_hunt1={
  ai_turret_set_state( TR_NORM );
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt2)
};
void() ai_gev_hunt2={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt3)
};
void() ai_gev_hunt3={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
 
  macro_ai_frame(ai_gev_hunt4)
};
void() ai_gev_hunt4={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt5)
};
void() ai_gev_hunt5={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt6)
};
void() ai_gev_hunt6={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt7)
};
void() ai_gev_hunt7={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt8)
};
void() ai_gev_hunt8={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis( self.enemy ) ){
      ai_sfx_spotted();
      macro_ai_frame(ai_gev_fight_prep)
      return;
    }
  }
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt9)
};
void() ai_gev_hunt9={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt10)
};
void() ai_gev_hunt10={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt11)
};
void() ai_gev_hunt11={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_gev_hunt12)
};
void() ai_gev_hunt12={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_updateTank)
  te_unit_dust( self.origin, self.angles, self.velocity, 1);
  
  movetogoal( self.m_fspeed * AI_RUN_FACTOR );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  if( !ai_check_vis( self.enemy ) ){
    macro_ai_frame_count(ai_gev_hunt1)
  }
  
  ai_sfx_huntEnd();
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_gev_patrol1)
    remove(self.ai_node_recall);
    return;
  }
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  macro_ai_frame(ai_gev_fight_prep)
};

/*
  AI SPAWN FUNCTION
*/
void() ai_gev={  

  ai_unit_ini_var();
  data_iniVehc( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, trigOnSpawn ); //event interface
 
  self.th_stand = ai_gev_stand1;
  self.th_walk = ai_gev_patrol1;
  self.th_pain = ai_gev_pain;
  self.th_missile = ai_gev_fight_prep;
  self.th_die = ai_gev_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};