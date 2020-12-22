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
  
  prevDir = self.ai_dir;
  if( self.deadflag == DEAD_NO ){
    if((self.owner.movement_x == 0) && (self.owner.movement_y == 0)){
      self.movetype = MOVETYPE_NONE;
      makevectors(self.owner.angles);
      adj = self.owner.origin + (v_up * self.compOffset_y) + (v_right * self.compOffset_x) + (v_forward * self.compOffset_z);
      setorigin(self, adj);
      if( self.ai_dir != 0 ){
        self.ai_dir = 0;  // animation switch -> 'stand'
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
        }
      }
      else{
        nextDirs_y = anglemod( nextDirs_y + 180) * -1;
        if( self.ai_dir != -1 ){
          self.ai_dir = -1; // animation switch -> 'reverse'
        }
      }
      self.angles =  nextDirs;
      self.v_angle = self.angles;
    }
  }
};


void() ctrl_dieLegs={
  local entity newLegs;
  local entity check;
  local float blown;
  //leg critical hit
  if( self.owner.deadflag == DEAD_NO ){
    //leg critical hit event.
    if( !(self.flags & FL_DISARMED) ){
      if( self.health <= 0 ){
        blown = FALSE;
        for( check = self.owner.w_slot; check != world; check = check.w_slot ){
          if( blown ){
            continue;
          }
          if( check.deadflag != DEAD_NO ){
            continue;
          }
          if( check.data_idx == UID_ITEM_turbo_charger){
            blown = TRUE;
            newLegs = self;
            self = check;
              check.th_die();
            self = newLegs;
          }
        }
        if( !blown ){
          self.flags = self.flags | FL_DISARMED;
          if( (self.owner.flags & FL_CLIENT) ){
            self.owner.data_speed_forward = self.owner.data_speed_forward * 0.7;
            self.owner.data_speed_strafe = self.owner.data_speed_strafe * 0.8;
            self.owner.data_speed_backward = self.owner.data_speed_backward;
            if(self.clientData != world ){
              self.clientData.SendFlags = self.clientData.SendFlags | SENDFLAG_EFLAGS;
            }
          }
          else{
            //AI suffers way more for blown legs
            self.owner.data_speed_forward = self.owner.data_speed_forward * 0.5;
            self.owner.data_speed_strafe = self.owner.data_speed_strafe * 0.67;
            self.owner.data_speed_backward = self.owner.data_speed_backward;
            if( !(self.owner.SendFlags & SENDFLAG_CRIT) ){
              self.owner.SendFlags = self.owner.SendFlags | SENDFLAG_CRIT;
            }
            if( !(self.owner.damageValue & M_LEGS) ){
              self.owner.damageValue = self.owner.damageValue | M_LEGS;
            }
          }
        }
      }
    }
    return;
  }
  
  if( self.deadflag == DEAD_NO ){
    //te_vehicle_chunk( self, self.owner.velocity, self.angles,  particleeffectnum("TE_DEBRIS_TRAIL_MED"), 3600, 1 );
    
    self.health = 0;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;  
    self.movetype = MOVETYPE_NONE;
    self.aiment = world;
    self.health = 0;
    setsize(self, '-1 -1 -1', '1 1 1');
    setorigin( self, self.origin );
  }
};
