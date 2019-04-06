/*
battleMETAL
Author: Peter Roohr
Date: 3/21/2018
Overview: data file for the human repair bay
*/

void() building_repair_touch;

void() hrepair_th = [0, hrepair_th]{
  if( self.trigger_field.takedamage >= DAMAGE_YES){
    self.th_walk();
    return;
  }
  else{
    if(self.rl_cur < self.rl_max){
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur > self.rl_max){
        self.rl_cur = self.rl_max;
      }
    }
  }
  building_burn();
};

void() hrepair_rep = [0, hrepair_rep]{
  local float end_repair;
  end_repair = TRUE;
  if( vlen(self.trigger_field.origin - self.e_cam.origin) <= 16 ){
    local entity repairMe,fix;  
    repairMe = self.trigger_field;
    if(csqc_updateCompStat(repairMe) < 100){
      fix = repairMe;
    }
    else{
      local entity part;
      local float lowHP;
      part = repairMe.c_part;
      lowHP = 99.99;
      while(part){
        if(part.deadflag <= DEAD_NO){
          local float hp;
          hp = csqc_updateCompStat(part);
          if( hp <= lowHP){
            lowHP = hp;
            fix = part;
          }
        }
        part = part.c_part;
      }
    }
    if(fix){
      end_repair = FALSE;
      local vector fx;
      makevectors(self.angles);
      fx = self.origin + (v_up * 75) + (v_forward * -24);
      pointparticles( particleeffectnum("TE_REPAIR_MUZZLE"), fx, normalize( fix.origin - fx ) * 3, 1);
      pointparticles( particleeffectnum("TE_REPAIR_IMPACT"), fix.origin, normalize( fix.origin - fx ) * -3, 1);
      trailparticles( world, particleeffectnum("TE_REPAIR_RAIL"), fx, fix.origin);
  
      fix.health = fix.health + self.rl_rate * DAT_BLD_H_REPAIR_RL_RATIO;
      self.rl_cur = self.rl_cur - (self.rl_rate * self.trigger_field.vec_size);
      if(fix.health >= fix.max_health){
        fix.health = fix.max_health;
        if( fix.comp_id == M_LEGS ){
          if( (fix.flags & FL_DISARMED) ) {
            fix.flags = fix.flags - (fix.flags & FL_DISARMED);
            fix.owner.m_fspeed = fix.m_fspeed;
            fix.owner.m_bspeed = fix.m_bspeed;
            fix.owner.m_sspeed = fix.m_sspeed;
            fix.owner.m_maccel = fix.m_maccel;
          }
        }
      }
      self.trigger_field.stat_plr_rep = (self.rl_cur / self.rl_max);
    }
  }
  if(end_repair){
    if( (self.trigger_field.flags & FL_CLIENT) ){
      centerprint(self.trigger_field, "[Repairs complete]\n");
    }
    self.trigger_field.stat_plr_rep = -1;
    self.trigger_field.repair_request = FALSE;
    self.trigger_field = world;
    self.th_stand();
    return;
  }
};

void() hrepair_die = [0, hrepair_die1]{
  //fire triggers when dead
  trigger_event( self, trigOnDeath );
  
  self.takedamage = DAMAGE_NO;
  self.deadflag = DEAD_DYING;
  self.solid = SOLID_CORPSE;
  building_die_removeFire();
};
void() hrepair_die1 = [1, hrepair_die2]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die2 = [2, hrepair_die3]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die3 = [3, hrepair_die4]{};
void() hrepair_die4 = [4, hrepair_die5]{};
void() hrepair_die5 = [5, hrepair_die6]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die6 = [6, hrepair_die7]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die7 = [7, hrepair_die8]{};
void() hrepair_die8 = [8, hrepair_die9]{};
void() hrepair_die9 = [9, hrepair_die10]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die10 = [10, hrepair_die11]{
  te_object_explode( '0.75 0.75 0.6' );};
void() hrepair_die11 = [11, BecomeExplosion]{
  te_object_explode( '0.75 0.75 0.6' );
  
};

void() building_human_repair={
  self.data_idx = ID_BLD_H_REPAIR;
  self.data_type = DATA_BLD;
  self.vec_name = "Repair Bay";
  self.flags = self.flags | (FL_MONSTER | FL_UNIT);
  self.vec_size = 3;
  util_setModel(DAT_BLD_H_REPAIR_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_YES, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_REPAIR_HP, DAT_BLD_H_REPAIR_HP, 1, 100) ;
  setsize(self, '-53 -53 0', '53 53 40');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_REPAIR_SH_MAX;
  self.sh_rate= DAT_BLD_H_REPAIR_SH_RATE;
  self.rl_cur = DAT_BLD_H_REPAIR_RL_MAX;
  self.rl_rate = DAT_BLD_H_REPAIR_RL_RATE;
  self.rl_max = DAT_BLD_H_REPAIR_RL_MAX;
  self.deadflag = DEAD_NO;
  
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  self.movetype = MOVETYPE_NONE;
  self.nextthink = time + 0.1;
  self.use = multi_trigger;
  
  if(util_cornerSlopeCheck(self, 1)){
    util_generateBuildingFoundation(self);
  }
  makevectors(self.angles);
  self.c_ofs = self.origin + (v_forward * -20) + (v_up * 30) + (v_right * 4);
  local entity repairNode, this;
  this  = self;
  repairNode = spawn();
  repairNode.effects = repairNode.effects | EF_NODRAW;
  repairNode.touch = building_repair_touch;
  repairNode.deadflag = DEAD_NO;
  repairNode.trigger_field = world;
  repairNode.owner = this;
  this.e_cam = repairNode;
  self = repairNode;
    util_setModel("q3mdl/testball.md3", repairNode.skin, 0) ;
    util_setCollider(FALSE, SOLID_TRIGGER, MOVETYPE_NONE) ;
    util_setHealthArmor(0, 0, 0, 0) ;
  self = this;
  setsize(repairNode, '-16 -16 -24', '16 16 32');
  setorigin(repairNode, this.c_ofs);
  
  self.th_die = hrepair_die;
  self.th_stand = hrepair_th;
  self.th_walk = hrepair_rep;
  hrepair_th();
};

void() building_repair_think={
};

void() building_repair_touch={
  if( vlen(other.origin - self.origin) <= 32){
    if(self.owner.rl_cur > 0){
      if(other.data_type == DATA_MECH){
        if(other.i_faction == self.owner.i_faction){
          if(util_getMechHpAverage(other) < 1){
            if( (other.flags & FL_CLIENT) ){
              centerprint( other, "[Press 'E' to start REPAIR]\n");
            }
            if(other.repair_request){
              self.owner.trigger_field = other;
              other.velocity = '0 0 0';
              other.avelocity = '0 0 0';
              other.v_angle = self.owner.angles;
              other.angles = self.owner.angles;
            }
          }
        }
      }
    }
  }
  return;
};

void() building_repair_die={
  self.e_cam.trigger_field = world;
  remove(self.e_cam);
  building_die();
};