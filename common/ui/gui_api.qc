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


vector(float x, float y, float z) Vector3={
  local vector v;
  v_x = x;
  v_y = y;
  v_z = z;
  return v;
};


vector(float x, float y) Vector2={
  local vector v;
  v_x = x;
  v_y = y;
  return v;
};


string(float anglee) gui_angleToNav={
  anglee = anglemod(anglee);
  if(anglee >= 337.5 || anglee < 22.5){
    return "N";
  }
  else if(anglee >= 22.5 && anglee < 67.5){
    return "NW";  
  }
  else if(anglee >= 67.5 && anglee < 112.5){
    return "W";  
  }
  else if(anglee >= 112.5 && anglee < 157){
    return "SW"; 
  }
  else if(anglee >= 157 && anglee < 202){
    return "S";
  }
  else if(anglee >= 202 && anglee < 247){
    return "SE";  
  }
  else if(anglee >= 247 && anglee < 292){
    return "E";  
  }
  else if(anglee >= 292 && anglee < 337.5){
    return "NE"; 
  }
  else{
    return "?";
  }
};

string(float anglee) gui_angleToArrow={
  anglee = anglemod(anglee);
  if(anglee >= 337.5 || anglee < 22.5){
    return "gfx/hud/map_lf.png";
  }
  else if(anglee >= 22.5 && anglee < 67.5){
    return "gfx/hud/map_ul.png";
  }
  else if(anglee >= 67.5 && anglee < 112.5){
    return "gfx/hud/map_up.png";
  }
  else if(anglee >= 112.5 && anglee < 157){
    return "gfx/hud/map_ur.png";
  }
  else if(anglee >= 157 && anglee < 202){
    return "gfx/hud/map_rt.png";
  }
  else if(anglee >= 202 && anglee < 247){
    return "gfx/hud/map_dr.png";
  }
  else if(anglee >= 247 && anglee < 292){
    return "gfx/hud/map_dn.png";
  }
  else if(anglee >= 292 && anglee < 337.5){
    return "gfx/hud/map_dl.png";
  }
  else{
    return "gfx/hud/map_dr.png";
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

/*
  Lame attempt to get aspect ratio applied to UI elements...can this be a built-in 
  for DP already?
  
  (original height / original width) x new width = new height
    
  aspect ratio = original width / original height
  adjusted height = <user chosen width> / aspect ratio
  
  adjusted width / (original width / original height) = adjusted height,
  
  -> from Darkplaces Engine (vid_conwidthauto)
  conwidth = floor(conheight * vid.width / (vid.height * vid_pixelheight.value));
*/
void() gui_set_screen_size={
  
  VIEW_WIDTH = cvar("vid_width");
  VIEW_HEIGHT = cvar("vid_height");
  VIEW_PIXELH = cvar("vid_pixelheight");

  UI_ASPECT = VIEW_WIDTH / VIEW_HEIGHT;
  
  VIEW_MAX_x = cvar("vid_conwidth");
  VIEW_MAX_y = cvar("vid_conheight");
  
  VIEW_CTR = VIEW_MAX * 0.5;
  
  UI_ORG = VIEW_CTR - Vector2(320, VIEW_MAX_y / 2);
  UI_MAX = Vector2(UI_ORG_x + 640, VIEW_MAX_y);
  UI_CTR = UI_ORG + (UI_MAX * 0.5);
  
  //some stuff requires knowing percents rather than values....looking at you con_chatpos  u_u
  UI_ORG_PERCENT_x = UI_ORG_x / VIEW_MAX_x;
  UI_ORG_PERCENT_y = UI_ORG_y / VIEW_MAX_y;
  
  UI_CTR_PERCENT_x = (UI_CTR_x / VIEW_MAX_x) - (UI_ORG_PERCENT_x * 2);  //left-and-right margins
  UI_CTR_PERCENT_y = (UI_CTR_y / VIEW_MAX_y) - (UI_ORG_PERCENT_y * 2);
  
  UI_MAX_PERCENT_x = (640 / VIEW_MAX_x) + UI_ORG_PERCENT_x;
  UI_MAX_PERCENT_y = VIEW_MAX_y / VIEW_MAX_y;
};

vector(float pcx, float pcy) gui_percentToPixel={
  local vector pixel;
  
  pixel_x = VIEW_MAX_x * pcx;
  pixel_y = VIEW_MAX_y * pcy;
  
  pixel_z = 0;
  return pixel;
};

float(float pcx) gui_percentX={
  return (VIEW_MAX_x * pcx);
};

float(float pcy) gui_percentY={
  return (VIEW_MAX_y * pcy);
}; 

//Raw is for dynamically generated values
//the UI was aligned on a 1280x960 display

vector(float tX, float tY) gui_percentToPixelRaw={
  local vector pct;
  pct = '0 0 0';
  if(tX < 0){
    pct_x = 0 - tX;
    pct_x = pct_x / 1280;
    pct_x = 0 - pct_x;
  }
  else{
    pct_x = tX / 1280;
  }
  if(tY < 0){
    pct_y = 0 - tY;
    pct_y = pct_y / 960;
    pct_y = 0 - pct_y;
  }
  else{
    pct_y = tY / 960;
  }
  pct_x = tX;
  pct_y = tY;
  //return gui_percentToPixel(pct_x, pct_y);
  return pct;
};

vector(vector p) gui_percentToPixelRawVec={
  local vector pct;
  /*pct = '0 0 0';
  if(p_x < 0){
    pct_x = 0 - p_x;
    pct_x = pct_x / 1280;
    pct_x = 0 - pct_x;
  }
  else{
    pct_x = p_x / 1280;
  }
  if(p_y < 0){
    pct_y = 0 - p_y;
    pct_y = pct_y / 960;
    pct_y = 0 - pct_y;
  }
  else{
    pct_y = p_y / 960;
  }
  
  return gui_percentToPixel(pct_x, pct_y);*/
  return p;
};

float(float pcx) gui_percentXRaw={
  local float pct;
  /*if(pcx < 0){
    pcx = pcx * -1;
    pct = pcx / 1280;
    pct = gui_percentX(pct);
    pct = pct * -1;
  }
  else{
    pct = pcx / 1280;
    pct = gui_percentX(pct);
  }*/
  return pcx;
};


float(float pcy) gui_percentYRaw={
  /*local float pct;
  if(pcy < 0){
    pcy = pcy * -1;
    pct = pcy / 960;
    pct = gui_percentY(pct);
    pct = pct * -1;
  }
  else{
    pct = pcy / 960;
    pct = gui_percentY(pct);
  }*/
  return pcy;
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

string RECT32_TL = "gfx/ui/box32_tl.tga";
string RECT32_TC = "gfx/ui/box32_tc.tga";
string RECT32_TR = "gfx/ui/box32_tr.tga";
string RECT32_ML = "gfx/ui/box32_ml.tga";
string RECT32_MC = "gfx/ui/box32_mc.tga";
string RECT32_MR = "gfx/ui/box32_mr.tga";
string RECT32_BL = "gfx/ui/box32_bl.tga";
string RECT32_BC = "gfx/ui/box32_bc.tga";
string RECT32_BR = "gfx/ui/box32_br.tga";


void(vector org, vector siz, vector colr, float alpha, float drawFlag) gui_renderPatch9_1_32={
  
  local float rows;
  local float cols;
  
  local float celSize;
  local float i;
  local float j;
  
  cols = floor(siz_x / 16);
  rows = floor(siz_y / 16);
  
  celSize = 16;
  
  //top-left corner
  drawpic(org, RECT32_TL, '16 16', colr, alpha, drawFlag);
  
  //top bar
  for(i=1; i < cols; i=i+1){
    drawpic(org + Vector2(i*celSize, 0), RECT32_TC, '16 16', colr, alpha, drawFlag);
  }
  
  //top-right corner
  drawpic(org + Vector2(cols * celSize, 0), RECT32_TR, '16 16', colr, alpha, drawFlag);
  
  //bottom left corner
  drawpic(org + Vector2(0, (rows-1) * celSize), RECT32_BL, '16 16', colr, alpha, drawFlag);
  
  //bottoms bar
  for(i=1; i < cols; i=i+1){
    drawpic(org + Vector2(i*celSize, (rows-1)* celSize), RECT32_BC, '16 16', colr, alpha, drawFlag);
  }
  
  //bottom right corner
  drawpic(org + Vector2(cols * celSize, (rows-1)* celSize), RECT32_BR, '16 16', colr, alpha, drawFlag);
  
  //left side
  for(i=1; i < rows-1; i=i+1){
    drawpic(org + Vector2(0, i * celSize), RECT32_ML, '16 16', colr, alpha, drawFlag);
  }
  
  //right side
  for(i=1; i < rows-1; i=i+1){
    drawpic(org + Vector2(cols * celSize, i * celSize), RECT32_MR, '16 16', colr, alpha, drawFlag);
  }
  
  if(cols > 2 && rows > 2 ){
    for(i=1; i < cols; i=i+1){
      for(j=1; j < rows-1; j=j+1){
        drawpic(org + Vector2(i * celSize, j * celSize), RECT32_MC, '16 16', colr, alpha, drawFlag);
      }
    }
  }
};


string BORD32_TL = "gfx/ui/bor32_tl.tga";
string BORD32_TC = "gfx/ui/bor32_tc.tga";
string BORD32_TR = "gfx/ui/bor32_tr.tga";
string BORD32_ML = "gfx/ui/bor32_ml.tga";
string BORD32_MR = "gfx/ui/bor32_mr.tga";
string BORD32_BL = "gfx/ui/bor32_bl.tga";
string BORD32_BC = "gfx/ui/bor32_bc.tga";
string BORD32_BR = "gfx/ui/bor32_br.tga";
void(vector org, vector siz, vector colr, float alpha, float drawFlag) gui_renderBorder9_1_32={
  
  local float rows;
  local float cols;
  
  local float celSize;
  local float i;
  local float j;
  
  cols = floor(siz_x / 16);
  rows = floor(siz_y / 16);
  
  celSize = 16;
  
  //top-left corner
  drawpic(org, BORD32_TL, '16 16', colr, alpha, drawFlag);
  
  //top bar
  for(i=1; i < cols; i=i+1){
    drawpic(org + Vector2(i*celSize, 0), BORD32_TC, '16 16', colr, alpha, drawFlag);
  }
  
  //top-right corner
  drawpic(org + Vector2(cols * celSize, 0), BORD32_TR, '16 16', colr, alpha, drawFlag);
  
  //bottom left corner
  drawpic(org + Vector2(0, (rows-1) * celSize), BORD32_BL, '16 16', colr, alpha, drawFlag);
  
  //bottoms bar
  for(i=1; i < cols; i=i+1){
    drawpic(org + Vector2(i*celSize, (rows-1)* celSize), BORD32_BC, '16 16', colr, alpha, drawFlag);
  }
  
  //bottom right corner
  drawpic(org + Vector2(cols * celSize, (rows-1)* celSize), BORD32_BR, '16 16', colr, alpha, drawFlag);
  
  //left side
  for(i=1; i < rows-1; i=i+1){
    drawpic(org + Vector2(0, i * celSize), BORD32_ML, '16 16', colr, alpha, drawFlag);
  }
  
  //right side
  for(i=1; i < rows-1; i=i+1){
    drawpic(org + Vector2(cols * celSize, i * celSize), BORD32_MR, '16 16', colr, alpha, drawFlag);
  }
};


vector(vector areaMins, vector areaMinAndMax, vector objectCoords, vector uiOffsetStart, vector uiAreaSize) gui_mapCoordToImgCoord={
  local vector mapCenter, objectTransform, objectPercent, objectUIOrg;
  
  mapCenter_x = ((areaMins_x*-1)/areaMinAndMax_x) * areaMinAndMax_x;
  mapCenter_x = areaMinAndMax_x - mapCenter_x;
  
  mapCenter_y = ((areaMins_y*-1)/areaMinAndMax_y) * areaMinAndMax_y;
  mapCenter_y = areaMinAndMax_y - mapCenter_y;
  
  objectTransform = mapCenter - objectCoords;
  objectTransform_z = 0;
  
  objectPercent = gui_percentCustomVec(objectTransform, areaMinAndMax, uiAreaSize);
  objectUIOrg = uiOffsetStart + objectPercent;
  
  return objectUIOrg;
};



void(float bool, vector org, string img, vector i_sz, vector tnt_clr, vector nrm_clr, float setAlpha, float flg) gui_renderTintImage2={
  local vector clr;
  if(bool){
    clr = tnt_clr;
  }
  else{
    clr = nrm_clr;
  }
  drawpic(org, img, i_sz, clr, setAlpha, flg);
};


void(float bool, vector org, string img, vector i_sz, vector tnt_clr, float setAlpha, float flg) gui_renderTintImage={
  local vector clr;
  if(bool){
    clr = tnt_clr;
  }
  else{
    clr = '1 1 1';
  }
  drawpic(org, img, i_sz, clr, setAlpha, flg);
};






void(float val, vector org, vector sz, vector clr_bk, vector clr_fr, float setAlpha, float flg, float ax, float vdir) gui_renderMeter={
  /*
    given target origin, meter size, current meter value
  */
  local float clampVal, perc, adj, diff;
  local vector norg, end;
  norg = gui_calcAxis(org, sz, ax);
  if(clr_bk_x > -1){
    drawfill(norg, sz, clr_bk, setAlpha, flg);
  }
  end = norg;
  
  clampVal = min( val, 100);
  
  perc = (clampVal / 100);
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
  drawfill(norg, sz, clr_fr, setAlpha, flg);
};

/*
*/
vector(vector offSet, float algn) gui_calcAlign={
  if(algn > 0){
    local vector toSender;
    if( (algn & VIEW_TOP) ){
      toSender_y = VIEW_ORG_y + offSet_y;
    }
    else if( (algn & VIEW_BOT) ){
      toSender_y = VIEW_MAX_y - offSet_y;
    }
    
    if( (algn & VIEW_LFT) ){
      toSender_x = VIEW_ORG_x + offSet_x;
    }
    else if( (algn & VIEW_RGT) ){
      toSender_x = VIEW_MAX_x - offSet_x;
    }
    
    if( (algn & VIEW_CTX) ){
      toSender_x = VIEW_CTR_x - offSet_x;
    }
    if( (algn & VIEW_CTY) ){
      toSender_y = VIEW_CTR_y - offSet_y;
    }
    return toSender;
  }
  else{
    return offSet;
  }
};

/*
  Align to a custom origin instead of TOPLEFT
*/
vector(vector offSet, float algn, vector org) gui_calcAlignCustom={
  local vector toSender;
  if((algn & VIEW_TOP)){
    toSender_y = org_y - offSet_y;
  }
  else if((algn & VIEW_BOT)){
    toSender_y = org_y + offSet_y;
  }
  
  if((algn & VIEW_LFT)){
    toSender_x = org_x - offSet_x;
  }
  else if((algn & VIEW_RGT)){
    toSender_x = org_x + offSet_x;
  }
  
  if((algn & VIEW_CTX)){
   toSender_x = org_x + offSet_x;
  }
  if((algn & VIEW_CTY)){
    toSender_y = org_y + offSet_y;
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

void(vector ofs, float bit, float state1, vector color1, vector color2, vector sz, float setAlpha, float flg) gui_renderModalPip={
  local vector colorActual;
  if(bit & state1){
    colorActual = color1;
  }
  else{
    colorActual = color2;
  }
  
  drawfill(ofs, sz, colorActual, setAlpha, flg);
};

void(vector ofs, float bool, vector color1, vector color2, vector sz, float setAlpha, float flg) gui_renderModalFill={
  local vector colorActual;
  if(bool){
    colorActual = color1;
  }
  else{
    colorActual = color2;
  }
  drawfill(ofs, sz, colorActual, setAlpha, flg);
};

/*
  Draws an image that occupies the entire screen size
*/
void(string src_img, vector tintcolor, float setAlpha, float flg) gui_renderImageFullScreen={
  local vector pnl_sz, img_sz, ofs, org;
  local float aln;
  
  img_sz = draw_getimagesize(src_img);
  aln = VIEW_BOT | VIEW_LFT;
  pnl_sz_x = VIEW_MAX_x;
  pnl_sz_y = img_sz_y;
  ofs_y = ofs_y + pnl_sz_y;
  org = gui_calcAlign(ofs, aln);
  drawpic(org, src_img, pnl_sz, tintcolor, setAlpha, flg);
};

void(string str, vector ofs, vector hclr, vector clr, float bool, vector sz, float setAlpha, float flg) gui_renderHighlightString={
  if(bool){
    gui_renderString(str, ofs, hclr, sz, setAlpha, flg);
    return;
  }
  gui_renderString(str, ofs, clr, sz, setAlpha, flg);
};

void(string str, vector ofs, vector color, vector sz, float setAlpha, float flg) gui_renderString={
  drawstring(ofs, str, sz,color, setAlpha, flg);
};

vector(vector sz) gui_getCenter={
  local vector toSender;
  toSender_x = sz_x / 2;
  toSender_y = sz_y / 2;
  return toSender;
};

void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float setAlpha, float flg) gui_renderImageReel={
  local vector isz;
  isz = draw_getimagesize(src_img);
  clipSize_x = clipSize_x / isz_x;
  clipSize_y = clipSize_y / isz_y;
  isz = gui_scaleSize(isz, VIEW_SCALE);
  drawsubpic(srcOrg, isz, src_img, percent, clipSize, clr, setAlpha, flg);
  
};

/*
  Displays text that will wrap to a given area as best it can.
  Y coords are unbound, so it will spill over the area's y coord - sorry :(
  
  it returns the ending y coord so you have a reference of where the wrapping ended,
  see ui_brief_c.menu_briefObjectivePanel() for a use-case
*/
float(vector loc, vector area, string text, vector fsize, vector clr, float alph) gui_wrapText={
  
  local float totes, token, line_row, line_length;
  local vector varea, textOrg;
  local vector charpos;
  local float charlen, pipe;
  local string toke;
  
  varea = area;
  totes = tokenizebyseparator(text, " ");
  
  token = 0;
  textOrg = loc;
  line_row = 0;
  line_length = 0;
  toke = argv(token);
  
  while( strlen(toke) > 0 ){
    toke = argv(token);
    
    if( toke == "|" ){
      //code can't seem to understand '\n' character read in from a strzone'd string, so use '|' for line breaks on external strings
      toke = "\n";
    }
    pipe = strstrofs(toke, "\n", 0);
    if( pipe != -1 ){
      toke = substring(toke, pipe, strlen(toke));
    }
    if(toke != "\n"){
      if( toke == "+" ){
        //make lists?
        line_row = line_row + 1;
        line_length = 0;
      }
      toke = strcat(toke, " ");
      charlen = stringwidth(toke, 0, fsize);
      charpos_x = textOrg_x + line_length;
      line_length = line_length + charlen;
      if( line_length > varea_x ){
        charpos_x = textOrg_x;
        line_row = line_row + 1;
        line_length = charlen;
      }
      charpos_y = textOrg_y + (line_row * (fsize_y + (fsize_y * 0.12)));
      drawstring(charpos, toke, fsize, clr, alph, 0);
    }
    else{
      line_row = line_row + 0.75;
      line_length = 0;
    }
    token = token + 1;
    toke = argv(token);
  }
  
  return (line_row+1) * (fsize_y + (fsize_y * 0.15));
}

void( vector lOrg, string label, string value, vector labelColor, vector valueColor, vector fonts, vector fontSize ) gui_labelKeyPair={
  local float labelLen, valueLen;
  
  local vector valueOrg;
  
  labelLen = stringwidth( label, 0, fontSize );
  valueLen = stringwidth( value, 0, fontSize );
  
  drawfont_prev = drawfont;
  drawfont = fonts_x;
    drawstring( lOrg, label, fontSize, labelColor, 1, 0 );
  
  drawfont = drawfont_prev;
  
  valueOrg = Vector2(lOrg_x + labelLen + fontSize_x, lOrg_y);
  
  drawfont_prev = drawfont;
  drawfont = fonts_y;
    drawstring( valueOrg, value, fontSize, valueColor, 1, 0 );
  
  drawfont = drawfont_prev;
};

float( float desiredColor, float startColor, float colorRate ) gui_colorFadeTo={
  local float newValue;

  newValue = (desiredColor * colorRate) + (startColor * (1 - colorRate));
  return newValue;
};


void() gui_drawversion={
  local float lblLen;
  local string lbl;
  local float lblAlpha;
  local vector lowerLeft, lowerRight, upperRight;
  
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
  lbl = strcat("Release ",cvar_string("gameversion"));
  
  lblAlpha = 0.4;
  
  lblLen = stringwidth(lbl, 0, '12 12 0');
  drawstring(VIEW_ORG + '2 2', lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  lowerLeft = VIEW_ORG;
  lowerLeft_y = lowerLeft_y + VIEW_MAX_y - 14;
  drawstring(lowerLeft + '2 0', lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  lowerRight = VIEW_MAX;
  lowerRight_x = lowerRight_x - lblLen;
  lowerRight_y = lowerRight_y - 14;
  drawstring(lowerRight, lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  upperRight_x = VIEW_MAX_x - lblLen;
  upperRight_y = 2;
  drawstring(upperRight, lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  drawfont = drawfont_prev;
};

string(float checkSkill) gui_skillAsString={
  local string s;
  switch(checkSkill){
    default:
      s = "Recruit";
      break;
    case 1:
      s = "Regular";
      break;
    case 2:
      s = "Veteran";
      break;
    case 3:
      s = "Ace";
      break;
  }
  return s;
};


void(string msg, float val) cons_logAFloat={
  print(sprintf("%s : %s\n", msg, ftos(val)));
};
void(string msg, vector v1) cons_logAVector={
  print(sprintf("%s : %s\n", msg, vtos(v1)));
};
void(string msg, string s1) cons_logAString={
  print(sprintf("%s : %s\n", msg, s1));
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