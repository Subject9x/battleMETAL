/*
mech Mod
Author: Subject9x
Date: 02/26/2017
Overview: 
*/
//LIGHT AUTOCANNON=======================
float DAT_QRFL_IDX = ID_WEP_QRF;
string DAT_QRFL_NAME = "Q-Rifle";
float DAT_QRFL_DMG = 10;
float DAT_QRFL_FIRETIME = 0;
float DAT_QRFL_CLIPSIZE = 1;//was 1 - 5/14/2017
float DAT_QRFL_CURRENTAMMO = 1;//was 1 - 5/14/2017
float DAT_QRFL_FIRERATE = 0.75;//was 0.5 - 5/14/2017
float DAT_QRFL_RELOADTIME = 0.75;//was 0.5  - 5/14/2017
vector DAT_QRFL_FIRE_OFS = '0 0 2';
string DAT_QRFL_MODEL = "q3mdl/weapons/w_atc.md3";
float DAT_QRFL_PROJ_ID= ID_PRJ_QRFL;
float DAT_QRFL_EN_COST= -1;
string DAT_QRFL_SOUND = "sound/ac5.ogg";
float DAT_QRFL_TECH_LEVEL = 1;
float DAT_QRFL_SPR_X = 1;
float DAT_QRFL_SPR_Y = 5;
float DAT_QRFL_WSIZE = 3;
float DAT_QRFL_HPX = 20;
float DAT_QRFL_QBITS = 7;

void() data_wep_qrfl;
void() data_qrfl_ini;
void() data_qrfl_atk;
void() data_qrfl_think;

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
  self.w_isready = 0;
  self.w_firetime = DAT_QRFL_FIRETIME;
  self.w_clipsize = DAT_QRFL_CLIPSIZE;
  self.w_currentammo = DAT_QRFL_CURRENTAMMO;
  self.w_firerate = DAT_QRFL_FIRERATE;
  self.w_reloadtime = DAT_QRFL_RELOADTIME;
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
  self.i_size = DAT_QRFL_WSIZE;
  self.w_think = data_qrfl_think;
  self.health = DAT_QRFL_HPX;
  self.max_health = DAT_QRFL_HPX;
  self.w_range = 1500;
};

void() data_qrfl_think={
  if(time > self.w_firetime){
    if(self.w_currentammo > 0){
      self.w_isready = TRUE;
    }
  }
  else{
    self.w_isready = FALSE;
  }
};


void() data_qrfl_atk={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
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
    
    if((player.flags & FL_MONSTER)){
      if(dir == player.origin){
        player.ai_patience = player.ai_patience + 1;
        return;
      }
    }
    
    self.w_isready = FALSE;
    self.w_currentammo = self.w_currentammo - 1;
    if(self.w_currentammo <=0){
      self.w_firetime = time + self.w_reloadtime;
      self.power_timer = self.w_firetime;
      self.w_currentammo = self.w_clipsize;
    }
    else{
      self.w_firetime = time + self.w_firerate;
    }
    
    local float qbits;
    qbits = DAT_QRFL_QBITS;
    while(qbits > 0){
      newmis = spawn();
      oself = self;
      self = newmis;
        self.owner = player;
        proj.unit_ini();
        local vector rando;
        rando = randomvec();
        rando_x = (dir_x + rando_x) + (50 + crandom() * 100);
        rando_y = (dir_y + rando_y) + (50 + crandom() * 100);
        rando_z = (dir_z + rando_z) + (50 + crandom() * 100);
        
        self.velocity = normalize(dir - rando);
        self.think = SUB_Remove;
        self.nextthink = time + self.p_lifetime;
        self.velocity = self.velocity * self.p_velocity;
        self.angles = vectoangles(self.velocity);
        util_setModel(self.c_model, 0);
        util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
        util_setBoundBox('0 0 0', '0 0 0');
        setorigin(self, rando);
      self = oself;
      qbits = qbits - 1;
    }
    sound (self, CHAN_ITEM, self.fire_sound, 1, ATTN_NORM);
  }
  else{
    bprint("oops!\n");
  }
};
