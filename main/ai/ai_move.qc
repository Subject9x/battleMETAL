/*
battleMETAL 
Author: Peter Roohr
Date: 06/30/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over.
*/
/*
===================================================
  AI MOVEMENTS
  I've decided to completely standardize ALL AI movement into a select list of generic possible actions.
    It is up to each bot to determine HOW LONG they will execute a maneuver, and WHEN they will do so,
    but the maneuvers themselves will be described here. 
    
    Movements are chosen by setting .ai_move_next INSIDE any [ST_COM_MOVE_START] state calls.
    these functions are then chosen be a switch-case() operation in ai_combat_move_frame().
    
    Each move will require some inputs for the 'setup' and some will access ai_dampen for simulating velocity.
    Each movement function has a 'header' / 'setup' by comparing current ai_move against ai_move_last.
===================================================
*/
/*
  MOVE-STAND
    AI stands in place, tracking target as needed.
*/
void() ai_move_stand={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    if(self.data_type == DATA_MECH){
      cons_logAFloat("---------NEW MOVE STAND", -1); //debug
    }
    self.ai_movewait = time + self.ai_movedist;
    if(self.legs){
      self.legs.attack_state = TR_YAW;
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    ai_face_targ();
    ai_attack();
    return;
  }
  ai_face_targ();
  ai_attack();
};

/*
  MOVE-CHARGE
    AI charges forwar at target, maintaining direction TO target
*/
float() ai_move_charge={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = self.data_speed_forward;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 10;
    ai_angle = self.angles;
    self.ideal_yaw = self.angles_y;
    if( ai_check_face( self.enemy, 0.85, FALSE) ){
      self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
      ai_angle_y = self.ai_dir;
      self.ideal_yaw = self.ai_dir;
    }
    
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  ChangeYaw();
  
  status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );

  ai_attack();
  return status;
};

/*
  MOVE-CHARGE/LEFT
    AI charges at target but along angle (A)
*/
float() ai_move_charge_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir + 45);
  
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  yawCache = self.yaw_speed;
  self.yaw_speed = yawCache * 2;
  ChangeYaw();
  self.yaw_speed = yawCache;
  status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );
  
  ai_attack();
  return status;
};

/*
  MOVE-CHARGE/RIGHT
    AI charges at target but along angle (A)
*/
float() ai_move_charge_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir - 45);
  
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = self.ai_dir;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  yawCache = self.yaw_speed;
  self.yaw_speed = yawCache * 2;
  ChangeYaw();
  self.yaw_speed = yawCache;
  
  status = walkmove( self.angles_y, self.ai_wishSpeed * self.ai_dampen );
  
  ai_attack();
  return status;
};


/*
  MOVE-STRAFE/LEFT
    AI moves at a 85-110 deg perpendicular angle(initially)  to the target, and does not rotate to track target.
*/
float() ai_move_strafe_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y + 90);
    self.ai_wishSpeed = self.data_speed_strafe;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.ai_dir = self.ai_dir;
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  yawCache = self.yaw_speed;
  self.yaw_speed = yawCache * 3;
  ChangeYaw();
  self.yaw_speed = yawCache;
  
  status = walkmove( self.ai_dir, (self.data_speed_strafe * self.ai_dampen) );
  
  ai_attack();
  return status;
};
/*
  MOVE-STRAFE/RIGHT
    AI moves at a 85-110 deg perpendicular angle(initially)  to the target, and does not rotate to track target.
*/
float() ai_move_strafe_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y - 90);
    self.ai_wishSpeed = self.data_speed_strafe;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.ai_dir = self.ai_dir;
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  yawCache = self.yaw_speed;
  self.yaw_speed = yawCache * 3;
  ChangeYaw();
  self.yaw_speed = yawCache;
    
  status = walkmove( self.ai_dir, self.data_speed_strafe * self.ai_dampen);
  
  ai_attack();
  return status;
};

/*
  MOVE-CIRCLE/LEFT
    AI moves in an oblique direction to target, using target-facing angle a it moves, 'circle-strafing' essentially.
*/
float() ai_move_circle_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir + 70);
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.legs ){
    self.legs.ai_dir = self.ai_dir;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  ChangeYaw();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );

  ai_attack();
  return status;
};
/*
  MOVE-CIRCLE/right
    AI moves in an oblique direction to target, using target-facing angle a it moves, 'circle-strafing' essentially.
*/
float() ai_move_circle_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = vectoyaw(self.enemy.origin - self.origin);
    self.ai_dir = anglemod(self.ai_dir - 70);
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }
  if( self.legs ){
    self.legs.ai_dir = self.ai_dir;
  }
  if( self.ai_dampen < 1.0 ){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  
  ChangeYaw();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  
  ai_attack();
  return status;
};


