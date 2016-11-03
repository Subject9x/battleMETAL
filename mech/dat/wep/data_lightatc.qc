/*
mech mod
Author: Subject9x
Date: 9/1/2016
  weapo definition file
  WEAPON: Light Autocannon
  ROLE: Harassing fire
  DESC: low DPS, High RoF
*/
void() latc_attack={
  local entity player, proj, cam, oself;
  player = self.owner;
  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  if(proj){
    local vector dir, org, end, adj;

    makevectors(player.v_angle);
    cam = player.e_cam;//.clientcamera;
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
    self.classname = "spike";
    self.owner = player;
    self.p_damage = proj.p_damage;
    self.p_dmgtype = proj.p_dmgtype;
    util_setModel(proj.c_model, 0);
    util_setCollider(0, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    
    self.effects = proj.effects;
    self.modelflags = proj.modelflags;
    self.alpha = proj.alpha;
    self.colormod = proj.colormod;
    self.glow_color = proj.glow_color;
    self.glow_size = proj.glow_size;
    self.glow_trail = proj.glow_trail;
    
    self.velocity = normalize(dir - org);
    self.touch = proj.touch;
    util_setBoundBox('0 0 0', '0 0 0');
    self.think = SUB_Remove;
    self.nextthink = time + proj.p_lifetime;
    setorigin(self, org);
    
    self.velocity = self.velocity * proj.p_velocity;
    self.angles = vectoangles(self.velocity);
    
    self = oself;
    sound (self, CHAN_ITEM, "sound/ac5.ogg", 1, ATTN_NORM);
  }
  else{
    bprint("oops!\n");
  }
};

void() latc_ini={
  local entity oself, gun;
  oself = self;
  gun = spawn();
  self = gun;
  
  self.classname = "data";
  self.data_type = DATA_WEPN;
  self.data_idx = 0;
  self.w_name = "Light Autocannon";
  
  self.w_firetime = 0;
  self.w_clipsize = 4;
  self.w_currentammo = 4;
  self.w_firerate = 0.18;
  self.w_reloadtime = 0.45;
  self.w_isfire = 0;
  self.w_fire_ofs = '0 0 12'; //kinda important, this helps the traceline clear the player bboxes
  self.health = 50;
  self.armorvalue = 50;
  self.armortype = 1;
  self.c_bbx_n = '-3 -3 -2';
  self.c_bbx_x = '3 3 2';
  self.c_model = "q3mdl/weapons/w_atc.md3";
  self.w_attack = latc_attack;
  self.w_proj = 0;
  self.en_max = 0;
  
  self = oself;
};

