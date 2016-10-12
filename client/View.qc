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
		setviewprop(VF_DRAWENGINESBAR, 1);



	// Setup Entities to be Rendered (include all base types; normal, engine and viewmodels)
	addentities(MASK_ENGINE | MASK_VIEWMODEL);
	
	// Render the Scene
	renderscene();
  
  //draw hud
  local float hp;
  hp = getstatf(STAT_HEALTH);
  //drawfill float(vector position, vector size, vector rgb, float alpha,  float flag) 
  
  drawfill('0 0 0','8 12 0', DMG_COLOR_GREEN, 1, 0 );
  //drawstring('0 0 0', ftos(hp), '8 8 0', '1 1 1', 1, 0);
}
