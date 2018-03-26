/*
mech Mod
Author: Peter Roohr
Date: 3/21/2018
Overview: data file for the human repair bay
*/

/*QUAKED building_repair (.1 .1 .1) (-72 -72 -40) (72 72 40)
*/
void() building_repair_die;
void() building_repair_touch;
void() building_repair_think;
void() building_repair;

void() building_repair={
  self.data_idx = ID_BLD_H_REPAIR;
  self.data_type = DATA_BLD;
  self.vec_name = "Repair Bay";
  self.flags = self.flags | FL_MONSTER;
  util_setModel(DAT_BLD_H_REPAIR_MODEL, self.skin, 0) ;
  util_setCollider(DAMAGE_AIM, SOLID_BSP, MOVETYPE_NONE) ;
  util_setHealthArmor(DAT_BLD_H_REPAIR_HP, DAT_BLD_H_REPAIR_HP, 1, 100) ;
  util_setBoundBox('-72 -72 -40', '72 72 40');
  self.sh_cur= 0;
  self.sh_max= DAT_BLD_H_REPAIR_SH_MAX;
  self.sh_rate= DAT_BLD_H_REPAIR_SH_RATE;
  self.scale = 1;
  self.rl_cur = DAT_BLD_H_REPAIR_RL_MAX;
  self.rl_rate = DAT_BLD_H_REPAIR_RL_RATE;
  self.rl_max = DAT_BLD_H_REPAIR_RL_MAX;
  self.deadflag = DEAD_NO;
  
  setorigin(self, util_dropToGround(self.angles, self.origin, (self.mins_z + 4)));
  droptofloor();
  
  self.movetype = MOVETYPE_NONE;
  self.th_die = building_repair_die;
  self.think = building_repair_think;
  self.nextthink = time + 0.1;
  self.use = multi_trigger;
  self.SendEntity = send_building;
  self.SendFlags = -1;
  makevectors(self.angles);
  self.c_ofs = self.origin + (v_forward * 35) + (v_up * -3) + (v_right * 5);
  local entity nde, this;
  this  = self;
  nde = spawn();
  self = nde;
    util_setModel("q3mdl/testball.md3", self.skin, 0) ;
    util_setCollider(DAMAGE_NO, SOLID_TRIGGER, MOVETYPE_NONE) ;
    util_setHealthArmor(0, 0, 0, 0) ;
    util_setBoundBox('-8 -8 -8', '8 8 8');
    setorigin(self, this.c_ofs);
    self.effects = self.effects | EF_NODRAW;
    self.touch = building_repair_touch;
    self.deadflag = DEAD_NO;
    self.trigger_field = world;
    self.owner = this;
  self = this;
  this.e_cam = nde;
};

void() building_repair_think={
  if(self.rl_cur < self.rl_max){
    self.rl_cur = self.rl_cur + self.rl_rate;
    if(self.rl_cur > self.rl_max){
      self.rl_cur = self.rl_max;
    }
  }
  if( self.trigger_field != world ){
    if( (vlen(self.trigger_field.origin - self.e_cam.origin) > 16) ){
      self.trigger_field.repair_request = FALSE;
      self.trigger_field = world;
    }
    else{
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
        local vector fx;
        makevectors(self.angles);
        fx = self.origin + (v_forward * 45) + (v_up * 40);
        te_beam_laser(fx, fix.origin);
        
        fix.health = fix.health + self.rl_rate * DAT_BLD_H_REPAIR_RL_RATIO;
        self.rl_cur = self.rl_cur - self.rl_rate;
        if(fix.health > fix.max_health){
          fix.health = fix.max_health;
        }
      }
      else{
        if( (self.trigger_field.flags & FL_CLIENT) ){
          centerprint(self.trigger_field, "[Repairs complete]\n");
        }
        self.trigger_field.power_timer = time + 2;
        self.trigger_field = world;
      } 
    }
  }
  
  self.think = building_repair_think;
  self.nextthink = time + 0.1;
};

void() building_repair_touch={
  if( vlen(other.origin - self.origin) <= 16){
    if(self.owner.rl_cur > 0){
      if(other.data_type == DATA_MECH){
        if(other.i_faction == self.owner.i_faction){
          if(util_getMechHpAverage(other) < 1){
            if(self.owner.trigger_field == world){ 
              if( (other.flags & FL_CLIENT) ){
                centerprint( other, "[Hold 'E' to REAPIR]\n");
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
  }
  return;
};


void() building_repair_die={
  self.e_cam.trigger_field = world;
  remove(self.e_cam);
  building_die();
};