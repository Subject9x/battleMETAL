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
  pct = '0 0 0';
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

vector(vector p) gui_percentToPixelRawVec={
  local vector pct;
  pct = '0 0 0';
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
  
  return gui_percentToPixel(pct_x, pct_y);
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
    pct = pcy / 960;  //BUG - WAS wrong value, fix all references!
    pct = gui_percentY(pct);
    pct = pct * -1;
  }
  else{
    pct = pcy / 960;
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

vector(vector areaMins, vector areaMinAndMax, vector objectCoords, vector uiOffsetStart, vector uiAreaSize) gui_mapCoordToImgCoord={
  local vector mapCenter, objectTransform, objectPercent, objectUIOrg;
  
  mapCenter_x = ((areaMins_x*-1)/areaMinAndMax_x) * areaMinAndMax_x;
  mapCenter_x = areaMinAndMax_x - mapCenter_x;
  
  mapCenter_y = ((areaMins_y*-1)/areaMinAndMax_y) * areaMinAndMax_y;
  mapCenter_y = areaMinAndMax_y - mapCenter_y;
  
  objectTransform = mapCenter - objectCoords;
  objectTransform_z = 0;
  
  objectPercent = gui_percentCustomVec(objectTransform, areaMinAndMax, uiAreaSize);
  objectUIOrg = uiOffsetStart + gui_percentToPixelRawVec(objectPercent);
  
  return objectUIOrg;
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


vector(float val) gui_getColorForArmor={
  if((0<val)&&(val<=25)){
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

vector(float val) gui_getColorForArmorTarget={
  if((0<val)&&(val<=25)){
    return CLR_DEF_TARG_ARM_ONEQ;
  }
  else if((25<val)&&(val<=50)){
    return CLR_DEF_TARG_ARM_HALF;
  }
  else if((50<val)&&(val<=75)){
    return CLR_DEF_TARG_ARM_THREEQ;
  }
  else if((75<val)&&(val<=100)){
    return CLR_DEF_TARG_ARM_OK;
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
  return CLR_DEF_ARM_DED;
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
  }
  else{
    gui_renderString(str, ofs, clr, sz, setAlpha, flg);
  }
};


void(string str, vector ofs, vector color, vector sz, float setAlpha, float flg) gui_renderString={
  drawstring(ofs, str, sz,color, setAlpha, flg);
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


void(vector srcOrg, vector percent, string src_img, vector clipSize, vector clr, float setAlpha, float flg) gui_renderImageReel={
  local vector isz;
  isz = draw_getimagesize(src_img);
  clipSize_x = clipSize_x / isz_x;
  clipSize_y = clipSize_y / isz_y;
  isz = gui_scaleSize(isz, VIEW_SCALE);
  drawsubpic(srcOrg, isz, src_img, percent, clipSize, clr, setAlpha, flg);
  
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
  
  local float totes, token, line_row, line_length;
  local vector varea, textOrg;
  local vector charpos;
  local float charlen, pipe;
  local string toke;
  
  varea = gui_percentToPixelRawVec(area);
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
      line_length = line_length + gui_percentXRaw(charlen);
      if( line_length > varea_x ){
        charpos_x = textOrg_x;
        line_row = line_row + 1;
        line_length = charlen;
      }
      charpos_y = textOrg_y + (line_row * (fsize_y + (fsize_y * 0.15)));
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
};

/*
	tipMessage = string for the tooltip.
	targetSize = ideal size for the text and (optional) image panel - final size isn't fixed, you will have to adjust size to match output.
	fontSize = size of the font for text.
	panelImage = if != "", this will draw your desired image as the background panel to the tip.
	cursorOffset = offset from mouse's screen position to draw the tooltip.
	textColor = color for the text.
	boxColor = color TINT of image, '1 1 1' means no color tinting.
	alph = alpha, the alpha of the tooltip.
*/
void(string tipMessage, vector targetSize, vector fontSize, string panelImage, vector cursorOffset, vector textColor, vector panelColor, float alph ) gui_toolTipMessage={
	local vector toolTipOrigin;
	local vector panelAdjust;
	
  drawfont_prev = drawfont;
  drawfont = FONT_NUM_ROBOT_REGULAR;
  
	toolTipOrigin = cursorpos + cursorOffset;
	
	if( (toolTipOrigin_x + targetSize_x) > VIEW_MAX_x ){
		toolTipOrigin_x = toolTipOrigin_x - (cursorImageSize_x + targetSize_x);
	}
	
	if( (toolTipOrigin_y + targetSize_y) > VIEW_MAX_y ){
		toolTipOrigin_y = toolTipOrigin_y - (cursorImageSize_y + targetSize_y);
	}
	
	if( panelImage && (panelImage != "") ){
		panelAdjust_x = targetSize_x * 0.025;
		panelAdjust_y = targetSize_y * -0.075;
		drawpic( toolTipOrigin + panelAdjust - gui_percentToPixelRawVec('2 2'), panelImage, targetSize + gui_percentToPixelRawVec('4 4'), panelColor - (panelColor * 0.85), alph + 0.25, 0 );
		drawpic( toolTipOrigin + panelAdjust, panelImage, targetSize, panelColor, alph + 0.25, 0 );
	}
	gui_wrapText( toolTipOrigin + panelAdjust, targetSize, tipMessage, fontSize, textColor, alph); 
  drawfont = drawfont_prev;
};

void( vector lOrg, string label, string value, vector labelColor, vector valueColor, vector fonts, vector fontSize ) gui_labelKeyPair={
  local float labelLen, valueLen;
  
  local vector valueOrg;
  
  labelLen = stringwidth( label, 0, fontSize );
  valueLen = stringwidth( value, 0, fontSize );
  
  drawfont_prev = drawfont;
  drawfont = fonts_x;
    drawstring( lOrg, label, fontSize, labelColor, 1, 0 );
  
  drawfont = drawfont_prev;
  
  valueOrg_x = lOrg_x + gui_percentXRaw(labelLen) + fontSize_x;
  valueOrg_y = lOrg_y;
  
  drawfont_prev = drawfont;
  drawfont = fonts_y;
    drawstring( valueOrg, value, fontSize, valueColor, 1, 0 );
  
  drawfont = drawfont_prev;
};

/*
  Simply renders a tooltip help box, enforcing global styling standard.
*/
void( vector tipOrg ) gui_renderTooltipIcon={
  drawpic( tipOrg, UI_HELP_IMG, gui_percentToPixelRawVec('14 14'), CLR_DEF_RET_HASLOCK, 1, 0);
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
  drawstring(VIEW_ORG + gui_percentToPixelRawVec('2 2'), lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  lowerLeft = VIEW_ORG;
  lowerLeft_y = lowerLeft_y + VIEW_MAX_y - gui_percentXRaw(14);
  drawstring(lowerLeft + gui_percentToPixelRawVec('2 0'), lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  lowerRight = VIEW_MAX;
  lowerRight_x = lowerRight_x - gui_percentXRaw(lblLen);
  lowerRight_y = lowerRight_y - gui_percentYRaw(14);
  drawstring(lowerRight, lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  upperRight_x = VIEW_MAX_x - gui_percentXRaw(lblLen);
  upperRight_y = gui_percentYRaw(2);
  drawstring(upperRight, lbl, '12 12', '1 1 1', lblAlpha, 0);
  
  drawfont = drawfont_prev;
};

entity(float wepBit) gui_get_weapon={
  local entity item;
  local entity found;
  
  item = findfloat(world, clientLocalId, player_localentnum);
  item = item.w_slot;
  while( item != world ){
    if(item.w_group == wepBit){
      found = item;
    }
    item = item.w_slot;
  }
  if(found){
    return found;
  }
  return world;
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