/*
battleMETAL
Author: Peter Roohr
Date: 03/8/2017
Overview: GUI API class file
*/

float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

string(float anglee) gui_angleToNav={
  anglee = anglemod(anglee);
  if(anglee >= 337.5 || anglee < 22.5){
    return "N";
  }
  else if(anglee >= 22.5 && anglee < 67.5){
    return "NE";  
  }
  else if(anglee >= 67.5 && anglee < 112.5){
    return "E";  
  }
  else if(anglee >= 112.5 && anglee < 157){
    return "ES"; 
  }
  else if(anglee >= 157 && anglee < 202){
    return "S";
  }
  else if(anglee >= 202 && anglee < 247){
    return "SW";  
  }
  else if(anglee >= 247 && anglee < 292){
    return "W";  
  }
  else if(anglee >= 292 && anglee < 337.5){
    return "NW"; 
  }
  else{
    return "?";
  }
};

float(float anglee) gui_angleToEnum={
  anglee = anglemod(anglee);
  if(anglee >= 315 || anglee < 45){
    return 0;
  }
  else if(anglee >= 45 && anglee < 135){
    return 1;  
  }
  else if(anglee >= 135 && anglee <  225){
    return 2;  
  }
  else if(anglee >= 225 && anglee < 315){
    return 3; 
  }
  else{
    return 0;
  }
};



vector(float pcx, float pcy) gui_percentToPixel={
  local vector pixel;
  pixel_x = VIEW_SIZE_x * pcx;
  pixel_y = VIEW_SIZE_y * pcy;
  pixel_z = 0;
  return pixel;
};

float(float pcx) gui_percentX={
  return (VIEW_SIZE_x * pcx);
};

float(float pcy) gui_percentY={
  return (VIEW_SIZE_y * pcy);
}; 

//Raw is for dynamically generated values
//the UI was aligned on a 1280x960 display
vector(float pcx, float pcy) gui_percentToPixelRaw={
  local vector pct;
  if(pcx < 0){
    pct_x = 0 - pcx;
    pct_x = pct_x / 1280;
    pct_x = 0 - pct_x;
  }
  else{
    pct_x = pcx / 1280;
  }
  if(pcy < 0){
    pct_y = 0 - pcy;
    pct_y = pct_y / 960;
    pct_y = 0 - pct_y;
  }
  else{
    pct_y = pcy / 960;
  }
  return gui_percentToPixel(pct_x, pct_y);
};

//oops
vector(vector p) gui_percentToPixelRawVec={
  return gui_percentToPixelRaw(p_x, p_y);
};

float(float pcx) gui_percentXRaw={
  local float pct;
  if(pcx < 0){
    pcx = pcx * -1;
    pct = pcx / 1280;
    pct = gui_percentX(pct);
    pct = pct * -1;
  }
  else{
    pct = pcx / 1280;
    pct = gui_percentX(pct);
  }
  return pct;
};

float(float pcy) gui_percentYRaw={
  local float pct;
  if(pcy < 0){
    pcy = pcy * -1;
    pct = pcy / 1280;
    pct = gui_percentY(pct);
    pct = pct * -1;
  }
  else{
    pct = pcy / 1280;
    pct = gui_percentY(pct);
  }
  return pct;
};

float(float pct, float ox, float mx) gui_percentCustom={
  pct = pct / ox;
  pct = pct * mx;
  return pct;
};

vector(vector pct, vector org_size, vector dest_size) gui_percentCustomVec={
  local vector ret;
  ret_x = gui_percentCustom(pct_x, org_size_x, dest_size_x);
  ret_y = gui_percentCustom(pct_y, org_size_y, dest_size_y);
  return ret;
};

