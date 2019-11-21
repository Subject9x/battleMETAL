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
  if( self.deadflag == DEAD_NO ){
    if((self.owner.movement_x == 0) && (self.owner.movement_y == 0)){
      self.movetype = MOVETYPE_NONE;
      makevectors(self.owner.angles);
      adj = self.owner.origin + (v_up * self.compOffset_y) + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z);
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
  }
};


void() ctrl_dieLegs={
  local entity newLegs;
  te_missile_explode( self.origin, self.owner.vec_size, '1 0.25 0.75', random() * (self.vec_size * 1.5), 2); 

  newLegs = spawn();
  newLegs.vec_size = self.owner.vec_size;
  newLegs.skin = self.skin;
  newLegs.angles = self.owner.angles;
  newLegs.mins = self.compOffset;
  newLegs.maxs = self.compAltOffset;
  setorigin(newLegs, self.origin);
  setmodel(newLegs, self.model);

  if( (self.owner.flags & FL_CLIENT) ){
    newLegs.think = leg_die1;
  }
  else{
    newLegs.think = bot_leg_die1;
  }
  newLegs.nextthink = time + 0.1;
  
  self.health = 0;
  self.deadflag = DEAD_DEAD;
  self.effects = EF_NODRAW;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.alpha = 0;
  setsize(self, '-1 -1 -1', '1 1 1');
  setorigin( self, self.origin );
  self.think = SUB_Remove;
  self.nextthink = time + 3;
};
