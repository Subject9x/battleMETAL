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
  }
};


void() ctrl_dieLegs={

  te_missile_explode( self.origin, self.owner.vec_size, '1 0.25 0.75', random() * (self.vec_size * 1.5), 2); 
  te_mech_piece_explode( self, self.origin, self.angles, self.owner.velocity, self.model, self.skin );
  self.health = 0;
  self.deadflag = DEAD_DEAD;
  self.effects = EF_NODRAW;
  setsize(self, '0 0 0', '0 0 0');
  setorigin( self, self.origin );

  local entity this;
  newmis = spawn();
  this = self;
    self.movetype = MOVETYPE_BOUNCE;
    self.solid = SOLID_NOT;
    self.owner = this.owner;
    self.touch = touch_mechPiece;
    self.skin = this.skin;
    setmodel(self, this.model);
    self.frame = this.frame;
    self.mins = self.owner.mins;
    self.mins_z = self.owner.mins_z / 2;
    self.maxs = self.owner.maxs;
    self.maxs_z = self.owner.mins_z / -1;
    self.maxs = self.maxs * 0.67;
    self.mins = self.mins * 0.67;
    setsize(self, self.mins, self.maxs);
    setorigin(self, self.origin);
  
    if( (self.owner.flags & FL_CLIENT) ){
      leg_die1();
    }
    else{
      bot_leg_die1();
    }
  self = this;
};
