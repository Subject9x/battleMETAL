/*
battleMETAL
Author: Peter Roohr
Date: 9/1/2016
mod - 3/4/2017
mod - 3/16/2019
Overview: weapon controller header
*/

void(entity wep) ctrl_wpn_think={
  local entity weaponOwner;
  weaponOwner = self;
  self = wep;
    if(self.deadflag >= DEAD_DYING){
      self.deadflag = DEAD_DEAD;
      self = weaponOwner;
      return;
    }
    if(self.deadflag == DEAD_DEAD){
      self = weaponOwner;
      return;
    }  
    if( self.think ){
      self.think();
      if( (weaponOwner.flags & FL_CLIENT) ){
        if(self.w_isready){
          ctrl_weapon_isReady(self, self.stat_wep_rel);
        }else{
          ctrl_weapon_isReload(self, self.stat_wep_rel);
        }
      }
      self.think = self.think;
    }
  self = weaponOwner;
};

float() ctrl_weapon_checkEnergy={
  if( self.w_currentammo ==  self.w_clipsize){
    if(self.en_rate && (self.owner.en_cur >= self.en_rate)){
      self.owner.en_cur = self.owner.en_cur - self.en_rate;
      if(self.owner.en_cur < 0){
        self.owner.en_cur = 0;
      }
    }
    else{
      return FALSE;
    }
  }
  return TRUE;
};


void() ctrl_weapon_fireOffset={
  FIRE_ENT = self.owner; 
  FIRE_OFFSET = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  if( self.c_part ){
    WEAPON_PARENT= self.c_part;
  }
  else{
    WEAPON_PARENT = FIRE_ENT;
  }
 
  makevectors( WEAPON_PARENT.angles );
  FIRE_ORIGIN = FIRE_ENT.origin + (v_forward * FIRE_OFFSET_z) + (v_right * FIRE_OFFSET_x) + (v_up * FIRE_OFFSET_y);
  FIRE_ENDPOINT = util_applySpreadToTrace( FIRE_ENT.v_angle, self.w_range, self.spreadDefault, FIRE_ENT.accuracy );//becomes 'endpoint' for shot angle
};

void( float burstFire, float burstRate ) ctrl_weapon_updateAmmo={
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    if( (FIRE_ENT.flags & FL_MONSTER) ){
      self.w_firetime = time + (self.rl_rate / burstRate) * 2.25;
    }
    else{
      self.w_firetime = time + self.rl_rate / burstRate;
    }
    self.w_state = RECOIL;
    self.w_isburst = burstFire;
  }
};

void( float updateDelay ) ctrl_weapon_make_projectile={
  local entity theWeapon;
  if( self.data_ini_projectile ){
    theWeapon = self;
    NEWSHOT = spawn();
    self = NEWSHOT;
      self.owner = FIRE_ENT;
      self.p_dmgtype = theWeapon.p_dmgtype;
      self.p_damage = theWeapon.p_damage;
      theWeapon.data_ini_projectile();
      self.p_lifetime = time + self.p_lifetime;
      self.w_firetime = time + 0.5;
      self.velocity = normalize(FIRE_ENDPOINT - FIRE_ORIGIN);
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
      if( updateDelay > -1 ){
        self.nextthink = time + updateDelay;
      }
      else if( updateDelay == -1 ){
        self.nextthink = time + self.p_lifetime;
      }
      util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
      util_setModel(self.model, 0, 0);
      setsize(self, '0 0 0', '0 0 0');
      setorigin(self, FIRE_ORIGIN);
    self = theWeapon;
  }
  else{
    if( cvar("developer") ){
      cons_logAString("[Error]", "data_ini_projectile() not defined");  //DEBUG
    }
  }
};

//gross
void(entity wep, float wstate) ctrl_weapon_addState={
  if(!(wep.owner.stat_wep_state & wstate)){
    wep.owner.stat_wep_state = wep.owner.stat_wep_state | wstate;
  }
};

void(entity wep, float wstate) ctrl_weapon_subState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & wstate);
};

void(entity wep, float state1, float state2) ctrl_weapon_clearState={
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state1);
  wep.owner.stat_wep_state = wep.owner.stat_wep_state - (wep.owner.stat_wep_state & state2);
};

void(entity wep, float wstate) ctrl_weapon_isReload={
  if(!(wep.owner.stat_wep_rel & wstate)){
    wep.owner.stat_wep_rel = wep.owner.stat_wep_rel | wstate;
  }
};

void(entity wep, float wstate) ctrl_weapon_isReady={
  wep.owner.stat_wep_rel = wep.owner.stat_wep_rel - (wep.owner.stat_wep_rel & wstate);
};

void() ctrl_die_weapon={
  if(self.deadflag <= DEAD_NO){
    local entity oself;
    oself = self;
    newmis = spawn();
    self = newmis;
      setorigin(newmis, oself.origin);
      BecomeExplosion();//TODO - replace with te_explosion
    self = oself;
    if((oself.currentWeaponGroup & self.w_group)){
      oself.currentWeaponGroup = oself.currentWeaponGroup - (oself.currentWeaponGroup & self.w_group);
      self.w_group = 0;
    }
    if((self.owner.flags & FL_CLIENT)){
      ctrl_weapon_subState(self, self.state_1);
      ctrl_weapon_addState(self, self.state_2);
    }
    else{
      ai_wep_calcranges();
    }
    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    
    if( (self.p_dmgtype & DMG_MSC) ){
      //weapon is equip, run death func which undoes the module's upgrades
       self.unit_wep1();
    }
  }
};