/*
battleMETAL
Author: Peter Roohr
Date: 09/11/2019
Overview: 
  data file for the simple guard tower building
*/

void() guard_tower_die2={
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 3, 2 );
};

void() guard_tower_die1={
  if( self.deadflag > DEAD_NO ){
    return;
  }
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DEAD; 
  self.solid = SOLID_NOT;
  self.touch = SUB_Null;
  
  //fire triggers when dead
  trigger_event( self.enemy, self.trigOnDeath );
  
  self.model = "q3mdl/map/ruins/ruin_small.obj";
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);

  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
  
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, normalize(shoot - self.origin) * 5, '0 0 0', 5, 1 );
  
  ai_alert_close(self.enemy);
  
  self.think = guard_tower_die2;
  self.nextthink = time + 0.1;
};

/*QUAKED building_guard_tower (0 0 1) (-24 -24 0) (24 24 48) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - LIGHTS_OFF IS_MAPKEY IS_VIP
{ model("models/buildings/towersmall/guardtower.md3"); }

Base Decoration building.
  + can glow yellow.
Does not require power.

Max Health = 200. (default)

Shield Max = 150. (default)

-------- KEYS --------
.faction : <float> 1, 2, 3 - [REQUIRED]
.style : <float>, light style. [OPTIONAL]
.compOffset : <vector>, color for lighting.
.targetname : <string>, used for trigger calls from other ents
.target : <string> name of ent to go to, usually a patrol node
.trigOnSpawn: <string> target, fire this ENTITY when activated
.trigOnDeath: <string> target, fire this ENTITY when killed
.trigOnTarget: <string> target, fire this ENTITY when spotting a target
.delay : <float>, use with trigOnTarget, wait time between calls to trigOnTarget
  -1 = fire trigOnTarget once
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
LIGHTS_OFF 2097152: turns off lights from this building.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_guard_tower={
  self.data_idx = self.nextVecChoice = UI_BUILDING_guard_tower;
  self.data_type = DATA_BLD;

  if( ai_can_spawn() == FALSE ){
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
    return;
  }

  self.vec_name = "Guard Tower";
  self.flags = self.flags | FL_MONSTER;
  self.vec_size = 1;
  macro_set_collider(DAMAGE_YES, SOLID_SLIDEBOX, MOVETYPE_NONE)
  macro_set_model("q3mdl/testball.md3", self.skin,0)
  setsize(self, '-22 -22 0', '22 22 40');
  
  self.deadflag = DEAD_NO;
  self.movetype = MOVETYPE_NONE;
  
  self.th_die = guard_tower_die1;
  
  if( !self.health) {
    self.health = self.max_health = 200;
  }
  
  if( !self.shieldMax ){
    self.shieldMax = 150;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0;
  }
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 1000;
  }
  
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
  
  self.SendEntity = ctrl_send_building;
  self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }
  self.think = building_burn_th;
  self.nextthink = time + random() * 3;
};