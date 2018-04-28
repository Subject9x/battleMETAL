/*
mech Mod
Author: Peter Roohr
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========

float DAT_MARH_HPX = 100;

void() data_marh_atk;  //the actual attack call
void() data_marh_think;

void() data_marh_ini={
  self.data_idx = ID_WEP_MARH;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.p_damage = DAT_MARH_DMG;
  self.w_name = DAT_MARH_NAME;
  self.w_firetime = 0;
  self.w_clipsize = DAT_MARH_CLIPSIZE;
  self.w_currentammo = DAT_MARH_CLIPSIZE;
  self.w_fire_ofs = DAT_MARH_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_MARH_MODEL;
  self.w_attack = data_marh_atk;
  self.w_proj = DAT_MARH_PROJ_ID;
  self.rl_cur = DAT_MARH_RL_MAX;
  self.rl_rate = DAT_MARH_RL_RATE;
  self.rl_max = DAT_MARH_RL_MAX;
  self.en_max = DAT_MARH_EN_RATE;
  self.fire_sound = DAT_MARH_FIRESOUND;
  self.i_techlvl = DAT_MARH_TECH_LEVEL;
  self.i_size = DAT_MARH_WSIZE;
  self.w_think = data_marh_think;
  self.health = DAT_MARH_HPX;
  self.max_health = DAT_MARH_HPX;
  self.w_isburst = FALSE;
};

void() data_marh_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.rl_cur = self.rl_cur + self.rl_rate;
      if(self.rl_cur >= self.rl_max){
        self.rl_cur = self.rl_max;
        self.w_state = READY;
      }
    }
  }
};


void() data_marh_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  if(self.owner.stat_rdr_mode == TRUE){
    if(self.owner.stat_lck_stt & LOCK_TARG_HAS){ 
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
          self.w_firetime = time + self.rl_rate ;
        }
        else{
          self.w_firetime = time + self.rl_rate / 1.25;
        }
        self.w_state = RECOIL;
        self.w_isburst = TRUE;
      }
              
      adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
      makevectors(player.angles);
      org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
      
      local float dist;
      local vector arc, start;
      dist = vlen(dir - org);
      arc = org + (v_forward * (300 + (crandom() * 20)));
      arc = arc + (v_up * (300 + (crandom() * 20))) + (v_right * (crandom() * 20));
      arc = arc + (v_right * (crandom() * 20));
      
      start = org + ((crandom() * 2) * v_right) + (v_up * (crandom() * 4));
      newmis = spawn();
      oself = self;
      self = newmis;
        self.owner = player;
        data_iniProjectile(oself.w_proj);
        self.p_dmgtype = oself.p_dmgtype;
        self.p_damage = oself.p_damage;
        self.enemy = self.owner.enemy;
        self.c_ofs = arc;
        self.p_lifetime = time + self.p_lifetime;
        util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
        util_setModel(self.c_model, 0, 0);
        util_setBoundBox('0 0 0', '0 0 0');
        setorigin(self, start);
        self.velocity = normalize(arc - start);
        self.velocity = self.velocity * self.p_velocity;
        self.angles = vectoangles(self.velocity);
        self.think = data_prj_marh_th;
        self.nextthink = time + 1;
        sound (self, CHAN_ITEM, oself.fire_sound, 1, ATTN_NORM);
      self = oself;
    }
  }
};