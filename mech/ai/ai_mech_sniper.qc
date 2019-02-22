/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
Overview: ai unit
  Mech - Sniper
  an on-ground, turreted, walking unit
  sniperrs try to work the mid and long range
  close-up they're kinda useless, only should attack at longer ranges
*/

void() ai_mech_sniper_die;
void() ai_mech_sniper_die1;
void() ai_mech_sniper_die2;

/*
  TH_DIE
*/ 
void() ai_mech_sniper_die={
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
  
  otemp = self;
  self = self.e_legs;
    bot_leg_die1();
  self = otemp;
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.think = ai_mech_sniper_die1;
  self.ai_action_time = time + 300;
  //basically overkill damage will just remove the mech (nice and clean)
  if( self.health <= (self.max_health / 1.5) * -1 ){
    self.think = ai_mech_sniper_die2;
  }
  self.nextthink = time + 0.1;
};

/*
  smoking wreck
*/
void() ai_mech_sniper_die1={
  makevectors( world.v_angle );
  local vector sm;
  sm = world.v_angle + (v_forward * world.m_fspeed) + (v_right * world.m_fspeed) + (v_up * world.m_fspeed);
  te_smoke_test(self.origin, sm + '0 0 5', 3);
  te_smoke_test(self.e_tor_l.origin, sm + '0 0 5', 1);
  te_smoke_test(self.e_tor_r.origin, sm + '0 0 5', 1);
  
  self.think = ai_mech_sniper_die1;
  if( time > self.ai_action_time ){
    self.think = ai_mech_sniper_die2;
  } 
  self.nextthink = time + 0.1;
};

//explode
void() ai_mech_sniper_die2={
  mech_cleanupMech();
  self.nextthink = time + 0.1;
  self.think = BecomeExplosion;
};

/*
  macro rebuild
*/

void() ai_mech_sniper_walk1;
void() ai_mech_sniper_stand1;

void() ai_mech_sniper_patrol1;
void() ai_mech_sniper_patrol_walk1;

void() ai_mech_sniper_fight_prep;

void() ai_mech_sniper_reverse1;
void() ai_mech_sniper_reverse2;
void() ai_mech_sniper_reverse3;
void() ai_mech_sniper_reverse4;
void() ai_mech_sniper_reverse5;
void() ai_mech_sniper_reverse6;
void() ai_mech_sniper_reverse7;
void() ai_mech_sniper_reverse8;
void() ai_mech_sniper_reverse9;
void() ai_mech_sniper_reverse10;
void() ai_mech_sniper_reverse11;
void() ai_mech_sniper_reverse12;
void() ai_mech_sniper_reverse13;
void() ai_mech_sniper_reverse14;
void() ai_mech_sniper_reverse15;
void() ai_mech_sniper_reverse16;

void() ai_mech_sniper_charge1;
void() ai_mech_sniper_charge2;
void() ai_mech_sniper_charge3;
void() ai_mech_sniper_charge4;
void() ai_mech_sniper_charge5;
void() ai_mech_sniper_charge6;
void() ai_mech_sniper_charge7;
void() ai_mech_sniper_charge8;
void() ai_mech_sniper_charge9;
void() ai_mech_sniper_charge10;
void() ai_mech_sniper_charge11;
void() ai_mech_sniper_charge12;
void() ai_mech_sniper_charge13;
void() ai_mech_sniper_charge14;
void() ai_mech_sniper_charge15;
void() ai_mech_sniper_charge16;

void() ai_mech_sniper_rotate1;
void() ai_mech_sniper_rotate2;
void() ai_mech_sniper_rotate3;
void() ai_mech_sniper_rotate4;
void() ai_mech_sniper_rotate5;
void() ai_mech_sniper_rotate6;
void() ai_mech_sniper_rotate7;
void() ai_mech_sniper_rotate8;

void() ai_mech_sniper_turn1;
void() ai_mech_sniper_turn2;
void() ai_mech_sniper_turn3;
void() ai_mech_sniper_turn4;

void() ai_mech_sniper_snipe1;
void() ai_mech_sniper_snipe2;
void() ai_mech_sniper_snipe3;
void() ai_mech_sniper_snipe4;
void() ai_mech_sniper_snipe5;
void() ai_mech_sniper_snipe6;
void() ai_mech_sniper_snipe7;
void() ai_mech_sniper_snipe8;

