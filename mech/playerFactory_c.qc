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
  self.scale = 0.005;

  util_setBoundBox('-1 -1 -1', '1 1 1');
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
    self.data_idx = dat.data_idx;
    buildVehicle(dat);
    if(self.flags & FL_CLIENT){
      self.targetpip = spawn();
      self.targetpip.drawonlytoclient = self;
      setmodel(self.targetpip, "q3mdl/green_pip.spr32");
      setorigin(self.targetpip, self.origin);
      setsize(self.targetpip, '-1 -1 -1', '1 1 1');
      self.targetpip.effects = EF_NODRAW;
      mh_world_updateClientSpeed(self.m_fspeed, self.m_sspeed, self.m_bspeed, self.m_maccel, self.m_rollangle);
      mh_world_updateClientViewBob(self.m_bob, self.m_bcycle, self.m_bup);
      mh_world_updateClientModelBob(self.m_bmodel, self.m_bside, self.m_bobspd);
      self.stat_plr_stt = PLAYER_SPAWN;
     //1/27/2017
      msg_entity = self;
      WriteByte(MSG_ONE, SVC_SETVIEWPORT);
      WriteEntity(MSG_ONE, self.e_cam);
    }
  self = oself;
};