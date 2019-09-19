/*
battleMETAL 
Author: Peter Roohr
Date: 7/16/2018
Overview: ai unit
  Stock Turret Unit
  an on-ground, static vehicle
*/

void() ai_turret_die;
void() ai_turret_die_burn;
void() temp_chunk_burn;

void() temp_chunk_burn={
  if( time > self.delay){
    self.think = SUB_Remove;
  }
  else{  
    te_smoke_test(self.origin, 3);
    self.think = temp_chunk_burn;
  }
	self.nextthink = time + 0.1;
};

/*
  TH_DIE
*/
void() ai_turret_die={
  local vector  v;
  ai_sfx_dead();
  
  self.deadflag = DEAD_DYING;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_CORPSE;
  self.colormod = '0.25 0.25 0.25';
  
  //annoying that turret corpses block a lot of fire.
  self.maxs_x = self.maxs_x * 0.33;
  self.maxs_y = self.maxs_y * 0.33;
  self.maxs_z = self.maxs_z * 0.67;
  self.mins_x = self.maxs_x * -1;
  self.mins_y = self.maxs_y * -1;
  setsize(self, self.mins, self.maxs);
  
  local entity w_chain;
  w_chain = self.w_slot;
  while(w_chain){
    mech_player_compdie(w_chain);
    w_chain = w_chain.w_slot;
  }
  mech_player_compdie(self.cockpit);  
  mech_player_compdie(self.torsoCenter);
  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );

  makevectors( self.angles );
  v = self.origin + (v_up * 2);
  te_debris( self.origin, self.angles, normalize( v - self.origin) * 100, (random() * self.vec_size) + 5, self.vec_size - 1);
  te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, self.vec_size, 360, self.vec_size / 20); 
  
  self.think = ai_turret_die_burn;
  self.ai_action_time = time + 360;
};

void() ai_turret_die_burn={  

  self.think = ai_turret_die_burn;
  self.nextthink = time + 0.1;
  
  if ( time > self.ai_action_time ){
   
    self.think = BecomeExplosion;
    self.nextthink = time + 0.01;
  }
};

/*
  macro rebuild
*/
void() ai_turret_patrol1;
void() ai_turret_patrol2;
void() ai_turret_patrol3;
void() ai_turret_patrol4;
void() ai_turret_patrol5;
void() ai_turret_patrol6;
void() ai_turret_patrol7;
void() ai_turret_patrol8;

void() ai_turret_fight_prep;

void() ai_turret_rotate1;
void() ai_turret_rotate2;
void() ai_turret_rotate3;
void() ai_turret_rotate4;
void() ai_turret_rotate5;
void() ai_turret_rotate6;
void() ai_turret_rotate7;
void() ai_turret_rotate8;

void() ai_turret_combat1;
void() ai_turret_combat2;
void() ai_turret_combat3;
void() ai_turret_combat4;
void() ai_turret_combat5;
void() ai_turret_combat6;

void() ai_turret_hunt1;
void() ai_turret_hunt2;
void() ai_turret_hunt3;
void() ai_turret_hunt4;
void() ai_turret_hunt5;
void() ai_turret_hunt6;
void() ai_turret_hunt7;
void() ai_turret_hunt8;
void() ai_turret_hunt9;
void() ai_turret_hunt10;

void() ai_turret_idle1;
void() ai_turret_idle2;
void() ai_turret_idle3;
void() ai_turret_idle4;
void() ai_turret_idle5;
void() ai_turret_idle6;
void() ai_turret_idle7;
void() ai_turret_idle8;
void() ai_turret_idle9;
void() ai_turret_idle10;
void( entity attacker ) ai_turret_react1;
void() ai_turret_react2;

