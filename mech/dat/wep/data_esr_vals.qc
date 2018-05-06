/*
mech Mod
Author: Peter Roohr
Date: 02/26/2017
Overview: 
*/
//Electro static Rifle=======================
float DAT_ESR_HPX = 150; 

void() data_esr_atk;
void() data_esr_think;

void() data_esr_ini={
  self.data_idx = ID_WEP_ESR;
  self.w_name = DAT_ESR_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_ENE;
  self.p_damage = DAT_ESR_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_ESR_CLIPSIZE;
  self.w_currentammo = DAT_ESR_CLIPSIZE;
  self.w_fire_ofs = DAT_ESR_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ESR_MODEL;
  self.w_attack = data_esr_atk;
  self.rl_cur = DAT_ESR_RL_MAX;
  self.rl_rate = DAT_ESR_RL_RATE;
  self.rl_max = DAT_ESR_RL_MAX;
  self.en_rate = DAT_ESR_EN_RATE;
  self.fire_sound = DAT_ESR_FIRESOUND;
  self.i_techlvl = DAT_ESR_TECH_LEVEL;
  self.i_size = DAT_ESR_WSIZE;
  self.w_think = data_esr_think;
  self.health = DAT_ESR_HPX;
  self.max_health = DAT_ESR_HPX;
  self.w_range = DAT_ESR_RANGE;
  self.stat_spr_x = DAT_ESR_SPR_X;
  self.stat_spr_y = DAT_ESR_SPR_Y;
  self.w_state = READY;
  self.w_isburst = FALSE;
};

void() data_esr_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){ 
      self.rl_cur = 100;
      self.w_state = READY;
    }
    else{
      local float delta, max;
      delta = time - self.count1;
      max = self.rl_max;      
      self.rl_cur = (delta / max) * 100;
    }
  }
};

void() data_esr_atk={
  local entity cam, player, oself, proj;
  local vector spr;
	local vector dir,org, end, adj;
  player = self.owner;
  
  if( self.w_currentammo == self.w_clipsize){
    if(self.en_rate && (player.en_cur >= self.en_rate)){
      player.en_cur = player.en_cur - self.en_rate;
      if(player.en_cur < 0){
        player.en_cur = 0;
      }
    }
    else{
      return;
    }
  }
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = ai_attack_calcSpread(player); 
  }
  dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
  
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
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + (self.rl_rate/200) * 2;
    }
    else{
      self.w_firetime = time + self.rl_rate/200;
    }

    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }

  local entity laser_org, this;
  t_damage(trace_ent, self, player, self.p_damage, DMG_ENE, dir, '0 0 0');

  this = self;
  laser_org = spawn();
  self = laser_org;
    self.movetype = SOLID_NOT;
    self.classname = "missile";
    makevectors(this.angles);
    this.fx_origin = this.fx_origin + (v_forward*2);
    setorigin(self, this.fx_origin);
    setsize(self, '0 0 0', '0 0 0');
    self.scale = 1;
    self.think = SUB_Remove;
    self.nextthink = time + 0.01; //0.01
  self = this;
  sound (laser_org, CHAN_WEAPON, self.fire_sound, 1, ATTN_NORM);
  
  te_beam_esr(laser_org.origin, dir);
  
  te_flamejet(dir, '0 15 0', 5);
  te_customflash(dir, 4, 10, '0 0 1');
};
