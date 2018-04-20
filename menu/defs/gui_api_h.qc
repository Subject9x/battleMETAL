/*
mech Mod
Author: Peter Roohr
Date: 04/12/2018
Overview: cloned gui_api from csqc
*/

//MENU SYSTEM GLOBALS
vector VIEW_ORG;
vector VIEW_MAX;
vector VIEW_CTR;
vector VIEW_MPOS;
float VIEW_SCALE;
vector VIEW_ACT;

//MENU SYSTEM CONSTANT
float VIEW_TOP = 1;
float VIEW_BOT = 2;
float VIEW_LFT = 4;
float VIEW_RGT = 8;
float VIEW_CTX = 16;
float VIEW_CTY = 32;
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

//unused by menu
//string NAVNAMES[21];
//string(float bit) gui_getWeaponId;
//vector(float val) gui_getColorForArmor;
//vector(float val) gui_getColorForShield;
//string(float anglee) gui_angleToNav;
//vector(float bits, float dead, float ok, float wrange, float prange) gui_getWepStatusColor
//vector(vector map_size, vector obj_coords, vector ui_coords, vector img_sz) gui_mapCoordToImgCoord;
//string(float navname) gui_getNavName;
//void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) gui_BoxOnLabel;
//void(vector ofs, vector r_sz, vector ln_sz, vector clr) gui_DrawRect;
//void(float select, vector ofs, vector r_sz, vector ln_sz1, vector clr1, vector ln_sz2, vector clr2) gui_DrawHighlightRect;
//void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderScroll;
//vector(float dmg_type) gui_colorForWeaponType;

vector(vector vec, float scle) gui_scaleSize;

vector(vector sz) gui_getCenter;

vector(vector vec, float algn) gui_calcAlign;

vector(vector vec, float algn, vector org) gui_calcAlignCustom;

vector(vector org, vector sz, float axs) gui_calcAxis;

void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderMeter;

void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float alpha, float flg) gui_renderModalPip;

void(string str, vector ofs, vector color, vector sz, float alpha, float flg) gui_renderString;

void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float alpha, float flg) gui_renderImageReel;

void(string src_img, vector tintcolor, float alpha, float flg) gui_renderImageFullScreen;

void(float bool, vector org, string img, vector i_sz, vector tnt_clr, float alpha, float flg) gui_renderTintImage;

void(float bool, vector org, string img, vector i_sz, vector tnt_clr, vector nrm_clr, float alpha, float flg) gui_renderTintImage2;

void(string str, vector ofs, vector hclr, vector clr, float bool, vector sz, float alpha, float flg) gui_renderHighlightString;

void(vector ofs, float bool, vector color1, vector color2, vector sz, float alpha, float flg) gui_renderModalFill;

vector(float pcx, float pcy) gui_percentToPixel;

float(float pcx) gui_percentX;

float(float pcy) gui_percentY;

float(float ang) anglemod;

vector(float pcx, float pcy) gui_percentToPixelRaw;

float(float pcx) gui_percentXRaw;

float(float pcy) gui_percentYRaw;

vector(vector p) gui_percentToPixelRawVec;

vector(vector pct, vector org_size, vector dest_size) gui_percentCustomVec;

float(float pct, float ox, float mx) gui_percentCustom;

float(vector loc, vector area, string text, vector fsize, vector clr, float alph) gui_wrapText;