void() ai_turret_patrol1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.torsoCenter.ai_dir = (random() * self.ai_angleLimits_x) * -1;
  self.torsoCenter.ai_dir = self.torsoCenter.ai_dir + self.ai_angleLimits_y;
  self.torsoCenter.ai_dir = self.torsoCenter.ai_dir * crandom();
  self.torsoCenter.ai_dir = anglemod( self.torsoCenter.angles_y + self.torsoCenter.ai_dir);
  
  ai_turret_set_state(TR_YAW);
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol2)
};
void() ai_turret_patrol2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol3)
};
void() ai_turret_patrol3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol4)
};
void() ai_turret_patrol4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol5)
};
void() ai_turret_patrol5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol6)
};
void() ai_turret_patrol6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol7)
};
void() ai_turret_patrol7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  macro_ai_frame(ai_turret_patrol8)
};
void() ai_turret_patrol8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_scan(self.stat_rdr_mode) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  if( self.torsoCenter.angles_y != self.torsoCenter.ai_dir ){
    macro_ai_frame(ai_turret_patrol2)
    return;
  }
  
  if( self.ai_rank > AI_RANK_REG ){
    if( random() < 0.35 ){
      macro_ai_frame(ai_turret_idle1)
      return;
    }
  }
  if( random() < 0.5 ){
    macro_ai_frame(ai_turret_idle1)
    return;
  }
  
  macro_ai_frame(ai_turret_patrol1)
};

void() ai_turret_fight_prep={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_valid_target(self.enemy) ){
    self.ai_action_time = self.ai_action_mod;
    enemy_vis = ai_check_vis( self.enemy );
    enemy_range = ai_check_range( self.enemy );
    enemy_infront = ai_check_targ_infront( self.enemy, self.ai_fov, TRUE);
    
    if( enemy_vis == VIS_FRAC ){
      if( enemy_range <= self.ai_minrange ){
        if( enemy_infront ){
          macro_ai_frame(ai_turret_combat1)
          return;
        }
        macro_ai_update(ai_turret_rotate1)
        return;
      }
      if( enemy_range > self.ai_minrange ){
        macro_ai_update(ai_turret_rotate1)
        return;
      }
    }
    if( enemy_vis == VIS_FRN ){
      macro_ai_update(ai_turret_rotate1)
      return;
    }
    if( enemy_vis == VIS_FAIL ){
      if( enemy_range >= AI_RANGE_L ){
        self.enemy = world;
        macro_ai_frame(ai_turret_patrol1)
        return;
      }
      ai_turret_set_state( TR_YAW );
      self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.origin );
      ai_sfx_huntStart();
      macro_ai_frame(ai_turret_hunt1)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_idle1)
};

/*
  Rotate
  turret merely rotates to track target
*/
void() ai_turret_rotate1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  ai_turret_set_state(TR_TARG);
   
  ai_attack();
  
  macro_ai_frame(ai_turret_rotate2)
};
void() ai_turret_rotate2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
 
  macro_ai_frame(ai_turret_rotate3)
};
void() ai_turret_rotate3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  macro_ai_frame(ai_turret_rotate4)
};
void() ai_turret_rotate4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
   
  ai_attack();

  macro_ai_frame(ai_turret_rotate5)
};
void() ai_turret_rotate5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  macro_ai_frame(ai_turret_rotate6)
};
void() ai_turret_rotate6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_rotate7)
};
void() ai_turret_rotate7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
   
  ai_attack();
  
  macro_ai_frame(ai_turret_rotate8)
};
void() ai_turret_rotate8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_turret_fight_prep)
};

/*
  Combat - turret fires at target
*/
void() ai_turret_combat1={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  ai_turret_set_state(TR_TARG);
  ai_attack();
  
  macro_ai_frame(ai_turret_combat2)
};
void() ai_turret_combat2={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_turret_combat3)
};
void() ai_turret_combat3={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_combat4)
};
void() ai_turret_combat4={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_combat5)
};
void() ai_turret_combat5={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)

  ai_attack();
  
  macro_ai_frame(ai_turret_combat6)
};
void() ai_turret_combat6={
  ai_update_accuracy( FALSE );
  macro_ai_update(ctrl_updateTank)

  if( self.ai_rank > AI_RANK_REG ){
    ai_attack();
  }
  
  macro_ai_frame(ai_turret_fight_prep)
};

