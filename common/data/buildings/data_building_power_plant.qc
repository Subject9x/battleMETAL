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
  self.solid = SOLID_NOT;

  head = findradius(self.origin, 800);
  for( head = findradius(self.origin, 800); head != world; head = head.chain ){
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
  }

  te_object_explode( '0.75 0.75 0.6' );
  if( self.deadflag > DEAD_NO){
    return;
  }
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  world_remove_dlight(self);
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD;
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  building_die_removeFire();
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
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
};
void() hpower_die10 = [10, hpower_die11]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );};
void() hpower_die11 = [11, SUB_Null]{
  te_object_explode( '0.75 0.75 0.6' );
  te_object_explode( '0.75 0.75 0.6' );
};

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
  for( t = findchainfloat(data_type, DATA_BLD); t != world; t = t.chain){
    if(t.faction != self.faction){
      continue;
    }
    if(t == self){
      continue;
    }
    if(vlen(t.origin - self.origin) > 800){
      continue;
    }
    t.energyRate = self.energyRate;
  }
  building_burn();
}; 


/*QUAKED building_human_power (0.074 0.66 0.93) (-75 -75 0) (75 75 26) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY -
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
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_power={
  self.data_idx = self.nextVecChoice = UI_BUILDING_power_plant;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  self.vec_name = "Power Generator";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 3;
  macro_set_model("q3mdl/buildings/power_plant/mdl_bld_h_power.md3", self.skin, 0) 
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  util_setHealthArmor(1200, 1200, 1, 100);
  setsize(self, '-75 -75 0', '75 75 26');
  self.shield= 0;
  self.shieldMax = 300;
  self.shieldRate = 0.67;
  self.energy= 0;
  self.energyMax= 4000;
  self.energyRate= 4;
  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  makevectors(self.angles);
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  
  self.th_die = hpower_die;
  self.use = multi_trigger;
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  
  hpower_th();
};