/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

void() building_power_die;

void() hpower_die = [0, hpower_die1]{
  local entity head;
  head = findradius(self.origin, DAT_BLD_H_POWER_PLANT_EN_RADIUS);
  while(head){
    //if( (head.data_type == DATA_MECH) || (head.data_type == DATA_MECH_AI) ){
    if( head.data_type == DATA_MECH ){
      head.energy = head.energy + 100;
      if(head.energy > head.energyMax){
        head.energy = head.energyMax;
      }
    }
    if( head.data_type == DATA_BLD ){
      if( head.faction == self.faction ){
        if( head.data_idx != ID_BLD_H_POWER){
          head.energyRate = 0;
        }
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
  te_object_explode( '0.75 0.75 0.6' );
};
void() hpower_die1 = [1, hpower_die2]{};
void() hpower_die2 = [2, hpower_die3]{};
void() hpower_die3 = [3, hpower_die4]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die4 = [4, hpower_die5]{};
void() hpower_die5 = [5, hpower_die6]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die6 = [6, hpower_die7]{};
void() hpower_die7 = [7, hpower_die8]{};
void() hpower_die8 = [8, hpower_die9]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die9 = [9, hpower_die10]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die10 = [10, hpower_die11]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die11 = [11, BecomeExplosion]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};

void() hpower_th = [0, hpower_th]{
  if(self.energy < self.energyMax){
    self.energy = self.energy + self.energyRate;
    if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
  
  //power friendly local buildings
  local entity t;
  t = findchainfloat(data_type, DATA_BLD);
  while(t){
    if(t.faction == self.faction){
      if(t != self){
        if(vlen(t.origin - self.origin) <= DAT_BLD_H_POWER_PLANT_EN_RADIUS){
          t.energyRate = self.energyRate;
        }
      }
    }
    t = t.chain;
  }
  building_burn();
}; 


/*QUAKED building_human_power (.1 .1 .1) (-56 -56 0) (56 56 46)
*/
void() building_human_power={
  self.data_idx = ID_BLD_H_POWER;
  self.data_type = DATA_BLD;
  self.vec_name = "Power Generator";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  util_setModel(DAT_BLD_H_POWER_PLANT_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_POWER_PLANT_HP, DAT_BLD_H_POWER_PLANT_HP, 1, 100);
  setsize(self, '-75 -75 0', '75 75 26');
  self.shield= 0;
  self.shieldMax= DAT_BLD_H_POWER_PLANT_SH_MAX;
  self.shieldRate= DAT_BLD_H_POWER_PLANT_SH_RATE;
  self.energy= 0;
  self.energyMax= DAT_BLD_H_POWER_PLANT_EN_MAX;
  self.energyRate= DAT_BLD_H_POWER_PLANT_EN_RATE;
  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
    
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  
  self.th_die = hpower_die;
  self.use = multi_trigger;
  
  hpower_th();
};