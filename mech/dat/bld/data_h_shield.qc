/*
mech Mod
Author: Subject9x
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
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_shield.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(1000, 1000, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 35');
  self.sh_cur= 0;
  self.sh_max= 800;
  self.sh_rate= 1;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = building_shield_die;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags = 1;
};

void() building_shield_die={
  local entity head;
  head = findradius(self.origin, 400);
  while(head){
    if(head.p_class == P_MECH){
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