/*
  melee for veterans, tries to shoot some,
  then strafes
*/
void() ai_mech_sniper_melee1;
void() ai_mech_sniper_melee2;
void() ai_mech_sniper_melee3;
void() ai_mech_sniper_melee4;
void() ai_mech_sniper_melee5;
void() ai_mech_sniper_melee6;
void() ai_mech_sniper_melee7;
void() ai_mech_sniper_melee8;
void() ai_mech_sniper_melee9;
void() ai_mech_sniper_melee10;
void() ai_mech_sniper_melee11;
void() ai_mech_sniper_melee12;
void() ai_mech_sniper_melee13;
void() ai_mech_sniper_melee14;

void() ai_mech_sniper_walk1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_walk1)
};

void() ai_mech_sniper_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  otemp = self;
  self = self.e_legs;
    bot_leg_stand1();
    self.attack_state = TR_YAW;
  self = otemp;
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_mech_sniper_stand1)
};

void() ai_mech_sniper_fight_prep={
  local float rand;
  rand = random();
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_face( self.enemy, self.ai_fov );
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range < 200 ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_melee1)
            return;
          }
          if( rand < 0.35 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          if( self.ai_rank > AI_RANK_REG ){
            if( rand < 0.35 ){
              macro_ai_frame(ai_mech_sniper_reverse1)
              return;
            }
            if( rand < 0.67 ){
              //melee
              self.lefty = self.lefty * -1;
              self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
              self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
              self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
              macro_ai_frame(ai_mech_sniper_melee1)
              return;
            }
          }
          if( rand < 0.15 ){
            macro_ai_frame(ai_mech_sniper_snipe1)
            return;
          }
          if( rand < 0.3 ){
            macro_ai_frame(ai_mech_sniper_reverse1)
            return;
          }
          if( rand < 0.67 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          macro_ai_frame(ai_mech_sniper_rotate1)
          return;
        }
        if( self.ai_rank > AI_RANK_REG ){
          if( rand < 0.2 ){
            //melee
            self.lefty = self.lefty * -1;
            self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
            self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_melee1)
            return;
          }
          self.lefty = self.lefty * -1;
          self.ai_dir = (random() * 45) * 2;
          self.ai_dir = self.ai_dir * self.lefty;
          self.ai_dir = anglemod( self.angles_y + self.ai_dir );
          macro_ai_frame(ai_mech_sniper_charge1)
          return;
        }
        if( rand < 0.4 ){
          macro_ai_frame(ai_mech_sniper_reverse1)
          return;
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
      if( enemy_range > self.ai_minrange ){
        if( enemy_infront ){
          local float rand;
          rand = random();
          if( rand < 0.35 ){
            self.lefty = self.lefty * -1;
            self.ai_dir = (random() * 45) * 2;
            self.ai_dir = self.ai_dir * self.lefty;
            self.ai_dir = anglemod( self.angles_y + self.ai_dir );
            macro_ai_frame(ai_mech_sniper_charge1)
            return;
          }
          if( rand < 0.5 ){
            macro_ai_frame(ai_mech_sniper_snipe1)
            return;
          }
        }
        macro_ai_frame(ai_mech_sniper_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      if( self.ai_rank > AI_RANK_REG ){
        //melee
        self.lefty = self.lefty * -1;
        self.ai_dir = (50 + ceil(random() * 60)) * self.lefty;
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ai_dir = anglemod( self.ideal_yaw + self.ai_dir );
        macro_ai_frame(ai_mech_sniper_melee1)
        return;
      }
      macro_ai_frame(ai_mech_sniper_reverse1)
      return;
    }
    self.enemy = world;
    //snipers don't hunt, snapshot last known yaw
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    macro_ai_frame(ai_mech_sniper_turn1)
    return;
  }
  
  macro_ai_frame(ai_mech_sniper_patrol1)
};

void() ai_mech_sniper_reverse1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.attack_state = TR_NORM;
  
  macro_ai_frame(ai_mech_sniper_reverse2)
};
void() ai_mech_sniper_reverse2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_reverse3)
};
void() ai_mech_sniper_reverse3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_reverse4)
};
void() ai_mech_sniper_reverse4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_reverse5)
};
void() ai_mech_sniper_reverse5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  otemp = self;
  self = self.e_legs;
    bot_leg_back1();
    self.attack_state = TR_YAW;
    self.ai_dir = anglemod(self.angles_y + 180);
  self = otemp;
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse6)
};
void() ai_mech_sniper_reverse6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse7)
};
void() ai_mech_sniper_reverse7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse8)
};
void() ai_mech_sniper_reverse8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse9)
};
void() ai_mech_sniper_reverse9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse10)
};
void() ai_mech_sniper_reverse10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse11)
};
void() ai_mech_sniper_reverse11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse12)
};
void() ai_mech_sniper_reverse12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.m_bspeed );
  
  macro_ai_frame(ai_mech_sniper_reverse13)
};
void() ai_mech_sniper_reverse13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse14)
};
void() ai_mech_sniper_reverse14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse15)
};
void() ai_mech_sniper_reverse15={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse16)
};
void() ai_mech_sniper_reverse16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

