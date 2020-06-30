/*
battleMETAL 
Author: Peter Roohr
Date: 06/30/2020
Overview: 
  Ferris Bueller: what are you all still doing here? movies over.
*/

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