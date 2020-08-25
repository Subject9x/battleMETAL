/*
battleMETAL
Author: Peter Roohr
Date: 8/24/2020
Overview: 
  synchronizing leg models to the client
*/



void() predraw_legs={
  local float savedang;
  local float dir;
  
  if(self.legs == world){
    return;
  }
  
  if (self.legs.nextthink != self.frame1time)
  {
    self.legs.frame2time = self.legs.frame1time;
    self.legs.frame1time = self.legs.nextthink;
    self.legs.frame2 = self.legs.frame1;
    self.legs.frame1 = self.legs.frame;
    self.legs.origin2 = self.legs.origin1;
    self.legs.origin1 = self.legs.origin;
    self.legs.angle2 = self.legs.angle1;
    self.angle1 = self.legs.angles_y;
  }
  self.legs.lerpfrac = (time - self.legs.frame2time) / max(self.legs.frame1time-self.legs.frame2time, 1);
  self.legs.lerpfrac = 1-bound(0, self.legs.lerpfrac, 1);
  
  savedang = self.legs.angles_y;
  dir = (self.legs.angle2-self.legs.angle1);
  if (dir > 180){
    dir -= 360;
  }
  else if (dir < -180){
    dir += 360;
  }
  self.legs.angles_y = self.legs.angle1 + dir*self.legs.lerpfrac;
  self.angle1 = self.angles_y;
  self.legs.angles_y = self.legDir;
  
};

/*
  Client Leg Animations - Stand
*/
void() leg_stand1={
  self.frame = $l_stand1;
  self.think = leg_stand1;
  self.nextthink = time + 0.1;
};

/*
  Client Leg Animations - Forward
*/
void() leg_walk1 ={
  cons_logAFloat("leg_walk1", 1); //debug
  self.frame = $l_walk1;
  self.think = leg_walk2;
  self.nextthink = time + 0.1; 
  
  if( self.owner.moveState > 0 ){
    self.think = leg_run2;
  }

};
void() leg_walk2 ={
  self.frame = $l_walk2;
  self.think = leg_walk3;
  self.nextthink = time + 0.1; 
  if( self.owner.moveState > 0 ){
    self.think = leg_run2;
  }
};
void() leg_walk3 ={
  self.frame = $l_walk3; 
  self.think = leg_walk4;
  self.nextthink = time + 0.1; 
  if( self.owner.moveState > 0 ){
    self.think = leg_run2;
  }
};

void() leg_walk4 ={
  self.frame = $l_walk4; 
  self.think = leg_walk5;
  self.nextthink = time + 0.1; 
  if( self.owner.moveState > 0 ){
    self.think = leg_run3;
  }
};

void() leg_walk5 ={
  self.frame = $l_walk5; 
  self.think = leg_walk6;
  self.nextthink = time + 0.1; 
  if( self.owner.moveState > 0 ){
    self.think = leg_run3;
  }
};

void() leg_walk6 ={
  self.frame = $l_walk6;
  self.think = leg_walk7;
  self.nextthink = time + 0.1; 
  //te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
  if( self.owner.moveState > 0 ){
    self.think = leg_run3;
  }
};

void() leg_walk7 ={
  self.frame = $l_walk7; 
  self.think = leg_walk8;
  self.nextthink = time + 0.1;
  if( self.owner.moveState > 0 ){
    self.think = leg_run4;
  }
};

void() leg_walk8 ={
  self.frame = $l_walk8; 
  self.think = leg_walk1;
  self.nextthink = time + 0.1;
  if( self.owner.moveState > 0 ){
    self.think = leg_run4;
  }
};

/*
  Client Leg Animations - Run
*/

void() leg_run1 = [$l_walk2, leg_run2]{
  self.frame = $l_walk2; 
  if( self.owner.moveState == 0 ){
    self.think = leg_walk3;
  }
};
void() leg_run2 = [$l_walk4, leg_run3]{
  self.frame = $l_walk4; 
  if( self.owner.moveState == 0 ){
    self.think = leg_walk5;
  }
};
void() leg_run3 = [$l_walk6, leg_run4]{
  self.frame = $l_walk6; 
  //te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
  if( self.owner.moveState == 0 ){
    self.think = leg_walk7;
  }
};
void() leg_run4 = [$l_walk7, leg_run5]{
  self.frame = $l_walk8; 
  if( self.owner.moveState == 0 ){
    self.think = leg_walk1;
  }
};
void() leg_run5 = [$l_walk8, leg_run1]{
  self.frame = $l_walk8; 
  if( self.owner.moveState == 0 ){
    self.think = leg_walk1;
  }
};

/*
  Client Leg Animations - Backward
*/

void() leg_back1=[$l_walk1, leg_back8]{
  self.frame = $l_walk1;
};

void() leg_back2=[$l_walk2, leg_back1]{
  self.frame = $l_walk2;
};

void() leg_back3=[$l_walk3, leg_back2]{
  self.frame = $l_walk3;
};

void() leg_back4=[$l_walk4, leg_back3]{
  self.frame = $l_walk4;
};

void() leg_back5=[$l_walk5, leg_back4]{
  self.frame = $l_walk5;
};

void() leg_back6=[$l_walk6, leg_back5]{
  self.frame = $l_walk6;
  //te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, TRUE);
};

void() leg_back7=[$l_walk7, leg_back6]{
  self.frame = $l_walk7;

};

void() leg_back8=[$l_walk8, leg_back7]{
  self.frame = $l_walk8;
  //te_foot_stomp( self.owner.origin, self.owner.angles, self.owner.vec_size, self.owner.mins, FALSE);
};

void() leg_die1={
  self.frame = 5;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.think = SUB_Remove;
  self.nextthink = time + 3600;
};