vector(vector map_size, vector obj_coords, vector ui_coords, vector img_sz) gui_mapCoordToImgCoord={
  local vector map_ctr, obj_trans, obj_prc, obj_ui;
  map_ctr_x = ((world.mins_x*-1)/map_size_x) * map_size_x;
  map_ctr_x = map_size_x - map_ctr_x;
  map_ctr_y = ((world.mins_y*-1)/map_size_y) * map_size_y;
  map_ctr_y = map_size_y - map_ctr_y;
  obj_trans = map_ctr - obj_coords;
  obj_trans_z = 0;
  obj_prc = gui_percentCustomVec(obj_trans, map_size, img_sz);
  obj_ui = ui_coords + gui_percentToPixelRawVec(obj_prc);
  return obj_ui;
};
string(float navname) gui_getNavName={
  return NAVNAMES[navname];
};

vector(float dmg_type) gui_colorForWeaponType={
  if((dmg_type & DMG_BAL)){
    return CLR_DEF_ARM_HALF;
  }
  else if((dmg_type & DMG_ENE)){
    return ( CLR_DEF_ARM_ONEQ + '0.25 0.2 0.2');
  }
  else if((dmg_type & DMG_EXP)){
    return CLR_DEF_ARM_OK;
  }
  else{
    return CLR_DEF_TXT_HIGHLIGHT;
  }
};

void(float bool, vector org, string img, vector i_sz, vector tnt_clr, vector nrm_clr, float alpha, float flg) gui_renderTintImage2={
  local vector clr;
  if(bool){
    clr = tnt_clr;
  }
  else{
    clr = nrm_clr;
  }
  drawpic(org, img, i_sz, clr, alpha, flg);
};


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
  if((-1<val)&&(val<=25)){
    return CLR_DEF_ARM_ONEQ;
  }
  else if((25<val)&&(val<=50)){
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
  else if((25<val)&&(val<=50)){
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

vector(float bits, float dead, float ok, float wrange, float prange) gui_getWepStatusColor={
  if((bits & dead)){
    return CLR_DEF_ARM_DED;
  }
  else if((bits & ok)){
    if(prange > wrange){
      return CLR_DEF_ARM_THREEQ;
    }
    else{
       return CLR_DEF_WHITE;
    }
  }
};

void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float alpha, float flg, float ax, float vdir) gui_renderMeter={
  /*
    given target origin, meter size, current meter value
  */
  local float perc, adj, diff;
  local vector norg, end;
  norg = gui_calcAxis(org, sz, ax);
  if(clr_bk_x > -1){
    drawfill(norg, sz, clr_bk, alpha, flg);
  }
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
     sz_x = sz_x - diff;
  }
  drawfill(norg, sz, clr_fr, alpha, flg);
};

/*
*/
vector(vector vec, float algn) gui_calcAlign={
  if(algn > 0){
    local vector toSender;
    if( (algn & VIEW_TOP) ){
      toSender_y = VIEW_ORG_y + vec_y;
    }
    else if( (algn & VIEW_BOT) ){
      toSender_y = VIEW_MAX_y - vec_y;
    }
    
    if( (algn & VIEW_LFT) ){
      toSender_x = VIEW_ORG_x + vec_x;
    }
    else if( (algn & VIEW_RGT) ){
      toSender_x = VIEW_MAX_x - vec_x;
    }
    
    if( (algn & VIEW_CTX) ){
      toSender_x = VIEW_CTR_x - vec_x;
    }
    if( (algn & VIEW_CTY) ){
      toSender_y = VIEW_CTR_y - vec_y;
    }
    return toSender;
  }
  else{
    return vec;
  }
};