/*
  charges in direction of self.ai_dir
  
*/
void() ai_mech_sniper_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ai_move_turn(); 
  otemp = self;
  self = self.e_legs;
    bot_leg_walk1();
    self.attack_state = TR_NORM;
  self = otemp;
  walkmove( self.angles_y, self.m_fspeed );
  
  macro_ai_frame(ai_mech_sniper_charge2)
};
void() ai_mech_sniper_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  
  macro_ai_frame(ai_mech_sniper_charge3)
};
void() ai_mech_sniper_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  
  macro_ai_frame(ai_mech_sniper_charge4)
};
void() ai_mech_sniper_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  
  macro_ai_frame(ai_mech_sniper_charge5)
};
void() ai_mech_sniper_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_charge6)
};
void() ai_mech_sniper_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_charge7)
};
void() ai_mech_sniper_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_charge8)
};
void() ai_mech_sniper_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge9)
};
void() ai_mech_sniper_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge10)
};
void() ai_mech_sniper_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge11)
};
void() ai_mech_sniper_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge12)
};
void() ai_mech_sniper_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();
 
  macro_ai_frame(ai_mech_sniper_charge13)
};
void() ai_mech_sniper_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_charge14)
};
void() ai_mech_sniper_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_charge15)
};
void() ai_mech_sniper_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge16)
};
void() ai_mech_sniper_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  walkmove( self.angles_y, self.m_fspeed );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};


/*
  Mech Sniper rotates to face target
*/  
void() ai_mech_sniper_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.e_legs.attack_state = TR_NORM;
  
  macro_ai_frame(ai_mech_sniper_rotate2)
};
void() ai_mech_sniper_rotate2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate3)
};
void() ai_mech_sniper_rotate3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate4)
};
void() ai_mech_sniper_rotate4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate5)
};
void() ai_mech_sniper_rotate5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_rotate6)
};
void() ai_mech_sniper_rotate6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_rotate7)
};
void() ai_mech_sniper_rotate7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_rotate8)
};
void() ai_mech_sniper_rotate8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

/*
  Turns to face ideal_yaw,
  but not based on target
*/
void() ai_mech_sniper_turn1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  
  macro_ai_frame(ai_mech_sniper_turn2)
};
void() ai_mech_sniper_turn2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  
  macro_ai_frame(ai_mech_sniper_turn3)
};
void() ai_mech_sniper_turn3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  
  macro_ai_frame(ai_mech_sniper_turn4)
};
void() ai_mech_sniper_turn4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  
  if( !ai_check_vis(self.enemy) ){
    self.enemy = world;
    macro_ai_frame(ai_mech_sniper_patrol1)
  }
  
  macro_ai_frame_count(ai_mech_sniper_turn1)
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

void() ai_mech_sniper_snipe1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe2)
};
void() ai_mech_sniper_snipe2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe3)
};
void() ai_mech_sniper_snipe3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe4)
};
void() ai_mech_sniper_snipe4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
  macro_ai_frame(ai_mech_sniper_snipe5)
};
void() ai_mech_sniper_snipe5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe6)
};
void() ai_mech_sniper_snipe6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe7)
};
void() ai_mech_sniper_snipe7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe8)
};
void() ai_mech_sniper_snipe8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  ai_attack();
  
  macro_ai_frame_count(ai_mech_sniper_snipe1)
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

/*
  melee for veterans, tries to shoot some,
  then strafes.
  self.ai_dir = strafe dir, rotate first
*/
void() ai_mech_sniper_melee1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ai_move_turn();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)

  ai_move_turn();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_move_turn();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
   
  otemp = self;
  self = self.e_legs;
    self.attack_state = TR_NORM;
    bot_leg_walk1();
  self = otemp;
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.m_sspeed );
  
  macro_ai_frame_count(ai_mech_sniper_melee5)
  
  macro_ai_frame(ai_mech_sniper_melee2)
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={

  ai_unit_ini_var();
  data_iniMech( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
    
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_mech_sniper_stand1;
  self.th_walk = ai_mech_sniper_walk1;
  self.th_missile = ai_mech_sniper_fight_prep;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  if( (self.spawnflags & AI_SPAWNFLAG_COLDSTART) ){
    self.nextthink = time + (7 + random()* 1); //spread out thinks
  }
  else{
    self.nextthink = time + (random()*0.9); //spread out thinks
  }
};