void() ai_turret_hunt1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_vis(self.enemy) != VIS_FAIL ){
    ai_turret_set_state(TR_TARG);
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_hunt2)
};
void() ai_turret_hunt2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis(self.enemy) != VIS_FAIL ){
      ai_turret_set_state(TR_TARG);
      macro_ai_frame(ai_turret_fight_prep)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_hunt3)
};
void() ai_turret_hunt3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_vis(self.enemy) != VIS_FAIL ){
    ai_turret_set_state(TR_TARG);
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }

  macro_ai_frame(ai_turret_hunt4)
};
void() ai_turret_hunt4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis(self.enemy) != VIS_FAIL ){
      ai_turret_set_state(TR_TARG);
      macro_ai_frame(ai_turret_fight_prep)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_hunt5)
};
void() ai_turret_hunt5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  if( ai_check_vis(self.enemy) != VIS_FAIL ){
    ai_turret_set_state(TR_TARG);
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_hunt6)
};
void() ai_turret_hunt6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis(self.enemy) != VIS_FAIL ){
      ai_turret_set_state(TR_TARG);
      macro_ai_frame(ai_turret_fight_prep)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_hunt7)
};
void() ai_turret_hunt7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_vis(self.enemy) != VIS_FAIL ){
    ai_turret_set_state(TR_TARG);
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }

  macro_ai_frame(ai_turret_hunt8)
};
void() ai_turret_hunt8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis(self.enemy) != VIS_FAIL ){
      ai_turret_set_state(TR_TARG);
      macro_ai_frame(ai_turret_fight_prep)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_hunt9)
};
void() ai_turret_hunt9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( ai_check_vis(self.enemy) != VIS_FAIL ){
    ai_turret_set_state(TR_TARG);
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_hunt10)
};
void() ai_turret_hunt10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( ai_check_vis(self.enemy) != VIS_FAIL ){
      ai_turret_set_state(TR_TARG);
      macro_ai_frame(ai_turret_fight_prep)
      return;
    }
  }
  
  macro_ai_frame_count(ai_turret_hunt1)
  
  self.enemy = world; //dumps target
  if( ai_valid_target( self.oldenemy ) ){
    self.enemy = self.oldenemy;
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  ai_turret_set_state(TR_NORM);
  macro_ai_frame(ai_turret_patrol1)
};

