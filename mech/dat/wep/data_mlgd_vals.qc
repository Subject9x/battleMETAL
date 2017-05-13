/*
mech Mod
Author: Subject9x
Date: 02/25/2017
Overview: Laser-guided missile
  missile is long-range, will follow player's aiming reticule
*/
//========LASER GUIDED MISSILE=========
float DATWEP_MLGD_IDX = ID_WEP_MLGD;
string DATWEP_MLGD_NAME = "MIS-LGD";
float DATWEP_MLGD_FIRETIME = 0;
float DATWEP_MLGD_CLIPSIZE = 1;
float DATWEP_MLGD_CURRENTAMMO = 1;
float DATWEP_MLGD_FIRERATE = 0.75;//0.95;
float DATWEP_MLGD_RELOADTIME = 0.75;
vector DATWEP_MLGD_FIRE_OFS = '0 0 2';
string DATWEP_MLGD_MODEL = "q3mdl/weapons/w_mis.md3";
float DATWEP_MLGD_PROJ_ID= ID_PRJ_MLGD;
float DATWEP_MLGD_EN_COST= -1;
string DATWEP_MLGD_FIRESOUND = "sound/llaser.ogg";
float DATWEP_MLGD_TECH_LEVEL = 2;
float DAT_MLGD_WSIZE = 1;
float DAT_MLGD_HPX = 10;

void() data_wep_mlgd;  //called by the data system at game startup
void() data_mlgd_ini;  //used by the vehicle factory when building a weapon hardpoint
void() data_mlgd_atk;  //the actual attack call
void() data_mlgd_think;

void() data_wep_mlgd={
  local entity oself, mlgd;
  mlgd = spawn();
  oself = self;
  self = mlgd;
    self.classname = "data";
    self.data_idx = DATWEP_MLGD_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_mlgd_ini;
    self.w_name = DATWEP_MLGD_NAME;
  self = oself;
};

void() data_mlgd_ini={
  self.data_idx = DATWEP_MLGD_IDX;
  self.w_name = DATWEP_MLGD_NAME;
  self.w_firetime = DATWEP_MLGD_FIRETIME;
  self.w_clipsize = DATWEP_MLGD_CLIPSIZE;
  self.w_currentammo = DATWEP_MLGD_CURRENTAMMO;
  self.w_firerate = DATWEP_MLGD_FIRERATE;
  self.w_reloadtime = DATWEP_MLGD_RELOADTIME;
  self.w_isready = 0;
  self.w_fire_ofs = DATWEP_MLGD_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DATWEP_MLGD_MODEL;
  self.w_attack = data_mlgd_atk;
  self.w_proj = DATWEP_MLGD_PROJ_ID;
  self.en_cur = -1;
  self.en_max = DATWEP_MLGD_EN_COST;
  self.fire_sound = DATWEP_MLGD_FIRESOUND;
  self.i_techlvl = DATWEP_MLGD_TECH_LEVEL;
  self.i_size = DAT_MLGD_WSIZE;
  self.w_think = data_mlgd_think;
  self.health = DAT_MLGD_HPX;
  self.max_health = DAT_MLGD_HPX;
};

void() data_mlgd_think={
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


void() data_mlgd_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    self.w_isready = FALSE;
    self.w_currentammo = self.w_currentammo - 1;
    self.w_firetime = time + self.w_firerate;
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
      self.think = data_prj_mlgd_th;
      self.nextthink = time + 0.05;
      self.p_lifetime = time + self.p_lifetime;
      setorigin(self, org);
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
      
    self = oself;
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  }
  else{
    bprint("projectile not found, check your code!\n");
  }
};