
// called during level initialization, before first entities are received, only world is valid at this point
void() CSQC_Init =
{
	maxclients = 0;
	while (maxclients < 1024 && getplayerkeyvalue(maxclients, "viewentity"))
		maxclients = maxclients + 1;
  
	// this is the place to do any registercmd() calls we want for custom csqc commands (like replacing +showscores) so that they tab-complete properly
	// we can precache_sound and precache_model and precache_pic here
  plr_orig = '0 0 0';
  plr_angles = '0 0 0';
  VIEW_ORG = '0 0';
  
  cs_precache();
  hud_ini();
};

// called on level shutdown (disconnect, level change, quit, loading a saved game, etc)
void() CSQC_Shutdown =
{
};

// typ 0 = keydown (keysym, unicode character but this may be zero) or typed input (-1, unicode character)
// typ 1 = keyup (keysym, may have unicode character but generally not)
// typ 2 = mousemove (x, y) if inputmode is off
// typ 3 = mousepos (x, y) if inputmode is on
// return TRUE if you want to eat this event or FALSE if you want to pass it along to the engine code
float(float typ, float x, float y) CSQC_InputEvent =
{
	return FALSE;
};

// the most important function in CSQC...
void(float w, float h, float menushown) CSQC_UpdateView =
{
	/*local vector vf_size;
	local vector vf_min;
	
	local float chasecam, vid_width, vid_height,vid_conwidth,vid_conheight,vid_pixelheight;
	vf_size = getpropertyvec(VF_SIZE);
	vf_min = getpropertyvec(VF_MIN);
CON_W = vid_conwidth = cvar("vid_conwidth");
	CON_H = vid_conheight = cvar("vid_conheight");
	vid_pixelheight = cvar("vid_pixelheight");
  VIEW_SCALE = (w/h)/10;
	chasecam = cvar("chase_active") != 0;*/

	// do any manipulation we want on fov here (weapon zoom, respawn zoom, etc)
	// nothing right now

	// clear the scene information (entities, polygons, etc)
	clearscene();
  local vector fovvec,
                vf_sz,
                vf_mn;
	fovvec = getpropertyvec(VF_FOV); // note this is a vector (x and y are independent)
	vf_sz_x = w;
  vf_sz_y = h;
  vf_sz_z = 0;
  vf_mn = '0 0 0';
	// set up the scene parameters
	//setproperty(VF_SIZE, vf_size);
	//setproperty(VF_MIN, vf_min);
  setproperty(VF_MIN, vf_mn);   //set the left of the view
  setproperty(VF_SIZE, vf_sz);   //set how wide the view is (full width)
  
  //setproperty(VF_FOV, fovvec);
  setproperty(VF_DRAWWORLD, 1);
	setproperty(VF_DRAWCROSSHAIR, 1); // TODO custom crosshairs
	setproperty(VF_DRAWENGINESBAR, 0); // TODO custom hud
  VIEW_ORG = '0 0';
  VIEW_MAX_x = cvar("vid_conwidth");
  VIEW_MAX_y = cvar("vid_conheight");
  VIEW_SCALE = 0.35;
	// add clientside entities (MASK_NORMAL)
	// add engine networked entities (MASK_ENGINE)
	// and engine viewmodel and engine networked entities with the viewdemol flag (MASK_ENGINEVIEWMODELS)
	// TODO: do clientside viewmodel entity instead
	addentities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);

	// add any polygons we want here

	// draw the main view
	renderscene();

	// force switch to 2D polygon drawing in case we want to do any polygons before we draw pics and strings
	// FIXME: engine should have a drawflag for 3D and another for 2D (also would be nice to have 3D drawstring and drawpic)
	//drawstring('0 0 0', "", '1 1 0', '1 1 1', 0, 0);

	// draw custom hud
 //draw hud
 
  local float p_class, eid;
  local vector vforg;
  vforg = getpropertyvec(VF_ANGLES);
  p_class = getstati(STAT_PCLASS);
   eid = getstati(STAT_ENTITY_ID);
  /*drawstring('0 0 0', vtos(VIEW_ORG), '8 8 0', '1 1 1', 1, 0);
  drawstring('0 8 0', vtos(VIEW_MAX), '8 8 0', '1 1 1', 1, 0);
  drawstring('0 16 0', vtos(VIEW_MAX), '8 8 0', '1 1 1', 1, 0);
 */
  if(p_class != P_OBS){
    local float vid;
    local entity hud, oself, plr;
    vid = getstati(STAT_VID);
    hud = m_findData(vid);
    if(hud != world){
      oself = self;
      self = hud;
        hud_renderEnergy();
        hud_renderPaper();
        hud_renderShield();
      self = oself;
   }
  }
	// draw custom crosshair
};

// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command
float(string s) CSQC_ConsoleCommand =
{
	return FALSE;
};

// parse tempentity if it suits your fancy, return TRUE to tell engine you have finished parsing the tempentity, return FALSE to tell engine to parse tempentity itself (it will reset parse position automatically)
float() CSQC_Parse_TempEntity =
{
  local float id;
  id = ReadByte();
  
	return FALSE;
};

// if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).
void(string s) CSQC_Parse_StuffCmd =
{
	localcmd(s);
};

// if string is interesting, deal with it, otherwise pass it to print() to invoke the engine code.
void(string s) CSQC_Parse_Print =
{
	print(s);
};

// if string is interesting, deal with it, otherwise pass it to centerprint() to invoke the engine code.
void(string s) CSQC_Parse_CenterPrint =
{
	centerprint(s);
};

// return TRUE if you wish to eat this sound, return FALSE to let engine handle it.
float(entity ent, float channel, string soundname, float volume, float attenuation, vector pos, float speed100, float sflags) CSQC_Event_Sound =
{
	return FALSE;
};

// return TRUE if you want to eat this event, otherwise return FALSE to let engine handle it.
// NOT USED IN DARKPLACES
float(float event) CSQC_Event =
{
	return FALSE;
};

/*
// called when a network slot was previously empty, before parsing begins
// this basically lets you do extra work before returning the result of spawn()
// OPTIONAL, probably should be deprecated as well
entity(float entnum) CSQC_Ent_Spawn =
{
	return spawn();
};
*/

// parse a network update, isnew indicates this network slot was previously empty
// if you wish to do interpolation, be sure to make use the proper time variables: time is previous packet time, servertime is new packet time, so the tick time between packets is servertime - time and the interpolation should begin the new move at servertime and end at servertime + (servertime - time)
void(float isnew) CSQC_Ent_Update =
{
  
};

// called when a network slot is emptied, you may choose to remove(self) or not
void() CSQC_Ent_Remove =
{
	//if (self.t_remove)
		//if (self.t_remove())
  remove(self);
};

// called when cl_cmd is used in the console (much like menu_cmd and sv_cmd for menu.dat and progs.dat), can perform special logic or useful functionality (like bestweapon)
void(string msg) GameCommand =
{
};

// called on each entity each time it is about to be added to the scene (by R_AddEntities)
//.void() predraw;

// called on each entity each frame if self.nextthink <= time + frametime
//.void() think;

// this function is called when a transformview message is received (when you enter a warpzone), to allow you to customize the view transform
// return value is new origin
// v_forward, v_right, v_up must be set correctly
// trace_endpos should be set correctly (before call it will be the same value as org)
//.vector(vector org, vector ang, vector forward, vector right, vector up) camera_transform;

