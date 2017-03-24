/*
mech Mod
Author: Subject9x
Date: 03/8/2017
Overview: GUI API class file
*/

void(float bool, vector org, string img, vector i_sz, vector tnt_clr, float alpha, float flg) gui_renderTintImage={
  local vector clr;
  if(bool){
    clr = tnt_clr;
  }
  else{
    clr = '1 1 1';
  }
  drawpic(org, img, i_sz, clr, alpha, flg);
};


vector(float val) gui_getColorForArmor={
  if(val < 1){
    return CLR_DEF_ARM_DED;
  }
  else if((1<val)&&(val<=25)){
    return CLR_DEF_ARM_ONEQ;
  }
  else if((25<val)&&(val<50)){
    return CLR_DEF_ARM_HALF;
  }
  else if((50<val)&&(val<=75)){
    return CLR_DEF_ARM_THREEQ;
  }
  else if((75<val)&&(val<=100)){
    return CLR_DEF_ARM_OK;
  }
  else{
    return CLR_DEF_ARM_DED;
  }
};

vector(float val) gui_getColorForShield={
  if((1<val)&&(val<=25)){
    return CLR_DEF_SHD_ONEQ;
  }
  else if((25<val)&&(val<50)){
    return CLR_DEF_SHD_HALF;
  }
  else if((50<val)&&(val<=75)){
    return CLR_DEF_SHD_THREEQ;
  }
  else if((75<val)&&(val<=100)){
    return CLR_DEF_SHD_OK;
  }
  else{
    return CLR_DEF_SHD_DED;
  }
};


vector(float bits, float dead, float ok) gui_getWepStatusColor{
  if((bits & dead)){
    return '0.1 0.1 0.1';
  }
  else if((bits & ok)){
    return '0.215 0.709 0.29';
  }
}

void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderMeter={
  /*
    given target origin, meter size, current meter value
  */
  local float perc, adj, diff;
  local vector norg, end;
  norg = gui_calcAxis(org, sz, ax);  
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
vector(vector vec, float algn) gui_calcAlign={
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
vector(vector org, vector sz, float axs) gui_calcAxis={
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

vector(vector vec, float scle) gui_scaleSize={
  local vector toSender;
  toSender_x = vec_x * scle;
  toSender_y = vec_y * scle;
  
  return toSender;
};

vector(float val) gui_calcRadarHeat={
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

void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float alpha, float flg) gui_renderModalPip={
  local vector colorActual;
  if(bit & state1){
    colorActual = color1;
  }
  else{
    colorActual = color2;
  }
  
  drawfill(ofs, sz, colorActual, alpha, flg);
};

/*
  Draws an image that occupies the entire screen size
*/
void(string src_img, vector tintcolor, float alpha, float flg) gui_renderImageFullScreen={
  local vector pnl_sz, img_sz, ofs, org;
  local float aln;
  
  img_sz = draw_getimagesize(src_img);
  aln = VIEW_BOT | VIEW_LFT;
  pnl_sz_x = VIEW_MAX_x;
  pnl_sz_y = img_sz_y;
  ofs_y = ofs_y + pnl_sz_y;
  org = gui_calcAlign(ofs, aln);
  drawpic(org, src_img, pnl_sz, tintcolor, alpha, flg);
};

void(string str, vector ofs, vector color, vector sz, float alpha, float flg, float ax, float vdir) gui_renderString={

};

void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) gui_BoxOnLabel={
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

void(vector ofs, vector r_sz, vector ln_sz, vector clr) gui_DrawRect={
  local vector tl, tr, bl, br;
  tl = ofs;
  tr = ofs;
  tr_x = ofs_x + r_sz_x;
  bl_x = ofs_x;
  bl_y = ofs_y + r_sz_y;
  br = tr;
  br_y = tr_y + r_sz_y;
  
  drawline(ln_sz_x, tl, tr, clr, 1, 0);
  drawline(ln_sz_y, tl, bl, clr, 1, 0);
  drawline(ln_sz_y, tr, br, clr, 1, 0);
  drawline(ln_sz_x, bl, br, clr, 1, 0);
};
  

vector(vector sz) gui_getCenter={
  local vector toSender;
  toSender_x = sz_x / 2;
  toSender_y = sz_y / 2;
  return toSender;
};


void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float alpha, float flg) gui_renderImageReel={
  local vector isz, ratio, split_sz, split_org;
  isz = draw_getimagesize(src_img);
  clipSize_x = clipSize_x / isz_x;
  clipSize_y = clipSize_y / isz_y;
  isz = gui_scaleSize(isz, VIEW_SCALE);
  drawsubpic(srcOrg, isz, src_img, percent, clipSize, clr, alpha, flg);
  
};

string(float bit) gui_getWeaponId={
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

void(float select, vector ofs, vector r_sz, vector ln_sz1, vector clr1, vector ln_sz2, vector clr2) gui_DrawHighlightRect={
  if(select){
    gui_DrawRect(ofs, r_sz, ln_sz1, clr1);
  }else{
    gui_DrawRect(ofs, r_sz, ln_sz2, clr2);
  }
};