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
      head.shield = head.shield + 250;
      if(head.shield > head.shieldMax){
        head.shield = head.shieldMax;
      }
    }
    head = head.chain;
  }  
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_CORPSE;
  building_die_removeFire();
  te_object_explode( '0.25 1 0.05' );
  te_object_explode( '0.25 1 0.05' );
  te_object_explode( '0.25 1 0.05' );
};
void() hshield_die1 = [1, hshield_die2]{};
void() hshield_die2 = [2, hshield_die3]{};
void() hshield_die3 = [3, hshield_die4]{};
void() hshield_die4 = [4, hshield_die5]{};
void() hshield_die5 = [5, hshield_die6]{};
void() hshield_die6 = [6, hshield_die7]{};
void() hshield_die7 = [7, hshield_die8]{
  te_object_explode( '0.25 1 0.05' );};
void() hshield_die8 = [8, hshield_die9]{
  te_object_explode( '0.5 1 0.05' );};
void() hshield_die9 = [9, hshield_die10]{
  te_object_explode( '0.75 1 0.05' );};
void() hshield_die10 = [10, hshield_die11]{
  te_object_explode( '1 1 0.05' );};
void() hshield_die11 = [11, BecomeExplosion]{};

void() hshield_th = [0, hshield_th]{
  local entity t, p;

  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
  
  if(self.shield < self.shieldMax){
    if(self.energy > 0){
      if( time > self.sh_hit ){
        self.shield = self.shield + self.shieldRate * 2;
        self.energy = self.energy - self.shieldRate / 2; 
        if(self.shield > self.shieldMax){
          self.shield = self.shieldMax;
        }  
      }
    }
  }

  t = findchainflags(flags, FL_MONSTER);
  while(t){
    if(t.faction == self.faction){
      if(t != self){
        local float dist;
        dist = vlen(t.origin - self.origin);
        if(dist <= DAT_BLD_H_SHIELD_RADIUS){
          if(self.energy > 0){
            if( time > t.sh_hit){
              if(t.shield < t.shieldMax){
                local float mod;
                mod = self.shieldRate / 2;
                t.shield = t.shield + mod;
                self.energy = self.energy - mod;
                if(t.shield > t.shieldMax){
                  t.shield = t.shieldMax;
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
    if(p.faction == self.faction){
      local float pdist;
      pdist = vlen(t.origin - self.origin);
      if(pdist <= DAT_BLD_H_SHIELD_RADIUS){
        if(self.energy > 0){
          if(p.shield < p.shieldMax){
            local float pmod;
            pmod = self.shieldRate;
            p.shield = p.shield + pmod;
            self.energy = self.energy - pmod;
            if(p.shield > p.shieldMax){
              p.shield = p.shieldMax;
            }
          }
        }
      }
    }
    p = p.chain;
  }
  building_burn();
}

/*QUAKED building_human_shield (.1 .1 .1) (-56 -56 0) (56 56 17.5)
*/
void() building_human_shield={
  self.data_idx = ID_BLD_H_SHIELD;
  self.data_type = DATA_BLD;
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.data_type = DATA_BLD;
  util_setModel(DAT_BLD_H_SHIELDGEN_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_SHIELDGEN_HP, DAT_BLD_H_SHIELDGEN_HP, 1, 100) ;
  setsize(self, '-56 -56 0', '56 56 17.5');
  self.shield= 0;
  self.shieldMax= DAT_BLD_H_SHIELDGEN_SH_MAX;
  self.shieldRate= DAT_BLD_H_SHIELDGEN_SH_RATE;
  self.energy = 0;
  self.energyRate = 0;
  self.energyMax= DAT_BLD_H_POWER_PLANT_EN_MAX / 2;
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