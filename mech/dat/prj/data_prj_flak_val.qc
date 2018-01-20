/*
mech Mod
Author: Peter Roohr
Date: 01/22/2017
Overview: data def file for a weapon projectile
*/

//FLAK CANNON SHOT==================
void() data_prj_flak_touch;
void() data_prj_flak_think;
void() data_prj_flak_explode;

void() data_prj_flak_ini={
  self.classname = "missile";
  self.touch = data_prj_sfga_touch;
  self.data_idx = DAT_FLAK_PROJ_ID;
  self.p_velocity = DAT_PRJ_FLAK_VELOCITY;
  self.c_model = DAT_PRJ_FLAK_MODEL;
  self.p_lifetime = DAT_PRJ_FLAK_LIFETIME;
  
  //cosmetics
  self.effects = self.effects | DAT_PRJ_FLAK_EFFECTS;
  self.modelflags = DAT_PRJ_FLAK_MODELFLAGS;
  self.alpha = DAT_PRJ_FLAK_ALPHA;
  self.colormod = DAT_PRJ_FLAK_COLORMOD;
  self.glow_color = DAT_PRJ_FLAK_GLOWCOLOR;
  self.glow_size = DAT_PRJ_FLAK_GLOWSIZE;
  self.glow_trail = DAT_PRJ_FLAK_GLOWTRAIL;
};

void() data_prj_flak_think={
  local float dist;
  local float explode;
  explode = FALSE;
  if(time > self.w_firetime){
    local entity proxy;
    proxy = findradius(self.origin, DAT_PRJ_FLAK_PROXYRAD);
    while(proxy){
      if(((proxy.flags & FL_CLIENT) || (proxy.flags & FL_MONSTER))){
        local float ln;
        ln = vlen(proxy.origin - self.origin);
        if(ln <= DAT_PRJ_FLAK_PROXYRAD){
          self.e_cam = proxy;
          explode = TRUE;
        }
      }
      proxy = proxy.chain;
    }
  }
  
  if(time >= self.p_lifetime){
    explode = TRUE;
  }
  
  if(explode){
    self.think = data_prj_flak_explode;
  }else{
    self.think = data_prj_flak_think;
  }
  self.nextthink = time + 0.001;
};

void() data_prj_flak_explode={
  local float totes;
  totes = DAT_FLAK_SHRAP_TOTAL;
  while(totes > 0){
    local vector ang, v;
    local float d;
    d = vlen(self.e_cam.origin - self.origin);
    ang = vectoangles(self.e_cam.origin - self.origin);
    makevectors(ang);
    v = self.origin + (v_forward * (d )) + (v_right * (crandom() * (random() * DAT_PRJ_FLAK_EXPRAD/3)))
            + (v_up * (crandom() * (random() * DAT_PRJ_FLAK_EXPRAD/3)));
    traceline(self.origin, v, FALSE, self);
    t_damage(self.e_cam, self, self.owner, self.p_damage, self.p_dmgtype, trace_endpos, '0 0 0');
    totes = totes - 1;
  }
  self.think = BecomeExplosion;
  self.nextthink = time + 0.001;
};

void() data_prj_flak_touch={
	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}
  
  if(other.classname == "worldspawn"){
    BecomeExplosion();
    return;
  }

  if(other == self.owner){
    return;
  }
  
  if(other.owner == self.owner){
    return;
  }
  
  if(other.classname == "missile"){
    return;
  }
  
  if(other.takedamage == DAMAGE_NO){
    return;
  }
  //optimization fix
  if(other.sh_cur > 0){
    //damage against shield should be unreliable
    local float dmg;
    dmg = DAT_FLAK_SHRAP_TOTAL * self.p_damage;
    dmg = dmg * random();
    t_damage(other, self, self.owner, dmg, self.p_dmgtype, trace_endpos, '0 0 0');
    BecomeExplosion();
  }
  else{
    makevectors(self.angles);
    local vector adj;
    adj = self.origin + (v_forward * (DAT_PRJ_FLAK_PROXYRAD * -1));
    setorigin(self, adj);
    self.e_cam = other;
    data_prj_flak_explode();
  }
};