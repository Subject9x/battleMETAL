/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_HPX = 200;
void() data_latc_atk;
void() data_latc_think; 

void() data_latc_ini={
  self.data_idx = ID_WEP_LATC;
  self.w_name = DAT_LATC_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL | EFF_PRC;
  self.p_damage = DAT_LATC_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_currentammo = DAT_LATC_CLIPSIZE;
  self.w_fire_ofs = DAT_LATC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LATC_MODEL;
  self.w_attack = data_latc_atk;
  self.rl_cur = DAT_LATC_RL_MAX;
  self.rl_rate = DAT_LATC_RL_RATE;
  self.rl_max = DAT_LATC_RL_MAX;
  self.en_rate = DAT_LATC_EN_RATE;
  self.fire_sound = DAT_LATC_FIRESOUND;
  self.i_techlvl = DAT_LATC_TECH_LEVEL;
  self.stat_spr_x = DAT_LATC_SPR_X;
  self.stat_spr_y = DAT_LATC_SPR_Y;
  self.i_size = DAT_LATC_WSIZE;
  self.w_think = data_latc_think;
  self.health = DAT_LATC_HPX;
  self.max_health = DAT_LATC_HPX;
  self.w_range = DAT_LATC_RANGE;
  self.w_state = READY;
};


void() data_latc_think={
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

void() data_latc_atk={
  local entity player, proj, oself;
  local vector dir, org, end, adj, angl;
  local float range, convx, convy;
  
  player = self.owner;
  
  convx = player.stat_spr_x + self.stat_spr_x;
  convy = player.stat_spr_y + self.stat_spr_y;
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  angl = player.angles;
  range = self.w_range;
  if( (player.flags & FL_MONSTER) ){
    angl = player.v_angle; //set by each AI, due to FL_TURRET
    range = player.ai_minrange;    //convergence / spread works differently for AI
  }
  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
 
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI( org, angl, self.w_range );
  }
  dir = util_applySpreadToTrace( end, player.v_angle, player.stat_trg_dist, range, convx, convy );//becomes 'endpoint' for shot angle

  self.w_currentammo = self.w_currentammo - 1;
  if(self.w_currentammo <= 0){
    self.rl_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
    self.w_firetime = time + self.rl_max;
    self.count1 = time;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  if( trace_ent ){
    t_damage(trace_ent, self, player, self.p_damage, DMG_BAL, dir, '0 0 0');
    if( trace_ent.sh_cur <= 0 ){
      sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
      te_superspike(dir);
    }
  }
  
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.movetype = MOVETYPE_NONE;
  bul_fx.solid = SOLID_NOT;
  bul_fx.classname = "missile";
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '-1 -1 -1', '1 1 1');
  makevectors(self.angles);
  setorigin(bul_fx, org + (v_forward * 5));
  bul_fx.alpha = 0.85;
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.01;// + 0.35;
};
