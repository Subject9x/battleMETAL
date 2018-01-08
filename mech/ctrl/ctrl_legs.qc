/*
mech mod
Author: Peter Roohr
Date: 9/6/2016
mod - 5/10/2017 - added terrain check
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
      //texture check
      local vector dn, angl;
      local float vertic;
      makevectors(self.owner.angles);
      vertic = self.owner.c_bbx_n_y - 16;
      dn = self.origin + (v_up*vertic);
      traceline(self.origin, dn, TRUE, self.owner);
      //trace_dphittexturename
      local vector m;
      m = self.owner.movement;
      m_y = m_y * -1;
      self.angles =  vectoangles(m);
      self.v_angle = self.angles;
    }
  }
};

void() ctrl_dieLegs={
  local entity this;
  newmis = spawn();
  this = self;
    setorigin(self, this.origin);
    local vector v1, v2;
    local float f1, f2, f3;
    v1 = this.owner.c_bbx_n;
    v2 = this.owner.c_bbx_x;
    f1 = v1_z*-1; 
    f2 = v2_x/2;
    f3 = v2_y/2;
    v1_x = v1_x + f2;
    v1_y = v1_y + f3;
    v2_x = v2_x - f2;
    v2_y = v2_y - f3;
    v1_z = v1_z + f1;
    v2_z = f1;
    setsize(self, v1, v2);
    setmodel(self, this.model);
    self.frame = this.walkframe;
    self.touch = touch_mechPiece;
    leg_die1();
  self = this;
};
