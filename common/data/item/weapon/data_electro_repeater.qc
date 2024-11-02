/*
battleMETAL
Author: Peter Roohr
Date: 05/31/2019
Overview: 
  Data File - Item - Weapon
    Electro-Static Repeater
      Range - Short
      Consumes Energy
      hit scan
      Inaccurate
      spin up and cooldown
*/
#ifdef SSQC
// last fire time == self.count1
// cooldown check == self.count2;
// last fire rate = self.count3
// next cool check == self.count4
// reload counter = self.count
// overheat counter = self.count5
//float DATA_ESR_COOLDOWN_MAX = 2;

/*float ESR_HEAT_UP = 0.05;    //count5
float ESR_MAX_RATE = 0.09;  //count3
float ESR_RATE_UP = 0.0065;   //count3
float ESR_RATE_DN = 0.01;   //count3
float ESR_SPREAD_UP = 1.15;
float ESR_SPREAD_DN = 0.95;*/

float DATA_ESR_COOLDOWN_MAX = 2;

float ESR_HEAT_UP = 0.05;    //count5

float ESR_MAX_RATE = 0.09;  //count3
float ESR_RATE_UP = 0.003;   //count3 - was 65
float ESR_RATE_DN = 0.01;   //count3

float ESR_SPREAD_UP = 1.15; //1.15
float ESR_SPREAD_DN = 0.9;  //0.95

void() weapon_esr_think={
  local float lim;
  local float prevState;
  
  prevState = self.wepReloadState;

  //Reloading - overheated, full cooldown
  if( self.wepReloadState == RELOADING ){
    if( time > self.w_firetime ){
      if( self.w_currentammo < self.reloadMax ){
        self.w_currentammo = self.w_currentammo + ESR_HEAT_UP;
        self.w_firetime = time + 0.33;
        if( (self.owner.flags & FL_CLIENT) ){
          if( getsoundtime(self, CHAN_BODY) == -1){
            sound(self, CHAN_BODY, "sound/weapons/esr_ovrht.ogg", 1.0, ATTN_NORM);
          }
        }
      }
      else{
        self.reloadValue = 100;
        self.wepReloadState = READY;
      }
    }
  }
  else{
    //Recoil - Just fired
    if( prevState == RECOIL ){
      if( time > self.w_firetime ){
        self.wepReloadState = READY;
        self.reloadValue = 100;
      }
    }
    //Waiting - has not been fired recently, cooling down
    if( prevState == WAITING || time > self.count2 ){
      if( self.wepReloadState == WAITING ){
        //proper cool down
        if( time > self.count4 ){
          //spin down the fire rate
          self.count3 = self.count3 + ESR_RATE_DN;
          if( self.count3 > self.reloadRate ){
            self.count3 = self.reloadRate;
          }
          //unfocus the spread lens
          self.spreadDefault = self.spreadDefault * ESR_SPREAD_UP;
          if( self.spreadDefault_x > self.spreadCache_x * 4 ){
            self.spreadDefault = self.spreadCache * 4;
          }
          //take off some heat
          if( self.w_currentammo < self.reloadMax ){
            self.w_currentammo = self.w_currentammo + ESR_HEAT_UP / 3;
          }
        }
      }
      else{
        self.wepReloadState = WAITING;
        self.count4 = time + 0.1;
      }
    }
  }

  lim = self.reloadMax;
  self.reloadValue = (self.w_currentammo / lim) * 100;
  self.think = weapon_esr_think;
};

void() data_ini_attack_electro_repeater_;
#endif 

