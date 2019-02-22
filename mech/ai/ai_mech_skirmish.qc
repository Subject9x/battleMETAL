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
void() ai_mech_sk_die;
void() ai_mech_sk_die1;
void() ai_mech_sk_die2;

/*
  TH_DIE
*/ 
void() ai_mech_sk_die={
  local entity this;
  
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
  mech_player_compdie(self.e_legs);
  mech_player_compdie(self.e_cam);
  
  this = self;
  self = self.e_legs;
    self.attack_state = TR_YAW;
    bot_leg_die1();
  self = this;
  
  
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
  Macro rebuild
*/

void() ai_mech_sk_fight_prep;
void() ai_mech_sk_patrol1;
void() ai_mech_sk_patrol2;
void() ai_mech_sk_patrol3;
void() ai_mech_sk_patrol4;
void() ai_mech_sk_patrol5;
void() ai_mech_sk_patrol6;
void() ai_mech_sk_patrol7;
void() ai_mech_sk_patrol8;
void() ai_mech_sk_patrol9;
void() ai_mech_sk_patrol10;
void() ai_mech_sk_patrol11;
void() ai_mech_sk_patrol12;
void() ai_mech_sk_patrol13;
void() ai_mech_sk_patrol14;
void() ai_mech_sk_patrol15;
void() ai_mech_sk_patrol16;
void() ai_mech_sk_patrol_stand1;
void() ai_mech_sk_patrol_stand2;
void() ai_mech_sk_stand1;

/*
  self.lefty = 1 Forward | -1 Backward
  self.ideal_yaw = enemy yaw
*/
void() ai_mech_sk_charge1;
void() ai_mech_sk_charge2;
void() ai_mech_sk_charge3;
void() ai_mech_sk_charge4;
void() ai_mech_sk_charge5;
void() ai_mech_sk_charge6;
void() ai_mech_sk_charge7;
void() ai_mech_sk_charge8;
void() ai_mech_sk_charge9;
void() ai_mech_sk_charge10;
void() ai_mech_sk_charge11;
void() ai_mech_sk_charge12;
void() ai_mech_sk_charge13;
void() ai_mech_sk_charge14;
void() ai_mech_sk_charge15;
void() ai_mech_sk_charge16;

void() ai_mech_sk_flank1;
void() ai_mech_sk_flank2;
void() ai_mech_sk_flank3;
void() ai_mech_sk_flank4;
void() ai_mech_sk_flank5;
void() ai_mech_sk_flank6;
void() ai_mech_sk_flank7;
void() ai_mech_sk_flank8;
void() ai_mech_sk_flank9;
void() ai_mech_sk_flank10;
void() ai_mech_sk_flank11;
void() ai_mech_sk_flank12;
void() ai_mech_sk_flank13;
void() ai_mech_sk_flank14;
void() ai_mech_sk_flank15;
void() ai_mech_sk_flank16;

/*
  move 90d to target
  first adjusts to angle then walks that dir
  self.ideal_yaw = enemy_yaw + mod
  but bake it in
*/
void() ai_mech_sk_strafe1;
void() ai_mech_sk_strafe2;
void() ai_mech_sk_strafe3;
void() ai_mech_sk_strafe4;
void() ai_mech_sk_strafe5;
void() ai_mech_sk_strafe6;
void() ai_mech_sk_strafe7;
void() ai_mech_sk_strafe8;
void() ai_mech_sk_strafe9;
void() ai_mech_sk_strafe10;
void() ai_mech_sk_strafe11;
void() ai_mech_sk_strafe12;
void() ai_mech_sk_strafe13;
void() ai_mech_sk_strafe14;
void() ai_mech_sk_strafe15;
void() ai_mech_sk_strafe16;

void() ai_mech_sk_pivot1;
void() ai_mech_sk_pivot2;
void() ai_mech_sk_pivot3;
void() ai_mech_sk_pivot4;

void() ai_mech_sk_hunt1;
void() ai_mech_sk_hunt2;
void() ai_mech_sk_hunt3;
void() ai_mech_sk_hunt4;
void() ai_mech_sk_hunt5;
void() ai_mech_sk_hunt6;
void() ai_mech_sk_hunt7;
void() ai_mech_sk_hunt8;
void() ai_mech_sk_hunt9;
void() ai_mech_sk_hunt10;
void() ai_mech_sk_hunt11;
void() ai_mech_sk_hunt12;
void() ai_mech_sk_hunt13;
void() ai_mech_sk_hunt14;
void() ai_mech_sk_hunt15;
void() ai_mech_sk_hunt16;

void() ai_mech_sk_fight_prep={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            if( random() < 0.5){
              self.lefty = self.lefty * -1;
              self.ai_dir = self.lefty * (45 + (random() * 60));
              macro_ai_update(ai_mech_sk_flank1)
              return;
            }
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * (45 + (random() * 75));
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
            macro_ai_update(ai_mech_sk_strafe1)
            return;
          }
          if( random() < 0.25){
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * (25 + (random() * 45));
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
            macro_ai_update(ai_mech_sk_flank1)
            return;
          }
          self.lefty = -1;
          macro_ai_update(ai_mech_sk_charge1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = self.lefty * -1;
          self.ai_dir = self.lefty * (45 + (random() * 75));
          self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
          self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
          macro_ai_update(ai_mech_sk_flank1)
          return;
        }
        macro_ai_update(ai_mech_sk_pivot1)
        return;
      }
      
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            local float rand;
            rand = random();
            if( rand < 0.25 ){
              self.lefty = 1;
              macro_ai_update(ai_mech_sk_charge1)
              return;
            }
            if( rand < 0.5 ){
              self.lefty = self.lefty * -1;
              self.ai_dir = self.lefty * (25 + (random() * 45));
              self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
              self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
              macro_ai_update(ai_mech_sk_flank1)
              return;
            }
            self.lefty = self.lefty * -1;
            self.ai_dir = self.lefty * (45 + (random() * 60));
            macro_ai_update(ai_mech_sk_flank1)
            return;
          }
          self.lefty = self.lefty * -1;
          self.ai_dir = self.lefty * (45 + (random() * 60));
          macro_ai_update(ai_mech_sk_flank1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          self.lefty = -1;
          macro_ai_update(ai_mech_sk_charge1)
          return;
        }
        macro_ai_update(ai_mech_sk_pivot1)
        return;
      }
      
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          self.lefty = 1;
          macro_ai_update(ai_mech_sk_charge1)
          return;
        }
        self.lefty = self.lefty * -1;
        self.ai_dir = self.lefty * (25 + (random() * 45));
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
        macro_ai_update(ai_mech_sk_flank1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      if( rand < 0.33 ){
        self.lefty = self.lefty * -1;
        self.ai_dir = self.lefty * (25 + (random() * 45));
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ideal_yaw = anglemod( self.ideal_yaw + self.ai_dir);
        macro_ai_update(ai_mech_sk_strafe1)
        return;
      }
      self.lefty = self.lefty * -1;
      self.ai_dir = self.lefty * (45 + (random() * 60));
      macro_ai_update(ai_mech_sk_flank1)
      return;
    }
    //goto hunting
    macro_ai_frame_hunt(ai_mech_sk_hunt1)
  }
  macro_ai_frame(ai_mech_sk_patrol1)
};


