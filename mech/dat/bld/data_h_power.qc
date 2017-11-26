/*
mech Mod
Author: Subject9x
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

/*QUAKED building_power (.1 .1 .1) (-56 -56 0) (56 56 46)
*/
void() building_power_die;
void() building_power;

void() building_power={
  self.data_idx = ID_BLD_H_POWER;
  self.data_type = DATA_BLD;
  self.vec_name = "Power Generator";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_power.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(2500, 2500, 1, 100);
  util_setBoundBox('-75 -75 0', '75 75 48');
  self.sh_cur= 0;
  self.sh_max= 600;
  self.sh_rate= 1;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = building_power_die;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = 1;
};

void() building_power_die={
  local entity head;
  head = findradius(self.origin, 400);
  while(head){
    if(head.p_class == P_MECH){
      head.en_cur = head.en_cur + 100;
      if(head.en_cur > head.en_max){
        head.en_cur = head.en_max;
      }
    }
    head = head.chain;
  }
  building_die();
  BecomeExplosion();
};