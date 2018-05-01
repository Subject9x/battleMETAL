/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_power (.1 .1 .1) (-56 -56 0) (56 56 46)
*/
void() building_power_think;
void() building_power_die;
void() building_power;

void() building_power={
  self.data_idx = ID_BLD_H_POWER;
  self.data_type = DATA_BLD;
  self.vec_name = "Power Generator";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 3;
  util_setModel(DAT_BLD_H_POWER_PLANT_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_POWER_PLANT_HP, DAT_BLD_H_POWER_PLANT_HP, 1, 100);
  util_setBoundBox('-75 -75 0', '75 75 26');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_POWER_PLANT_SH_MAX;
  self.sh_rate= DAT_BLD_H_POWER_PLANT_SH_RATE;
  self.en_cur= 0;
  self.en_max= DAT_BLD_H_POWER_PLANT_EN_MAX;
  self.en_rate= DAT_BLD_H_POWER_PLANT_EN_RATE;
  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
    
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  
  self.th_die = building_power_die;
  self.use = multi_trigger;
  self.SendEntity = send_building;
  self.SendFlags = -1;
  self.think = building_power_think;
  self.nextthink = time + 1;
};


void() building_power_think={
  if(self.en_cur < self.en_max){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur > self.en_max){
      self.en_cur = self.en_max;
    }
  }
  
  //power friendly local buildings
  local entity t;
  t = findchainfloat(data_type, DATA_BLD);
  while(t){
    if(t.i_faction == self.i_faction){
      if(t != self){
        if(vlen(t.origin - self.origin) <= DAT_BLD_H_POWER_PLANT_EN_RADIUS){
          t.en_rate = self.en_rate;
        }
      }
    }
    t = t.chain;
  }
  
  self.think = building_power_think;
  self.nextthink = time + 0.1;
};

void() building_power_die={
  local entity head;
  head = findradius(self.origin, DAT_BLD_H_POWER_PLANT_EN_RADIUS);
  while(head){
    if( (head.data_type == DATA_MECH) || (head.data_type == DATA_MECH_AI) ){
      head.en_cur = head.en_cur + 100;
      if(head.en_cur > head.en_max){
        head.en_cur = head.en_max;
      }
    }
    if( head.data_type == DATA_BLD ){
      if( head.i_faction == self.i_faction ){
        if( head.data_idx != ID_BLD_H_POWER){
          head.en_rate = 0;
        }
      }
    }
    head = head.chain;
  }
  building_die();
};