/*
mech mod
Author: Peter Roohr
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={
  local float diff;
  
  if((self.flags & FL_CLIENT)){
    if(time > self.laser_sight_timer){
      local entity cam;
      local vector v1;
      makevectors(self.v_angle);
      v1 = self.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
      traceline(v1, v1 + v_forward*10000, FALSE, self);
      self.laser_sight_org = trace_endpos;
      self.laser_sight_timer = time + 0.05;
    }
  }
  else{
    local entity cam;
    local vector v1;
    makevectors(self.angles);
    v1 = self.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
    traceline(v1, v1 + v_forward*10000, FALSE, self);
    self.laser_sight_org = trace_endpos;
    self.laser_sight_timer = time + 0.05;
  }

  if(self.en_cur >= 0){
    if(self.movement_x <= self.m_fspeed && self.movement_y <= self.m_fspeed){
      self.en_cur = self.en_cur + self.en_rate;
    }
    else{
      self.en_cur = self.en_cur + (self.en_rate - self.m_maccel);
    }
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
  else if(self.en_cur > self.en_max){
    self.en_cur = self.en_max;
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
    local float r_max, r_min;
    if(self.stat_rdr_mode){
      r_max = self.conv_max_z / 2;
      r_min = self.conv_min_z * 2;
    }
    else{
      r_max = self.conv_max_z;
      r_min = self.conv_min_z;
    }
    if((mx >= (self.m_fspeed + 1)) || (my >= (self.m_sspeed + 1))){
      local float v;
      local vector norg;
      norg_x = self.origin_x + self.velocity_x;
      norg_y = self.origin_y + self.velocity_y;
      v = vlen(norg - self.origin) / 3000;
      
      self.stat_spr_x = self.stat_spr_x + r_max;
      if(self.stat_spr_x > self.conv_max_x){
        self.stat_spr_x =  self.conv_max_x;
      }
      self.stat_spr_y = self.stat_spr_y + r_max;
      if(self.stat_spr_y > self.conv_max_y){
        self.stat_spr_y =  self.conv_max_y;
      }
    }
    else{
      
      self.stat_spr_x = self.stat_spr_x - r_min;
      if(self.stat_spr_x < self.conv_min_x){
        self.stat_spr_x =  self.conv_min_x;
      }
      self.stat_spr_y = self.stat_spr_y - r_min;
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
        self.avelocity_x = random()*150;
        self.avelocity_y = random()*150;
        self.avelocity_z = random()*100;
      }
      else{
        self.velocity = VelocityForDamage (100);
        self.avelocity_x = random()*150;
        self.avelocity_y = random()*150;
        self.avelocity_z = random()*100;
      }      
      util_setHealthArmor(10,10,10,10);
      self.th_die = SUB_Remove;
      self.owner = oself.owner;
      util_setCollider(DAMAGE_AIM, SOLID_CORPSE, MOVETYPE_BOUNCE);
      util_setModel(oself.model, oself.owner.mskin, 0);
      setsize(self, '-3 -3 -3', '3 3 3');
      setorigin(self, oself.origin);
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
    if((self.owner.flags & FL_MONSTER)){
      if( ai_core_noguns()){
        //TODO - panic behavior
      }
    }
  }
};

void() touch_mech={
  if(other == world){
    return;
  }
  if( (other.flags & FL_CLIENT) || (other.flags & FL_MONSTER) ){
    local float dif;
    dif = self.vec_size - other.vec_size;
    if(dif == 2){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health, DMG_BAL, other.origin, '0 0 0');
      }
      else{
        t_damage(other, self, self, self.max_health * 0.15, DMG_BAL, other.origin, '0 0 0');
      }
    }
    else if(dif == 1){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health , DMG_BAL, other.origin, '0 0 0');
      }
      else{
        t_damage(other, self, self, self.max_health*0.15, DMG_BAL, other.origin, '0 0 0');
      }
    
    }
    else if(dif == 0){
      if(other.data_type == DATA_VEHC){
        t_damage(other, self, self, other.max_health / 4, DMG_BAL, other.origin, '0 0 0');
      }
    }
    else if(dif == -1){
      if(other.data_type != DATA_VEHC){
        t_damage(self, other, other, other.max_health / 1.5, DMG_BAL, self.origin, '0 0 0');
      }
    }
    else if(dif == -2){
      if(other.data_type != DATA_VEHC){
        t_damage(self, other, other, other.max_health / 2, DMG_BAL, self.origin, '0 0 0');
      }
    }
  }
};

void() touch_mechPiece={
  if(other == world){
    return;
  }
  if( other.classname == MECH_PIECE ){
    return;
  }
  
  BecomeExplosion();
  
};