/*
  MOVE-BACK
    AI moves straight back along move-starting angle.
*/
float() ai_move_back={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dir = anglemod(self.angles_y - 180);
    self.ai_wishSpeed = self.data_speed_backward;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  ai_attack();
  ChangeYaw();
  status = walkmove( self.ai_dir,  self.ai_wishSpeed * self.ai_dampen  );
  return status;
};
/*
  MOVE-BACK/LEFT
    AI moves straight back along move-starting angle.
*/
float() ai_move_back_left={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) / 2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    self.ai_dir = self.angles_y - 180;
    self.ai_dir = self.ai_dir + (25 + (random() * 35));
    self.ai_dir = anglemod(self.ai_dir);
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
    
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + status;
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  ai_attack();
  ChangeYaw();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  return status;
};
/*
  MOVE-BACK/RIGHT
    AI moves straight back along move-starting angle.
*/
float() ai_move_back_right={
  local float status;
  status = TRUE;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_wishSpeed = (self.data_speed_forward + self.data_speed_strafe) /2;
    self.ai_movedist = (self.ai_movedist * self.ai_wishSpeed) * 25;
    self.ai_dir = self.angles_y - 180;
    self.ai_dir = self.ai_dir - (25 + (random() * 35));
    self.ai_dir = anglemod(self.ai_dir);
    ai_angle = self.angles;
    ai_angle_y = self.ai_dir;
    makevectors(ai_angle);
    status = ai_calc_move(self.origin + (v_forward * self.ai_movedist), self.ai_wishSpeed);
     
    if( status <= 0.1 ){
      return FALSE;
    }
    self.ai_movewait = time + (status * 0.5);
    self.ideal_yaw = self.ai_dir;
    
    if( self.legs ){
      self.legs.attack_state = TR_TARG;
      self.legs.ai_dir = anglemod(self.ai_dir + 180);
      self.legs.think = bot_leg_back1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return TRUE;
  }  
  if( self.ai_dampen < 1.0){
    self.ai_dampen = self.ai_dampen + self.data_speed_accel;
  }
  ai_attack();
  ChangeYaw();
  status = walkmove( self.ai_dir, self.ai_wishSpeed * self.ai_dampen );
  return status;
};

/*
  MOVE-SNAP-SHOT
    AI rotates at double its yaw_speed (calling ChangeYaw twice per frame)
    to quickly aim at its target.
*/
void() ai_move_snapshot={
  local entity that;
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  if(self.torsoCenter){
    that = self;
    self = that.torsoCenter;
      ChangeYaw();  //double the rotation rate on this move
    self = that;
  }
  ai_face_targ();//double the rotation rate on this move
  ai_face_targ();
  ai_attack();
};

/*
  MOVE-SNIPER SHOT
    AI remains stationary but charges up for a full, super accurate blast.
*/
void() ai_move_snipeshot={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){    
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  ai_face_targ();
  ai_attack();
};

/*
  MOVE-STAND-FACE
    AI remains stationary but turns whole body to face target.
*/
void() ai_move_standface={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_movewait = time + self.ai_movedist;
    if( self.legs ){
      self.legs.attack_state = TR_NORM;
      self.legs.ai_dir = anglemod(self.angles_y);
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    return;
  }
  ai_face_targ();
  ai_attack();
  if(self.data_type == DATA_MECH){
  
  }
};

/*
  Special move for AI that have a patrol route.
  If they're attacked on a patrol route, they first try to find the closest patrol node to their target.
  IF! this condition is true, they execute this particular maneuver to get closer to the enemy
  
  biggest difference between this and AI_PATROL_FRAME() is that the bot can track its target while
  moving to that node, and make attacks.
*/
float(float outRadius) ai_move_patrol_node={
  local entity nextNode;
  local float distLeft;
  local float walkSpeed, cornerSpeed;
  
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.patrolState = 0;
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.ai_dampen = 1;
    
    if( self.legs ){
      self.legs.attack_state = TR_GOAL;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    return -1;
  }
  walkSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 2;
  cornerSpeed = (self.data_speed_forward + self.data_speed_strafe ) / 3;
  
  self.lastorigin = self.origin;
  distLeft = vlen(self.tetherOrg - self.origin);
  //Going to node
  if( distLeft > outRadius ){
    ai_face_goal();
    if( (self.legs) ){
      self.legs.attack_state = TR_NORM;
    }
    if( ai_check_face(self.goalentity, 0.75, FALSE) ){
      if( !walkmove(self.angles_y, walkSpeed) ){
        movetogoal( walkSpeed );
      }
    }
    else{
      if( !walkmove(self.angles_y, cornerSpeed) ){
        movetogoal( cornerSpeed );
      }
    }
    ai_attack();
    return PATROL_WALKING;
  }

  return PATROL_ARRIVE;
};