vector(vector vec, float algn, vector org) gui_calcAlignCustom={
  local vector toSender;
  if((algn & VIEW_TOP)){
    toSender_y = org_y - vec_y;
  }
  else if((algn & VIEW_BOT)){
    toSender_y = org_y + vec_y;
  }
  
  if((algn & VIEW_LFT)){
    toSender_x = org_x - vec_x;
  }
  else if((algn & VIEW_RGT)){
    toSender_x = org_x + vec_x;
  }
  
  if((algn & VIEW_CTX)){
   toSender_x = org_x + vec_x;   
  }
  if((algn & VIEW_CTY)){
    toSender_y = org_y + vec_y;
  }
  
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

void(vector ofs, float bool, vector color1, vector color2, vector sz, float alpha, float flg) gui_renderModalFill={
  local vector colorActual;
  if(bool){
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

void(string str, vector ofs, vector hclr, vector clr, float bool, vector sz, float alpha, float flg) gui_renderHighlightString={

  if(bool){
    gui_renderString(str, ofs, hclr, sz, alpha, flg);
  }
  else{
    gui_renderString(str, ofs, clr, sz, alpha, flg);
  }
};


void(string str, vector ofs, vector color, vector sz, float alpha, float flg) gui_renderString={
  drawstring(ofs, str, sz,color, alpha, flg);
};

void(string str, vector ofs, vector txt_sz, vector ln_sz, vector clr) gui_BoxOnLabel={
  local float len;
  len = stringwidth(str, 0, txt_sz);
  local vector tl, tr, bl, br;
  tl = ofs - gui_percentToPixelRawVec('2 2');
  tr = ofs - gui_percentToPixelRawVec('2 2');
  tr_x = tr_x + len + gui_percentXRaw(4);
  bl = ofs;
  bl_x = tl_x;
  bl_y = bl_y + gui_percentYRaw(6);
  br = ofs;
  br_x = ofs_x + len + gui_percentXRaw(2);
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

/*
  Displays text that will wrap to a given area as best it can.
  Y coords are unbound, so it will spill over the area's y coord - sorry :(
  
  it returns the ending y coord so you have a reference of where the wrapping ended,
  see ui_brief_c.menu_briefObjectivePanel() for a use-case
*/
float(vector loc, vector area, string text, vector fsize, vector clr, float alph) gui_wrapText={
  local float totes, token, line_cnt, line_rtn;
  local vector vloc, varea, torg;
  local string line;
 
  varea = gui_percentToPixelRawVec(area);
  totes = tokenizebyseparator(text, " ");
  
  token = 0;
  line = "";
  torg = loc;
  line_cnt = 1;
  line_rtn = 1;
  while(token <= totes){
    local vector charpos;
    local float charlen, line_len;
    local string toke;
    toke = argv(token);
    if(toke == "|"){
      //code can't seem to understand '\n' character read in from a strzone'd string, so use '|' for line breaks on external strings
      toke = "\n";
    }
    if(toke != "\n"){
      if( (token > 0) || (line_rtn == 0) ){
        toke = strcat(" ", toke);
      }
      charlen = stringwidth(toke, 0, fsize);
      charpos_x = torg_x + line_rtn + gui_percentXRaw(fsize_x);
      line_rtn = line_rtn + gui_percentXRaw(charlen);
      if( line_rtn > varea_x ){
        charpos_x = torg_x;
        line_cnt = line_cnt + 1;
        line_rtn = charlen;
      }
    }
    else{
      line_cnt = line_cnt + 1;
      line_rtn = 0;
    }
    if( (toke != "\n") ){
      charpos_y = torg_y + (line_cnt * fsize_y);
      drawstring(charpos, toke, fsize, clr, alph);
    }
    token = token + 1;
  }
  return line_cnt * fsize_y;
};

void(string msg, float val) cons_logAFloat={
  print(strcat(msg,":", ftos(val),"\n"));
};
void(string msg, vector v1) cons_logAVector={
  print(strcat(msg,":", vtos(v1),"\n"));
};
void(string msg, string s1) cons_logAString={
  print(strcat(msg,":", s1,"\n"));
};

void(string msg, float val, string split, float val2) cons_log2Float={
  print(strcat(msg,":", ftos(val), " | ", split, ":", ftos(val2),"\n"));
};
void(string msg, vector v1, string split, vector v2) cons_log2Vectors={
  print(strcat(msg,":", vtos(v1),"| ", split,vtos(v2),"\n"));
};
void(string msg, string s1, string split, string s2) cons_log2Strings={
  print(strcat(msg," : ",s1," | ", split," : ",s2,"\n"));
};