/*
battleMETAL
Author: Peter Roohr
Date: 01/21/2017
Overview: data file for building
  type: Shield Generator
  faction: humans
  func: provides shields to all friendly units in its radius, but requires a nearby power plant.
*/

#ifdef CSQC
void() shield_gen_die_vfx={
  local vector margin;
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);      
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){
    margin = randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5));  
    te_field_quantum( randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)), randompos(self.origin + (self.mins * 1.5), self.origin + (self.maxs * 1.5)) );
    te_field_quantum_light( margin, rint(random()*5) ) ;
  }
  
  self.scale = self.scale - (0.05 * frametime);
  self.alpha = self.alpha - (0.05 * frametime);
};
#endif


void() shield_gen_die = [0, shield_gen_die1]{
#ifdef SSQC
  if( self.deadflag > DEAD_NO){
    return;
  }
  ai_alert_close(self.enemy);
  self.deadflag = DEAD_DYING;
  self.SendFlags = self.SendFlags | SENDFLAG_DEAD;
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die1 = [1, shield_gen_die2]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die2 = [2, shield_gen_die3]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die3 = [3, shield_gen_die4]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die4 = [4, shield_gen_die5]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die5 = [5, shield_gen_die6]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die6 = [6, shield_gen_die7]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die7 = [7, shield_gen_die8]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die8 = [8, shield_gen_die9]{
#ifdef SSQC
  local vector shoot;
  shoot = randompos(self.absmin, self.absmax);
  te_debris( shoot, '0 0 0', '0 0 0', 5, 1 );
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die9 = [9, shield_gen_die10]{
#ifdef SSQC
  local entity head;
  
  if( self.energy > 0 ){
    for(head = nextent(world); head != world; head = nextent(head) ){
      if( head == self ){
        continue;
      }
      if( vlen(head.origin - self.origin) > (self.ai_minrange / 2) ){
        continue;
      }
      if( !(head.flags & (FL_UNIT | FL_MONSTER)) ){
        continue;
      }
      if( head.shield <= 0 ){
        continue;
      }
      if( self.energy < 0 ){
        continue;
      }
      head.shield = head.shield - ((self.energy / self.energyMax) / 2);
      if( head.shield < 0 ){
        head.shield = 0;
      }
      if( !head.stat_client_shield ){
        head.stat_client_shield = (head.shield / head.shieldMax) * 100;
      }
      if( head.data_type == DATA_BLD ){
        head.SendFlags = head.SendFlags | SENDFLAG_IMPACT;
      }
      
    
      head.shieldHitDelay = time + ((self.energy / self.energyMax) / 2);
      self.energy  = self.energy - ((self.energy / self.energyMax) / 5);
    }
  }
#endif
#ifdef CSQC
  shield_gen_die_vfx();
  te_missile_explode( randompos(self.absmin, self.absmax), 1, '0.85 0.45 0.8', 0.085 );
  sound7(self, CHAN_AUTO, "sound/fx_boom.ogg", (0.67 + random() * 0.3), ATTN_NORM, (0.4 + (random() * 0.5)) * 90, 0 );
#endif
};
void() shield_gen_die10 = [10, shield_gen_die11]{};
void() shield_gen_die11 = [11, shield_gen_die12]{};
void() shield_gen_die12 = [12, shield_gen_die13]{};
void() shield_gen_die13 = [13, shield_gen_die14]{};
void() shield_gen_die14 = [14, shield_gen_die15]{};
void() shield_gen_die15 = [15, SUB_Null]{
#ifdef SSQC
  building_die();
#endif
};

#ifdef SSQC
void() hshield_th ={
  local entity t;
  local float mod;
  local float cost;
 
  cost = 0;
  if( self.energy > 0 ){
    t = findradius(self.origin, self.ai_minrange);
    while(t){  
      if( t != self ){
        if( (t.flags & (FL_UNIT|FL_MONSTER)) ){
          if( t.faction == self.faction ){
            if( time > t.shieldHitDelay ){
              mod = t.shieldRate + self.shieldRate;
              t.shield = t.shield + mod;
              if( t.shield > t.shieldMax ){
                t.shield = t.shieldMax;
              }
              cost = cost + (self.shieldRate * 0.5);
              if( !t.stat_client_shield ){
                t.stat_client_shield = (t.shield / t.shieldMax) * 100;
              }
            }
          }
        }
      }
      t = t.chain;
    }
  }
  
  self.energy = self.energy - cost;
  self.energy = self.energy + self.energyRate;
  if(self.energy > self.energyMax){
    self.energy = self.energyMax;
  }
  
  if( time > self.shieldHitDelay ){
    self.shield = self.shield + self.shieldRate * 2;  //generators get their own shields for free
    if(self.shield > self.shieldMax){
      self.shield = self.shieldMax;
    }  
  }
  self.stat_client_shield = (self.shield / self.shieldMax) * 100;
  building_burn();
  
  if( self.last_shield != self.stat_client_shield ){
    self.SendFlags = self.SendFlags | SENDFLAG_SHIELD;
    self.last_shield = self.stat_client_shield;
  }
  self.think = hshield_th;
  self.nextthink = time + 0.1;
}
#endif


#ifdef CSQC
//FIXME
void() shield_gen_active;

void() shield_gen_idle={
  if( self.energy > 0 ){
    self.think = shield_gen_active;
    self.nextthink = servertime + 1;
    return;
  }
  
  self.think = shield_gen_idle;
  self.nextthink = servertime + 1;
};

void() shield_gen_active={
  local vector vfx, vfx2;
  
  if( self.energy <= 0 ){
    self.think = shield_gen_idle;
    self.nextthink = servertime + 0.1;
    return;
  }
  
  particleDraw = vlen(CLIENT_vis_org - self.origin);
  if( particleDraw <= PARTICLE_HAZ_DISTANCE ){  
    vfx = randompos(self.compOffset, self.compAltOffset);
    vfx2= randompos(self.compOffset, self.compAltOffset);
    te_field_quantum( vfx2, vfx );
    if( random() > 0.85 ){
      te_field_quantum_light( vfx2, 0.5) ;
    } 
  }

  self.think = shield_gen_active;
  self.nextthink = servertime + (random() * 1.5);
};
#endif


/*QUAKED building_shield (0.2 0.8 0.2) (-56 -56 0) (56 56 28) NO_CAMPAIGN NO_COOP NO_DM NO_TDM - - - - - NO_NOVICE NO_REGULAR NO_VETERAN NO_ELITE NODROP - - - - - - - - IS_MAPKEY IS_VIP
{ model("models/buildings/shield/shield.md3"); }
Shield Generator Building.
Gives SHIELD to EVERY FRIENDLY unit in radius, regardless if those units normally have shields!
MUST HAVE: Power Plant that can power it (check power plant radius).
Generator does have to pay for its shield generating, these can be taxed by too many nearby units.

Health = 500. (default)

Energy Max = 2000 units. (default)
Energy Rate = 0. (default)

Shield Max = 300. (default)
Shield Rate = 0.33 / tic (default)

Radius: 1000 units.(default)

behavior: death() will DAMAGE shields of all units at ai_minrange/2

-------- KEYS -------- 
faction : <float> [Required], faction id - 1 | 2 | 3
targetname : <string>, used for trigger calls from other ents.
target : <string> name of ent to go to, usually a patrol node.
trigOnSpawn: <string> ent, fire this ENTITY when activated.
trigOnDeath: <string target, fire this ENTITY when killed.
shieldRate: <float> [Optional], default is 4 / tic. set this to override default.
shieldMax: <float> [Optional], default is 4000. set this to override default.
ai_minrange: <float> [Optional], default is 100. set ths to override default;
-------- SPAWNFLAGS -------- 
NO_CAMPAIGN 1: remove from campaign mode
NO_COOP 2: remove from co-op mode
NO_DM 4: remove from DeathMatch
NO_TDM 8: remove from Team DeathMatch
NODROP 8192: doesnt run droptofloor logic, starts exactly where placed.
IS_MAPKEY 4194304: mark's this entity on player's briefing map.
IS_VIP 8388608: faction-allied player will be notified of this entity's state
*/
void() building_shield={
  self.data_idx = self.nextVecChoice = UI_BUILDING_shield_generator;
  self.data_type = DATA_BLD;

  self.vec_name = "Shield Generator";
  self.vec_size = 2;
  self.flags = self.flags | FL_MONSTER ;  
  self.scale = 1;
  self.deadflag = DEAD_NO;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_AIM;
  self.skin = self.faction - 1;
  self.model = "models/buildings/shield_gen/shieldgen.md3";
  precache_model("models/buildings/shield_gen/shieldgen.md3");
  setmodel(self, "models/buildings/shield_gen/shieldgen.md3");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  
  if( !self.health) {
    self.health = 500;
  }
  self.max_health = self.health;
  
  if( !self.shieldMax ){
    self.shieldMax = 4000;
  }
  
  if( !self.shieldRate ){
    self.shieldRate = 0.05;
  }
  
  if( !self.energyRate ){
    self.energyRate = 0;
  }
  if( !self.energyMax ){
    self.energyMax = 2000;
  }
  
  //fine, you don't want power plants in YOUR map <chuckle>
  if( !self.energy ){
    self.energy = 0;
  }
  self.th_die = shield_gen_die;
  
  makevectors(self.angles);
#ifdef CSQC
  self.th_walk = shield_gen_active;
  //local vfx
  self.compOffset = self.origin + (v_up * (self.maxs_z * 0.15)) + (v_right * self.mins_x) + (v_forward * self.mins_y);
  self.compAltOffset = self.origin + (v_up * self.maxs_z) + (v_right * (self.mins_x * 0.15)) + (v_forward * (self.mins_y * 0.15));
#endif
  
#ifdef SSQC
  if( self.angle ){
    self.angles_y = self.angle;
  }
  
  if( ai_can_spawn() == FALSE ){
    remove(self);
    return;
  }
  trigger_ext_check();
  
  if( !self.ai_minrange ){
    self.ai_minrange = 1000;
  }
  self.effects = self.effects | EF_LOWPRECISION;
  
  if( !(self.spawnflags & NO_DROP) ){
    if( util_cornerSlopeCheck(self, 0.95) ){
      util_generateBuildingFoundation(self);
    }
    else{
      droptofloor();
    }
  }
  setorigin(self, self.origin);
  
  self.hitOffset = self.origin + (v_up * self.maxs_z * 0.67);
  self.use = multi_trigger;
  
  if( (self.spawnflags & IS_MAPKEY) ){
    self.effects = self.effects | EF_NODEPTHTEST;
  }
  self.canTarget = TRUE;
  if( (self.spawnflags & BUILDING_TARGET_FLAG) ){
    self.canTarget = FALSE;
  }  
  if( self.canTarget || (self.spawnflags & IS_MAPKEY) ){
    self.SendEntity = ctrl_send_building;
    self.SendFlags = self.SendFlags | SENDFLAG_NEWENT;
  }
  self.building_delay_think = hshield_th;
  self.think = building_bbox_settle;
  self.nextthink = time + 0.01;
#endif
};