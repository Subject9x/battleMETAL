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
  local float runMode;
  local float prevLerp;
  local vector prevAngle;
  
  prevLerp = self.lerpfrac;
  prevAngle = self.angles;
  if (self.owner.nextthink != self.owner.frame1time)
  {
    self.legs_frame2time = self.legs_frame1time;
    self.legs_frame1time = self.owner.nextthink;
    self.legs_frame2 = self.legs_frame1;
    self.legs_frame1 = self.legs_frame;
    self.legs_origin2 = self.legs_origin1;
    self.legs_origin1 = self.legs_org;
    self.legs_angle2 = self.legs_angle1;
    self.legs_angle1 = self.legs_angl_y;
  }
  
  self.legs_org = predraw_unit_part_and_angle(self.legs_compOffset, legs_angl);
  self.legs_angl_y = self.legs_angle1 + dir*self.legs_lerpfrac;
  self.legs_angle1 = self.legs_angl_y;
  self.legs_angl_y = self.legDir;
  if( self.moveState != 0 ){
    if( self.moveState == MOVE_NORM ){
      runMode = self.legMoveRate;
    }
    else if( self.moveState == MOVE_SPRINT ){
      runMode = self.legRunRate;
    }
    self.legs_lerpfrac = self.legs_lerpfrac - (frametime * runMode);	//animate at 10fps
    
    while(self.legs_lerpfrac < 0) //protects against sudden low framerates.
    {
      self.legs_frame2 = self.legs_frame; //if we're at 0, frame2 became redundant anyway
      self.legs_frame = self.legs_frame + self.ai_dir;	//move on to the next frame
      
      if (self.legs_frame >= LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES){//this should be relative to the current animation that should be shown
        self.legs_frame = LEG_WALK_FIRSTFRAME;	//restart it.
      }
      else if(self.legs_frame < LEG_WALK_FIRSTFRAME){
        self.legs_frame = LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES;	//restart it.
      }
      
      if( (self.flags & FL_ONGROUND) ){
        if( rint(self.legs_frame) == LEG_WALK_STEP_LEFT ){
          te_foot_stomp( self.origin, self.legs_angl, self.vec_size, self.mins, TRUE);
        }
        if( rint(self.legs_frame) == LEG_WALK_STEP_RIGHT ){
          te_foot_stomp( self.origin, self.legs_angl, self.vec_size, self.mins, FALSE);
        }
      }
      
      self.legs_lerpfrac = self.legs_lerpfrac + 1; //go to the start of the frame
    }
  }
  else{
    self.legs_frame = 0;
  }
    
  savedang = self.legs_angl_y;
  dir = (self.legs_angle2-self.legs_angle1);
  if (dir > 180){
    dir -= 360;
  }
  else if (dir < -180){
    dir += 360;
  }
  setmodel(self, self.legs_mdl);
  self.frame = self.legs_frame;
  self.origin = self.legs_org;
  self.angles = self.legs_angl;
  addentity(self);
  self.frame = 0;
  self.lerpfrac = prevLerp;
  self.angles = prevAngle;
};