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
  //local float velDir, left, right;
  
  if( self.movement_x == 0 && self.movement_y == 0 ){
    self.legDir = LEGS_MOVE_STAND;  // animation switch -> 'stand'
  }
  else{
    self.legs_angl_y = vectoyaw( self.velocity );
    
    //outta time to really fix this one...<sigh>
    /*velDir = anglemod(self.v_angle_y - self.legs_angl_y);
    
    right = anglemod(self.v_angle_y + 90);
    left = anglemod(self.v_angle_y - 90);
    
    if( (self.legs_angl_y < left) && (self.legs_angl_y > right) ){
      self.legDir = LEGS_MOVE_BACK; // animation switch -> 'reverse'
    }
    else{
      self.legDir = LEGS_MOVE_FORWD; // animation switch -> 'forward'
    }*/
  }
};