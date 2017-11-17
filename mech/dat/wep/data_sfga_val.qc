/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_SFGA_IDX = ID_WEP_SFGA;
string DAT_SFGA_NAME = "Snub Field Gun";
float DAT_SFGA_DMG = 300;
float DAT_SFGA_FIRETIME = 0;
float DAT_SFGA_CLIPSIZE = 1;
float DAT_SFGA_CURRENTAMMO = 1;
float DAT_SFGA_FIRERATE = 8;
float DAT_SFGA_RELOADTIME = 8;
vector DAT_SFGA_FIRE_OFS = '0 0 2';
string DAT_SFGA_MODEL = "q3mdl/weapons/w_sfga.md3";
float DAT_SFGA_PROJ_ID= ID_PRJ_SFGA;
float DAT_SFGA_EN_COST = 10;
float DAT_SFGA_EN_MAX = 800;
string DAT_SFGA_SOUND = "sound/ac5.ogg";
float DAT_SFGA_TECH_LEVEL = 1;
float DAT_SFGA_SPR_X = 3;
float DAT_SFGA_SPR_Y = 2;
float DAT_SFGA_WSIZE = 1;
float DAT_SFGA_HPX = 200; //v0.0.3
float DAT_SFGA_RANGE = 3600;//v0.0.3

void() data_wep_sfga;
void() data_sfga_ini;
void() data_sfga_atk;
void() data_sfga_think; 

void() data_wep_sfga={
  local entity oself, sfga;
  sfga = spawn();
  oself = self;
  self = sfga;
    self.classname = "data";
    self.data_idx = DAT_SFGA_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_sfga_ini;
    self.w_name = DAT_SFGA_NAME;
  self = oself;
};

void() data_sfga_ini={
  self.data_idx = DAT_SFGA_IDX;
  self.w_name = DAT_SFGA_NAME;
  self.p_dmgtype = self.p_dmgtype | DMG_BAL;
  self.w_firetime = DAT_SFGA_FIRETIME;
  self.w_clipsize = DAT_SFGA_CLIPSIZE;
  self.w_currentammo = DAT_SFGA_CURRENTAMMO;
  self.w_firerate = DAT_SFGA_FIRERATE;
  self.w_fire_ofs = DAT_SFGA_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_SFGA_MODEL;
  self.w_attack = data_sfga_atk;
  self.w_proj = DAT_SFGA_PROJ_ID;
  self.en_cur = DAT_SFGA_EN_MAX;
  self.en_rate = DAT_SFGA_EN_COST;
  self.en_max = DAT_SFGA_EN_MAX;
  self.fire_sound = DAT_SFGA_SOUND;
  self.i_techlvl = DAT_SFGA_TECH_LEVEL;
  self.stat_spr_x = DAT_SFGA_SPR_X;
  self.stat_spr_y = DAT_SFGA_SPR_Y;
  self.i_size = DAT_SFGA_WSIZE;
  self.w_think = data_sfga_think;
  self.health = DAT_SFGA_HPX;
  self.max_health = DAT_SFGA_HPX;
  self.w_range = DAT_SFGA_RANGE;
  self.w_isburst = FALSE;
  self.w_state = READY;
};


void() data_sfga_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur >= self.en_max){
      self.w_state = READY;
    }
  }
};

void() data_sfga_atk={
  local entity player, proj, oself;
  player = self.owner;
 
  local vector dir, end, adj, org;
 
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
    self.en_cur = 0;
    self.w_currentammo = self.w_clipsize;
    self.w_state = RELOADING;
  }
  else{
    self.w_firetime = time + self.w_firerate;
    self.w_state = RECOIL;
  }
  
  adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
    
  if(trace_ent){
    te_superspike(dir);
  }
  
  sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    newmis = spawn();
    oself = self;
    self = newmis;
      self.owner = player;
      proj.unit_ini();
      util_setModel(self.c_model, 0);
      util_setCollider(0, SOLID_BBOX, MOVETYPE_BOUNCE);
      util_setBoundBox('0 0 0', '0 0 0');
      self.velocity = normalize(dir - org);
      self.velocity = self.velocity * self.p_velocity;
      self.velocity_z = self.velocity_z + 200;
      self.think = BecomeExplosion;
      self.nextthink = time + self.p_lifetime;
      setorigin(self, org);
      self.angles = vectoangles(self.velocity);
    self = oself;
    if((player.flags & FL_CLIENT)){
      player.punchangle = randomvec();
    }
  }

  
  local entity bul_fx;
  bul_fx = spawn();
  bul_fx.movetype = SOLID_NOT;
  bul_fx.classname = "missile";
  setmodel(bul_fx, "progs/muzzleflash.spr32");
  setsize(bul_fx, '0 0 0', '0 0 0');
  setorigin(bul_fx, self.fx_origin);
  bul_fx.glow_color = 250;
  bul_fx.glow_size = 1;
  bul_fx.glow_trail = TRUE;
  bul_fx.color = '1 0 0';
  bul_fx.think = SUB_Remove;
  bul_fx.nextthink = time + 0.001;// + 0.35;
};
