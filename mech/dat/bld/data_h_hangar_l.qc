/*
mech Mod
Author: Subject9x
Date: 5/10/2017
Overview: data file for building
*/

/*QUAKED building_hangar (.1 .1 .1) (-64 -64 0) (64 64 40)
*/
void() building_hangar;

void() building_hangar={
  self.data_idx = ID_BLD_H_HANGAR_L;
  self.data_type = DATA_BLD;
  self.vec_name = "Large Hangar";
  self.p_class = P_BULD;
  util_setModel("q3mdl/buildings/mdl_bld_h_hangar_l.md3", 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(500, 500, 1, 100) ;
  util_setBoundBox('-56 -56 0', '56 56 64');
  self.sh_cur= 0;
  self.sh_max= 500;
  self.sh_rate= 1;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  droptofloor();
  self.th_die = BecomeExplosion;
  self.think = building_think;
  self.nextthink = time + 1;
  self.SendEntity = send_building;
  self.SendFlags |= 1;
};