/*
mech mod
Author: Subject9x
Date: 9/3/2016
  weapo definition file
  WEAPON: EMP Cannon
  ROLE: Indirect effect
  DESC: low rof, inhibits movement
*/

void() mis_attack={
  local entity cam, player, oself, proj;
  local vector spread;
	local vector dir,org, end, adj;
  player = self.owner;
  
  makevectors(player.v_angle);
  cam = player.clientcamera;
  traceline(cam.origin, cam.origin + v_forward*10000, FALSE, player);
  end = trace_endpos;
  
  adj = self.c_ofs + self.c_alt_ofs + self.w_fire_ofs;
  makevectors(player.angles);
  org = player.origin+(v_up*adj_y)+(v_right*adj_x)+(v_forward*adj_z);
  traceline(org, end, FALSE, player);
  dir = trace_endpos;

  proj = mh_world_findData(self.w_proj, DATA_PROJ);
  
  newmis = spawn();
  oself = self;
  self = newmis;
    self.classname = "missile";
    self.owner = player;
    util_setModel(proj.c_model, 0);
    util_setCollider(DAMAGE_NO, SOLID_BBOX, MOVETYPE_FLYMISSILE);
    
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
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
  //mechs are accurate
	player.punchangle_x = -2.0;
};

void() mis_ini={
  local entity oself, gun;
  oself = self;
  gun = spawn();
  self = gun;
  
  self.classname = "data";
  self.data_type = DATA_WEPN;
  self.data_idx = 2;
  self.w_name = "MIS LAUNCHER";
  
  self.w_firetime = 0;
  self.w_clipsize = 6;
  self.w_currentammo = 6;
  self.w_firerate = 0.25;
  self.w_reloadtime = 1.75;
  self.w_isfire = 0;
  self.w_fire_ofs = '0 0 16'; //kinda important, this helps the traceline clear the player bboxes
  self.health = 75;
  self.armorvalue = 75;
  self.max_armor = 100;
  self.armortype = 1;
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  self.c_model = "q3mdl/weapons/w_mis.md3";
  self.w_attack = mis_attack;
  self.w_proj = 2;
  self.en_max = 0;
  self = oself;
};