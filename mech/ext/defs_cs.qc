/*
mech Mod
Author: Subject9x
Date: 10/12/2016
Overview: csqc defs for main game
*/



float ENT_INVALID = 0; // never used
float ENT_GAMESETTINGS = 1; // provide game parameters such as frag limit, time limit, etc...
float ENT_PLAYER = 2; // player entity (origin, aimdir, active weapon, etc)
float ENT_INVENTORYITEM = 3; // inventory items in this player's inventory are networked this way
float ENT_ADDVECCOMP = 4; //mod: add vehicle component to cs
float ENT_ADDWEPCOMP = 5;

float STAT_CPIT_MDL = 33;

float STAT_ENERGY_CUR = 34;
float STAT_ENERGY_MAX = 35;
float STAT_SHIELD_CUR = 36;
float STAT_SHIELD_MAX = 37;

.entity csqc_sendToEnt; //the player to send the ent too
.float(entity playerent, float changedflags) SendEntity;
.float SendFlags;
float MSG_ENTITY = SVC_SETVIEWPORT;

float(entity player, float changeFlag) csqc_SendVecComp={
  msg_entity = self;
  WriteByte(MSG_ENTITY, ENT_ADDVECCOMP);
  WriteString(MSG_ENTITY, self.e_legs.c_name);
  WriteByte(MSG_ENTITY, self.e_legs.max_health);
  WriteByte(MSG_ENTITY, self.e_legs.health);
  WriteByte(MSG_ENTITY, self.e_legs.armorvalue);
  WriteByte(MSG_ENTITY, self.e_legs.max_armor);
  return TRUE;
};

float() csqc_SendWepComp={
  WriteByte(MSG_ONE, ENT_ADDWEPCOMP);
  WriteString(MSG_ONE, self.w_name);
  WriteByte(MSG_ONE, self.max_health);
  WriteByte(MSG_ONE, self.health);
  WriteByte(MSG_ONE, self.armorvalue);
  WriteByte(MSG_ONE, self.max_armor);
  WriteByte(MSG_ONE,  self.w_clipsize);
  WriteByte(MSG_ONE,  self.w_currentammo);
  WriteByte(MSG_ONE,  self.w_firetime);
  WriteByte(MSG_ONE,  self.w_reloadtime);
  return TRUE;  
};