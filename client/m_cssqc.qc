/*
mech Mod
Author: Subject9x
Date: 11/08/2016
Overview: csscsqc? csqccss? cssqc?
*/

vector(vector vec, float scle) css_scaleSize;
vector(vector vec, float algn) css_calcAlign;
vector(vector org, vector sz, float axs) css_calcAxis;
void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float dir) css_renderMeter;

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
float AXIS_CTR = 32;
float DIR_UP = 1;
float DIR_DN = 2;
float DIR_LF = 3;
float DIR_RT = 4;
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
.vector parent_org;
.vector pos;
.float scale;
.float align;
.float axis;
.float dir; 
.float otype;
.vector margin_ins;
.float pattern;


void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float dir) css_renderMeter={
  /*
    given target origin, meter size, current meter value
  */
  local float perc, adj, diff;
  local vector norg, end;
  norg = css_calcAxis(org, sz, ax);  
  drawfill(norg, sz, clr_bk, alpha, flg);
  end = norg;
  perc = (val / 100);
  if(ax & AXIS_V){
     adj = sz_y * perc;
     diff = sz_y - adj;
     norg_y = norg_y + diff;
     sz_y = sz_y - diff;
  }
  else if(ax & AXIS_H){
     adj = sz_x * perc;
     diff = sz_x - adj;
     norg_x = norg_x + diff;
     sz_x = sz_x - diff;
  }
  drawfill(norg, sz, clr_fr, alpha, flg);
};

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
vector(vector org, vector sz, float axs) css_calcAxis={
  local vector toSender;
  toSender = org;
  if(axs & AXIS_H){
   if(axs & AXIS_LEFT){
    toSender_x = org_x - sz_x;
   }
   else if(axs & AXIS_RIGHT){
    toSender_x = org_x + sz_x;
   }
  }
  else if(axs & AXIS_V){
   if(axs & AXIS_UP){
    toSender_y = org_y - sz_y;
   }
   else if(axs & AXIS_DOWN){
    toSender_y = org_y + sz_y;
   }
  }
  return toSender;
};

vector(vector vec, float scle) css_scaleSize={
  local vector toSender;
  toSender_x = vec_x * scle;
  toSender_y = vec_y * scle;
  
  return toSender;
};