void() ai_move_node_radius={
  local entity node;
  local float oldPatrolState;
  local float outRadius, innerRadius;
  
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.patrolState = 0;
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.ai_dampen = 1;
    
    if( self.legs ){
      self.legs.attack_state = TR_GOAL;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    self.ai_movewait = time + 15;
    return;
  }
  
  oldPatrolState = self.patrolState;
  ai_attack();
  outRadius = max(self.goalentity.ai_view * 0.95, AI_RANGE_S/2);
  self.patrolState = ai_move_patrol_node( outRadius );
  
  if( 0.85 >= ai_check_node_radius(self) ){
    self.ai_state_next = ST_COM_MOVE_END;
    return;
  }
  if( time > self.ai_movewait ){
    if( ai_blocked_teleport() ){
      if( self.patrolNode.classname == "ai_node" ){
        self.ai_state_next = ST_PTR;
        return;
      }
      self.ai_state_next = ST_THR;
      return;
    }
    self.ai_state_next = ST_STAND;
    return;
  }
};

/*
  AI has a patrol node and the target is closer to another node
*/
void() ai_move_node_tactical={
  local float oldPatrolState;
  local float enemyRad;
  local float myRad;
  local float outRad;
  
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.patrolState = 0;
    self.goalentity = self.patrolNode;
    self.tetherOrg = self.goalentity.origin;
    self.ai_dampen = 1;
    
    if( self.legs ){
      self.legs.attack_state = TR_GOAL;
      self.legs.think = bot_leg_walk1;
      self.legs.nextthink = time + 0.1;
    }
    self.ai_movewait = time + 15;
    return;
  }
  oldPatrolState = self.patrolState;
  ai_attack();
  self.patrolState = ai_move_patrol_node( self.goalentity.ai_view * 0.95 );
  
  if( 0.9 >= ai_check_node_radius(self) ){
    self.ai_state_next = ST_COM_MOVE_END;
    return;
  }
  if( time > self.ai_movewait ){
    if( ai_blocked_teleport() ){
      if( self.tetherStatus == TETHER_PATROL ){
        self.ai_state_next = ST_PTR;
        return;
      }
      self.ai_state_next = ST_THR;
      return;
    }
    if(self.enemy){
      self.ai_state_next = ST_COMBAT;
      return;
    }
    self.ai_state_next = ST_STAND;
    return;
  }
};

/*
  MOVE_END_PAUSE
    Automatically used at the end of any combat move that isn't
      + node radius things
      + any stand_ still move.
      
    this is to help reduce traffic jams AND give the player some chances for solid hits.
*/
void() ai_move_end_pause={
  if( self.ai_state == ST_COM_MOVE_START && self.ai_state_last != ST_COM_MOVE_START ){
    self.ai_dampen = 0;
    if( self.legs ){
      self.legs.ai_dir = self.angles_y;
      self.legs.attack_state = TR_YAW;
      self.legs.think = bot_leg_stand1;
      self.legs.nextthink = time + 0.1;
    }
    if( self.torsoCenter ){
      self.torsoCenter.attack_state = TR_TARG;
    }
    self.ai_movewait = time + self.ai_rank;
    return;
  }
  if( !self.legs ){
    ai_face_targ();
  }
  ai_attack();
  if(time > self.ai_movewait ){
    self.ai_state_next = ST_COMBAT;
  } 
};

/*
  Ported sv_playermovement.qc walking code over to this.
  UNUSED FOR NOW
*/
void() ai_move_physics={
	local vector wishvel, wishdir, v;
	local float wishspeed, f;
  local vector sprintMove;
  // walking
  makevectors(self.ideal_yaw * '0 1 0');
  if( self.button8 ){
    sprintMove = v_forward * (self.movement_x * self.data_speed_accel);
    sprintMove = sprintMove + v_right * (self.movement_y * self.data_speed_accel);
    wishvel = sprintMove;
  }
  else{
    wishvel = v_forward * self.movement_x + v_right * self.movement_y;
  }
  // friction
  if (self.velocity_x || self.velocity_y){
    v = self.velocity;
    v_z = 0;
    f = vlen(v);
    if (f < sv_stopspeed * 1.25){
      f = 1 - frametime * (sv_stopspeed / f) * ( sv_friction * 4);
    }
    else{
      f = 1 - frametime * (sv_friction* 4);
    }
    if (f > 0){
      self.velocity = self.velocity * f;
    }
    else{
      self.velocity = '0 0 0';
    }
  }
  // acceleration
  wishdir = normalize(wishvel);
  wishspeed = vlen(wishvel);
  //if (wishspeed > sv_maxspeed){
  //  wishspeed = sv_maxspeed;
  //}
  if (wishspeed > self.data_speed_forward){
    wishspeed = self.data_speed_forward;
  }
  
  if (time >= self.teleport_time){
    f = wishspeed - (self.velocity * wishdir);
    if (f > 0){
      self.velocity = self.velocity + wishdir * min(f, sv_accelerate * frametime * wishspeed);
    }
  }
};
