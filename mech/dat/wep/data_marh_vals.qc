/*
mech Mod
Author: Subject9x
Date: 02/25/2017
Overview: long-range, low damage, homing missile
*/
//========ACTIVE-RADAR HOMING MISSILE=========
float DATWEP_MARH_IDX = ID_WEP_MARH;
string DATWEP_MARH_NAME = "MIS-ARH";
float DATWEP_MARH_FIRETIME = 0;
float DATWEP_MARH_CLIPSIZE = 1;
float DATWEP_MARH_CURRENTAMMO = 1;
float DATWEP_MARH_FIRERATE = 12;//0.95;
float DATWEP_MARH_RELOADTIME = 12;
vector DATWEP_MARH_FIRE_OFS = '0 0 2';
string DATWEP_MARH_MODEL = "q3mdl/weapons/w_mis.md3";
float DATWEP_MARH_PROJ_ID= ID_PRJ_MARH;
float DATWEP_MARH_EN_COST = 10;
float DATWEP_MARH_EN_MAX = 500;
string DATWEP_MARH_FIRESOUND = "sound/llaser.ogg";
float DATWEP_MARH_TECH_LEVEL = 2;
float DAT_MARH_WSIZE = 3;
float DAT_MARH_HPX = 15;
float DAT_MARH_RANGE = 2400;

void() data_wep_marh;  //called by the data system at game startup
void() data_marh_ini;  //used by the vehicle factory when building a weapon hardpoint
void() data_marh_atk;  //the actual attack call
void() data_marh_think;

void() data_wep_marh={
  local entity oself, marh;
  marh = spawn();
  oself = self;
  self = marh;
    self.classname = "data";
    self.data_idx = DATWEP_MARH_IDX;
    self.data_type = DATA_WEPN;
    self.unit_ini = data_marh_ini;
    self.w_name = DATWEP_MARH_NAME;
  self = oself;
};

void() data_marh_ini={
  self.data_idx = DATWEP_MARH_IDX;
  self.p_dmgtype = self.p_dmgtype | DMG_EXP;
  self.w_name = DATWEP_MARH_NAME;
  self.w_firetime = DATWEP_MARH_FIRETIME;
  self.w_clipsize = DATWEP_MARH_CLIPSIZE;
  self.w_currentammo = DATWEP_MARH_CURRENTAMMO;
  self.w_firerate = DATWEP_MARH_FIRERATE;
  self.w_fire_ofs = DATWEP_MARH_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DATWEP_MARH_MODEL;
  self.w_attack = data_marh_atk;
  self.w_proj = DATWEP_MARH_PROJ_ID;
  self.en_cur = DATWEP_MARH_EN_MAX;
  self.en_rate = DATWEP_MARH_EN_COST;
  self.en_max = DATWEP_MARH_EN_MAX;
  self.fire_sound = DATWEP_MARH_FIRESOUND;
  self.i_techlvl = DATWEP_MARH_TECH_LEVEL;
  self.i_size = DAT_MARH_WSIZE;
  self.w_think = data_marh_think;
  self.health = DAT_MARH_HPX;
  self.max_health = DAT_MARH_HPX;
  self.w_isburst = FALSE;
};

void() data_marh_think={
  if(self.w_state == RECOIL){
    if(time > self.w_firetime){
      self.w_state = READY;
    }
  }
  else if(self.w_state == RELOADING){
    if(self.owner.en_cur > self.en_rate){
      self.owner.en_cur = self.owner.en_cur - (self.en_rate / 15);
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur >= self.en_max){
        self.w_state = READY;
      }
    }
  }
};


void() data_marh_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    if(self.owner.stat_rdr_mode == TRUE){
      if(self.owner.stat_lck_stt & LOCK_TARG){ 
        
        local vector dir, org, end, adj;
        
        if((player.flags & FL_CLIENT)){
          end = util_traceForPlayer(player, self.w_range);
        }
        else{
          end = util_traceForAI(player, self.w_range, player.ai_leading); 
        }
        dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
              
        if((player.flags & FL_MONSTER)){
          if((end == player.origin) || (dir == player.origin)){
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
        
        local float countlim, itr;
        countlim = 15;
        
        local float dist;
        local vector arc;
        dist = vlen(dir - org);
        arc = org + (v_forward * (300 + (crandom() * 20))) + (v_up * (300 + (crandom() * 20))) + (v_right * 0);
        
        while(itr < countlim){
          local vector start;
          start = org + ((crandom() * 15) * v_right) + (v_up * (crandom() * 15)) + (v_right * 0);
          itr = itr + 1;
          newmis = spawn();
          oself = self;
          self = newmis;
            self.owner = player;
            proj.unit_ini();
            util_setModel(self.c_model, 0);
            util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
            util_setBoundBox('0 0 0', '0 0 0');
            self.velocity = normalize(arc - start);
            self.enemy = self.owner.enemy;
            self.c_ofs = arc;
            self.lock_timer = time + 0.75;
            self.p_lifetime = time + self.p_lifetime;
            setorigin(self, start);
            self.velocity = self.velocity * self.p_velocity;
            self.angles = vectoangles(self.velocity);
            self.think = data_prj_marh_th;
            self.nextthink = time + 0.01;
          self = oself;
        }
        sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
      }
    }
  }
  else{
    bprint("projectile not found, check your code!\n");
  }
};