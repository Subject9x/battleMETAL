/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_QRFL_IDX = ID_WEP_QRF;
string DAT_QRFL_NAME = "Q-Rifle";
float DAT_QRFL_DMG = 15;
float DAT_QRFL_FIRETIME = 0;
float DAT_QRFL_CLIPSIZE = 1;
float DAT_QRFL_CURRENTAMMO = 1;
float DAT_QRFL_FIRERATE = 0.5;
float DAT_QRFL_RELOADTIME = 0.5;
float DAT_QRFL_ISFIRE = 0;
vector DAT_QRFL_FIRE_OFS = '0 0 2';
string DAT_QRFL_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_QRFL_PROJ_ID= ID_PRJ_QRFL;
float DAT_QRFL_EN_COST= -1;
string DAT_QRFL_SOUND = "sound/ac5.ogg";
float DAT_QRFL_TECH_LEVEL = 1;
float DAT_QRFL_SPR_X = 3;
float DAT_QRFL_SPR_Y = 2;

void() data_wep_qrfl;
void() data_qrfl_ini;
void() data_qrfl_atk;

void() data_wep_qrfl={
  local entity oself, latc;
  latc = spawn();
  oself = self;
  self = latc;
    self.classname = "data";
    self.data_idx = DAT_QRFL_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_qrfl_ini;
    self.w_name = DAT_QRFL_NAME;
  self = oself;
};

void() data_qrfl_ini={
  self.data_idx = DAT_QRFL_IDX;
  self.w_name = DAT_QRFL_NAME;
  self.w_firetime = DAT_QRFL_FIRETIME;
  self.w_clipsize = DAT_QRFL_CLIPSIZE;
  self.w_currentammo = DAT_QRFL_CURRENTAMMO;
  self.w_firerate = DAT_QRFL_FIRERATE;
  self.w_reloadtime = DAT_QRFL_RELOADTIME;
  self.w_isfire = DAT_QRFL_ISFIRE;
  self.w_fire_ofs = DAT_QRFL_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_QRFL_MODEL;
  self.w_attack = data_qrfl_atk;
  self.w_proj = DAT_QRFL_PROJ_ID;
  self.en_cur = -1;
  self.en_max = DAT_QRFL_EN_COST;
  self.fire_sound = DAT_QRFL_SOUND;
  self.i_techlvl = DAT_QRFL_TECH_LEVEL;
  self.stat_spr_x = DAT_QRFL_SPR_X;
  self.stat_spr_y = DAT_QRFL_SPR_Y;
};

void() data_qrfl_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
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
    
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);

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
      self.lock_timer = 0;
      util_setModel(self.c_model, 0);
      util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
      util_setBoundBox('0 0 0', '0 0 0');
      setorigin(self, org);
    self = oself;
  }
  else{
    bprint("oops!\n");
  }
};