#ifdef CSQC
void() te_beam_esr={
  local float len;
  local float segCount;
  local vector bAngl;
  local float segment;
  local vector segOrg;
  local vector nexOrg;
  local float itr;
  local float width;

  segCount = 6;
  width = self.beamWidth;
  len = vlen(self.beamEnd - self.wepFireOffset);
  segment = rint(len / segCount);
  segOrg = self.wepFireOffset;

  bAngl = vectoangles(self.beamEnd - self.wepFireOffset);
  bAngl_x = bAngl_x * -1;

  makevectors(bAngl);
  if(len > 100){
    nexOrg = self.wepFireOffset + (v_forward * segment) + (v_right * crandom() * 4) + (v_up * crandom() * 6);
    Draw_CylindricLine(self.wepFireOffset, nexOrg, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 0.95, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
    
    segOrg = nexOrg;
    segCount = segCount - 2;

    for( itr = segCount; itr < segCount; itr = itr + 1){
      nexOrg = self.wepFireOffset + (v_forward * segment * itr) + (v_right * crandom() * 2) + (v_up * crandom() * 4);

      Draw_CylindricLine(segOrg, nexOrg, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 0.95, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
      
      width = max(1, width - 1);

      segOrg = nexOrg;
    }
  }
  else{
    segOrg = self.wepFireOffset;
  }
  Draw_CylindricLine(segOrg, self.beamEnd, width, "particles/electro_beam", 0.1, time * 0.1, '0.17 0.33 1.0', 0.95, DRAWFLAG_NORMAL | DRAWFLAG_MIPMAP, CLIENT_vis_org);
};
void() te_muzzle_esr={
  local vector startOrg;
  local vector endOrg;
  local vector norm;
  local float impactStyle;
  
  startOrg = self.wepFireOffset;
  endOrg = self.beamEnd;

  norm = normalize(endOrg - startOrg);
  
  sound7(self, CHAN_AUTO, self.fire_sound, 1, ATTN_NORM, (0.5 + (random() * 0.5)) * 175, 0 );
  
  if( particleDraw < PARTICLE_HAZ_DISTANCE / 2){
    pointparticles( particleeffectnum("TE_ESR_MUZZLE"), startOrg,  norm* 1, 1);

    traceline(self.wepFireOffset, self.beamEnd, FALSE, self.owner);
    impactStyle  = te_impact_type(self.beamEnd, trace_ent, trace_dphitcontents);

    if(impactStyle == IMPACT_ARMOR){
        pointparticles( particleeffectnum("TE_ESR_IMPACT_ARMOR"), endOrg, norm * -6, 1);
    }
    if(impactStyle == IMPACT_DIRT){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_DIRT"), endOrg, norm * -4, 1);
      pointparticles(PTC_HIT_DIRT_ENE_SML, endOrg, trace_plane_normal * -1, 1);
    }
    if(impactStyle == IMPACT_SHIELD){
      pointparticles( particleeffectnum("TE_ESR_IMPACT_SHIELD"), endOrg, norm * -4, 1);
    }
  }

  self.beamTime = time + 0.02;
  self.beamOrg = startOrg;
  self.beamWidth = 4.0;
  self.beamActive = TRUE;
};
#endif
void() data_ini_electro_repeater_={
  
  self.data_idx = UID_ITEM_electro_repeater;
  
  self.w_clipsize = 1;
  self.reloadRate = 0.2;
  self.reloadMax = 4;
  self.energyRate = 5;
  
  self.w_range = 850;
  self.damageValue = 12;
  self.damageType = DMG_ENE;

  self.techLevel = 2;
  self.equipSize = ENE2;

  self.spreadDefault = '0.1 0.1 0';
  self.wepFireOffset = '0 0 8'; 
  self.burstRate = 0;
  self.beamFlag = TRUE;
  
  precache_sound("sound/weapons/esr_ovrht.ogg");
#ifdef CSQC
  precache_model("models/weapons/w_esr.md3");
  precache_sound("sound/weapons/esr_fire.ogg");
  precache_file( "gfx/ui/wep_icons/wi_esr.png");
  self.w_name = "Electro-Static Repeater";
  self.fire_sound = "sound/weapons/esr_fire.ogg";
  // self.reload_sound = "sound/weapons/esr_ovrht.ogg";
  self.model = "models/weapons/w_esr.md3";
  self.abbrev = "ESR";
  self.description = "+ Instant-impact weapon. + Rate of Fire spin up/cool down. + Damage reduced by 50% against <shields>";
  self.icon = "gfx/ui/wep_icons/wi_esr.png";
  self.itemMuzzleFlash = te_muzzle_esr;
  self.effect_beam = te_beam_esr;
#endif

#ifdef SSQC
  self.reloadMaxCache = 4;
  self.w_isburst = FALSE;
  if( (self.owner.flags & FL_MONSTER) ){
    self.reloadMax = 1;
    self.energyRate = self.energyRate / 2;
    self.think = default_weapon_think;
  }
  else{
    self.think = weapon_esr_think;
  }
  
  self.w_attack = data_ini_attack_electro_repeater_;
  self.spreadCache = self.spreadDefault;
  self.damageCache = self.damageValue;
  self.count3 = self.reloadRate;
#endif
};

#ifdef SSQC
void() data_ini_attack_electro_repeater_={
  local float impactStyle;
  if( self.owner.energy <= self.energyRate ){
    self.wepReloadState = RELOADING;
    self.w_currentammo = self.reloadMax / 1.125;
    return;
  }
  
  self.wepReloadState = RECOIL;
  self.count1 = time;
  self.count2 = time + self.reloadRate * 2;
  
  self.count3 = self.count3 - ESR_RATE_UP;
  if( self.count3 < ESR_MAX_RATE ){
    self.count3 = ESR_MAX_RATE;
  }
  
  self.w_firetime = time + self.count3;

  self.spreadDefault = self.spreadDefault * ESR_SPREAD_DN;
  if( self.spreadDefault_x < self.spreadCache_x ){
    self.spreadDefault = self.spreadCache;
  }
  
  self.owner.energy = self.owner.energy - self.energyRate;
  
  self.w_currentammo = self.w_currentammo - ESR_HEAT_UP;
  if( self.w_currentammo < 0 ){
    self.wepReloadState = RELOADING;
    self.count2 = time;
    self.count3 = self.reloadRate;
    self.spreadDefault = self.spreadCache * 4;
  }
  ctrl_weapon_fireOffset();
  
  impactStyle = IMPACT_SKY;
  self.owner.attackFlag = self.owner.attackFlag | self.w_group;
  if( !(trace_dphitcontents & DPCONTENTS_SKY) && !(trace_dphitq3surfaceflags & Q3SURFACEFLAG_SKY) ){
    impactStyle = IMPACT_DIRT;

    if( trace_ent.takedamage ){
      impactStyle = IMPACT_ARMOR;
      
      if( trace_ent.shield > 0 ){
        t_damage_shield(trace_ent, self, self.owner, self.damageValue * 0.5, FIRE_ENDPOINT, FALSE);
        impactStyle = IMPACT_SHIELD;
      }
      else{
        HIT_LOCATION = t_damage(trace_ent, self, self.owner, self.damageValue, FIRE_ENDPOINT, '0 0 0');
        if( HIT_LOCATION && !(self.owner.statTargetHitParts & HIT_LOCATION) ){
          self.owner.statTargetHitParts = self.owner.statTargetHitParts | HIT_LOCATION;
        }
      }
    }
  }
  client_send_particle_rail( BEAM_ESR, num_for_edict(self), FIRE_ORIGIN, FIRE_ENDPOINT, 4,  impactStyle);
};
#endif