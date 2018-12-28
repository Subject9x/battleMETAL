/*
mech Mod
Author: Peter Roohr
Date: 01/18/2018
Overview: new year, new toys
*/
//FLAK CANNON=======================

float DAT_FLAK_HPX = 200;

void() data_flak_atk;
void() data_flak_think; 

void() data_flak_ini={
  self.data_idx = ID_WEP_FLAK;
  self.w_name = DAT_FLAK_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL;
  self.p_damage = DAT_FLAK_DMG;
  self.w_firetime = 0;
  self.w_clipsize = DAT_FLAK_CLIPSIZE;
  self.w_currentammo = DAT_FLAK_CLIPSIZE;
  self.w_fire_ofs = DAT_FLAK_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_FLAK_MODEL;
  self.w_attack = data_flak_atk;
  self.rl_cur = DAT_FLAK_RL_MAX;
  self.rl_rate = DAT_FLAK_RL_RATE;
  self.rl_max = DAT_FLAK_RL_MAX;
  self.en_rate = DAT_FLAK_EN_RATE;
  self.fire_sound = DAT_FLAK_FIRESOUND;
  self.i_techlvl = DAT_FLAK_TECH_LEVEL;
  self.i_size = DAT_FLAK_WSIZE;
  self.w_think = data_flak_think;
  self.health = DAT_FLAK_HPX;
  self.max_health = DAT_FLAK_HPX;
  self.w_range = DAT_FLAK_RANGE;
  self.w_state = READY;
  self.spreadDefault = DAT_FLAK_ACC;
};


void() data_flak_think={
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
      local float delta, lim;
      delta = time - self.count1;
      lim = self.rl_max;      
      self.rl_cur = (delta / lim) * 100;
    }
  }
};

void() data_flak_atk={
  local entity player, oself, this, enm;
  local vector dir, org, end, adj, angl;
  local float range;
  local entity boom;
  local vector ang, v;
  local float d;
  
  player = self.owner;
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;    //complete offset from player origin
  angl = player.angles;
  range = self.w_range;
  if( (player.flags & FL_MONSTER) ){
    angl = player.v_angle; //set by each AI, due to FL_TURRET
  }
  org = util_getOffsetOfVector( player.origin, adj, angl );    //origin for barrel of weapon
 
  if((player.flags & FL_CLIENT)){
    end = util_traceForPlayer(player, self.w_range);
  }
  else{
    end = util_traceForAI( org, angl, self.w_range, player );
  }
  dir = util_applySpreadToTrace( player.v_angle, range, self.spreadDefault, player.accuracy );//becomes 'endpoint' for shot angle
  enm = trace_ent;
  
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
    if((self.flags * FL_MONSTER)){
      self.w_firetime = time + (self.rl_rate / 10 ) / 1.5;
    }
    else{
      self.w_firetime = time + self.rl_rate / 2;
    }
    self.w_state = RECOIL;
    self.w_isburst = TRUE;
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  
  pointparticles( particleeffectnum("TE_FLK_MUZZLE"), org + v_forward * 3, normalize( dir - org ) * 4, 1);
  
  if( (trace_dphitcontents & DPCONTENTS_SKY) ){
    return;
  }  
  
  if( !trace_ent.takedamage ){
    if( (trace_dphitcontents & DPCONTENTS_SOLID) || (trace_dphitcontents & DPCONTENTS_OPAQUE) ){
      pointparticles( particleeffectnum("TE_FLK_DIRT"), dir + (v_up * 3) + (v_forward * -7), normalize( dir - org ) * 20, 1);
    }
    return;
  }
  pointparticles( particleeffectnum("TE_FLK_IMPACT"), dir - (v_forward * 2), '1 1 1', 1);
  if(enm && enm != world){
    local float totes;
    totes = DAT_FLAK_SHRAP_TOTAL;
    if(enm.sh_cur > (self.p_damage * totes)){
      t_damage(enm, self, self.owner, self.p_damage * totes, self.p_dmgtype, trace_endpos, '0 0 0');
    }
    else{
      while(totes > 0){
        d = vlen(enm.origin - dir);
        ang = vectoangles(enm.origin - dir);
        makevectors(ang);
        v = dir + (v_forward * (d )) + (v_right * (crandom() * (random() * DAT_PRJ_FLAK_EXPRAD/3)))
                + (v_up * (crandom() * (random() * DAT_PRJ_FLAK_EXPRAD/3)));
        traceline(dir, v, FALSE, self);
        t_damage(enm, self, self.owner, self.p_damage, self.p_dmgtype, trace_endpos, '0 0 0');
        totes = totes - 1;
      }
      
    }
  }
};