/*
  TH_REACT
    what to do when hit by fire
*/
void( entity attacker ) ai_turret_react1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float my_hp;
  local float enemy_hp, enemy_size;
  local float atk_hp, atk_size;

  //AI has taken friendly fire
  if( attacker.faction == self.faction ){
    return;
  }
 
  self.ai_react_buffer = time + self.ai_react_time;
  
  //AI currently has no target
  if( !self.enemy ){
    self.enemy = attacker;
    self.th_missile();
    return;
  }
  
  my_hp = util_getMechHpAverage(self);
  
  atk_hp = util_getMechHpAverage(attacker);
  atk_size = attacker.vec_size;
  
  if( self.enemy ){  
    if( ai_check_vis(attacker) == VIS_FAIL ){
      self.ai_react_buffer = time + self.ai_react_time;
      return;
    }
    if( (attacker.flags & FL_CLIENT) ){
      //prioritize players
      self.oldenemy = self.enemy;
      self.enemy = attacker;
      self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
      self.ai_react_buffer = time + self.ai_react_time * 3;
      macro_ai_frame(ai_turret_react2)
      return;
    }
    else{
      enemy_hp  = util_getMechHpAverage(self.enemy);
      enemy_size = self.enemy.vec_size;
      if( self.ai_rank > AI_RANK_REG ){
        if( atk_hp < enemy_hp ){
          //high rank turrets will attack weaker targets (the smart move)
          if( ai_check_face( attacker, self.ai_fov) ){
            self.oldenemy = self.enemy;
            self.enemy = attacker;
            self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
            self.ai_react_buffer = time + self.ai_react_time * 2;
            macro_ai_frame(ai_turret_react2)
            return;
          }
        }
        else if( atk_size > enemy_size ){
          if( atk_hp < enemy_hp ){
            if( ai_check_face(attacker, self.ai_fov) ){
              self.oldenemy = self.enemy;
              self.enemy = attacker;
              self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
              self.ai_react_buffer = time + self.ai_react_time * 2;
              ai_turret_set_state(TR_YAW);
              macro_ai_frame(ai_turret_react2)
              return;
            }
          }
        }
      }
      else{
        if( atk_size > enemy_size ){
          //lesser bots usually panic
          self.oldenemy = self.enemy;
          self.enemy = attacker;
          self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
          self.ai_react_buffer = time + self.ai_react_time;
          macro_ai_frame(ai_turret_react2)
          return;
        
        }
        else{
          if( ai_check_face(attacker, self.ai_fov) ){
            //lesser bots usually panic
            self.oldenemy = self.enemy;
            self.enemy = attacker;
            self.torsoCenter.ai_dir = vectoyaw( self.enemy.origin - self.torsoCenter.origin );
            self.ai_react_buffer = time + self.ai_react_time;
            macro_ai_frame(ai_turret_react2)
            return;
          }
        }
      }
    }
  }
};  
void() ai_turret_react2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  local float angHigh, angLow;
  angHigh = anglemod( self.torsoCenter.angles_y + 15 );
  angLow = anglemod( self.torsoCenter.angles_y - 15 );
  if( ai_check_face( self.enemy, self.ai_fov) ){
    macro_ai_frame(ai_turret_fight_prep)
    return;
  }
  
  macro_ai_frame(ai_turret_react2)
};

/*
  Turret idles by rotating to a random heading
*/
void() ai_turret_idle1={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  self.torsoCenter.ideal_yaw = anglemod( self.angles_y + (35 + (random() * 25) + (random() * 45)) * crandom() );
  ai_turret_set_state(TR_YAW);
  
  macro_ai_frame(ai_turret_idle2)
};
void() ai_turret_idle2={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  macro_ai_frame(ai_turret_idle3)
};
void() ai_turret_idle3={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  macro_ai_frame(ai_turret_idle4)
};
void() ai_turret_idle4={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_idle5)
};
void() ai_turret_idle5={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)

  macro_ai_frame(ai_turret_idle6)
};
void() ai_turret_idle6={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_idle7)
};
void() ai_turret_idle7={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_idle8)
};
void() ai_turret_idle8={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( random() < 0.33){
      macro_ai_frame(ai_turret_patrol1)
      return;
    }
  }
  
  macro_ai_frame(ai_turret_idle9)
};
void() ai_turret_idle9={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  if( self.ai_rank > AI_RANK_REG ){
    if( random() < 0.33){
      macro_ai_frame(ai_turret_patrol1)
      return;
    }
  }
  macro_ai_frame(ai_turret_idle10)
};
void() ai_turret_idle10={
  ai_update_accuracy( TRUE );
  macro_ai_update(ctrl_updateTank)
  
  macro_ai_frame(ai_turret_patrol1)
};

/*
  SPAWN
*/
void() ai_turret={
  
  ai_unit_ini_var();
  initialize_data_turret_( self.nextVecChoice );
  ai_pilot_ini_stats(self.ai_rank);
  ai_voice_ini( TRUE );
  
  trigger_event( self, trigOnSpawn); //event interface
  
  self.spreadDefault = ACCURACY_LOWTECH;

  self.th_stand = ai_turret_patrol1;
  self.th_walk = ai_turret_idle1;
  self.th_missile = ai_turret_fight_prep;
  self.th_react = ai_turret_react1;
  self.th_die = ai_turret_die;
  
  self.think = ai_turret_patrol1;
  self.nextthink = time + (random()*0.5); //spread out thinks
};