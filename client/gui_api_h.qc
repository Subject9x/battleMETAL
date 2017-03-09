/*
mech Mod
Author: Subject9x
Date: 03/8/2017
Overview: GUI API header
*/

vector(float val, float type) gui_getStatusColor;
vector(vector vec, float scle) gui_scaleSize;
vector(vector sz) gui_getCenter;
vector(vector vec, float algn) gui_calcAlign;
vector(vector org, vector sz, float axs) gui_calcAxis;
void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderMeter;
vector(float val) gui_calcRadarHeat;
void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float alpha, float flg) gui_renderModalPip;
void(string str, vector ofs, vector color, vector sz, float alpha, float flg, float ax, float vdir) gui_renderString;
void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderScroll;
void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float alpha, float flg) gui_renderImageReel;
void(string src_img, vector tintcolor, float alpha, float flg) gui_renderImageFullScreen;
vector(float bit, float check1, float check2, float check3) gui_getStatusColor3;
void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) gui_BoxOnLabel;
void(vector ofs, vector r_sz, vector ln_sz, vector clr) gui_DrawRect;
string(float bit) gui_getWeaponId;
void(float select, vector ofs, vector r_sz, vector ln_sz1, vector clr1, vector ln_sz2, vector clr2) gui_DrawHighlightRect;

//system const
vector VIEW_ORG;
vector VIEW_MAX;
vector VIEW_CTR;
vector PLR_VIEW;
float VIEW_TOP = 1;
float VIEW_BOT = 2;
float VIEW_LFT = 4;
float VIEW_RGT = 8;
float VIEW_CTX = 16;
float VIEW_CTY = 32;
float VIEW_SCALE;
float AXIS_H = 1;	
float AXIS_V = 2;
float AXIS_LEFT = 4;
float AXIS_RIGHT = 8;
float AXIS_UP = 16;
float AXIS_DOWN = 24;
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
float HUD_ALPHA = 1;

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
.vector offset;
.vector asize;
.vector colortint;
.vector hsize;