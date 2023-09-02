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
  
  if(!self.unit_legs){
    return;
  }
  
  self.legs_org = predraw_unit_part(self.legs_compOffset);
  self.legs_angl = [0, self.legDir, 0];
  
  //self.legs_angl_y = self.legDir;
  if( self.moveState != MOVE_STAND ){
    if( self.moveState == MOVE_NORM ){
      runMode = self.legMoveRate;
    }
    else if( self.moveState == MOVE_SPRINT ){
      runMode = self.legRunRate;
    }
    
    self.unit_legs.lerpfrac = self.unit_legs.lerpfrac - frametime * runMode;	//animate at moveRate (legMoveRate or  legRunRate)
    while(self.unit_legs.lerpfrac < 0) //protects against sudden low framerates.
    {
      self.unit_legs.frame2 = self.unit_legs.frame; //if we're at 0, frame2 became redundant anyway
      self.unit_legs.frame = self.unit_legs.frame + 1;	//move on to the next frame
    
      if (self.unit_legs.frame >= LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES){//this should be relative to the current animation that should be shown
        self.unit_legs.frame = LEG_WALK_FIRSTFRAME;	//restart it.
      }
      else if(self.unit_legs.frame < LEG_WALK_FIRSTFRAME){
        self.unit_legs.frame = LEG_WALK_FIRSTFRAME+LEG_WALK_NUMFRAMES;	//restart it.
      }
      
      if( (self.flags & FL_ONGROUND) ){
        if( rint(self.unit_legs.frame) == LEG_WALK_STEP_LEFT ){
          te_foot_stomp( self.rootOrigin, self.legs_angl, self.vec_size, self.mins, TRUE);
        }
        if( rint(self.legs_frame) == LEG_WALK_STEP_RIGHT ){
          te_foot_stomp( self.rootOrigin, self.legs_angl, self.vec_size, self.mins, FALSE);
        }
      }
        
      self.unit_legs.lerpfrac = self.unit_legs.lerpfrac + 1; //go to the start of the frame
    }
  }
  else{
    self.unit_legs.frame = 0;
  }
  
  setmodel(self.unit_legs, self.legs_mdl);
  if( (self.flags & FL_CLIENT) ){
    self.unit_legs.colormod = CLR_PLAYER_LIST[self.unitColorLG];
  }
  else{
    self.unit_legs.colormod = CLR_DEF_WHITE;
  }
  self.unit_legs.colormod =  self.unit_legs.colormod * (self.legs_hp / self.legs_hpMax) * 2;
  self.unit_legs.angles = self.legs_angl;
  self.unit_legs.origin = self.legs_org;
  self.legs_frame = self.unit_legs.frame;
  addentity(self.unit_legs);
  
};