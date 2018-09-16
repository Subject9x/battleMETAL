/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/
void() hshield_die = [0, hshield_die1]{
  local entity head;
  head = findradius(self.origin, 400);
  while(head){
    if(head.data_type == DATA_MECH){
      head.sh_cur = head.sh_cur + 250;
      if(head.sh_cur > head.sh_max){
        head.sh_cur = head.sh_max;
      }
    }
    head = head.chain;
  }
  activator = self.enemy;
	SUB_UseTargets ();
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_CORPSE;
  multi_trigger();
};
void() hshield_die1 = [1, hshield_die2]{};
void() hshield_die2 = [2, hshield_die3]{};
void() hshield_die3 = [3, hshield_die4]{};
void() hshield_die4 = [4, hshield_die5]{};
void() hshield_die5 = [5, hshield_die6]{};
void() hshield_die6 = [6, hshield_die7]{};
void() hshield_die7 = [7, hshield_die8]{};
void() hshield_die8 = [8, hshield_die9]{};
void() hshield_die9 = [9, hshield_die10]{};
void() hshield_die10 = [10, hshield_die11]{};
void() hshield_die11 = [11, BecomeExplosion]{};

void() hshield_th = [0, hshield_th]{
  local entity t, p;

  self.en_cur = self.en_cur + self.en_rate;
  if(self.en_cur > self.en_max){
    self.en_cur = self.en_max;
  }
  
  if(self.sh_cur < self.sh_max){
    if(self.en_cur > 0){
      self.sh_cur = self.sh_cur + self.sh_rate * 2;
      self.en_cur = self.en_cur - self.sh_rate / 2; 
      if(self.sh_cur > self.sh_max){
        self.sh_cur = self.sh_max;
      }  
    }
  }

  t = findchainflags(flags, FL_MONSTER);
  while(t){
    if(t.i_faction == self.i_faction){
      if(t != self){
        local float dist;
        dist = vlen(t.origin - self.origin);
        if(dist <= DAT_BLD_H_SHIELD_RADIUS){
          if(self.en_cur > 0){
            if( time > t.sh_hit){
              if(t.sh_cur < t.sh_max){
                local float mod;
                mod = self.sh_rate / 2;
                t.sh_cur = t.sh_cur + mod;
                self.en_cur = self.en_cur - mod;
                if(t.sh_cur > t.sh_max){
                  t.sh_cur = t.sh_max;
                }
              }
            }
          }
        }
      }
    }
    t = t.chain;
  }
  
  p = findchainflags(flags, FL_CLIENT);
  while(p){
    if(p.i_faction == self.i_faction){
      local float pdist;
      pdist = vlen(t.origin - self.origin);
      if(pdist <= DAT_BLD_H_SHIELD_RADIUS){
        if(self.en_cur > 0){
          if(p.sh_cur < p.sh_max){
            local float pmod;
            pmod = self.sh_rate;
            p.sh_cur = p.sh_cur + pmod;
            self.en_cur = self.en_cur - pmod;
            if(p.sh_cur > p.sh_max){
              p.sh_cur = p.sh_max;
            }
          }
        }
      }
    }
    p = p.chain;
  }
}

/*QUAKED building_shield (.1 .1 .1) (-64 -64 -17.5) (64 64 17.5)
*/
void() building_shield={
  self.data_idx = ID_BLD_H_SHIELD;
  self.data_type = DATA_BLD;
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.data_type = DATA_BLD;
  util_setModel(DAT_BLD_H_SHIELDGEN_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_SHIELDGEN_HP, DAT_BLD_H_SHIELDGEN_HP, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 17.5');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_SHIELDGEN_SH_MAX;
  self.sh_rate= DAT_BLD_H_SHIELDGEN_SH_RATE;
  self.en_cur = 0;
  self.en_rate = 0;
  self.en_max= DAT_BLD_H_POWER_PLANT_EN_MAX / 2;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  
  self.th_die = hshield_die;
  self.use = multi_trigger;
  hshield_th();
};