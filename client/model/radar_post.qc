/*
battleMETAL
Author: Peter Roohr
Date: 03/24/2020
Overview: 
  CSQC-side animations for radar posts
*/

/*
  Radar Post - Dynamic Lights
*/
void() radar_post_dlights={
  if( self.deadflag == DEAD_NO ){
    adddynamiclight( self.compOffset, 128, self.compAltOffsetCache); 
  }
};

/*
  Radar Post - Think
*/
void() radar_post_th={
  if( self.deadflag == DEAD_NO ){
    if( self.faction == CLIENT_faction ){
      if(  self.w_firetime == 1 ){
        //ST_STAND -> sv/main/ai/ai_api.qh 
        //post detecting, countdown to alarm
        self.compAltOffsetCache = '1 1 0.4';
        self.partTypeId = 2;
      }
      else if(  self.w_firetime == 2 ){
        //ST_WALK -> sv/main/ai/ai_api.qh 
        //idling normally
        self.compAltOffsetCache = '0 0.8 0.6';
        self.partTypeId = 11;
      }
      else if( self.w_firetime == 4 ){
        //ST_RUN -> sv/main/ai/ai_api.qh 
        //post is raising alarm
        self.compAltOffsetCache = '1 0.6 0';
        self.partTypeId = 4;
      }
    }
    else{     
      if( self.w_firetime == 1 ){
        //ST_STAND-> sv/main/ai/ai_api.qh 
        //post detecting, countdown to alarm
        self.compAltOffsetCache = '1 0.8 0.4';
        self.partTypeId = 3;
      }
      else if(  self.w_firetime == 2 ){
        //ST_WALK -> sv/main/ai/ai_api.qh 
        //idling normally
        self.compAltOffsetCache = '0 0.4 1';
        self.partTypeId = 9;
      }
      else if( self.w_firetime == 4 ){
        //ST_RUN -> sv/main/ai/ai_api.qh 
        //post is raising alarm
        self.compAltOffsetCache = '1 0 0';
        self.partTypeId = 1;
      }
    }
    self.think = radar_post_th;
    self.nextthink = time + 0.1;
  }
};

/*
  Radar Post - DEATH
*/
void() radar_post_die1={
  self.render_dlights = SUB_Null;
  
  self.think = radar_post_die2;
  self.nextthink = time + 0.1;
};

void() radar_post_die2={
  te_missile_explode( self.origin, 5, '1 0.75 0.75', 0.01 );
  building_sound_explode();
  self.think = sendevent_building_die;
  self.nextthink = time + 0.1;
};