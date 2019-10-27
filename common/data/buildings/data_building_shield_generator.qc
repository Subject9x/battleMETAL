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
  head = findradius(self.origin, 400);
  while(head){
    if(head.data_type == DATA_MECH){
      head.shield = head.shield + 250;
      if(head.shield > head.shieldMax){
        head.shield = head.shieldMax;
      }
    }
    head = head.chain;
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

  t = findchainflags(flags, FL_MONSTER);
  while(t){
    if(t.faction == self.faction){
      if(t != self){
        local float dist;
        dist = vlen(t.origin - self.origin);
        if(dist <= 1000){
          if(self.energy > 0){
            if( time > t.shieldHitDelay){
              if(t.shield < t.shieldMax){
                local float mod;
                mod = self.shieldRate / 2;
                t.shield = t.shield + mod;
                self.energy = self.energy - mod;
                if(t.shield > t.shieldMax){
                  t.shield = t.shieldMax;
                }
              }
            }
          }
        }
      }
    }
    t = t.chain;
  }
  
  p = findchainflags(flags, FL_CLIENT);
  while(p){
    if(p.faction == self.faction){
      local float pdist;
      pdist = vlen(t.origin - self.origin);
      if(pdist <= 1000){
        if(self.energy > 0){
          if(p.shield < p.shieldMax){
            local float pmod;
            pmod = self.shieldRate;
            p.shield = p.shield + pmod;
            self.energy = self.energy - pmod;
            if(p.shield > p.shieldMax){
              p.shield = p.shieldMax;
            }
          }
        }
      }
    }
    p = p.chain;
  }
  building_burn();
}

/*QUAKED building_human_shield (0.2 0.8 0.2) (-56 -56 0) (56 56 17.5) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE - - - - - - - - - IS_MAPKEY -
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
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
*/
void() building_human_shield={
  self.data_idx = UI_BUILDING_shield_generator;
  self.data_type = DATA_BLD;
  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | FL_MONSTER | FL_UNIT;
  self.data_type = DATA_BLD;
  util_setModel("q3mdl/buildings/shield_gen/mdl_bld_h_shield.md3", self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_SLIDEBOX, MOVETYPE_NONE) ;
  util_setHealthArmor(500, 500, 1, 100) ;
  setsize(self, '-56 -56 0', '56 56 17.5');
  self.shield= 0;
  self.shieldMax= 1000;
  self.shieldRate= 1;
  self.energy = 0;
  self.energyRate = 0;
  self.energyMax = 2000;
  self.scale = 1;
  self.deadflag = DEAD_NO;
  
  if(util_cornerSlopeCheck(self, 0.95)){
    util_generateBuildingFoundation(self);
  }
  else{
    droptofloor();
  }
  
  self.th_die = hshield_die;
  self.use = multi_trigger;
  hshield_th();
};