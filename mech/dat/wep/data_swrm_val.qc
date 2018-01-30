/*
mech Mod
Author: Peter Roohr
Date: 01/21/2018
Overview: weapon data file for the Swarm Missile launcher
*/
//Swarm Missile Launcher=======================


float DAT_SWRM_HPX = 150; 

void() data_swrm_atk;
void() data_swrm_think;

void() data_swrm_ini={
  self.data_idx = ID_WEP_SWRM;
  self.w_name = DAT_SWRM_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_SWRM_CLIPSIZE;
  self.w_currentammo = DAT_SWRM_CLIPSIZE;
  self.w_fire_ofs = DAT_SWRM_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_SWRM_MODEL;
  self.w_attack = data_swrm_atk;
  self.w_think = data_swrm_think;
  self.w_proj = DAT_SWRM_PROJ_ID;
  self.rl_cur = DAT_SWRM_RL_MAX;
  self.rl_rate = DAT_SWRM_RL_RATE;
  self.rl_max = DAT_SWRM_RL_MAX;
  self.en_rate = DAT_SWRM_EN_RATE;
  self.fire_sound = DAT_SWRM_FIRESOUND;
  self.i_techlvl = DAT_SWRM_TECH_LEVEL;
  self.stat_spr_x = DAT_SWRM_SPR_X;
  self.stat_spr_y = DAT_SWRM_SPR_Y;
  self.i_size = DAT_SWRM_WSIZE;
  self.health = DAT_SWRM_HPX;
  self.max_health = DAT_SWRM_HPX;
  self.w_range = DAT_SWRM_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_SWRM_DMG;
};

void() data_swrm_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    self.rl_cur = self.rl_cur + self.rl_rate;
    if(self.rl_cur >= self.rl_max){
      self.rl_cur = self.rl_max;
      self.w_state = READY;
    }
  }
};

void() data_swrm_atk={
  local entity player, proj, cam, oself;
  local vector dir, org, end, adj;
  local float randx, randy;
  
  player = self.owner;
  if(!player.stat_rdr_mode){
    //only fires if radar is on
    return;
  }
  
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI(player, self.w_range, player.ai_leading);
    if((player.flags & FL_MONSTER)){
      if(end == player.origin){
        player.patience = player.patience + 1;
        return;
      }
    }
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
      self.w_firetime = time + ((self.rl_rate / 3) / 10);
    }
    else{
      self.w_firetime = time + self.rl_rate * 2;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  randy = adj_y + (crandom() * (random() * self.stat_spr_y));
  randx = adj_x + (crandom() * (random() * self.stat_spr_x));
  org = player.origin + (v_up * randy) + (v_right * randx) + (v_forward*adj_z);
  
  local entity targs;
  targs = findradius(player.origin, self.w_range);
  while(targs){
    if((targs.flags & FL_CLIENT) || (targs.flags & FL_MONSTER)){
      if(targs.deadflag == DEAD_NO){
        if(ai_target_infront(targs) && targs!=player){
          local entity mis;
          mis = spawn();
          oself = self;
          self = mis;
            self.owner = player;
            data_iniProjectile(oself.w_proj);
            util_setModel(self.c_model, 0);
            util_setCollider(0, SOLID_BBOX, MOVETYPE_BOUNCE);
            util_setBoundBox('0 0 0', '0 0 0');
            self.p_dmgtype = oself.p_dmgtype;
            self.p_damage = oself.p_damage;
            self.enemy = targs;
            self.p_lifetime = time + self.p_lifetime;
            self.touch = data_prj_swrm_touch;
            self.velocity = normalize(targs.origin - org);
            self.velocity = self.velocity * self.p_velocity;
            self.velocity_z = self.velocity_z + 800;
            self.think = data_prj_swrm_think;
            self.nextthink = time + 0.1;
            setorigin(self, org);
            self.angles = vectoangles(self.velocity);
          self = oself;
          sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
        }
      }
    }
    targs = targs.chain;
  }
};
