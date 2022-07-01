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
  local float prevDir;
  local vector adj, nextDirs;
  local float playerDir, velDir, left, right;
  
  prevDir = self.legDir;
  if( self.movement_x == 0 && self.movement_y == 0 ){
    if( self.legDir != 0 ){
      self.legDir = 0;  // animation switch -> 'stand'
    }
  }
  else{
    velDir = vectoyaw( self.movement );
    playerDir = vectoyaw( self.v_angle );
    velDir = anglemod( playerDir - velDir);
    right = anglemod( playerDir + 90 );
    left = anglemod( playerDir - 90 );
    nextDirs = vectoangles(self.movement);
    if( (velDir >= left) || (velDir <= right) ){
      nextDirs_y = anglemod( nextDirs_y + 180) * -1;
      self.legDir = 1; // animation switch -> 'forward'
    }
    else{
      nextDirs_y = anglemod(nextDirs_y * -1);
      self.legDir = -1; // animation switch -> 'reverse'
    }
    self.legs_angl_y = nextDirs_y;
  }
};