/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_MIS_IDX = ID_WEP_MIS;
string DAT_MIS_NAME = "Missile Launcher";
float DAT_MIS_FIRETIME = 0;
float DAT_MIS_CLIPSIZE = 6;
float DAT_MIS_CURRENTAMMO = 6;
float DAT_MIS_FIRERATE = 0.25;
float DAT_MIS_RELOADTIME = 01.75;
float DAT_MIS_ISFIRE = 0;
vector DAT_MIS_FIRE_OFS = '0 0 12';
float DAT_MIS_HP = 50;
float DAT_MIS_HPMAX = 50;
float DAT_MIS_ARMOR = 50;
float DAT_MIS_ARMORMAX = 50;
string DAT_MIS_MODEL = "q3mdl/weapons/w_mis.md3";
float DAT_MIS_PROJ_ID= ID_PRJ_MIS;
float DAT_MIS_EN_COST= 0;
string DAT_MIS_SOUND = "weapons/sgun1.wav";
float DAT_MIS_TECH_LEVEL = 1;

void() data_wep_mis;
void() data_mis_ini;
void() data_mis_atk;

void() data_wep_mis={
  local entity oself, mis;
  mis = spawn();
  oself = self;
  self = mis;
    self.classname = "data";
    self.data_idx = DAT_MIS_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_mis_ini;
    self.w_name = DAT_MIS_NAME;
  self = oself;
};

void() data_mis_ini={
  self.data_idx = DAT_MIS_IDX;
  self.w_name = DAT_MIS_NAME;
  self.w_firetime = DAT_MIS_FIRETIME;
  self.w_clipsize = DAT_MIS_CLIPSIZE;
  self.w_currentammo = DAT_MIS_CURRENTAMMO;
  self.w_firerate = DAT_MIS_FIRERATE;
  self.w_reloadtime = DAT_MIS_RELOADTIME;
  self.w_isfire = DAT_MIS_ISFIRE;
  self.w_fire_ofs = DAT_MIS_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.health = DAT_MIS_HP;
  self.max_health = DAT_MIS_HPMAX;
  self.armorvalue = DAT_MIS_ARMOR;
  self.max_armor = DAT_MIS_ARMORMAX;
  self.c_model = DAT_MIS_MODEL;
  self.w_attack = data_mis_atk;
  self.w_proj = DAT_MIS_PROJ_ID;
  self.en_max = DAT_MIS_EN_COST;
  self.fire_sound = DAT_MIS_SOUND;
  self.i_techlvl = DAT_MIS_TECH_LEVEL;
};

void() data_mis_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    local vector dir, org, end, adj;

    makevectors(player.v_angle);
    cam = player.e_cam;
    traceline(cam.origin, cam.origin + v_forward*10000, FALSE, player);
    end = trace_endpos;
    
    adj = self.c_ofs + self.w_fire_ofs + self.c_alt_ofs;
    makevectors(player.angles);
    org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
    traceline(org, end, FALSE, player);
    dir = trace_endpos;
    
    newmis = spawn();
    oself = self;
    self = newmis;
      self.owner = player;
      proj.unit_ini();
      util_setModel(self.c_model, 0);
      util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
      util_setBoundBox('0 0 0', '0 0 0');
      self.velocity = normalize(dir - org);
      self.think = SUB_Remove;
      self.nextthink = time + self.p_lifetime;
      setorigin(self, org);
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
    self = oself;
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  }
  else{
    bprint("oops!\n");
  }
};
