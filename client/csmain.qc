
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
  cs_precache();
  precache_model ("q3mdl/mechs/notl/mdl_notl_t_cent.md3");
  precache_model ("q3mdl/mechs/notl/mdl_notl_t_left.md3");  
  precache_model ("q3mdl/mechs/notl/mdl_notl_legs.md3");
  //hud_ini();
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
void(float w, float h) CSQC_UpdateView =
{
	local vector vf_size;
	local vector vf_min;
	local vector fovvec;
	local float chasecam, vid_width, vid_height,vid_conwidth,vid_conheight,vid_pixelheight;
	vf_size = getpropertyvec(VF_SIZE);
	vf_min = getpropertyvec(VF_MIN);
	fovvec = getpropertyvec(VF_FOV); // note this is a vector (x and y are independent)
	vid_width = w;
	vid_height = h;
	//vid_conwidth = autocvar_vid_conwidth;
	//vid_conheight = autocvar_vid_conheight;
	//vid_pixelheight = autocvar_vid_pixelheight;
	//chasecam = autocvar_chase_active != 0;

	// do any manipulation we want on fov here (weapon zoom, respawn zoom, etc)
	// nothing right now

	// clear the scene information (entities, polygons, etc)
	clearscene();

	// set up the scene parameters
	setproperty(VF_SIZE, vf_size);
	setproperty(VF_MIN, vf_min);
	setproperty(VF_FOV, fovvec);
	setproperty(VF_DRAWWORLD, 1);
	setproperty(VF_DRAWCROSSHAIR, 1); // TODO custom crosshairs
	setproperty(VF_DRAWENGINESBAR, 0); // TODO custom hud

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
 
  local float p_class;
  p_class = getstati(STAT_PCLASS);
 
  if(p_class != P_OBS){
    local float eid, en_mx, en_cr, sh_mx, sh_cr;
    en_cr = getstati(STAT_ENERGY);
    //en_mx = getstati(STAT_SHIELD);
    eid = getstati(STAT_ENTITY_ID);
    //drawfill float(vector position, vector size, vector rgb, float alpha,  float flag) 
    //ENG_COLOR_CURRENT = colorForVal(en_cr);
    local vector shl_loc;
    shl_loc = '0 0 0';
    shl_loc_x = shl_loc_x + 250;
    shl_loc_y = shl_loc_y + (vid_height/2) - 48;
    /*drawfill(shl_loc, '48 48 0', ENG_COLOR_CURRENT, 1, 0 );
    drawstring((shl_loc + '1 20 0'), "ENERGY", '8 8 0', '1 1 1', 1, 0);
    
    drawstring('0 16 0', ftos(en_cr), '8 8 0', '1 1 1', 1, 0);
    drawstring('0 26 0', ftos(en_mx), '8 8 0', '1 1 1', 1, 0);
  */
    local float vid;
    local entity hud, oself;
    vid = getstati(STAT_VID);
    hud = m_findData(vid);
    if(hud != world){
      oself = self;
      self = hud.wdg_en;
        self.actionCallback();
      self = oself;
    }
  }
  
  if(p_class == P_MECH){
    local float lg_hp,ctr_hp,ltr_hp,rtr_hp,lam_hp,ram_hp;
    lg_hp = getstatf(STAT_LEG_HP);
    ctr_hp = getstatf(STAT_CTOR_HP);
    ltr_hp = getstatf(STAT_LTOR_HP);
    rtr_hp = getstatf(STAT_RTOR_HP);
    lam_hp = getstatf(STAT_LARM_HP);
    ram_hp = getstatf(STAT_RARM_HP);
    local vector hp_loc;
    hp_loc = shl_loc - '100 -25 0';
    hud_paperdoll(lg_hp, hp_loc, '24 48 0');
    
    hp_loc = shl_loc - '100 0 0';
    hud_paperdoll(ctr_hp, hp_loc, '24 24 0');
    
    hp_loc = shl_loc - '117 0 0';
    hud_paperdoll(ltr_hp, hp_loc, '16 24 0');
    
    hp_loc = shl_loc - '75 0 0';
    hud_paperdoll(rtr_hp, hp_loc, '16 24 0');
    
    hp_loc = shl_loc - '134 0 0';
    hud_paperdoll(lam_hp, hp_loc, '16 16 0');
    
    hp_loc = shl_loc - '58 0 0';
    hud_paperdoll(ram_hp, hp_loc, '16 16 0');
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

