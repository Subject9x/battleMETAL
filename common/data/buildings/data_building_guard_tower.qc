/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building
*/

void() guard_tower_think={
  building_burn();
  self.think = guard_tower_think;
  self.nextthink = time + 0.1;
};

void() guard_tower_die={
  
  building_die();
};

/*QUAKED building_guard_tower (0 0 1) (-24 -24 0) (24 24 48) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - LIGHTS_OFF IS_MAPKEY -
{ model("models/buildings/towersmall/guardtower.md3"); }
Listening Post, has the ability to detect the player and alert friendly bots.
-------- KEYS -------- 
.targetname : string, used for trigger calls from other ents
.target : string name of ent to go to, usually a patrol node
.trigOnSpawn:string target, fire this ENTITY when activated
.trigOnDeath: string target, fire this ENTITY when killed
.trigOnTarget: string target, fire this ENTITY when spotting a target
.delay : float, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
.style : float, light style. OPTIONAL
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
LIGHTS_OFF 2097152: turns off lights from this building.
*/
void() building_guard_tower={
  self.data_idx = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;
  self.vec_name = "Guard Tower";
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.vec_size = 1;
  util_setModel("q3mdl/buildings/towersmall/guardtower.obj", self.skin, 0);
  util_setCollider(DAMAGE_YES, SOLID_SLIDEBOX, MOVETYPE_NONE);
  util_setHealthArmor(200, 200, 1, 100);
  setsize(self, '-22 -22 0', '22 22 40');
  self.shield = 0;
  self.shieldMax = 100;
  self.shieldRate = 1;
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  self.th_die = building_die;
  self.think = guard_tower_think;
  self.nextthink = time + 0.1;
  
  if( !(self.spawnflags & AI_SPAWNFLAG_NODROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  
  if( !(self.spawnflags & 2097152) ){
    if( !self.style ){
      self.style = 0;
    }
    local vector lightOrg;
    makevectors(self.angles);
    lightOrg = self.origin + (v_up * 36);
    world_make_dlight( (lightOrg + (v_forward * 18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_forward * -18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_right * 18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    world_make_dlight( (lightOrg + (v_right * -18)), self, 1, '0.85 0.8 0.2', self.style, (PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW), '-45 0 0', 0, 66);
    
  }
};