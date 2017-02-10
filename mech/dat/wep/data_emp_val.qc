/*
mech Mod
Author: Subject9x
Date: 01/22/2017
Overview: weapon  values are being reorganized to ease maintenance
-these are utilized by their relevant data entity and its ini functions
*/
//LIGHT AUTOCANNON=======================
float DAT_EMP_IDX = ID_WEP_EMP;
string DAT_EMP_NAME = "EMP Cannon";
float DAT_EMP_FIRETIME = 0;
float DAT_EMP_CLIPSIZE = 1;
float DAT_EMP_CURRENTAMMO = 1;
float DAT_EMP_FIRERATE = 0.95;
float DAT_EMP_RELOADTIME = 0.95;
float DAT_EMP_ISFIRE = 0;
vector DAT_EMP_FIRE_OFS = '0 0 16';
float DAT_EMP_HP = 50;
float DAT_EMP_HPMAX = 50;
float DAT_EMP_ARMOR = 50;
float DAT_EMP_ARMORMAX = 50;
string DAT_EMP_MODEL = "q3mdl/weapons/w_emp.md3";
float DAT_EMP_PROJ_ID= ID_PRJ_EMP;
float DAT_EMP_EN_COST= 15;
string DAT_EMP_SOUND = "sound/llaser.ogg";
float DAT_EMP_TECH_LEVEL = 1;

void() data_wep_emp;
void() data_emp_ini;
void() data_emp_atk;

void() data_wep_emp={
  local entity oself, emp;
  emp = spawn();
  oself = self;
  self = emp;
    self.classname = "data";
    self.data_idx = DAT_EMP_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_emp_ini;
    self.w_name = DAT_EMP_NAME;
  self = oself;
};

void() data_emp_ini={
  self.data_idx = DAT_EMP_IDX;
  self.w_name = DAT_EMP_NAME;
  self.w_firetime = DAT_EMP_FIRETIME;
  self.w_clipsize = DAT_EMP_CLIPSIZE;
  self.w_currentammo = DAT_EMP_CURRENTAMMO;
  self.w_firerate = DAT_EMP_FIRERATE;
  self.w_reloadtime = DAT_EMP_RELOADTIME;
  self.w_isfire = DAT_EMP_ISFIRE;
  self.w_fire_ofs = DAT_EMP_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.health = DAT_EMP_HP;
  self.max_health = DAT_EMP_HPMAX;
  self.armorvalue = DAT_EMP_ARMOR;
  self.max_armor = DAT_EMP_ARMORMAX;
  self.c_model = DAT_EMP_MODEL;
  self.w_attack = data_emp_atk;
  self.w_proj = DAT_EMP_PROJ_ID;
  self.en_max = DAT_EMP_EN_COST;
  self.fire_sound = DAT_EMP_SOUND;
  self.i_techlvl = DAT_EMP_TECH_LEVEL;
};

void() data_emp_atk={
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
