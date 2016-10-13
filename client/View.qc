// CSQC_UpdateView - Called every rendered frame on the client.  Useful for HUD drawing operations.
void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
  local vector screen_size, screen_center;

	screen_size = screen_center = '0 0 0';//prevent noref warning
	screen_size_x = vwidth;
	screen_size_y = vheight;

	screen_center_x = screen_size_x/2;
	screen_center_y = screen_size_y/2;


	// ALWAYS Clear Current Scene First
	clearscene();

	// Assign Standard Viewflags
		// Draw the World (and sky)
		setviewprop(VF_DRAWWORLD, 1);
		// Draw the Crosshair
		setviewprop(VF_DRAWCROSSHAIR, 1);
		// Draw the Engine Status Bar (the default Quake HUD)
		setviewprop(VF_DRAWENGINESBAR, 0);

	// Setup Entities to be Rendered (include all base types; normal, engine and viewmodels)
	addentities(MASK_ENGINE | MASK_VIEWMODEL);
	
	// Render the Scene
	renderscene();
  
  //draw hud
  local float hp, en_mx, en_cr, sh_mx, sh_cr;
  hp = getstatf(STAT_HEALTH);
  en_cr = getstatf(STAT_ENERGY_CUR);
  en_mx = getstatf(STAT_ENERGY_MAX);
  //drawfill float(vector position, vector size, vector rgb, float alpha,  float flag) 
  
  //vector ENG_COLOR_CURRENT;
  //vector SHD_COLOR_CURRENT;
  //vector DMG_COLOR_CURRENT;
  if(en_cr <= (en_mx/2)){
    ENG_COLOR_CURRENT = DMG_COLOR_YELLOW;
    if(en_cr <= (en_mx/4)){
      ENG_COLOR_CURRENT = DMG_COLOR_RED;
      if(en_cr <= 0){
        ENG_COLOR_CURRENT = DMG_COLOR_GRAY;
      }
    }
  }
  else{
    ENG_COLOR_CURRENT = DMG_COLOR_GREEN;
  }
  local vector shl_loc;
  shl_loc = '0 0 0';
  shl_loc_x = shl_loc_x + 150;
  shl_loc_y = shl_loc_y + screen_center_y - 48;
  drawfill(shl_loc, '48 48 0', ENG_COLOR_CURRENT, 1, 0 );
  drawstring((shl_loc + '1 20 0'), "ENERGY", '8 8 0', '1 1 1', 1, 0);
  
  drawstring('0 16 0', ftos(en_cr), '8 8 0', '1 1 1', 1, 0);
  drawstring('0 26 0', ftos(en_mx), '8 8 0', '1 1 1', 1, 0);
  
  //drawstring('0 0 0', ftos(hp), '8 8 0', '1 1 1', 1, 0);
}
