/*
battleMETAL
Author: Peter Roohr
Date: 08/18/2021
Overview: 
  I merged menu.dat and csqc.dat gui_api into a single shared file.
  
  some functionality that is CSQC specific has been ported over to here.
*/

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
void(float select, vector ofs, vector r_sz, vector ln_sz1, vector clr1, vector ln_sz2, vector clr2) gui_DrawHighlightRect={
  if(select){
    gui_DrawRect(ofs, r_sz, ln_sz1, clr1);
  }else{
    gui_DrawRect(ofs, r_sz, ln_sz2, clr2);
  }
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
    panelAdjust = Vector2(targetSize_x * 0.025,  targetSize_y * -0.075);
    gui_renderPatch9_1_32(toolTipOrigin + panelAdjust, targetSize, panelColor, alph + 0.25, 0);
	}
	gui_wrapText( toolTipOrigin + panelAdjust, targetSize, tipMessage, fontSize, textColor, alph); 
  drawfont = drawfont_prev;
};

/*
  Simply renders a tooltip help box, enforcing global styling standard.
*/
void( vector tipOrg ) gui_renderTooltipIcon={
  drawpic( tipOrg, UI_HELP_IMG, '14 14', CLR_DEF_RET_HASLOCK, 1, 0);
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
