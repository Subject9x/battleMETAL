/*
mech Mod
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_shield (.1 .1 .1) (-64 -64 0) (64 64 40)
*/
void() building_shield_die;
void() building_shield;

void() building_shield={
  self.data_idx = ID_BLD_H_SHIELD;
  self.data_type = DATA_BLD;
  self.vec_name = "Shield Generator";
  self.flags = self.flags | FL_MONSTER;
  self.data_type = P_BULD;
  util_setModel(DAT_BLD_H_SHIELDGEN_MODEL, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_SHIELDGEN_HP, DAT_BLD_H_SHIELDGEN_HP, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 35');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_SHIELDGEN_SH_MAX;
  self.sh_rate= DAT_BLD_H_SHIELDGEN_SH_RATE;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  
  self.th_die = building_shield_die;
  self.use = multi_trigger;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = -1;
};

void() building_shield_die={
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
  building_die();
  BecomeExplosion();
};
