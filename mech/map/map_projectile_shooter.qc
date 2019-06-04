/*
battleMETAL
Author: Peter Roohr
Date: 11/16/2018
Overview: 
  Mostly for debug, but could be handy in-general.
  Projectile Shooter that uses weapons-fire.
  
Inputs
  .data_idx = <float> [weapon id] - the weapon to use
  .count = <float> [particle amount] - set a max number of shots
  .count3 = <float> [rate of fire] - interval to try next shot;
  .p_lifetime = <float> - time to live, use with spawnflags[2]
  .wait = <float> - recharge delay - how long to wait before reactivating, use with spawnflags[4]
  
  .spawnflags = <float> [flag] 1 - START_OFF - only activated by trigger
  .spawnflags = <float> [flag] 2 - lifetime
  .spawnflags = <float> [flag] 4 - reactivate after countdown
  .spawnflags = <float> [flag] 8 - remove after first countdown
  .spawnflags = <float> [flag] 16 - draw the whole weapon model
  .spawnflags = <float> [flag] 32 - use limited number of shots
*/

void() map_projectile_shooter_use={
  

  if( (self.spawnflags & 4) ){
    if( time < self.nextthink ){
      //prevent multi-fire while cooling down
      return;
    }
  }
  self.w_attack();
  
};

void() map_projectile_shooter_think={
  
  map_projectile_shooter_use();
  self.en_cur = 100000;
  self.w_state = READY;
  self.rl_cur = self.rl_max;
  self.w_currentammo = self.w_clipsize;
  
  self.think = map_projectile_shooter_think;
  self.nextthink = time + self.count3;
  
  if( (self.spawnflags & 32) ){
    //use shot counter
    self.count = self.count - 1;
    if( self.count <= 0 ){
      if( (self.spawnflags & 4) ){
        //reactivate soon
        self.isActive = FALSE;
        self.nextthink = time + self.wait;
      }
      else{
        //out of shots, remove me
        remove(self.w_slot);
        self.isActive = FALSE;
        self.think = SUB_Remove;
        self.nextthink = time + 0.1;
        return;
      }
    }
  }
  
  if( (self.spawnflags & 2) ){
    if( time > self.count2 ){
      //lifetime hit
      if( (self.spawnflags & 8) ){
        //remove on first countdown end
        remove(self.w_slot);
        self.think = SUB_Remove;
        self.nextthink = time + 0.1;
        return;
      }
      if( (self.spawnflags & 4) ){
        //reactivate soon
        self.isActive = FALSE;
        self.nextthink = time + self.wait;
      }
    }
  }
};

/*QUAKED map_projectile_shooter (0.01 0.01 0.01)
*/
void() map_projectile_shooter={
  
  self.owner = self;  //haha what
  self.owner.enemy = self;
  self.owner.angles = self.angles;
  self.owner.v_angle = self.angles;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;

  initialize_data_item_( self.data_idx );
  self.rl_cur = 100; // bug fix - weapon reload indicator not starting at correct value
  self.en_cur = 10000;  //never run out of energy
  self.owner.stat_rdr_mode = TRUE;
  self.isActive = TRUE;
  self.rl_max = self.count3;
  self.owner.stat_lck_stt = self.owner.stat_lck_stt | LOCK_TARG_HAS;
  
  if( (self.flags & FL_MONSTER) ){
    self.p_damage = ai_pilot_mod_damage( skill, self.p_damage);
    if(self.w_clipsize > 1){
      self.w_firerate = self.w_firerate * AI_WEAPON_RPS_MOD;
    }
  }

  if( (self.p_dmgtype & DMG_MSC) ){
    self.w_think = SUB_Null;
  }
  self.th_die = ctrl_die_weapon;
  self.stat_wep_rel = WEAPON1_REL;
  
  //setmodel( self, self.c_model ); //gah, code can't correct for inverse pitch of model angle
  setsize( self, self.mins, self.maxs );
  setorigin( self, self.origin );
  
  if( (self.spawnflags & 16) ){
    newmis = spawn();
    setmodel( newmis, self.c_model );
    setsize( newmis, VEC_ORIGIN, VEC_ORIGIN );
    setorigin( newmis, self.origin );
    newmis.angles = self.angles;
    newmis.angles_x = newmis.angles_x * -1;
    self.w_slot = newmis;
  }
  
  //validate limited-use
  if( (self.spawnflags & 32) ){
    if( !self.count ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 32);
    }
  }
  
  //validate reactivate timer
  if( (self.spawnflags & 4) ){
    if( !self.wait ){
      self.spawnflags = self.spawnflags - (self.spawnflags & 4);
    }
  }
  
  //default interval
  if( !self.count3 ){
    self.count3 = 0.05;
  }
  
  if( (self.spawnflags & 1) ){
    //START_OFF
    self.isActive = FALSE;
    return;
  }

  self.think = map_projectile_shooter_think;
  self.count2 = time + self.p_lifetime;
  self.nextthink = time + self.count3;
};