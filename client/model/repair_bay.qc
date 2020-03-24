/*
battleMETAL
Author: Peter Roohr
Date: 03/23/2020
Overview: 
  CSQC-side animations for repair bay
*/


void() repair_bay_dlights={
  makevectors(self.angles);
  local vector lightColor;
  if( self.deadflag == DEAD_NO ){
    if( self.energy > 0 ){
      if( self.faction == CLIENT_faction ){
        if( self.energy < 0 ){
          lightColor = '1 0.6 0';
        }
        else{
          lightColor = '0.25 0.85 0.35';
        }
      }
      else{
        if( self.energy < 0 ){
          lightColor = '0 0 0';
        }
        else{
          lightColor = '0.95 0.25 0.15';
        }
      }
      adddynamiclight2( (self.origin + (v_up * 10) + (v_right * 24)), 128, lightColor, 2, "", 0); 
      adddynamiclight2( (self.origin + (v_up * 10) + (v_right * -24)), 128, lightColor, 2, "", 0); 
      adddynamiclight2( (self.origin + (v_up * 64) + (v_right * 32) + (v_forward * -32)), 64, lightColor, 2, "", PFLAGS_FULLDYNAMIC );
      adddynamiclight2( (self.origin + (v_up * 64) + (v_right * -32) + (v_forward * -32)), 64,lightColor, 2, "", PFLAGS_FULLDYNAMIC ); 
    }
  }
};

/*
  Repair Bay - Active
*/
void() repair_bay_active={
  local vector fx;
  if( self.energy < 0 ){
    self.think = repair_bay_idle;
    self.nextthink = time + 0.1;
    return;
  }
  if( self.w_firetime == 2 ){
    //see sv/main/ai/ai_api.qh -> ST_WALK for the '2' value.
    pointparticles( particleeffectnum("TE_REPAIR_MUZZLE"), self.compOffset, normalize( self.compAltOffset - self.compOffset ) * 2, 1);
    pointparticles( particleeffectnum("TE_REPAIR_IMPACT"), self.compAltOffset, normalize( self.compOffset - self.compAltOffset ) * -2, 1);
    trailparticles( world, particleeffectnum("TE_REPAIR_RAIL"), self.compOffset, self.compAltOffset);
  }

  self.think = repair_bay_active;
  self.nextthink = time + 0.1;
};

/*
  Repair Bay - Idle
*/
void() repair_bay_idle={

  if( self.energy > 0 ){
    self.think = repair_bay_active;
    self.nextthink = time + 0.1;
    return;
  }
  
  self.think = repair_bay_idle;
  self.nextthink = time + 0.1;
};

/*
  Repair Bay - Repair
*/
void() repair_bay_repair={
  
};

/*
  Repair Bay - DEATH
*/
void() repair_bay_die1={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 0) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 0) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die2;
  self.nextthink = time + 0.1;
};
void() repair_bay_die2={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 4) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 4) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die3;
  self.nextthink = time + 0.1;
};
void() repair_bay_die3={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 8) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 8) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die4;
  self.nextthink = time + 0.1;
};
void() repair_bay_die4={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 12) + (v_right * random() *32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 12) + (v_right * random() *-32) + (v_forward * random() *-32)), 1, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die5;
  self.nextthink = time + 0.1;
};
void() repair_bay_die5={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 16) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 16) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die6;
  self.nextthink = time + 0.1;
};
void() repair_bay_die6={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 20) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 20) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die7;
  self.nextthink = time + 0.1;
};
void() repair_bay_die7={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 24) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 24) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die8;
  self.nextthink = time + 0.1;
};
void() repair_bay_die8={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 28) + (v_right * random() *32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 28) + (v_right * random() *-32) + (v_forward * random() *-32)), 2, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die9;
  self.nextthink = time + 0.1;
};
void() repair_bay_die9={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 32) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 32) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die10;
  self.nextthink = time + 0.1;
};
void() repair_bay_die10={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 36) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 36) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die11;
  self.nextthink = time + 0.1;
};
void() repair_bay_die11={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 40) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 40) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die12;
  self.nextthink = time + 0.1;
};
void() repair_bay_die12={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 44) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 44) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die13;
  self.nextthink = time + 0.1;
};
void() repair_bay_die13={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 48) + (v_right * random() *32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 48) + (v_right * random() *-32) + (v_forward * random() *-32)), 3, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die14;
  self.nextthink = time + 0.1;
};
void() repair_bay_die14={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 52) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 52) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die15;
  self.nextthink = time + 0.1;
};
void() repair_bay_die15={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 56) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 56) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  
  pointsound( self.origin, "sound/fx_boom.ogg", (0.3 + random() * 0.6), ATTN_NORM);
  self.think = repair_bay_die16;
  self.nextthink = time + 0.1;
};
void() repair_bay_die16={
  makevectors(self.angles);
  te_missile_explode( (self.origin + (v_up * 60) + (v_right * random() *32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );
  te_missile_explode( (self.origin + (v_up * 60) + (v_right * random() *-32) + (v_forward * random() *-32)), 4, '1 0.7 0.1', 0.015 );

  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};
