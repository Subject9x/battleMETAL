/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_RPLAS_IDX = ID_WEP_RPC;
string DAT_RPLAS_NAME = "RPC";
float DAT_RPLAS_DMG = 8;
float DAT_RPLAS_FIRETIME = 0;
float DAT_RPLAS_CLIPSIZE = 1; //was 1 - 3/27/2017
float DAT_RPLAS_CURRENTAMMO = 1; //was 1 - 3/27/2017
float DAT_RPLAS_FIRERATE = 1; //was 0.28 - 3/27/2017
float DAT_RPLAS_RELOADTIME = 1; //was 0.28 - 3/27/2017
vector DAT_RPLAS_FIRE_OFS = '0 0 2';
string DAT_RPLAS_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_RPLAS_PROJ_ID = 6;//ID_PRJ_RPLAS;
float DAT_RPLAS_EN_COST = -1;
string DAT_RPLAS_SOUND = "sound/ac5.ogg";
float DAT_RPLAS_TECH_LEVEL = 1;
float DAT_RPLAS_SPR_X = 8;
float DAT_RPLAS_SPR_Y = 8;
float DAT_RPLAS_WSIZE = 2;
float DAT_RPLAS_HPX = 25;
float DAT_RPLAS_SHOT = 6;

void() data_wep_rplas;
void() data_rplas_ini;
void() data_rplas_atk;
void() data_rplas_think;

void() data_wep_rplas={
  local entity oself, rplas;
  rplas = spawn();
  oself = self;
  self = rplas;
    self.classname = "data";
    self.data_idx = DAT_RPLAS_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_rplas_ini;
    self.w_name = DAT_RPLAS_NAME;
    bprint(strcat(etos(self),"\n"));
  self = oself;
};

void() data_rplas_ini={
  self.data_idx = DAT_RPLAS_IDX;
  self.w_name = DAT_RPLAS_NAME;
  self.w_isready = 0;
  self.w_firetime = DAT_RPLAS_FIRETIME;
  self.w_clipsize = DAT_RPLAS_CLIPSIZE;
  self.w_currentammo = DAT_RPLAS_CURRENTAMMO;
  self.w_firerate = DAT_RPLAS_FIRERATE;
  self.w_reloadtime = DAT_RPLAS_RELOADTIME;
  self.w_fire_ofs = DAT_RPLAS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_RPLAS_MODEL;
  self.w_attack = data_rplas_atk;
  self.w_proj = DAT_RPLAS_PROJ_ID;
  self.en_cur = -1;
  self.en_max = DAT_RPLAS_EN_COST;
  self.fire_sound = DAT_RPLAS_SOUND;
  self.i_techlvl = DAT_RPLAS_TECH_LEVEL;
  self.stat_spr_x = DAT_RPLAS_SPR_X;
  self.stat_spr_y = DAT_RPLAS_SPR_Y;
  self.i_size = DAT_RPLAS_WSIZE;
  self.w_think = data_rplas_think;
  self.health = DAT_RPLAS_HPX;
  self.max_health = DAT_RPLAS_HPX;
  self.w_range = 1500;
};

void() data_rplas_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
    else{
      self.w_isready = FALSE;
      self.w_firetime = time + self.w_reloadtime;
      self.w_currentammo = self.w_clipsize;
    }
  }
  else{
    self.w_isready = FALSE;
  }
};

void() data_rplas_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    self.w_isready = FALSE;
    self.w_currentammo = self.w_currentammo - 1;
    self.w_firetime = time + self.w_firerate;
    
    local vector dir, org, end, adj;
   if((player.flags & FL_CLIENT)){
      end = util_traceForPlayer(player, (player.stat_spr_x + self.stat_spr_x), (player.stat_spr_y + self.stat_spr_y), '1 1 1', self.w_range);
    }
    else{
      local vector spr;
      spr_x = self.stat_spr_x;
      spr_y = self.stat_spr_y;
      end = util_traceForAI(player, spr, '1 1 1', self.w_range, 0); 
    }
    dir = util_traceForOffset(player, self, end);
    
    adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
    makevectors(player.angles);
    org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);

    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);

    local vector sfx;
    adj_z = adj_z + 45;
    sfx = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
    
    local entity bul_fx;
    bul_fx = spawn();
    bul_fx.solid = SOLID_NOT;
    bul_fx.classname = "missile";
    bul_fx.movetype = MOVETYPE_NONE;
    setmodel(bul_fx, "progs/muzzleflash.spr32");
    setsize(bul_fx, '0 0 0', '0 0 0');
    setorigin(bul_fx, sfx);
    bul_fx.glow_color = 250;
    bul_fx.glow_size = 1;
    bul_fx.glow_trail = TRUE;
    bul_fx.color = '1 0 0';
    bul_fx.think = SUB_Remove;
    bul_fx.nextthink = time + 0.001;// + 0.35;
    
    local float shots;
    shots = DAT_RPLAS_SHOT;
    while(shots > 0){
      local vector norg;
      norg = org;
      newmis = spawn();
      oself = self;
      self = newmis;
        self.owner = player;
        proj.unit_ini();
        self.velocity = normalize(dir - org);
        self.think = SUB_Remove;
        self.nextthink = time + self.p_lifetime;
        self.velocity = self.velocity * self.p_velocity;
        self.angles = vectoangles(self.velocity);
        util_setModel(self.c_model, 0);
        util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
        util_setBoundBox('0 0 0', '0 0 0');        
        self.angles_z = self.angles_z + (shots * 60);
        makevectors(self.angles);
        norg = org + (v_up * 8);
        setorigin(self, norg);
      self = oself;
      shots = shots - 1;
    }
  }
  else{
    bprint(strcat("proj not found!\n", ftos(self.w_proj),"\n"));
  }
};