/* 
  Patrol frames,
  16 for frame binding at 2 ai : 1 leg anim frame
*/
void() ai_mech_sk_patrol1={
  local entity this;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  this = self;
  self = self.e_legs;
    self.ideal_yaw = self.angles_y;
    self.attack_state = TR_NORM;
    bot_leg_walk1();
  self = this;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol2)
};
void() ai_mech_sk_patrol2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol3)
};
void() ai_mech_sk_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol4)
};
void() ai_mech_sk_patrol4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol5)
};
void() ai_mech_sk_patrol5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol6)
};
void() ai_mech_sk_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol7)
};
void() ai_mech_sk_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol8)
};
void() ai_mech_sk_patrol8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol9)
};
void() ai_mech_sk_patrol9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol10)
};
void() ai_mech_sk_patrol10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol11)
};
void() ai_mech_sk_patrol11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol12)
};
void() ai_mech_sk_patrol12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol13)
};
void() ai_mech_sk_patrol13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol14)
};
void() ai_mech_sk_patrol14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol15)
};
void() ai_mech_sk_patrol15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol16)
};
void() ai_mech_sk_patrol16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  movetogoal( self.m_fspeed );
  
  macro_ai_frame(ai_mech_sk_patrol1)
};

void() ai_mech_sk_patrol_stand1={
  local entity this;

  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  this = self;
  self = self.e_legs;
    self.attack_state = TR_YAW;
    bot_leg_stand1();
  self = this;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  if( time > self.pausetime ){
    macro_ai_frame(ai_mech_sk_patrol1)
  }
  macro_ai_frame(ai_mech_sk_patrol_stand1)
};
void() ai_mech_sk_patrol_stand2={
  local entity this;
  
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  this = self;
  self = this.e_legs;
    self.attack_state = TR_YAW;
    bot_leg_stand1();
  self = this;
};

