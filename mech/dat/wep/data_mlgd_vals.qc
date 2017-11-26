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
float DATWEP_MLGD_FIRERATE = 5;//0.95;
float DATWEP_MLGD_RELOADTIME = 5;
vector DATWEP_MLGD_FIRE_OFS = '0 0 2';
string DATWEP_MLGD_MODEL = "q3mdl/weapons/w_lgm.md3";
float DATWEP_MLGD_PROJ_ID= ID_PRJ_MLGD;
float DATWEP_MLGD_EN_COST = 10;
float DATWEP_MLGD_EN_MAX = 500; 
string DATWEP_MLGD_FIRESOUND = "sound/weapons/mis_fire.ogg";
float DATWEP_MLGD_TECH_LEVEL = 2;
float DAT_MLGD_WSIZE = 1;
float DAT_MLGD_HPX = 125; //v0.0.3
float DAT_MLGD_RANGE = 2400;//v0.0.3

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
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.w_firetime = DATWEP_MLGD_FIRETIME;
  self.w_clipsize = DATWEP_MLGD_CLIPSIZE;
  self.w_currentammo = DATWEP_MLGD_CURRENTAMMO;
  self.w_firerate = DATWEP_MLGD_FIRERATE;
  self.w_fire_ofs = DATWEP_MLGD_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DATWEP_MLGD_MODEL;
  self.w_attack = data_mlgd_atk;
  self.w_proj = DATWEP_MLGD_PROJ_ID;
  self.en_cur = DATWEP_MLGD_EN_MAX;
  self.en_rate = DATWEP_MLGD_EN_COST;
  self.en_max = DATWEP_MLGD_EN_MAX;
  self.fire_sound = DATWEP_MLGD_FIRESOUND;
  self.i_techlvl = DATWEP_MLGD_TECH_LEVEL;
  self.i_size = DAT_MLGD_WSIZE;
  self.w_think = data_mlgd_think;
  self.health = DAT_MLGD_HPX;
  self.max_health = DAT_MLGD_HPX;
  self.w_range = DAT_MLGD_RANGE;
  self.w_isburst = FALSE;
};

void() data_mlgd_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      //self.owner.en_cur = self.owner.en_cur - (self.en_rate / 8); //v0.0.3 - no longer needed
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.w_state = READY;
      }
    }
  }
};


void() data_mlgd_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    local vector dir, org, end, adj;

    if((player.flags & FL_CLIENT)){
      end = util_traceForPlayer(player, self.w_range);
    }
    else{
      end = util_traceForAI(player, self.w_range, player.ai_leading); 
    }
    dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
    
    if((player.flags & FL_MONSTER)){
      if(end == player.origin){
        player.patience = player.patience + 1;
        return;
      }
    }
    
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