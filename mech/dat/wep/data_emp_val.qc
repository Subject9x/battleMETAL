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
float DAT_EMP_FIRERATE = 2;
float DAT_EMP_RELOADTIME = 2;
vector DAT_EMP_FIRE_OFS = '0 0 2';
string DAT_EMP_MODEL = "q3mdl/weapons/w_emp.md3";
float DAT_EMP_PROJ_ID= ID_PRJ_EMP;
float DAT_EMP_EN_COST=  0.5;
string DAT_EMP_SOUND = "sound/llaser.ogg";
float DAT_EMP_TECH_LEVEL = 1;
float DAT_EMP_WSIZE = 2;
float DAT_EMP_HPX = 25;

void() data_wep_emp;  //called by the data system at game startup
void() data_emp_ini;  //used by the vehicle factory when building a weapon hardpoint
void() data_emp_atk;  //the actual attack call
void() data_emp_think;

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
  self.w_isready = 0;
  self.w_fire_ofs = DAT_EMP_FIRE_OFS; //kinda important, this helps the traceline clear the player bboxes
  self.c_model = DAT_EMP_MODEL;
  self.w_attack = data_emp_atk;
  self.w_proj = DAT_EMP_PROJ_ID;
  self.en_cur = 0;
  self.en_max = DAT_EMP_EN_COST;
  self.fire_sound = DAT_EMP_SOUND;
  self.i_techlvl = DAT_EMP_TECH_LEVEL;
  self.i_size = DAT_EMP_WSIZE;
  self.w_think = data_emp_think;
  self.health = DAT_EMP_HPX;
  self.max_health = DAT_EMP_HPX;
  self.p_dmgtype = self.p_dmgtype | EFF_STX;
  self.w_range = 1200;
};

void() data_emp_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
  }
  else{
    self.w_isready = FALSE;
    if(self.owner.en_cur > 0){
      self.owner.en_cur = util_zeroStat(self.en_max, self.owner.en_cur);
    }
    else{
      self.w_firetime = time + self.w_reloadtime;
    }
  }
};

void() data_emp_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    local vector dir, org, end, adj;

    if((player.flags & FL_CLIENT)){
      end = util_traceForPlayer(player, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y+self.stat_spr_y, self.w_range);
    }
    else{
      end = util_traceForAI(player, self.w_range, self.ai_leading); 
    }
    dir = util_traceForOffset(player, self, end, player.stat_spr_x + self.stat_spr_x, player.stat_spr_y + self.stat_spr_y);
    
    if(dir == player.origin){
      if((player.flags & FL_MONSTER)){
        player.ai_patience = player.ai_patience + 1;
      }
      return;
    }
    
    self.w_currentammo = self.w_currentammo - 1;
    self.w_isready = FALSE;
    if(self.w_currentammo <=0){
      self.w_firetime = time + self.w_reloadtime;
      self.power_timer = self.w_firetime;
      self.w_currentammo = self.w_clipsize;
    }
    else{
      self.w_firetime = time + self.w_firerate;
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
      self.p_lifetime = time + self.p_lifetime;
      self.w_firetime = time + 0.5;
      setorigin(self, org);
      self.velocity = self.velocity * self.p_velocity;
      self.angles = vectoangles(self.velocity);
      self.think = data_prj_emp_think;
      self.nextthink = time + 0.01;
    self = oself;
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  }
  else{
    bprint("oops!\n");
  }
};