void() ai_mech_sk_stand1={
  local entity this;
  
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  this = self;
  self = this.e_legs;
  self.attack_state = TR_YAW;
    bot_leg_stand1();
  self = this;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sk_fight_prep)
    return;
  }
  
  if( time > self.pausetime ){
    if( self.target ){
      macro_ai_frame(ai_mech_sk_patrol1)
      return;
    }
  }
  macro_ai_frame(ai_mech_sk_stand1)
};

/*
  move 90d to target
  first adjusts to angle then walks that dir
  self.ideal_yaw = enemy_yaw + mod
  but bake it in
*/
void() ai_mech_sk_strafe1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  ai_move_turn();
  self.e_legs.attack_state = TR_NORM;
  otemp = self;
  self = self.e_legs;
    bot_leg_walk1();
  self = otemp;
  if( self.angles_y == self.ideal_yaw ){
    macro_ai_frame(ai_mech_sk_strafe2)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_strafe1)
};
void() ai_mech_sk_strafe2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed);
  
  macro_ai_frame(ai_mech_sk_strafe3)
};
void() ai_mech_sk_strafe3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  
  macro_ai_frame(ai_mech_sk_strafe4)
};
void() ai_mech_sk_strafe4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  
  macro_ai_frame(ai_mech_sk_strafe5)
};
void() ai_mech_sk_strafe5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe6)
};
void() ai_mech_sk_strafe6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe7)
};
void() ai_mech_sk_strafe7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe8)
};
void() ai_mech_sk_strafe8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe9)
};
void() ai_mech_sk_strafe9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe10)
};
void() ai_mech_sk_strafe10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe11)
};
void() ai_mech_sk_strafe11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe12)
};
void() ai_mech_sk_strafe12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe13)
};
void() ai_mech_sk_strafe13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);

  macro_ai_frame(ai_mech_sk_strafe14)
};
void() ai_mech_sk_strafe14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);

  macro_ai_frame(ai_mech_sk_strafe15)
};
void() ai_mech_sk_strafe15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_strafe16)
};
void() ai_mech_sk_strafe16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
   
  walkmove( self.angles_y, self.m_sspeed);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame_count(ai_mech_sk_strafe1)
  
  if( random() < 0.67 ){
    macro_ai_frame(ai_mech_sk_pivot1)
    return;
  }
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};

/*
  self.lefty = 1 Forward | -1 Backward
  self.ideal_yaw = enemy yaw
*/
void() ai_mech_sk_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    otemp = self;
    walkmove( self.angles_y, self.m_fspeed );
    self.e_legs.attack_state = TR_NORM;
    self = self.e_legs;
      bot_leg_walk1();
    self = otemp;
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    otemp = self;
    self.e_legs.attack_state = TR_GOAL;
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
    self = self.e_legs;
      bot_leg_back1();
    self = otemp;
  }
  
  macro_ai_frame(ai_mech_sk_charge2)
};
void() ai_mech_sk_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge3)
};
void() ai_mech_sk_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge4)
};
void() ai_mech_sk_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge5)
};
void() ai_mech_sk_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame(ai_mech_sk_charge6)
};
void() ai_mech_sk_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge7)
};
void() ai_mech_sk_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge8)
};
void() ai_mech_sk_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge9)
};
void() ai_mech_sk_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge10)
};
void() ai_mech_sk_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge11)
};
void() ai_mech_sk_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge12)
};
void() ai_mech_sk_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge13)
};
void() ai_mech_sk_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge14)
};
void() ai_mech_sk_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge15)
};
void() ai_mech_sk_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sk_charge16)
};
void() ai_mech_sk_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.lefty > 0 ){
    walkmove( self.angles_y, self.m_fspeed );
  }
  else{
    walkmove( anglemod(self.angles_y + 180), self.m_bspeed);
    self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  }
  
  macro_ai_frame_count(ai_mech_sk_strafe1)
  
  if( random() < 0.75 ){
    macro_ai_frame(ai_mech_sk_pivot1)
    return;
  } 
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};

