/*
mech Mod
Author: Subject9x
Date: 10/28/2016
Overview: header for mech hud functions
*/

vector(float val) colorForVal;

void() hud_spread;
void() hud_shield;
void() hud_energy;
void(float val, vector loc, vector sz) hud_paperdoll;
void() hud_updatecpit;
void() hud_ini;

void() hud_ini={
  local float mindx;
  mindx = getstati(STAT_VID);

};

void() hud_updatecpit={
  local float mindx;
  mindx = getstati(STAT_VID);

};

//put in own class

void() hud_spread={

};

void() hud_shield={

};

void() hud_energy={

};

void(float val, vector loc, vector sz) hud_paperdoll={
  local vector color;
  color = colorForVal(val);
  drawfill(loc, sz, color, 1, 0 );
};

vector(float val) colorForVal={
/*  if(val <= 50){
    if(val <= 25){
      if(val <= 0){
        return DMG_COLOR_GRAY;
      }
      return DMG_COLOR_RED;
    }
    return DMG_COLOR_YELLOW;
  }
  else{
    return DMG_COLOR_GREEN;
  }*/
};