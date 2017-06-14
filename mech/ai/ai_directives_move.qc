/*
mech Mod
Date: 5/22/2017
Overview: next draft the ai
this one will focus on move to move
*/

//TODO - move this stuff to own file
void() ai_mech_update={
  local entity oself,wep_chain;
  
  ctrl_updateCenterTorso();
  
  if(self.e_legs){
    if(self.e_legs != world && oself.e_legs.owner == self){
      oself = self;
      self = oself.e_legs;
        ctrl_updateLegs();
      self = oself;
    }
  }
  wep_chain = self.w_slot;
  while(wep_chain){
    ctrl_wpn_think(wep_chain);
    wep_chain = wep_chain.w_slot;
  }
  
  if(self.ai_next_move == ai_move_stand){
    self.stat_spr_x = self.stat_spr_x - (self.conv_min_z / 100);
    if(self.stat_spr_x < self.conv_min_x){
      self.stat_spr_x =  self.conv_min_x;
    }
    self.stat_spr_y = self.stat_spr_y - (self.conv_min_z  / 100);
    if(self.stat_spr_y < self.conv_min_y){
      self.stat_spr_y =  self.conv_min_y;
    }
  }
  else{
    self.stat_spr_x = self.stat_spr_x + (self.conv_max_z * 10);
    if(self.stat_spr_x > self.conv_max_x){
      self.stat_spr_x =  self.conv_max_x;
    }
    self.stat_spr_y = self.stat_spr_y + (self.conv_max_z * 10);
    if(self.stat_spr_y > self.conv_max_y){
      self.stat_spr_y =  self.conv_max_y;
    }
  }
    
  if(self.enemy != world){
    self.stat_trg_dist = vlen(self.enemy.origin - self.origin);
  }
};

void() ai_mech_attack={
  local entity ai, wep_chain, oself;
  local float dist;
  ai = self;
  wep_chain = self.w_slot;
  while(wep_chain){
    local float fire;
    fire = FALSE;
    if((self.stat_trg_dist <= wep_chain.w_range) && (wep_chain.w_isburst == FALSE)){
      fire = TRUE;
    }
    else if(wep_chain.w_isburst == TRUE) {
      fire =  TRUE;
    }
    if(fire){
      if((wep_chain.p_dmgtype & DMG_ENE)){
        ai_attack_ene(wep_chain);
      }
      else if((wep_chain.p_dmgtype & DMG_BAL)){
        ai_attack_bal(wep_chain);
      }
      else if((wep_chain.p_dmgtype & DMG_EXP)){
        ai_attack_exp(wep_chain);
      }
      else{
        ai_attack_basic(wep_chain);
      }
    }
    wep_chain = wep_chain.w_slot;
  }
};
void(entity wep) ai_attack_basic={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;

  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};

