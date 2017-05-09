/*
mech mod
Author: Subject9x
Date: 9/6/2016
Overview: implementation for leg model updates
*/

void() ctrl_updateLegs={
  
  
  if((self.owner.movement_x == 0) && (self.owner.movement_y == 0)){
    self.movetype = MOVETYPE_NONE;
    makevectors(self.owner.angles);
    local vector adj;
    adj = self.owner.origin + (v_up * self.c_ofs_y) + (v_right * self.c_ofs_x) + (v_forward * self.c_ofs_z);
    setorigin(self, adj);
  }
  else{
    if(self.movetype != MOVETYPE_FOLLOW){
      self.movetype = MOVETYPE_FOLLOW;
    }
    if((self.owner.flags & FL_CLIENT)){
      local vector m;
      m = self.owner.movement;
      m_y = m_y * -1;
      self.angles =  vectoangles(m);
      self.v_angle = self.angles;
    }
    else{
      self.angles = self.owner.angles;
      self.v_angle = self.angles;
    }
  }
};

void() ctrl_dieLegs={
  if(self.owner.deadflag <= DEAD_NO){
    if(self.owner.flags & FL_CLIENT){
      if(self.owner!=world){
        local float fs, ms;
        self.owner.m_fspeed = self.owner.m_fspeed - (self.owner.m_fspeed * 0.05);
        self.owner.m_sspeed = self.owner.m_sspeed - (self.owner.m_sspeed * 0.02);
    
        mh_world_updateClientSpeed(self.owner.m_fspeed, self.owner.m_sspeed, self.owner.m_bspeed, self.owner.m_maccel, self.owner.m_rollangle);
      }
    }
    else{
      //todo leg damage
    }
    return;
  }
  leg_die1();
};




