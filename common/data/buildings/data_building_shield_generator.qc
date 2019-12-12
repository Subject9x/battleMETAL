/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: Shield Generator
  faction: humans
  func: provides shields to all friendly units in its radius, but requires a nearby power plant.
*/
void() hshield_die = [0, hshield_die1]{
  local entity head;
  
  self.solid = SOLID_NOT;
  for(head = findradius(self.origin, 400); head != world; head = head.chain){
    if( head.data_type != DATA_MECH ){
      continue;
    }
    head.shield = head.shield + 250;
    if(head.shield > head.shieldMax){
      head.shield = head.shieldMax;
    }
  }
  
  building_die();
  te_object_explode( '0.25 1 0.05' );
  te_object_explode( '0.25 1 0.05' );
  te_object_explode( '0.25 1 0.05' );
};
void() hshield_die1 = [1, hshield_die2]{};
void() hshield_die2 = [2, hshield_die3]{};
void() hshield_die3 = [3, hshield_die4]{};
void() hshield_die4 = [4, hshield_die5]{};
void() hshield_die5 = [5, hshield_die6]{};
void() hshield_die6 = [6, hshield_die7]{};
void() hshield_die7 = [7, hshield_die8]{
  te_object_explode( '0.25 1 0.05' );};
void() hshield_die8 = [8, hshield_die9]{
  te_object_explode( '0.5 1 0.05' );};
void() hshield_die9 = [9, hshield_die10]{
  te_object_explode( '0.75 1 0.05' );
  self.deadflag = DEAD_DEAD;
  local entity ruins;
  ruins = spawn();
  ruins.solid = SOLID_NOT;
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
void() hshield_die10 = [10, hshield_die11]{
  te_object_explode( '1 1 0.05' );};
void() hshield_die11 = [11, BecomeExplosion]{};

void() hshield_th = [0, hshield_th]{
  local entity t, p;
  local float dist;
  local float mod;
 
  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
  
  if(self.shield < self.shieldMax){
    if(self.energy > 0){
      if( time > self.shieldHitDelay ){
        self.shield = self.shield + self.shieldRate * 2;
        self.energy = self.energy - self.shieldRate / 2; 
        if(self.shield > self.shieldMax){
          self.shield = self.shieldMax;
        }  
      }
    }
  }

  for(t = findchainflags(flags, FL_MONSTER); t != world; t = t.chain ){

    if( t == self ){
      continue;
    }
   
    dist = vlen(t.origin - self.origin);
    if(dist > 1000){
      continue;
    }
    if( self.energy <= 0 ){
      continue;
    }
    if( time < t.shieldHitDelay ){
      continue;
    }
    if( t.shield > t.shieldMax ){
      continue;
    }
    mod = self.shieldRate / 2;
    t.shield = t.shield + mod;
    self.energy = self.energy - mod;
    if(t.shield > t.shieldMax){
      t.shield = t.shieldMax;
    }
  }
  
  for(p = findchainflags(flags, FL_CLIENT); p != world; p = p.chain ){
    if(p.faction != self.faction){
      continue;
    }
    dist = vlen(p.origin - self.origin);
    if(dist > 1000){
      continue;
    }
    if( self.energy <= 0 ){
      continue;
    }
    if( p.shield > p.shieldMax ){
      continue;
    } 
    mod = self.shieldRate;
    p.shield = p.shield + mod;
    self.energy = self.energy - mod;
    if(p.shield > p.shieldMax){
      p.shield = p.shieldMax;
    } 
  }
  building_burn();
}

/*QUAKED building_human_shield (0.2 0.8 0.2) (-56 -56 0) (56 56 17.5) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY -
{ model("models/buildings/shield/shield.md3"); }
Shield Generator Building.
Gives ALL FRIENDLY units a shield recharge boost IF they're in the radius.
Radius: 1000units
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
void() building_human_shield={
  self.data_idx = self.nextVecChoice = UI_BUILDING_shield_generator;
  self.data_type = DATA_BLD;
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  
  macro_set_model("q3mdl/buildings/shield_gen/mdl_bld_h_shield.md3", self.skin, 0)
  macro_set_collider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE)
  util_setHealthArmor(500, 500, 1, 100) ;
  setsize(self, '-48 -48 0', '48 48 32');
  self.shield = 0;
  self.shieldMax = 500;
  self.shieldRate = 0.45;
  self.energy = 0;
  self.energyRate = 0;
  self.energyMax = 2000;
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
  
  self.th_die = hshield_die;
  self.use = multi_trigger;
  hshield_th();
};