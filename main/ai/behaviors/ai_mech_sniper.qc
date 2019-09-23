/*
battleMETAL 
Author: Peter Roohr
Date: 10/24/2018
rebuild: 2/16/2019
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
  local vector vel;
  local vector forg;
  
  ai_sfx_dead();
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
  mech_player_compdie(self.torsoLeft);
  mech_player_compdie(self.torsoRight);
  mech_player_compdie(self.armLeft);
  mech_player_compdie(self.armRight);
  mech_player_compdie(self.cockpit);
  
  otemp = self;
  self = self.legs;
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
  
  makevectors( self.torsoCenter.angles );
  vel = self.origin + (v_up * 2);
  forg = self.origin + (v_up * (self.maxs_y / 2) ) + (v_forward * (self.mins_x / 1.5));
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
    case 3:
      te_big_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
    default:
      te_small_flame_start( forg, self.angles, self.vec_size, 600, self.vec_size / 20); 
      break;
  }
};

/*
  smoking wreck
*/
void() ai_mech_sniper_die1={

  te_smoke_test(self.origin, 3);
  te_smoke_test(self.torsoLeft.origin, 1);
  te_smoke_test(self.torsoRight.origin, 1);
  
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
void() ai_mech_sniper_patrol2;
void() ai_mech_sniper_patrol3;
void() ai_mech_sniper_patrol4;
void() ai_mech_sniper_patrol5;
void() ai_mech_sniper_patrol6;
void() ai_mech_sniper_patrol7;
void() ai_mech_sniper_patrol8;
void() ai_mech_sniper_patrol9;
void() ai_mech_sniper_patrol10;
void() ai_mech_sniper_patrol11;
void() ai_mech_sniper_patrol12;
void() ai_mech_sniper_patrol13;
void() ai_mech_sniper_patrol14;
void() ai_mech_sniper_patrol15;
void() ai_mech_sniper_patrol16;

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

/*
  th_pain
  Panic
*/
void(entity attacker) ai_mech_sniper_panic1;
void() ai_mech_sniper_panic2;
void() ai_mech_sniper_panic3;
void() ai_mech_sniper_panic4;
void() ai_mech_sniper_panic5;
void() ai_mech_sniper_panic6;
void() ai_mech_sniper_panic7;
void() ai_mech_sniper_panic8;
void() ai_mech_sniper_panic9;
void() ai_mech_sniper_panic10;
void() ai_mech_sniper_panic11;
void() ai_mech_sniper_panic12;
void() ai_mech_sniper_panic13;
void() ai_mech_sniper_panic14;
void() ai_mech_sniper_panic15;
void() ai_mech_sniper_panic16;

void( entity attacker ) ai_mech_sniper_react1;

void() ai_mech_sniper_walk1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_walk1)
};

