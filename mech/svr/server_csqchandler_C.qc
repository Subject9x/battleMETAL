/*
mech mod
Author: Subject9x
Date: 10/21/2016
Overview: csqc handler
*/

float(entity piece) csqc_updateCompStat={

  if(piece){
    if(piece.owner == self || piece == self){
      if(piece.health){
        local float perc;
        perc = (piece.health / piece.max_health)*100;
        return perc;
      }
    }
  }
  return -1;
};


entity() csqc_setHeader={
  local entity data, oself;
  data = spawn();
  oself = self;
  self = data;
    self.classname = "missile";
    self.deadflag = 0;
    self.walkframe = 1;
    setmodel(self, "q3mdl/testball.md3");
    self.alpha = 0;
    util_setBoundBox('-1 -1 -1', '1 1 1');
    util_setCollider(DAMAGE_NO, SOLID_NOT, MOVETYPE_NONE);
    setorigin(self, oself.origin);
  self = oself;
  return data;
};

void(entity to, float entType, float flagType) csqc_SendMechData={
  /*local entity data, oself;
  oself = self;
  local float f;
  f = num_for_edict(to);
  data = csqc_setHeader();
  self = data;
    self.health = f;
    self.owner = to;
    self.csqc_entType = entType;
    self.csqc_flgType = flagType;
    if(oself.e_legs.health>0){
      self.lg_hp_c = oself.e_legs.health;
      self.lg_am_c = oself.e_legs.armorvalue;
    }else{
      self.lg_hp_c = self.lg_am_c = 0;
    }
    
    if(oself.e_tor_l.health>0){
      self.lt_hp_c = oself.e_tor_l.health;
      self.lt_am_c = oself.e_tor_l.armorvalue;
    }else{
      self.lt_hp_c = self.lt_am_c = 0;
    }
    
    if(oself.e_tor_r.health>0){
      self.rt_hp_c = oself.e_tor_r.health;
      self.rt_am_c = oself.e_tor_r.armorvalue;
    }else{
      self.rt_hp_c = self.rt_am_c = 0;
    }
    
    if(oself.e_arm_l.health>0){
      self.la_hp_c = oself.e_arm_l.health;
      self.la_am_c = oself.e_arm_l.armorvalue;
    }else{
      self.la_hp_c = self.la_am_c = 0;
    }
    
    if(oself.e_arm_r.health>0){
      self.ra_hp_c = oself.e_arm_r.health;
      self.ra_am_c = oself.e_arm_r.armorvalue;
    }else{
      self.ra_hp_c = self.ra_am_c = 0;
    }
    self.SendEntity = sendData;
    self.SendFlags = flagType;
    self.think = SUB_Remove;
    self.nextthink = time + 0.01;
  self = oself;*/

};

void(entity to, float sendFlags) sendPlayer={
};

//float(entity to, float sendFlags) sendData={
float() sendData={
  /*msg_entity = self.owner;
  WriteByte(MSG_ENTITY, self.health);
  WriteByte(MSG_ENTITY, self.csqc_entType);
  WriteByte(MSG_ENTITY, self.csqc_flgType);
  
  WriteByte(MSG_ENTITY, self.lg_hp_c);
  WriteByte(MSG_ENTITY, self.lg_am_c);

  WriteByte(MSG_ENTITY, self.lt_hp_c);
  WriteByte(MSG_ENTITY, self.lt_am_c);
  
  WriteByte(MSG_ENTITY, self.rt_hp_c);
  WriteByte(MSG_ENTITY, self.rt_am_c);
  
  WriteByte(MSG_ENTITY, self.la_hp_c);
  WriteByte(MSG_ENTITY, self.la_am_c);
  
  WriteByte(MSG_ENTITY, self.ra_hp_c);
  WriteByte(MSG_ENTITY, self.ra_am_c);*/
  return TRUE;
};

/*
  garbage collection
*/
void() sendDataThink={
  self.think = SUB_Remove;
  self.nextthink = time + 0.0001;
};

