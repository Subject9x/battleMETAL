/*
battleMETAL
Author: Peter Roohr
Date: 8/24/2020
Overview: 
  synchronizing leg models to the client
*/



void() predraw_legs={
  local float runMode;
  local vector prevAngle;
  local float prevLerpFrac;
  
  self.legs_org = predraw_unit_part(self.legs_compOffset);
  self.legs_angl = [0, self.legDir, 0];
  //self.legs_angl_y = self.legDir;
  if( self.moveState != 0 ){
    if( self.moveState == MOVE_NORM ){
      runMode = self.legMoveRate;
    }
    else if( self.moveState == MOVE_SPRINT ){
      runMode = self.legRunRate;
    }
    
    self.legs_lerpfrac = self.legs_lerpfrac - frametime * runMode;	//animate at moveRate (legMoveRate or  legRunRate)
    while(self.legs_lerpfrac < 0) //protects against sudden low framerates.
    {
      self.legs_frame2 = self.legs_frame; //if we're at 0, frame2 became redundant anyway
      self.legs_frame = self.legs_frame + 1;	//move on to the next frame
    
      if (self.legs_frame >= LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES){//this should be relative to the current animation that should be shown
        self.legs_frame = LEG_WALK_FIRSTFRAME;	//restart it.
      }
      else if(self.legs_frame < LEG_WALK_FIRSTFRAME){
        self.legs_frame = LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES;	//restart it.
      }
      
      if( (self.flags & FL_ONGROUND) ){
        if( rint(self.legs_frame) == LEG_WALK_STEP_LEFT ){
          te_foot_stomp( self.rootOrigin, self.legs_angl, self.vec_size, self.mins, TRUE);
        }
        if( rint(self.legs_frame) == LEG_WALK_STEP_RIGHT ){
          te_foot_stomp( self.rootOrigin, self.legs_angl, self.vec_size, self.mins, FALSE);
        }
      }
        
      self.legs_lerpfrac = self.legs_lerpfrac + 1; //go to the start of the frame
    }
  }
  else{
    self.legs_frame = 0;
  }
  
  setmodel(self, self.legs_mdl);
  if( (self.flags & FL_CLIENT) ){
    self.colormod = CLR_PLAYER_LIST[self.unitColorLG];
  }
  self.angles = self.legs_angl;
  self.frame = self.legs_frame;
  self.origin = self.legs_org;
  addentity(self);
};