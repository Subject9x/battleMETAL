/*
mech Mod
Author: Subject9x
Date: 11/08/2016
Overview: csscsqc? csqccss? cssqc?
*/

vector(vector vec, float scle) css_scaleSize;
vector(vector vec, float algn) css_calcAlign;
vector(vector vec, float axs) css_calcAxis;

//system const
vector VIEW_ORG;
vector VIEW_MAX;
vector VIEW_CTR;
float VIEW_TOP = 1;//	(bit)
float VIEW_BOT = 2;// (bit)
float VIEW_LFT = 4;// (bit)
float VIEW_RGT = 8;// (bit)
float VIEW_SCALE;
float AXIS_H = 1;	//bit)
float AXIS_V = 2;// (bit)
float AXIS_LEFT = 4;// (bit)
float AXIS_RIGHT = 8;// (bit)
float AXIS_UP = 16;// (bit)
float AXIS_DOWN = 24;// (bit)
float OBJ_METER = 1;
float OBJ_SLIDER = 2;
float OBJ_LIST = 3;
float PAT_BAR = 1;
float PAT_SPH = 2;
float PAT_BOX = 3;

//common ent vars
.float data_idx;
.float data_type;
.string img;
.vector pos;
.float scale;
.float align;
.float axis;
.float otype;
.vector margin_ins;
.float pattern;

/*
*/
vector(vector vec, float algn) css_calcAlign={
  local vector toSender;
  local float x,y;
  if(algn & VIEW_TOP){
    y = VIEW_ORG_y + vec_y;
  }
  else if(algn & VIEW_BOT){
    y = VIEW_MAX_y - vec_y;
  }
  
  if(algn & VIEW_LFT){
    x = VIEW_ORG_x + vec_x;
  }
  else if(algn & VIEW_RGT){
    x = VIEW_MAX_x - vec_x;
  }
  
  toSender_x = x;
  toSender_y = y;
  
  return toSender;
};

/*
*/
vector(vector vec, float axs) css_calcAxis={
  


};

vector(vector vec, float scle) css_scaleSize={
  local vector toSender;
  toSender_x = vec_x * scle;
  toSender_y = vec_y * scle;
  
  return toSender;
};