/*
mech Mod
Author: Peter Roohr
Date: 01/20/2018
overiew: Ion Coil - a lighter ION cannon, 3-rnd burst
*/
//ION COIL GUN=======================

float DAT_ION_HPX = 200;

void() data_ion_atk;  //the actual attack call
void() data_ion_think;

void() data_ion_ini={
  self.data_idx = ID_WEP_ION;
  self.w_name = DAT_ION_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_ION_CLIPSIZE;
  self.w_currentammo = DAT_ION_CLIPSIZE;
  self.w_fire_ofs = DAT_ION_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_ION_MODEL;
  self.w_attack = data_ion_atk;
  self.w_proj = DAT_ION_PROJ_ID;
  self.rl_cur = DAT_ION_RL_MAX;
  self.rl_rate = DAT_ION_RL_RATE;
  self.rl_max = DAT_ION_RL_MAX;
  self.en_rate = DAT_ION_EN_RATE;
  self.fire_sound = DAT_ION_FIRESOUND;
  self.i_techlvl = DAT_ION_TECH_LEVEL;
  self.i_size = DAT_ION_WSIZE;
  self.w_think = data_ion_think;
  self.health = DAT_ION_HPX;
  self.max_health = DAT_ION_HPX;
  self.p_dmgtype = self.p_dmgtype | DMG_ENE | EFF_STX;
  self.w_range = DAT_ION_RANGE;
  self.w_state = READY;
  self.p_damage = DAT_ION_DMG;
  self.w_isburst = FALSE;
};

void() data_ion_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - self.en_rate;
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur >= self.rl_max){
        self.rl_cur = self.rl_max;
        self.w_state = READY;
      }
    }
  }
};

void() data_ion_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  local vector dir, org, end, adj;
  
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
  }
  else{
    if((player.flags & FL_MONSTER)){
      self.w_firetime = time + self.rl_rate;    
    }
    else{
      self.w_firetime = time + self.rl_rate * 1.5;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    util_setModel(self.c_model, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setBoundBox('0 0 0', '0 0 0');
    self.velocity = normalize(dir - org);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.p_lifetime = time + self.p_lifetime;
    self.w_firetime = time + 0.5;
    setorigin(self, org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
    self.think = data_prj_ion_think;
    self.nextthink = time + 0.01;
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};