void(entity wep) ai_attack_ene={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;

  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if((wep.p_dmgtype & EFF_STX)){
    if(self.enemy.sh_cur >= (self.enemy.sh_max/4)){
      attack = TRUE;
    }
    else{
      attack = FALSE; //cancel attack regardless of weapon state
    }
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};

void(entity wep) ai_attack_bal={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;
  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;  
};
void(entity wep) ai_attack_exp={
  local float attack;
  local entity oself;
  oself = self;
  attack = FALSE;
  if(wep.w_state == READY){
    if((wep.w_currentammo > 0) && (wep.w_currentammo < 2)){
      attack = TRUE;
    }
    else{
      attack = TRUE;
    }   
  }
  if((wep.p_dmgtype & DMG_EXP)){
    if(self.enemy.sh_cur >= (self.enemy.sh_max/5)){
      attack = TRUE;
    }
    else{
      attack = FALSE; //cancel attack regardless of weapon state
    }
  }
  if(wep.w_isburst == TRUE){
    attack = TRUE;
  }
  if(attack){
    self = wep;
    self.w_attack();
  }
  self = oself;
};


void() ai_mech_die={
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
  
  ctor_die1();
  
  self.think = ai_mech_cleanup;
  self.nextthink = time + 0.0001;
};

void() ai_mech_cleanup={
  mech_cleanupMech();
};

void() ai_mech_touch={
  local entity oact;
  if((other.owner.flags & FL_MONSTER)){
    oact = other.owner;
  }
  else if((other.owner.flags & FL_CLIENT)){
    oact = other.owner;
  }
  else{
    oact = other;
  }
  local float infront;
  infront = ai_target_infront(other);
  //bumped an ally!
  if(other.i_faction == self.i_faction){
    if(infront){
      self.ai_next_move = ai_move_backward;
      return;
    }
    else{
      self.ai_next_move = ai_move_forward;
      return;
    } 
  }
  //bumped a baddy!
  else{
    if(other.p_class == P_MECH){
      if(self.enemy == world){
        self.enemy = other;
      }
      else{
        self.oldenemy = self.enemy;
        self.enemy = other;
      }
    }
    if(infront){
      self.ai_next_move = ai_move_run_slide;
      return;
    }
    else{
      self.ai_next_move = ai_move_backward;
      return;
    } 
  }
};


//this is run after the unit spawns in
void() ai_spawn_start={
  if(self.target){
    self.goalentity = find(world, targetname, self.target);
  }
};

void() ai_control={
  if(self.deadflag >= DEAD_DYING){
    self.health = 0;
    self.th_die();
    return;
  }
  self.ai_unit_update();
  if(self.health <= (self.max_health /3)){
    if(self.en_cur <= 0){
      if(self.ai_next_state != ai_state_panic){
        self.ai_next_state =ai_state_panic;
      } 
    }
  }
  if(self.ai_patience > 5){
    if(self.enemy != world){
      if(ai_core_findtarget()){
        self.ai_next_state = ai_state_hunt;
      }
      else{
        self.ai_next_move = ai_move_backward;
      }
    }
    else{
      self.ai_next_move = ai_move_backward;
    }
    self.ai_patience = 0;
  }
  self.ai_next_state();
  self.ai_next_move();
  self.think = ai_control;
  self.nextthink = time + 0.05;
  self.e_cam.SendFlags = 1;
};

//move directives
void() ai_move_stand={
  self.ai_prev_move = ai_move_stand;
  if(ai_core_targetstate()){
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  }
};

void() ai_move_walk={
  self.ai_prev_move = ai_move_walk;
  self.e_legs.angles_y = self.ideal_yaw;
  ChangeYaw();
  movetogoal(self.m_fspeed / 50);
};

void() ai_mive_walk_slide={
  self.ai_prev_move = ai_mive_walk_slide;
  local float ofs;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  ChangeYaw();
  	if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_fspeed / 50)){
    self.e_legs.angles_y = self.ideal_yaw + ofs;
		return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_fspeed / 50);
  self.e_legs.angles_y = self.ideal_yaw;
};

void() ai_move_run={  
  self.ai_prev_move = ai_move_run;
  movetogoal(self.m_fspeed / 25);
  self.e_legs.angles_y = self.ideal_yaw;
};

void() ai_move_run_slide={  
  self.ai_prev_move = ai_move_run_slide;
  local float ofs;
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  ChangeYaw();
  	if (self.lefty){
		ofs = 90;
	}
  else{
		ofs = -90;
	}
	if (walkmove (self.ideal_yaw + ofs,  self.m_fspeed / 25)){
      self.e_legs.angles_y = self.ideal_yaw + ofs;
		return;
  }
	self.lefty = 1 - self.lefty;
  walkmove( self.ideal_yaw, self.m_fspeed / 25);
  self.e_legs.angles_y = self.ideal_yaw;
};

void() ai_move_forward={  
  self.ai_prev_move = ai_move_forward;
  self.e_legs.angles_y = self.angles_y;
  walkmove (self.angles_y, self.m_fspeed / 50);
};

void() ai_move_backward={  
  self.ai_prev_move = ai_move_backward;
  self.e_legs.angles_y = self.angles_y + 180;
  walkmove ((self.angles_y+180), self.m_fspeed / 50);
};

