/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_LATC_IDX = ID_WEP_LATC;
string DAT_LATC_NAME = "Light Autocannon";
float DAT_LATC_DMG = 6; //was 2 - 3/27/2017
float DAT_LATC_FIRETIME = 0;
float DAT_LATC_CLIPSIZE = 6;  //was 3 - 3/27/2017
float DAT_LATC_CURRENTAMMO = 6;  //was 3 - 3/27/2017
float DAT_LATC_FIRERATE = 0.15;  //was 0.2 - 3/27/2017
float DAT_LATC_RELOADTIME = 0.5;
vector DAT_LATC_FIRE_OFS = '0 0 2';
string DAT_LATC_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_LATC_PROJ_ID= ID_PRJ_LATC;
float DAT_LATC_EN_COST= -1;
string DAT_LATC_SOUND = "sound/ac5.ogg";
float DAT_LATC_TECH_LEVEL = 1;
float DAT_LATC_SPR_X = 3;
float DAT_LATC_SPR_Y = 2;
float DAT_LATC_WSIZE = 1;

void() data_wep_latc;
void() data_latc_ini;
void() data_latc_atk;
void() data_latc_think; 

void() data_wep_latc={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_LATC_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_latc_ini;
    self.w_name = DAT_LATC_NAME;
  self = oself;
};

void() data_latc_ini={
  self.data_idx = DAT_LATC_IDX;
  self.w_name = DAT_LATC_NAME;
  self.w_firetime = DAT_LATC_FIRETIME;
  self.w_clipsize = DAT_LATC_CLIPSIZE;
  self.w_currentammo = DAT_LATC_CURRENTAMMO;
  self.w_firerate = DAT_LATC_FIRERATE;
  self.w_reloadtime = DAT_LATC_RELOADTIME;
  self.w_isready = 0;
  self.w_fire_ofs = DAT_LATC_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_LATC_MODEL;
  self.w_attack = data_latc_atk;
  self.w_proj = DAT_LATC_PROJ_ID;
  self.en_cur = -1;
  self.en_max = DAT_LATC_EN_COST;
  self.fire_sound = DAT_LATC_SOUND;
  self.i_techlvl = DAT_LATC_TECH_LEVEL;
  self.stat_spr_x = DAT_LATC_SPR_X;
  self.stat_spr_y = DAT_LATC_SPR_Y;
  self.i_size = DAT_LATC_WSIZE;
  self.w_think = data_latc_think;
};


void() data_latc_think={
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

void() data_latc_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  //proj = mh_world_findData(self.w_proj, DATA_PROJ);
  //if(proj){
    self.w_isready = FALSE;
    self.w_currentammo = self.w_currentammo - 1;
    self.w_firetime = time + self.w_firerate;
    local vector dir, org, end, adj;

    makevectors(player.v_angle);
    cam = player.e_cam;
    traceline(cam.origin, cam.origin + v_forward*10000, FALSE, player);
    end = trace_endpos + (crandom() * (player.stat_spr_x + self.stat_spr_x) * v_right) + (v_up * crandom() * (player.stat_spr_y + self.stat_spr_y));
    
    adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
    makevectors(player.angles);
    org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
    traceline(org, end, FALSE, player);
    dir = trace_endpos;
    
    te_superspike(dir);
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
    t_damage(trace_ent, self, player, DAT_LATC_DMG, DMG_BAL, dir, '0 0 0');
    
    //local vector sfx;
    //adj_z = adj_z + 45;
    //sfx = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
    
    local entity bul_fx;
    bul_fx = spawn();
    bul_fx.movetype = SOLID_NOT;
    bul_fx.classname = "missile";
    setmodel(bul_fx, "progs/muzzleflash.spr32");
    setsize(bul_fx, '0 0 0', '0 0 0');
    setorigin(bul_fx, org);
    bul_fx.glow_color = 250;
    bul_fx.glow_size = 1;
    bul_fx.glow_trail = TRUE;
    bul_fx.color = '1 0 0';
    bul_fx.think = SUB_Remove;
    bul_fx.nextthink = time + 0.001;// + 0.35;
  //}
  //else{
  //  bprint("oops!\n");
  //}
};
