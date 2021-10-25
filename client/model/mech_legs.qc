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
  
  if (self.owner.nextthink != self.owner.frame1time)
  {
    self.legs.frame2time = self.legs.frame1time;
    self.legs.frame1time = self.owner.nextthink;
    self.legs.frame2 = self.legs.frame1;
    self.legs.frame1 = self.legs.frame;
    self.legs.origin2 = self.legs.origin1;
    self.legs.origin1 = self.legs.origin;
    self.legs.angle2 = self.legs.angle1;
    self.legs.angle1 = self.legs.angles_y;
  }
  
  local float runMode;
  if( self.moveState != 0 ){
    if( self.moveState == MOVE_NORM ){
      runMode = self.legMoveRate;
    }
    else if( self.moveState == MOVE_SPRINT ){
      runMode = self.legRunRate;
    }
    self.legs.lerpfrac = self.legs.lerpfrac - (frametime * runMode);	//animate at 10fps
    
    while(self.legs.lerpfrac < 0) //protects against sudden low framerates.
    {
      self.legs.frame2 = self.legs.frame; //if we're at 0, frame2 became redundant anyway
      self.legs.frame = self.legs.frame + self.ai_dir;	//move on to the next frame
      
      if (self.legs.frame >= LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES){//this should be relative to the current animation that should be shown
        self.legs.frame = LEG_WALK_FIRSTFRAME;	//restart it.
      }
      else if(self.legs.frame < LEG_WALK_FIRSTFRAME){
        self.legs.frame = LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES;	//restart it.
      }
      
      if( (self.flags & FL_ONGROUND) ){
        if( rint(self.legs.frame) == LEG_WALK_STEP_LEFT ){
          te_foot_stomp( self.origin, self.legs.angles, self.vec_size, self.mins, TRUE);
        }
        if( rint(self.legs.frame) == LEG_WALK_STEP_RIGHT ){
          te_foot_stomp( self.origin, self.legs.angles, self.vec_size, self.mins, FALSE);
        }
      }
      
      self.legs.lerpfrac = self.legs.lerpfrac + 1; //go to the start of the frame
    }
  }
  else{
    self.legs.frame = 0;
  }
    
  savedang = self.legs.angles_y;
  dir = (self.legs.angle2-self.legs.angle1);
  if (dir > 180){
    dir -= 360;
  }
  else if (dir < -180){
    dir += 360;
  }
  self.legs.angles_y = self.legs.angle1 + dir*self.legs.lerpfrac;
  self.legs.angle1 = self.legs.angles_y;
  self.legs.angles_y = self.legDir;
};