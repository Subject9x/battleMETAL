/*
battleMETAL
Author: Peter Roohr
Date: 9/1/2016
mod - 3/4/2017
mod - 3/16/2019
Overview: weapon controller header
*/

void(entity wep) ctrl_weapon_think={
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
      self.think = self.think;
    }
  self = weaponOwner;
};

/*
.float ai_weaponEnergy; //current max energy cost.
.float ai_attackPreviousEnergy; //cached every attack call, compared when new attack is made.
.float ai_nextFireTime; //last time this WEAPON was fired.
*/
void(entity wep) ctrl_weapon_think_ai={
  local entity weaponOwner;
  local float stackWeapon;
  local float energyCost;
  local float spreadRange;
  
  weaponOwner = self;
  stackWeapon = TRUE;
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
      self.think = self.think;
    }
    
    if( ai_valid_target( weaponOwner.enemy ) ){
      if( weaponOwner.stat_trg_dist > self.w_range ){
        stackWeapon = FALSE;
      }
      else{
        if( time < self.ai_nextFireTime ){
          stackWeapon = FALSE;
        }
        else{
          //Weapon REQUIRES a target lock to work, see if owner has a Target Lock
          if( (self.damageType & EFF_LOK) && !(weaponOwner.stat_lck_stt & LOCK_TARG_HAS) ){
            stackWeapon = FALSE;
          }
          
          if( stackWeapon ){
            //This is energy rationing to prevent the AI from trying to fire Weapons it doesn't have energy for.
            energyCost = weaponOwner.ai_weaponEnergy + self.energyRate;
            if( energyCost > weaponOwner.energy ){
              stackWeapon = FALSE;
            }
          }
          
          if( stackWeapon ){
            //If Weapon is a shield-breaked (eff-stx), only fire if the target has any amount of shielding worth breaking.
            if( (self.damageType & EFF_STX) ){
              if( self.damageValue >= (weaponOwner.enemy.shield * 1.25) ){
                stackWeapon = FALSE;
              }
            }
          }
          
          if( stackWeapon ){
            if( weaponOwner.ai_rank > AI_RANK_REG ){
              if( !(self.damageType & EFF_PTR) ){
                if( self.damageValue > 100 && !(weaponOwner.stat_lck_stt & LOCK_TARG_HAS)){
                  //magic number describing high-damage attacks.
                  spreadRange = weaponOwner.spreadDefault_x + (weaponOwner.spreadDefault_x * 0.33);
                  if( weaponOwner.accuracy >= spreadRange ){
                    stackWeapon = FALSE;
                  }
                }
              }
            }
          }
        }
      }
    }
    else{
      stackWeapon = FALSE;
    }
  
    if( stackWeapon == TRUE ){
      weaponOwner.currentWeaponGroup = weaponOwner.currentWeaponGroup | self.w_group;
      weaponOwner.ai_weaponEnergy = energyCost;
    }
  self = weaponOwner;
};

/*
  Only fires weapon if there's enough energy to do so, 
  AI ignores this, as this is filtered out in ctrl_weapon_think_ai
*/
float() ctrl_weapon_checkEnergy={
  if( self.w_currentammo == self.w_clipsize){
    if(self.energyRate && (self.owner.energy >= self.energyRate)){
      self.owner.energy = self.owner.energy - self.energyRate;
      if(self.owner.energy < 0){
        self.owner.energy = 0;
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
  if( self.aiment ){
    WEAPON_PARENT = self.aiment;
  }
  else{
    WEAPON_PARENT = FIRE_ENT;
  }
 
  makevectors( WEAPON_PARENT.angles );
  FIRE_ORIGIN = FIRE_ENT.origin + (v_forward * FIRE_OFFSET_z) + (v_right * FIRE_OFFSET_x) + (v_up * FIRE_OFFSET_y);
  FIRE_ENDPOINT = util_applySpreadToTrace( FIRE_ENT.v_angle, self.w_range, self.spreadDefault, FIRE_ENT.accuracy );//becomes 'endpoint' for shot angle
};

void( float burstFire ) ctrl_weapon_updateAmmo={
  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.reloadValue = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    if( (FIRE_ENT.flags & FL_MONSTER) ){
      self.w_firetime = time + (self.reloadRate / self.burstRate) * 2.25;
    }
    else{
      self.w_firetime = time + self.reloadRate / self.burstRate;
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
      self.damageType = theWeapon.damageType;
      self.damageValue = theWeapon.damageValue;
      theWeapon.data_ini_projectile();
      self.data_lifetime = time + self.data_lifetime;
      self.w_firetime = time + 0.5;
      self.velocity = normalize(FIRE_ENDPOINT - FIRE_ORIGIN);
      self.velocity = self.velocity * self.data_velocity;
      self.angles = vectoangles(self.velocity);
      if( updateDelay > -1 ){
        self.nextthink = time + updateDelay;
      }
      else{
        self.nextthink = time + 0.1;
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
    
    self.w_attack = SUB_Null;
    self.deadflag = DEAD_DEAD;
    self.effects = EF_NODRAW;
    setsize(self, '0 0 0', '0 0 0');
    
    if( (self.damageType & DMG_MSC) ){
      //weapon is equip, run death func which undoes the module's upgrades
      if( self.item_remove_upgrade ){
        self.item_remove_upgrade();      
      }
    }
  }
};