void() ai_mech_sniper_stand1={
  ai_update_accuracy( FALSE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  otemp = self;
  self = self.legs;
    bot_leg_stand1();
    self.attack_state = TR_YAW;
  self = otemp;
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  if( time > self.pausetime ){
    if( self.movetarget ){
      macro_ai_frame(ai_mech_sniper_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_mech_sniper_stand1)
};

/* 
  Patrol frames,
  16 for frame binding at 2 ai : 1 leg anim frame
*/
void() ai_mech_sniper_patrol1={
  local entity this;
  
  ai_update_accuracy( TRUE ); 
  macro_ai_update(ctrl_update_mechplayer)
  
  this = self;
  self = self.legs;
    self.ideal_yaw = self.angles_y;
    self.attack_state = TR_NORM;
    bot_leg_walk1();
  self = this;
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol2)
};
void() ai_mech_sniper_patrol2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol3)
};
void() ai_mech_sniper_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol4)
};
void() ai_mech_sniper_patrol4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol5)
};
void() ai_mech_sniper_patrol5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol6)
};
void() ai_mech_sniper_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol7)
};
void() ai_mech_sniper_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol8)
};
void() ai_mech_sniper_patrol8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol9)
};
void() ai_mech_sniper_patrol9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol10)
};
void() ai_mech_sniper_patrol10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol11)
};
void() ai_mech_sniper_patrol11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol12)
};
void() ai_mech_sniper_patrol12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol13)
};
void() ai_mech_sniper_patrol13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol13)
};
void() ai_mech_sniper_patrol14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol15)
};
void() ai_mech_sniper_patrol15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol16)
};
void() ai_mech_sniper_patrol16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( ai_check_scan( self.stat_rdr_mode ) ){
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  movetogoal( self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_patrol1)
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
  self.legs.attack_state = TR_NORM;
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse2)
};
void() ai_mech_sniper_reverse2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
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
  self = self.legs;
    bot_leg_back1();
    self.attack_state = TR_YAW;
    self.ai_dir = anglemod(self.angles_y + 180);
  self = otemp;
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse6)
};
void() ai_mech_sniper_reverse6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse7)
};
void() ai_mech_sniper_reverse7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_mech_sniper_reverse8)
};
void() ai_mech_sniper_reverse8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_mech_sniper_reverse9)
};
void() ai_mech_sniper_reverse9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_reverse10)
};
void() ai_mech_sniper_reverse10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_reverse11)
};
void() ai_mech_sniper_reverse11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_mech_sniper_reverse12)
};
void() ai_mech_sniper_reverse12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.ai_dir = anglemod(self.angles_y + 180);
  walkmove( anglemod(self.angles_y + 180), self.data_speed_backward );
  
  macro_ai_frame(ai_mech_sniper_reverse13)
};
void() ai_mech_sniper_reverse13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
 
  ai_attack();
  
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
  
  macro_ai_frame(ai_mech_sniper_reverse16)
};
void() ai_mech_sniper_reverse16={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};

/*
  charges in direction of self.ai_dir
  
*/
void() ai_mech_sniper_charge1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  self.ideal_yaw = self.ai_dir;
  ChangeYaw(); 
  otemp = self;
  self = self.legs;
    bot_leg_walk1();
    self.attack_state = TR_NORM;
  self = otemp;
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge2)
};
void() ai_mech_sniper_charge2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge3)
};
void() ai_mech_sniper_charge3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge4)
};
void() ai_mech_sniper_charge4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge5)
};
void() ai_mech_sniper_charge5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge6)
};
void() ai_mech_sniper_charge6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge7)
};
void() ai_mech_sniper_charge7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_charge8)
};
void() ai_mech_sniper_charge8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }

  macro_ai_frame(ai_mech_sniper_charge9)
};
void() ai_mech_sniper_charge9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );

  macro_ai_frame(ai_mech_sniper_charge10)
};
void() ai_mech_sniper_charge10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );

  macro_ai_frame(ai_mech_sniper_charge11)
};
void() ai_mech_sniper_charge11={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge12)
};
void() ai_mech_sniper_charge12={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
 
  macro_ai_frame(ai_mech_sniper_charge13)
};
void() ai_mech_sniper_charge13={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge14)
};
void() ai_mech_sniper_charge14={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  
  macro_ai_frame(ai_mech_sniper_charge15)
};
void() ai_mech_sniper_charge15={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
  ai_attack();

  macro_ai_frame(ai_mech_sniper_charge16)
};
void() ai_mech_sniper_charge16={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  walkmove( self.angles_y, self.data_speed_forward );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_fight_prep)
};


