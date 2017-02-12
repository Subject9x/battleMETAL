/*
mech mod
Author: Subject9x
Date: 9/5/2016
Overview: implementation for center torso updates
*/

void() ctrl_updateCenterTorso={
  if(self.en_cur < self.en_max){
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur > self.en_max){
        local float diff;
        diff = self.en_cur - self.en_max;
        self.en_cur = self.en_cur - diff;
      }
  }
  if(self.sh_cur < self.sh_max){
    if(time >= self.sh_hit){
      if(self.en_cur > (self.sh_rate*3)){
        self.sh_cur = self.sh_cur + self.sh_rate;
        self.en_cur = self.en_cur - (self.sh_rate/4);
        if(self.sh_cur > self.sh_max){
          local float diff;
          diff = self.sh_cur - self.sh_max;
          self.sh_cur = self.sh_cur - diff;
        }
      }
    }
  }
  
  if((self.velocity_x != 0) || (self.velocity_y != 0)){
    self.en_cur = self.en_cur - (self.en_rate/1.25);
    self.stat_spr_x = 8;
    self.stat_spr_y = 8;
  }
  else{
    self.stat_spr_x = 1;
    self.stat_spr_y = 1;
  }
  
  if(self.en_cur < 0){
    self.en_cur = 0;
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
      setorigin(self, oself.origin);
      util_setCollider(DAMAGE_AIM, SOLID_BBOX, MOVETYPE_BOUNCE);
      setmodel(self, oself.model);
      setsize(self, '-3 -3 -3', '3 3 3');
      self.think = BecomeExplosion;
      self.nextthink = time + 100;
    self = oself;

    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    //setmodel(self, "");
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
}

void() ctrl_dieMech={
  /*if(self.deadflag <= DEAD_NO){
    self.solid = SOLID_NOT;
    self.deadflag = DEAD_DYING;
    self.takedamage = DAMAGE_NO;
    setmodel(self, "");
    setsize(self, '0 0 0', '0 0 0'); 
  }*/
};