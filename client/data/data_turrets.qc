/*
battleMETAL
Author: Peter Roohr
Date: 03/10/2020
Overview: 
  CSQC-side ini function for synced turrets.
*/

/*
  client_main.CSQC_ent_update()->Ent Type == building, SENDFLAG_NEWENT
  scope = self
  self is building
*/
void( float dataID ) data_sync_new_turret={
  self.flags = FL_MONSTER | FL_UNIT;
  self.solid = SOLID_BBOX;
 
  weaponList = self;  //prepare to build unit's weapon list
  self.hardpoint_cnt = 0;
  
  self.data_type = DATA_BLD;
  self.colormod = '1 1 1';
  setorigin( self, self.origin );
  
  switch( dataID ){
    case UID_TURRET_light_turret:
      data_ini_light_turret_();
      self.vec_size = 1;
      break;
      
    case UID_TURRET_missile_turret:
      data_ini_missile_turret_();
      self.vec_size = 2;
      break;
      
    case UID_TURRET_heavy_turret:
      data_ini_heavy_turret_();
      self.vec_size = 3;
      break;
  }
  setmodel(self, self.model);
  
  makevectors(self.angles);
  data_mech_setup_part(self.torsoCenter);
  
  sendent_setup_weapons();
  sendent_ini_interpolate();
  self.takedamage = DAMAGE_AIM;
  self.interpolate_entity = interpolate_turret;
}
