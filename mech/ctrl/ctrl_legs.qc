/*
battleMETAL
Author: Peter Roohr
Date: 9/6/2016
mod - 5/10/2017 - added terrain check
mod - 03/08/2019 - modding some death logic

Overview: 
  main controller functions for mech leg entities
*/

void() ctrl_updateLegs={
  local vector adj, nextDirs;
  local float playerDir, velDir, left, right;
  
  if((self.owner.movement_x == 0) && (self.owner.movement_y == 0)){
    self.movetype = MOVETYPE_NONE;
    makevectors(self.owner.angles);
    adj = self.owner.origin + (v_up * self.c_ofs_y) + (v_right * self.c_ofs_x) + (v_forward * self.c_ofs_z);
    setorigin(self, adj);
    if( self.ai_dir != 0 ){
      self.ai_dir = 0;  // animation switch -> 'stand'
      leg_stand1();
      return;
    }
  }
  else{
    if(self.movetype != MOVETYPE_FOLLOW){
      self.movetype = MOVETYPE_FOLLOW;
    }
    velDir = vectoyaw( self.owner.movement );
    playerDir = vectoyaw( self.owner.v_angle );
    velDir = anglemod( playerDir - velDir);
    right = anglemod( playerDir + 90 );
    left = anglemod( playerDir - 90 );
    nextDirs = vectoangles(self.owner.movement);

    if( (velDir >= left) || (velDir <= right) ){
      nextDirs_y = nextDirs_y * -1;
      if( self.ai_dir != 1 ){
        self.ai_dir = 1; // animation switch -> 'forward'
        leg_walk5();
      }
    }
    else{
      nextDirs_y = anglemod( nextDirs_y + 180) * -1;
      if( self.ai_dir != -1 ){
        self.ai_dir = -1; // animation switch -> 'reverse'
        leg_back4();
      }
    }
    
    self.angles =  nextDirs;
    self.v_angle = self.angles;
  }
};


void() ctrl_dieLegs={
  local entity this;
  newmis = spawn();
  this = self;
    local vector v1, v2;
    local float f1, f2, f3;
    v1 = this.owner.mins;
    v2 = this.owner.maxs;
    v1_z = v1_z - (v1_z / 2);
    v2_z = v2_z - (v2_z / 2);
    v1_x = v1_y = v1_x - (v1_x / 2);
    v2_x = v2_y = v2_x - (v2_x / 2);
    setsize(self, v1, v2);
    setmodel(self, this.model);
    setorigin(self, this.origin);
    self.frame = this.walkframe;
    self.touch = touch_mechPiece;
    leg_die1();
  self = this;
};
