/*
mech Mod
Author: Subject9x
Date: 11/08/2016
Overview: csscsqc? csqccss? cssqc?
*/
vector(float val, float type) css_getStatusColor;
vector(vector vec, float scle) css_scaleSize;
vector(vector sz) css_getCenter;
vector(vector vec, float algn) css_calcAlign;
vector(vector org, vector sz, float axs) css_calcAxis;
void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) css_renderMeter;
vector(float val) css_calcRadarHeat;
void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float alpha, float flg) css_renderModalPip;
void(string str, vector ofs, vector color, vector sz, float alpha, float flg, float ax, float vdir) css_renderString;
void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) css_renderScroll;
void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float alpha, float flg) css_renderImageReel;
void(string src_img, vector tintcolor, float alpha, float flg) css_renderImageFullScreen;
vector(float bit, float check1, float check2, float check3) css_getStatusColor3;
void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) css_BoxOnLabel;
string(float bit) css_getWeaponId;

//system const
vector VIEW_ORG;
vector VIEW_MAX;
vector VIEW_CTR;
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
vector(float val, float type) css_getStatusColor={
	if(val == 0){
		return STATUS_DED;
	}
	else if(val == 1){
		return STATUS_DMG;
	}
	else if(val == 2){
		return STATUS_AOK;
	}
};

vector(float bits, float dead, float ok) css_getWepStatusColor{
  if((bits & dead)){
    return '0.1 0.1 0.1';
  }
  else if((bits & ok)){
    return '0.215 0.709 0.29';
  }
}

void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) css_renderMeter={
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
  
  if(algn & VIEW_CTX){
    x = VIEW_CTR_x - vec_x;
    
  }
  if(algn & VIEW_CTY){
    y = VIEW_CTR_y - vec_y;
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

vector(float val) css_calcRadarHeat={
  local vector toSender;
	if(val <= 2){
    toSender = STATUS_AOK;
  }
  if(val > 2){
    toSender = STATUS_DMG;
  }
  if(val >= 15){
    toSender = '0.7 0.11 0.23';
  }
  return toSender;
};

void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float alpha, float flg) css_renderModalPip={
  local vector colorActual;
  if(bit & state1){
    colorActual = color1;
  }
  else{
    colorActual = color2;
  }
  
  drawfill(ofs, sz, colorActual, alpha, flg);
};

vector(float bit, float check1, float check2, float check3) css_getStatusColor3={
	if(bit & check1){
		return STATUS_DED;
	}
	else if(bit & check2){
		return STATUS_DMG;
	}
	else if(bit & check3){
		return STATUS_AOK;
	}
};

/*
  Draws an image that occupies the entire screen size
*/
void(string src_img, vector tintcolor, float alpha, float flg) css_renderImageFullScreen={
  local vector pnl_sz, img_sz, ofs, org;
  local float aln;
  
  img_sz = draw_getimagesize(src_img);
  aln = VIEW_BOT | VIEW_LFT;
  pnl_sz_x = VIEW_MAX_x;
  pnl_sz_y = img_sz_y;
  ofs_y = ofs_y + pnl_sz_y;
  org = css_calcAlign(ofs, aln);
  drawpic(org, src_img, pnl_sz, tintcolor, alpha, flg);
};

void(string str, vector ofs, vector color, vector sz, float alpha, float flg, float ax, float vdir) css_renderString={

};

void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) css_BoxOnLabel={
  local float len;
  len = stringwidth(str, 0, txt_sz);
  local vector tl, tr, bl, br;
  tl = ofs - '2 2';
  tr = ofs - '2 2';
  tr_x = tr_x + len + 4;
  bl = ofs;
  bl_x = tl_x;
  bl_y = bl_y + 6;
  br = ofs;
  br_x = ofs_x + len + 2;
  br_y = bl_y;
  
  drawline(ln_sz_x, tl, tr, clr, 1, 0);
  drawline(ln_sz_y, tl, bl, clr, 1, 0);
  drawline(ln_sz_y, tr, br, clr, 1, 0);
  drawline(ln_sz_x, bl, br, clr, 1, 0);
};
  
vector(vector sz) css_getCenter={
  local vector toSender;
  toSender_x = sz_x / 2;
  toSender_y = sz_y / 2;
  return toSender;
};


void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float alpha, float flg) css_renderImageReel={
  local vector isz, nsz, ratio;
  isz = draw_getimagesize(src_img);
  clipSize_x = clipSize_x / isz_x;
  clipSize_y = clipSize_y / isz_y;
  isz = css_scaleSize(isz, VIEW_SCALE);
  drawsubpic(srcOrg, isz, src_img, percent, clipSize, clr, alpha, flg);
};

string(float bit) css_getWeaponId={
  if(bit == WEAPON1){
    return "1";
  }
  else if(bit == WEAPON2){
    return "2";
  }
  else if(bit == WEAPON3){
    return "3";
  }
  else if(bit == WEAPON4){
    return "4";
  }
  else if(bit == WEAPON5){
    return "5";
  }
  else if(bit == WEAPON6){
    return "6";
  }
  else if(bit == WEAPON7){
    return "7";
  }
  else if(bit == WEAPON8){
    return "8";
  }
  else if(bit == WEAPON9){
    return "9";
  }
};