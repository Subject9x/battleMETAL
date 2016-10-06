/*
mech Mod
Author: Subject9x
Date: 8/27/2016
Overview: header for player type factory
*/


void(entity ent) mh_makeObserver={
  local entity oself;
  oself = self;
  self = ent;
  self.view_ofs = '0 0 1';
  self.flags = self.flags & FL_FLY;
  util_setHealthArmor(1,1,1,0);
  util_setCollider(DAMAGE_NO, SOLID_TRIGGER, MOVETYPE_FLY);
  setmodel(self, "q3mdl/testball.md3");
  self.effects = EF_NODRAW;
  util_setBoundBox('-3 -3 -3', '3 3 3');
  self = oself;
};

void(entity ent) mh_makeVec={

  
};

void(entity ent) mh_makeMech={
  local entity oself, dat;
  dat = mh_world_findData(self.nextVecChoice, DATA_MECH);
  oself = self;
  self = ent;
  self.flags = oself.flags;
  
  buildVehicle(dat);
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_WALK);
  util_setModel(self.c_model, 0);
  util_setBoundBox(self.c_bbx_n, self.c_bbx_x);
  
  mh_world_updateClientSpeed(dat.m_fspeed, dat.m_sspeed, dat.m_bspeed, dat.m_maccel, dat.m_rollangle) ;
  mh_world_updateClientViewBob(dat.m_bob, dat.m_bcycle, dat.m_bup) ;
  mh_world_updateClientModelBob(dat.m_bmodel, dat.m_bside, dat.m_bobspd) ;
  self = oself;
};