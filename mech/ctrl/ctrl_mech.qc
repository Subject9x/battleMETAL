/*
mech mod
Author: Subject9x
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={
  local float diff;
  
  if((self.flags & FL_CLIENT)){
    if(time > self.laser_sight_timer){
      local entity cam;
      makevectors(self.v_angle);
      cam = self.e_cam;
      traceline(cam.origin, cam.origin + v_forward*10000, FALSE, self);
      self.laser_sight_org = trace_endpos;
      self.laser_sight_timer = time + 0.05;
    }
  }

  if(self.en_cur < self.en_max){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur > self.en_max){
      self.en_cur = self.en_max;
    }
  }
  
  if(self.sh_cur < self.sh_max){
    if(time > self.sh_hit){
      if(self.en_cur > 0){
        self.sh_cur = self.sh_cur + self.sh_rate;
        self.en_cur = self.en_cur - self.sh_rate;
        if(self.sh_cur > self.sh_max){
          self.sh_cur = self.sh_max;
        }
      }
    }
  }
  if(self.en_cur < 0){
    self.en_cur = 0;
  }
  if((self.flags & FL_CLIENT)){
    local float mx, my;
    mx = self.movement_x;
    if(mx < 0){
      mx = mx * -1;
    }
    
    my = self.movement_y;
    if(my < 0){
      my = my * -1;
    }
    
    if((mx >= (self.m_fspeed + 1)) || (my >= (self.m_sspeed + 1))){
      local float v;
      local vector norg;
      norg_x = self.origin_x + self.velocity_x;
      norg_y = self.origin_y + self.velocity_y;
      v = vlen(norg - self.origin) / 3000;
      self.en_cur = self.en_cur - (self.en_rate * 1.15);
      
      
      self.stat_spr_x = self.stat_spr_x + self.conv_max_z;
      if(self.stat_spr_x > self.conv_max_x){
        self.stat_spr_x =  self.conv_max_x;
      }
      self.stat_spr_y = self.stat_spr_y + self.conv_max_z;
      if(self.stat_spr_y > self.conv_max_y){
        self.stat_spr_y =  self.conv_max_y;
      }
    }
    else{
      
      self.stat_spr_x = self.stat_spr_x - self.conv_min_z;
      if(self.stat_spr_x < self.conv_min_x){
        self.stat_spr_x =  self.conv_min_x;
      }
      self.stat_spr_y = self.stat_spr_y - self.conv_min_z;
      if(self.stat_spr_y < self.conv_min_y){
        self.stat_spr_y =  self.conv_min_y;
      }
    }
  }
};

void() ctrl_die_comp={
  if(self.deadflag <= DEAD_NO){
    local entity oself, tmp;
    local vector pvel;
    local string compType;
    compType = self.c_name;
    oself = self;
    pvel = self.owner.velocity;
    newmis = spawn();
    self = newmis;
      setorigin(newmis, oself.origin);
      BecomeExplosion();
    self = oself;
    
    newmis = spawn();
    self = newmis;
      self.angles = oself.angles;
      if(pvel_x > 0 || pvel_y > 0 || pvel_z > 0){
        self.velocity = pvel + VelocityForDamage (100);
        self.avelocity_x = random()*600;
        self.avelocity_y = random()*600;
        self.avelocity_z = random()*600;
      }
      else{
        self.velocity = VelocityForDamage (100);
        self.avelocity_x = random()*600;
        self.avelocity_y = random()*600;
        self.avelocity_z = random()*600;
      }      
      util_setHealthArmor(10,10,10,10);
      self.th_die = SUB_Remove;
      self.owner = oself.owner;
      setorigin(self, oself.origin);
      util_setCollider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_BOUNCE);
      setmodel(self, oself.model);
      setsize(self, '-3 -3 -3', '3 3 3');
      self.touch = touch_mechPiece;
      self.think = BecomeExplosion;
      self.nextthink = time + 100;
    self = oself;

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    
    if(compType == M_TOR_LEFT){
      killed(self.owner.e_arm_l, self, 0);
    }
    else if(compType == M_TOR_RIGHT){
      killed(self.owner.e_arm_r, self, 0);
    }
    
    local entity c;
    c = self.owner.w_slot;
    while(c){
      if(c.c_parent == compType){
        killed(c, self, 0);
      }
      c = c.w_slot;
    }
  }
};

void() touch_mechPiece={
  if(other==world){
    return;
  }
  if(other.p_class == P_MECH){
    BecomeExplosion();
  }
};