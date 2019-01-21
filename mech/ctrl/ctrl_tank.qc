/*
battleMETAL
Author: Peter Roohr
Date: 1/15/2019
Overview: 
  per-frame game logic update functions
  
*/

void() ctrl_updateTank={
  local entity cam;
  local entity wep;
  local entity piece;
  local entity partParent;
  local vector v1;
  local vector spark;
  local float hp;
  
  makevectors(self.v_angle);
  v1 = self.origin + (v_right * cam.c_ofs_x) + (v_up*cam.c_ofs_y) + (v_forward*cam.c_ofs_z);
  traceline(v1, v1 + v_forward * 10000, FALSE, self);
  self.laser_sight_org = trace_endpos;
  self.laser_sight_timer = time + 0.05;

  if( time > self.count4 ){
    self.count4 = time + 0.1;
    if(self.en_cur >= 0){
      self.en_cur = self.en_cur + self.en_rate;
      if(self.en_cur > self.en_max){
        self.en_cur = self.en_max;
      }
    }  
    if(self.en_cur < 0){
      self.en_cur = 0;
    }
    else if(self.en_cur > self.en_max){
      self.en_cur = self.en_max;
    }
  }
  
  wep = self.w_slot;
  while(wep){
    ctrl_wpn_think(wep);
    wep = wep.w_slot;
  }
  
  //damage-based cosmetics for unit component pieces
  piece = self.c_part;
  while( piece ){
    if( piece.deadflag <= DEAD_NO ){
      hp = piece.health / piece.max_health;
      if( hp < 0.75){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1);
        if( hp < 0.5){
          spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1.25);
          pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5, 1.5);
          if( hp < 0.25){
            spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE"), spark, normalize( spark - piece.origin) * 5, 1.5);
            pointparticles( particleeffectnum("TE_MECHPIECE_DAMAGE_HOT"), spark, normalize( spark - piece.origin) * 5, 1.75);
          }
        }
      }
    }
    else{
      partParent = util_getPartFromName(piece.c_parent, self); 
      if( partParent.deadflag <= DEAD_NO ){
        spark = piece.origin + ( randomvec() * (random() * piece.maxs_x - piece.mins_x) );
        pointparticles( particleeffectnum("TE_MECHPIECE_DEAD_BURN"), spark, normalize( spark - piece.origin) * 5, 1);
      }
    }
    piece = piece.c_part;
  }
};