/*
  Mech Sniper rotates to face target
*/  
void() ai_mech_sniper_rotate1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  self.legs.attack_state = TR_NORM;
  
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
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_rotate4)
};
void() ai_mech_sniper_rotate4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
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
  
  macro_ai_frame(ai_mech_sniper_rotate7)
};
void() ai_mech_sniper_rotate7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
  
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
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn2)
};
void() ai_mech_sniper_turn2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn3)
};
void() ai_mech_sniper_turn3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_turn4)
};
void() ai_mech_sniper_turn4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
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
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_snipe5)
};
void() ai_mech_sniper_snipe5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_face_targ();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
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
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
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
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)

  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  ai_attack();
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ChangeYaw();
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee7={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
   
  otemp = self;
  self = self.legs;
    self.attack_state = TR_NORM;
    bot_leg_walk1();
  self = otemp;
  
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee8={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee9={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_attack();
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee10={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.data_speed_strafe );
    
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee11={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee12={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee13={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  ai_attack();
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame(ai_mech_sniper_melee2)
};
void() ai_mech_sniper_melee14={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_update_mechplayer)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  walkmove( self.angles_y, self.data_speed_strafe );
  
  macro_ai_frame_count(ai_mech_sniper_melee5)
  
  macro_ai_frame(ai_mech_sniper_melee2)
};

/*
  th_pain == 'panic'
  unit runs to its nearest node or ally
  if either are lacking, it'll just run in a rando direction
*/
void(entity attacker) ai_mech_sniper_panic1={
  local entity friend;
  
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  self.ai_dir = self.angles_y;
  friend = ai_find_friend( self.ai_view );
  if( friend ){
    self.goalentity = friend;
  }
  else if( self.movetarget ){
    self.goalentity = self.movetarget;
  }
  else{
    if( !ai_valid_target(self.enemy) ){
      if( ai_valid_target(attacker) ){
        self.enemy = attacker;
        macro_ai_frame(ai_mech_sniper_fight_prep)
        return;
      }
    }
    if( ai_valid_target(attacker) ){
      self.enemy = attacker;
      macro_ai_frame(ai_mech_sniper_fight_prep)
      return;
    }
  }
  
  macro_ai_frame( ai_mech_sniper_panic2 )
};
void() ai_mech_sniper_panic2={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )

  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic3 )
};
void() ai_mech_sniper_panic3={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic4 )
};
void() ai_mech_sniper_panic4={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic5 )
};
void() ai_mech_sniper_panic5={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic6 )
};
void() ai_mech_sniper_panic6 ={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
 
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );

  macro_ai_frame( ai_mech_sniper_panic7 )
};
void() ai_mech_sniper_panic7={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic8 )
};
void() ai_mech_sniper_panic8={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic9 )
};
void() ai_mech_sniper_panic9={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic10 )
};
void() ai_mech_sniper_panic10={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic11 )
};
void() ai_mech_sniper_panic11={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic12 )
};
void() ai_mech_sniper_panic12={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic13 )
};
void() ai_mech_sniper_panic13={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic14 )
};
void() ai_mech_sniper_panic14={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic15 )
};
void() ai_mech_sniper_panic15={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  macro_ai_frame( ai_mech_sniper_panic16 )
};
void() ai_mech_sniper_panic16={
  ai_update_accuracy( TRUE );
  macro_ai_update( ctrl_update_mechplayer )
  
  macro_ai_frame_count( ai_mech_sniper_panic1 )
  
  movetogoal( self.data_speed_forward * AI_RUN_FACTOR );
  
  if( ai_valid_target(self.enemy) ){
    macro_ai_frame( ai_mech_sniper_fight_prep )
    return;
  }
  
  if( self.movetarget ){
    macro_ai_frame( ai_mech_sniper_patrol1 )
    return;
  }
  
  macro_ai_frame( ai_mech_sniper_stand1 )
};

/*
  TH_REACT
*/
void( entity attacker ) ai_mech_sniper_react1={
  local float enemyvis;
  local float enemydist;

  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }

  //AI currently has no target
  if( ai_valid_target(self.enemy) == FALSE ){
    self.ai_react_buffer = time + self.ai_react_time * 1.25;
    self.enemy = attacker;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  enemyvis = ai_check_vis(self.enemy);
  if( enemyvis == VIS_FAIL ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
  if( ai_check_targ_infront( attacker, self.ai_fov) ){
    self.oldenemy = self.enemy;
    self.enemy = attacker;
    self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
    self.ai_react_buffer = time + self.ai_react_time * 3;
    macro_ai_frame(ai_mech_sniper_fight_prep)
    return;
  }
  
};

/*
  AI SPAWN FUNCTION
*/
void() ai_mech_sniper={

  ai_unit_ini_var();
  initialize_data_mech_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
    
  trigger_event( self, trigOnSpawn); //event interface
  
  self.th_stand = ai_mech_sniper_stand1;
  self.th_walk = ai_mech_sniper_patrol1;
  self.th_missile = ai_mech_sniper_fight_prep;
  self.th_pain = ai_mech_sniper_panic1;
  self.th_react = ai_mech_sniper_react1;
  self.th_die = ai_mech_sniper_die;
  self.touch = ai_touch;
  
  self.think = ai_setup_patrol;
  self.nextthink = time + (random()*0.9); //spread out thinks
};