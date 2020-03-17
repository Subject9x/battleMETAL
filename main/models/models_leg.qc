/*
battleMETAL
Author: Peter Roohr
Date: 9/22/2016
Refactor: 12/29/2018
Overview: 
  old - test animation harness
  
  worked out animation frame binding for leg models.
  the leg entities execute the frame macros, whereas leg-state is handled by the controller functions ( ctrl_updateLegs )
*/

/*
  Leg animation state controller.
  uses FrameStart / end to track between animation groups
*/
void( entity unitLegs ) anim_leg_control={
  //TODO?
};
/*
  Client Leg Animations - Stand
*/
void() leg_stand1= [$l_stand1, leg_stand1]{
  self.frame = $l_stand1;
};

/*
  Client Leg Animations - Forward
*/
void() leg_walk1 = [$l_walk1, leg_walk2]{
  self.walkframe = $l_walk1; 

};

void() leg_walk2 = [$l_walk2, leg_walk3]{
  self.walkframe = $l_walk2;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, FALSE);
};
void() leg_walk3 = [$l_walk3, leg_walk4]{
  self.walkframe = $l_walk3; 
};

void() leg_walk4 = [$l_walk4, leg_walk5]{
  self.walkframe = $l_walk4; 
};

void() leg_walk5 = [$l_walk5, leg_walk6]{
  self.walkframe = $l_walk5; 
};

void() leg_walk6 = [$l_walk6, leg_walk7]{
  self.walkframe = $l_walk6; 
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
};

void() leg_walk7 = [$l_walk7, leg_walk8]{
  self.walkframe = $l_walk7; 
};

void() leg_walk8 = [$l_walk8, leg_walk1]{
  self.walkframe = $l_walk8; 
};

/*
  Client Leg Animations - Backward
*/

void() leg_back1=[$l_walk1, leg_back8]{
  self.walkframe = $l_walk1;
};

void() leg_back2=[$l_walk2, leg_back1]{
  self.walkframe = $l_walk2;
};

void() leg_back3=[$l_walk3, leg_back2]{
  self.walkframe = $l_walk3;
};

void() leg_back4=[$l_walk4, leg_back3]{
  self.walkframe = $l_walk4;
};

void() leg_back5=[$l_walk5, leg_back4]{
  self.walkframe = $l_walk5;
};

void() leg_back6=[$l_walk6, leg_back5]{
  self.walkframe = $l_walk6;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
};

void() leg_back7=[$l_walk7, leg_back6]{
  self.walkframe = $l_walk7;

};

void() leg_back8=[$l_walk8, leg_back7]{
  self.walkframe = $l_walk8;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, FALSE);
};


void() leg_die1 = [$l_die1, leg_die2]{
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
};
void() leg_die2 = [$l_die2, leg_die3]{};
void() leg_die3 = [$l_die3, leg_die4]{};
void() leg_die4 = [$l_die4, leg_die4]{
  
  self.deadflag = DEAD_DEAD;
  self.think = SUB_Remove;
  self.nextthink = time + 100;
};

/*
  AI Leg Animations;
  this saves on a constant FL_CLIENT check
*/
void() bot_leg_stand1 = [$l_stand1, bot_leg_stand1]{
  self.frame = $l_stand1;
};

void() bot_leg_walk1 = [$l_walk1, bot_leg_walk2]{
  self.frame = $l_walk1;
};

void() bot_leg_walk2 = [$l_walk2, bot_leg_walk3]{
  self.frame = $l_walk2;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
};
void() bot_leg_walk3 = [$l_walk3, bot_leg_walk4]{
  self.frame = $l_walk3; 
};
void() bot_leg_walk4 = [$l_walk4, bot_leg_walk5]{
  self.frame = $l_walk4; 
};
void() bot_leg_walk5 = [$l_walk5, bot_leg_walk6]{
  self.frame = $l_walk5; 
};
void() bot_leg_walk6 = [$l_walk6, bot_leg_walk7]{
  self.frame = $l_walk6;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, FALSE);
};
void() bot_leg_walk7 = [$l_walk7, bot_leg_walk8]{
  self.frame = $l_walk7;
};
void() bot_leg_walk8 = [$l_walk8, bot_leg_walk1]{
  self.frame = $l_walk8;
};

