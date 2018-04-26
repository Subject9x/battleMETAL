/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
float DAT_MLGD_HPX = 125;

void() data_mlgd_atk;
void() data_mlgd_think;

void() data_mlgd_ini={
  self.data_idx = ID_WEP_MLGD;
  self.w_name = DAT_MLGD_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_MLGD_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_MLGD_CLIPSIZE;
  self.w_currentammo = DAT_MLGD_CLIPSIZE;
  self.w_fire_ofs = DAT_MLGD_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_MLGD_MODEL;
  self.w_attack = data_mlgd_atk;
  self.w_proj = DAT_MLGD_PROJ_ID;
  self.rl_cur = DAT_MLGD_RL_MAX;
  self.rl_rate = DAT_MLGD_RL_RATE;
  self.rl_max = DAT_MLGD_RL_MAX;
  self.en_rate = DAT_MLGD_EN_RATE;
  self.fire_sound = DAT_MLGD_FIRESOUND;
  self.i_techlvl = DAT_MLGD_TECH_LEVEL;
  self.i_size = DAT_MLGD_WSIZE;
  self.w_think = data_mlgd_think;
  self.health = DAT_MLGD_HPX;
  self.max_health = DAT_MLGD_HPX;
  self.w_range = DAT_MLGD_RANGE;
  self.w_isburst = FALSE;
};

void() data_mlgd_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.rl_cur = 100;
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(time > self.w_firetime){
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

void() data_mlgd_atk={
  local entity player, proj, cam, oself;
  local vector dir, org, end, adj;
  player = self.owner;
  
  if( self.w_currentammo ==  self.w_clipsize){
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
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.rl_rate;
    self.w_state = RECOIL;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.owner = player;
    data_iniProjectile(oself.w_proj);
    self.p_dmgtype = oself.p_dmgtype;
    self.p_damage = oself.p_damage;
    self.velocity = normalize(dir - org);
    self.think = data_prj_mlgd_th;
    self.nextthink = time + 0.05;
    self.p_lifetime = time + self.p_lifetime;
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    util_setModel(self.c_model, 0, 0);
    util_setBoundBox('0 0 0', '0 0 0');
    setorigin(self, org);
    self.velocity = self.velocity * self.p_velocity;
    self.angles = vectoangles(self.velocity);
  self = oself;
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
};