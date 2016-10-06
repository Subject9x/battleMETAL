/*
mech Mod
Author: Subject9x
Date: 9/1/2016
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think={
  local entity oself;
  oself = self;
  self = wep;
  if(self.deadflag >= DEAD_DYING){
    self.deadflag = DEAD_DEAD;
    self = oself;
    return;
  }
  
  if(self.deadflag == DEAD_DEAD){
    local entity torso;
    if(self.c_parent == M_TOR_LEFT){
      torso = oself.e_tor_l;
    }
    else if(self.c_parent == M_TOR_RIGHT){
      torso = oself.e_tor_r;
    }
    
    if(torso.deadflag <= DEAD_NO){
      local float rng;
      rng = random()*100;
      if(rng > 50){
        local vector spvel;
        spvel = '0 0 0';
        spvel_x = random()*100;
        spvel_y = random()*100;
        spvel_z = random()*100;
        te_spark(self.origin, spvel, random()*250);
      }
    }
    self = oself;
    return;
  }
  
  if(self.w_isfire == 1){
    if(self.w_currentammo > 0){
      if(time >= self.w_firetime){
        self.w_attack();
        self.w_currentammo = self.w_currentammo - 1;
        self.w_firetime = time + self.w_firerate;
      }
    }
    else{
      self.w_firetime = time + self.w_reloadtime;
      self.w_currentammo = self.w_clipsize;
    }
    self.w_isfire = 0;
  }
 
  self = oself;
};

void(entity wep) ctrl_weapon_tryFire={
  local entity oself;
  oself = self;
  self = wep;
    self.w_isfire = 1;
  self = oself;
};

void() ctrl_die_weapon={
  if(self.deadflag <= DEAD_NO){
    local entity oself;
    local vector pvel;
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
      self.nextthink = time + 1000;
    self = oself;

    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    //setmodel(self, "");
    setsize(self, '0 0 0', '0 0 0');
  }
};