void() bot_leg_back1 = [$l_walk1, bot_leg_back8]{
  self.frame = $l_walk1;
};
void() bot_leg_back2 = [$l_walk2, bot_leg_back1]{
  self.frame = $l_walk2;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, FALSE);
};
void() bot_leg_back3 = [$l_walk3, bot_leg_back2]{
  self.frame = $l_walk3; 
};
void() bot_leg_back4 = [$l_walk4, bot_leg_back3]{
  self.frame = $l_walk4; 
};
void() bot_leg_back5 = [$l_walk5, bot_leg_back4]{
  self.frame = $l_walk5; 
};
void() bot_leg_back6 = [$l_walk6, bot_leg_back5]{
  self.frame = $l_walk6;
  te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
};
void() bot_leg_back7 = [$l_walk7, bot_leg_back6]{
  self.frame = $l_walk7;
};
void() bot_leg_back8 = [$l_walk8, bot_leg_back7]{
  self.frame = $l_walk8;
};

void() bot_leg_pivot1 = [$l_walk7, bot_leg_pivot2]{
  self.frame = $l_walk7;
};
void() bot_leg_pivot2 = [$l_walk6, bot_leg_pivot3]{
  self.frame = $l_walk6;
};
void() bot_leg_pivot3 = [$l_walk5, bot_leg_pivot4]{
  self.frame = $l_walk5;
};
void() bot_leg_pivot4 = [$l_walk4, bot_leg_pivot5]{
  self.frame = $l_walk4;
};
void() bot_leg_pivot5 = [$l_walk3, bot_leg_pivot6]{
  self.frame = $l_walk3;
};
void() bot_leg_pivot6 = [$l_walk2, bot_leg_pivot7]{
  self.frame = $l_walk2;
};
void() bot_leg_pivot7 = [$l_walk3, bot_leg_pivot8]{
  self.frame = $l_walk3;
};
void() bot_leg_pivot8 = [$l_walk4, bot_leg_pivot9]{
  self.frame = $l_walk4;
};
void() bot_leg_pivot9 = [$l_walk5 bot_leg_pivot10]{
  self.frame = $l_walk5;
};
void() bot_leg_pivot10 = [$l_walk6, bot_leg_pivot11]{
  self.frame = $l_walk6;
};
void() bot_leg_pivot11 = [$l_walk7, bot_leg_pivot1]{
  self.frame = $l_walk7;
};


void() leg_die_touch={
  if( other == world || other.classname == "map_terrain_model" ){
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    return;
  }
  if( other.vec_size ){
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.think = BecomeExplosion;
    self.nextthink = time + 0.1;
    return;
  }
};
/*
  Bot Leg death frames
*/
void() bot_leg_die1={
  self.mins = self.mins * 0.67;
  self.mins_z = self.mins_z / 4;
  self.maxs = self.maxs * 0.67;
  self.maxs_z = self.mins_z / -4;
  
  self.frame = 1;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  self.think = bot_leg_die2;
  self.nextthink = time + 0.1;
};
void() bot_leg_die2={
  self.frame = rint(1 + random() * 3);
  
  local vector fall;
  makevectors(self.angles);
  fall = self.origin + (v_forward * (crandom() * 256)) + (v_right * (crandom() * 256)) + (v_up * 128);
  self.velocity =  normalize(self.origin - fall);
  self.avelocity = self.velocity * 2;
  self.movetype = MOVETYPE_BOUNCE;
  self.solid = SOLID_BBOX;
  self.think = bot_leg_die3;
  self.nextthink = time + 2;
};
void() bot_leg_die3={
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  setsize(self, '-4 -4 -4', '4 4 4');
  setorigin(self, self.origin);
  self.deadflag = DEAD_DEAD;
  self.think = SUB_Remove;
  self.nextthink = time + 7200;
  //TODO - fixme
  /*makevectors(self.angles);
  switch( self.vec_size ){
    case 2:
      te_med_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, rint(self.vec_size / 2), 3800, self.vec_size / 20, 4800); 
      break;
    case 3:
      te_big_flame_start( self.origin + (v_up * (self.maxs_y / 2)), self.angles, rint(self.vec_size / 2), 3800, self.vec_size / 20, 4800); 
      break;
    default:
      te_small_flame_start( self.origin + (v_up * (self.maxs_y /2)), self.angles, rint(self.vec_size / 2), 3800, self.vec_size / 20, 4800); 
      break;
  }*/
};

void() player_movestart =
{
  self.walkframe = 0;
  if(self.owner.velocity_x || self.owner.velocity_y){
    leg_walk1(); 
  }else{
    leg_stand1();
  }
};