/*
mech mod
Author: Subject9x
Date: 10/9/2016
  weapo definition file
  WEAPON: Standard laser
  ROLE: high accuracy weapon
  DESC: 
*/

void() las_attack;
void() las_ini;

void() las_attack={
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
  
  if (player.t_width < time){
		//sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
      //sound (self, CHAN_WEAPON, "weapons/laser_3.ogg", 1, ATTN_NORM);
    player.t_width = time + 0.05;//0.6;
	}
	player.punchangle_x = -0.05;

  local entity laser_org;
  laser_org = spawn();
  laser_org.movetype = SOLID_NOT;
  laser_org.classname = "missile";
  setsize(laser_org, '0 0 0', '0 0 0');
  setorigin(laser_org, org);
  
  //T_Damage(trace_ent, self.owner, self.owner, 12, 12, "", DT_IMPACT, other.origin, '0 0 0', Obituary_Generic);
  //damage_mech_main(trace_ent, self.owner, self.owner, 12, 0);
  t_damage(trace_ent, self, player, 10, 0, dir, '0 0 0');
  sound (laser_org, CHAN_WEAPON, "sound/weapons/laser_3.ogg", 1, ATTN_NORM); 
  te_lightning2(laser_org, laser_org.origin, dir); 
  te_spark(laser_org.origin, '0 0 0',25);
  te_plasmaburn(dir);
 
  laser_org.think = SUB_Remove;
  laser_org.nextthink = time + 0.001;// + 0.35;
};

void() las_ini={
  local entity oself, gun;
  oself = self;
  gun = spawn();
  self = gun;
  
  self.classname = "data";
  self.data_type = DATA_WEPN;
  self.data_idx = 3;
  self.w_name = "BASIC LASER";
  
  self.w_firetime = 0;
  self.w_clipsize = 1;
  self.w_currentammo = 1;
  self.w_firerate = 0.15;
  self.w_reloadtime = 0.15;
  self.w_isfire = 0;
  self.w_fire_ofs = '0 0 16'; //kinda important, this helps the traceline clear the player bboxes
  self.health = 75;
  self.armorvalue = 75;
  self.armortype = 1;
  self.c_bbx_n = '-1 -1 -1';
  self.c_bbx_x = '1 1 1';
  self.c_model = "q3mdl/weapons/w_laser.md3";
  self.w_attack = las_attack;
  self.w_proj = 0;
  
  self = oself;
};