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
    if( self.think && self.think != SUB_Remove){
      self.think();
      self.think = self.think;
    }
    
    if( weaponOwner.enemy ){
      if( weaponOwner.stat_trg_dist > self.w_range ){
        stackWeapon = FALSE;
      }
      else{
        if( time < self.ai_nextFireTime ){
          stackWeapon = FALSE;
        }
        else{
          //Weapon REQUIRES a target lock to work, see if owner has a Target Lock
          if( (self.damageType & EFF_LOK) && !(weaponOwner.targLockState & LOCK_TARG_HAS) ){
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
                if( self.damageValue > 100 && !(weaponOwner.targLockState & LOCK_TARG_HAS)){
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
  FIRE_OFFSET = self.compOffset + self.wepFireOffset + self.compAltOffset;    //complete offset from player origin
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
    self.wepReloadState = RELOADING;
    self.w_isburst = FALSE;
    self.w_firetime = time + self.reloadMax;
    self.count1 = time;
  }
  else{
    if( (FIRE_ENT.flags & FL_MONSTER) ){
      self.w_firetime = time + (self.reloadRate / self.burstRate) * 1.67;
    }
    else{
      self.w_firetime = time + self.reloadRate / self.burstRate;
    }
    self.wepReloadState = RECOIL;
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
      self.data_idx = theWeapon.data_idx; //use weapon idx to sync to CSQC
      self.data_lifetime = time + self.data_lifetime;
      self.w_firetime = time + 0.5;
      self.velocity = normalize(FIRE_ENDPOINT - FIRE_ORIGIN);
      self.velocity = self.velocity * self.data_velocity;
      self.angles = vectoangles(self.velocity);
      if( updateDelay > -1 ){
        self.nextthink = time + updateDelay;
      }
      else{
        if( cvar("gamemode") == GAMEMODE_CAMPAIGN ){
          self.nextthink = time + 0.01;
        }
        else{
          self.nextthink = time + 0.033;  //network compromise
        }
      }
      if( !self.movetype ){
        self.movetype = MOVETYPE_FLYMISSILE;
      }
      if( !self.solid ){
        self.solid = SOLID_BBOX;
      }
      self.takedamage = DAMAGE_NO;
      setmodel(self, "q3mdl/testball.md3");
      setsize(self, '0 0 0', '0 0 0');
      setorigin(self, FIRE_ORIGIN);
      self.SendEntity = te_send_missile;
      self.SendFlags = self.SendFlags | (SENDFLAG_MOVE | SENDFLAG_VELOCITY);
    self = theWeapon;
  }
  else{
    if( cvar("developer") ){
      cons_logAString("[Error]", "data_ini_projectile() not defined");  //DEBUG
    }
  }
};

/*
  Cosmetic death function, weapon entity is still 'active' on the server.
*/
void() ctrl_die_weapon={
  local entity prev;
  if(self.deadflag == DEAD_NO){
    self.deadflag = DEAD_DEAD;
    
    if( (self.damageType & DMG_MSC) ){
      //weapon is equip, run death func which undoes the module's upgrades
      if( self.item_remove_upgrade ){
        self.item_remove_upgrade();
      }
    }
    //attempt to garbage collect AI
    if( (self.owner.flags & FL_MONSTER) ){
      if( self.w_slot ){
        prev = self.partPrev;
        prev.w_slot = self.w_slot; //take hard point out of rotation.
        prev.w_slot.partPrev = prev;
      }
      self.think = SUB_Remove;
      self.nextthink = time + 0.01;
    }
  }
};

/*
  called to remove all hardpoints from a Unit, carefully.
*/
void() ctrl_weapon_remove_all={
  local entity removeChain;
  //call remove() in list order, no going back from this.
  
  for( removeChain = self.w_slot; removeChain != world; removeChain = removeChain.w_slot ){
    removeChain.think = SUB_Remove;
    removeChain.nextthink = time + 0.01;
  }
};

/*
  Dud missiles - edge case, fail state.
    When a missile misses its target, and its lifetime expires.
    
    missiles becomes dud, falls to ground over arc, dealing a fraction of damage
*/
void() ctrl_missile_dud={
  self.movetype = MOVETYPE_TOSS;
  self.gravity = 0.33;
  self.traileffectnum = 0;
  self.velocity = self.velocity * 0.67;
  self.angles = vectoangles(self.velocity);
  self.touch = ctrl_missile_dud_touch;
  self.think = SUB_Remove;
  self.nextthink = time + 10;
};

void() ctrl_missile_dud_touch={
  self.solid = SOLID_NOT;
	if ( pointcontents(self.origin) == CONTENT_SKY){
		return;
	}
  if(other.takedamage){
    t_damage(other, self, self.owner, self.damageValue * 0.05, self.origin, '0 0 0');
  }
  remove(self);
};

/*
  binds a Weapon's reloadValue to correct ADDSTAT() of the player.
  
  This was a conscious reversion to older logic, why?
    1) standing up ANY weapon reload logic on the clientside was a lot of extra work.
    2) given how diverse a weapon's reload logic COULD be, its better just to send 1
      single state value.
    3) only alternative would be to add more data sent for player's SENDFLAG_ATTACK
      Writes, and that isn't really a big gain.
*/
void(entity wep) ctrl_weapon_update_player={
  local float netValue;
  netValue = wep.reloadValue;
  if( (wep.damageType & DMG_MSC) ){
    return;
  }
  if( wep.deadflag != DEAD_NO ){
    netValue = 0;
  }
  switch( wep.w_group ){
    case WEAPON1:
      self.statWeaponReload1 = netValue;
      break;
    case WEAPON2:
      self.statWeaponReload2 = netValue;
      break;
    case WEAPON3:
      self.statWeaponReload3 = netValue;
      break;
    case WEAPON4:
      self.statWeaponReload4 = netValue;
      break;
    case WEAPON5:
      self.statWeaponReload5 = netValue;
      break;
    case WEAPON6:
      self.statWeaponReload6 = netValue;
      break;
    case WEAPON7:
      self.statWeaponReload7 = netValue;
      break;
    case WEAPON8:
      self.statWeaponReload8 = netValue;
      break;
    case WEAPON9:
      self.statWeaponReload9 = netValue;
      break;
  }
};

/*
  called after projectile impacts something, gives the server 1 extra frame to send
  any state data before calling removal.
*/
void() ctrl_missile_lastframe={

  self.SendFlags = self.SendFlags | SENDFLAG_IMPACT | SENDFLAG_MOVE;
  self.velocity = self.avelocity = '0 0 0';
  self.alpha = 0.0;
  self.effects = 0;

  self.think = SUB_Remove;
  self.nextthink = time + 0.01;
};