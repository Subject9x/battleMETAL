/*
mech mod
Author: Peter Roohr
Date: 10/21/2016
Overview: csqc handler
*/

float(entity piece) csqc_updateCompStat={

  if(piece){
    if(piece.classname != "world"){
      if(piece.health){
        local float perc;
        perc = (piece.health / piece.max_health)*100;
        return perc;
      }
    }
  }
  return 0;
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

