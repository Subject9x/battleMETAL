/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: radar tower
  faction: humans
  func: provides radar scanning to all friendly units in radius
*/

void() hpower_die = [0, hpower_die1]{
  local entity head;
  head = findradius(self.origin, 800);
  self.deadflag = DEAD_DYING;
  while(head){
    //if( (head.data_type == DATA_MECH) || (head.data_type == DATA_MECH_AI) ){
    if( head.data_type == DATA_MECH ){
      head.energy = head.energy + 100;
      if(head.energy > head.energyMax){
        head.energy = head.energyMax;
      }
    }
    if( head.data_type == DATA_BLD ){
      if( head.faction == self.faction ){
        if( head.data_idx != UI_BUILDING_power_plant){
          head.energyRate = 0;
        }
      }
    }
    head = head.chain;
  }

  te_object_explode( '0.75 0.75 0.6' );
  building_die();
};
void() hpower_die1 = [1, hpower_die2]{};
void() hpower_die2 = [2, hpower_die3]{};
void() hpower_die3 = [3, hpower_die4]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die4 = [4, hpower_die5]{};
void() hpower_die5 = [5, hpower_die6]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die6 = [6, hpower_die7]{};
void() hpower_die7 = [7, hpower_die8]{};
void() hpower_die8 = [8, hpower_die9]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die9 = [9, hpower_die10]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );
  self.deadflag = DEAD_DEAD;
  local entity ruins;
  ruins = spawn();
  ruins.solid = SOLID_BBOX;
  ruins.movetype = MOVETYPE_NONE;
  switch( self.vec_size ){
    case 2:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_medium.obj"));
      break;
    case 3:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_large.obj"));
      break;
    default:
      setmodel(ruins, precache_model("q3mdl/map/ruins/ruin_small.obj"));
      break;
  }
  setsize(ruins, ruins.mins, ruins.maxs * 0.75);
  setorigin(ruins, self.origin);
  ruins.vec_size = self.vec_size;
  ruins.angles = self.angles;
  ruins.armLeft = te_building_fire_start( ruins );
  if( ruins.vec_size > 1 ){
    ruins.armRight = te_building_fire_start( ruins );
    ruins.torsoLeft = te_building_fire_start( ruins );
  }  
};
void() hpower_die10 = [10, hpower_die11]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die11 = [11, BecomeExplosion]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};

void() hpower_th = [0, hpower_th]{
  if(self.energy < self.energyMax){
    self.energy = self.energy + self.energyRate;
    if(self.energy > self.energyMax){
      self.energy = self.energyMax;
    }
  }
  
  //power friendly local buildings
  local entity t;
  t = findchainfloat(data_type, DATA_BLD);
  while(t){
    if(t.faction == self.faction){
      if(t != self){
        if(vlen(t.origin - self.origin) <= 800){
          t.energyRate = self.energyRate;
        }
      }
    }
    t = t.chain;
  }
  building_burn();
}; 


/*QUAKED building_human_power (0.074 0.66 0.93) (-75 -75 0) (75 75 26) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - - - IS_MAPKEY -
{ model("models/buildings/reactor/reactor.md3"); }
Generates energy to power ALL FRIENDLY buildings
Radius: 800units
-------- KEYS -------- 
targetname : string, used for trigger calls from other ents
target : string name of ent to go to, usually a patrol node
trigOnSpawn:string ent, fire this ENTITY when activated
trigOnDeath: string target, fire this ENTITY when killed
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_power={
  self.data_idx = UI_BUILDING_power_plant;
  self.data_type = DATA_BLD;
  self.vec_name = "Power Generator";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  util_setModel("q3mdl/buildings/power_plant/mdl_bld_h_power.md3", self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(1200, 1200, 1, 100);
  setsize(self, '-75 -75 0', '75 75 26');
  self.shield= 0;
  self.shieldMax = 600;
  self.shieldRate = 1;
  self.energy= 0;
  self.energyMax= 4000;
  self.energyRate= 4;
  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  
  if( util_cornerSlopeCheck(self, 1) ){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  self.th_die = hpower_die;
  self.use = multi_trigger;
  
  hpower_th();
};