/*
  Mech moves to the side of its target, maintaining an offset yaw
  self.ai_dir = +/- 45 + random() * 60
  self.ideal_yaw = enemy yaw + self.ai_dir
*/
void() ai_mech_sk_flank1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.e_legs.th_walk();
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  self.e_legs.attack_state = TR_GOAL;
  otemp = self;
  self = self.e_legs;
  bot_leg_walk1();
  self = otemp;
  
  macro_ai_frame(ai_mech_sk_flank2)
};
void() ai_mech_sk_flank2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  
  macro_ai_frame(ai_mech_sk_flank3)
};
void() ai_mech_sk_flank3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  
  macro_ai_frame(ai_mech_sk_flank4)
};
void() ai_mech_sk_flank4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank5)
};
void() ai_mech_sk_flank5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank6)
};
void() ai_mech_sk_flank6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.ai_dir = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank7)
};
void() ai_mech_sk_flank7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank8)
};
void() ai_mech_sk_flank8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank9)
};
void() ai_mech_sk_flank9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank10)
};
void() ai_mech_sk_flank10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  
  macro_ai_frame(ai_mech_sk_flank11)
};
void() ai_mech_sk_flank11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  
  macro_ai_frame(ai_mech_sk_flank12)
};
void() ai_mech_sk_flank12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank13)
};
void() ai_mech_sk_flank13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_flank14)
};
void() ai_mech_sk_flank14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);

  macro_ai_frame(ai_mech_sk_flank15)
};
void() ai_mech_sk_flank15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);

  macro_ai_frame(ai_mech_sk_flank16)
};
void() ai_mech_sk_flank16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  walkmove( anglemod(self.angles_y + self.ai_dir), self.m_sspeed);
  self.e_legs.angles_y = anglemod(self.angles_y + self.ai_dir);
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame_count(ai_mech_sk_flank1)
  
  if( random() < 0.67 ){
    macro_ai_frame(ai_mech_sk_pivot1)
    return;
  } 
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};

/*
  Mech attempts to pivot to its ideal_yaw
*/
void() ai_mech_sk_pivot1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  otemp = self;
  self = self.e_legs;
    bot_leg_walk1();
  self = otemp;
  
  self.e_legs.attack_state = TR_NORM;
  
  macro_ai_frame(ai_mech_sk_pivot2)
};
void() ai_mech_sk_pivot2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sk_pivot3)
};
void() ai_mech_sk_pivot3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sk_pivot4)
};
void() ai_mech_sk_pivot4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame_count(ai_mech_sk_pivot1)
  
  macro_ai_frame(ai_mech_sk_fight_prep)
};

/*
  Mech Skirmish Hunt mode
*/
void() ai_mech_sk_hunt1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt2)
};
void() ai_mech_sk_hunt2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt3)
};
void() ai_mech_sk_hunt3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt4)
};
void() ai_mech_sk_hunt4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt5)
};
void() ai_mech_sk_hunt5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt6)
};
void() ai_mech_sk_hunt6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt7)
};
void() ai_mech_sk_hunt7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt8)
};
void() ai_mech_sk_hunt8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt9)
};
void() ai_mech_sk_hunt9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt10)
};
void() ai_mech_sk_hunt10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt11)
};
void() ai_mech_sk_hunt11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt12)
};
void() ai_mech_sk_hunt12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt13)
};
void() ai_mech_sk_hunt13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt14)
};
void() ai_mech_sk_hunt14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt15)
};
void() ai_mech_sk_hunt15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  macro_ai_frame(ai_mech_sk_hunt16)
};
void() ai_mech_sk_hunt16={
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  movetogoal( self.m_fspeed );
  
  if( !ai_valid_target(self.enemy) ){
    ai_sfx_kill();
    ai_sfx_huntEnd();
    self.goalentity = self.ai_node_recall;
  }
  
  if( !ai_check_vis( self.enemy ) ){
    macro_ai_frame_count(ai_mech_sk_hunt1)
  }
  
  ai_sfx_huntEnd();
  if( self.movetarget ){
    self.goalentity = self.movetarget;
    macro_ai_frame(ai_mech_sk_patrol1)
    remove(self.ai_node_recall);
    return;
  }
  if( self.ai_node_recall ){
    remove(self.ai_node_recall);
  }
  macro_ai_frame(ai_mech_sk_fight_prep)
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_skirmish={

  ai_unit_ini_var();
  data_iniMech( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  
  trigger_event( self, trigOnSpawn); //event interface
    
  self.th_stand = ai_mech_sk_stand1;
  self.th_walk = ai_mech_sk_patrol1;
  self.th_melee = ai_mech_sk_patrol_stand1;
  self.th_missile = ai_mech_sk_fight_prep;
  self.th_die = ai_mech_sk_die;
  self.touch = ai_touch;

  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
};