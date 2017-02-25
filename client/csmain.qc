
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
  
  registercommand("balls");
  cs_precache();
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
  VIEW_CTR_x = VIEW_MAX_x / 2;
  VIEW_CTR_y = VIEW_MAX_y / 2;
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
    //player general info
    local float vec_id, hitdir, conv_x, conv_y, pitch;
    vec_id = getstati(STAT_VID);
    hitdir = getstatf(STAT_HIT_DIR);
    conv_x = getstatf(STAT_SPR_X);
    conv_y = getstatf(STAT_SPR_Y);
    pitch = getstati(STAT_PLR_PTC);
    
    //player mech hp info
    local float plr_sh, plr_en, plr_ct, plr_rt, plr_lt, plr_ra, plr_la, plr_lg;
    plr_sh = getstati(STAT_SHIELD);
    plr_en = getstati(STAT_ENERGY);
    plr_ct = getstatf(STAT_CTOR_HP);
    plr_rt = getstatf(STAT_RTOR_HP);
    plr_lt = getstatf(STAT_LTOR_HP);
    plr_ra = getstatf(STAT_RARM_HP);
    plr_la = getstatf(STAT_LARM_HP);
    plr_lg = getstatf(STAT_LEG_HP);
    
    //player weapon tracking info
    local float plr_wgrp, plr_wstate, plr_wrel, w1_id, w2_id, w3_id, w4_id, w5_id, w6_id, w7_id, w8_id, w9_id;
    plr_wgrp = getstati(STAT_WEP_GRP);
    plr_wstate = getstati(STAT_WEP_STT);
    plr_wrel = getstati(STAT_WEP_REL);
    w1_id = getstati(STAT_WEP1_ID);
    w2_id = getstati(STAT_WEP2_ID);
    w3_id = getstati(STAT_WEP3_ID);
    w4_id = getstati(STAT_WEP4_ID);
    w5_id = getstati(STAT_WEP5_ID);
    w6_id = getstati(STAT_WEP6_ID);
    w7_id = getstati(STAT_WEP7_ID);
    w8_id = getstati(STAT_WEP8_ID);
    w9_id = getstati(STAT_WEP9_ID);
    
    //player radar info
    local float rad_frnt, rad_bck, rad_mode;
    rad_frnt = getstatf(STAT_RDR_FRNT);
    rad_bck = getstatf(STAT_RDR_BACK);
    rad_mode = getstati(STAT_RDR_MODE);
    
    //target tracking info
    local float trg_vid, trg_datid, trg_sh, trg_am, trg_dist, trg_dir, trg_lock;
    trg_vid = getstati(STAT_TRG_VID);
    trg_datid = getstati(STAT_TRG_DAT);
    trg_sh = getstatf(STAT_TRG_SH);
    trg_am = getstati(STAT_TRG_AM);
    trg_dist = getstati(STAT_TRG_DIST);
    trg_dir = getstati(STAT_TRG_FACE);
    trg_lock = getstati(STAT_LCK_STT);
    
    //render 
    local entity player_hud, vec_data, oself;
    vec_data = m_findData(1, DATA_MECH);
    player_hud = m_findData(1, DATA_HUD);
    
    oself = self;
    self = player_hud;
      self.hud_prep(vec_data);
      self.hud_HelmetImage(VIEW_MAX, VIEW_CTR);
      self.hud_playerArmor(plr_ct, plr_lt, plr_rt, plr_la, plr_ra, plr_lg);     
      self.hud_playerShield(plr_sh);
      self.hud_playerEnergy(plr_en);  
      self.hud_Radar(rad_frnt, rad_bck, rad_mode);
      self.hud_hitDirectionPips(hitdir);
      self.hud_renderWeapon1(plr_wgrp, plr_wstate, w1_id, WEAPON1, WEAPON1_DD, WEAPON1_OK, plr_wrel);
      self.hud_renderWeapon2(plr_wgrp, plr_wstate, w2_id, WEAPON2, WEAPON2_DD, WEAPON2_OK, plr_wrel);
      self.hud_renderWeapon3(plr_wgrp, plr_wstate, w3_id, WEAPON3, WEAPON3_DD, WEAPON3_OK, plr_wrel);
      self.hud_renderWeapon4(plr_wgrp, plr_wstate, w4_id, WEAPON4, WEAPON4_DD, WEAPON4_OK, plr_wrel);
      self.hud_renderWeapon5(plr_wgrp, plr_wstate, w5_id, WEAPON5, WEAPON5_DD, WEAPON5_OK, plr_wrel);
      self.hud_renderWeapon6(plr_wgrp, plr_wstate, w6_id, WEAPON6, WEAPON6_DD, WEAPON6_OK, plr_wrel);
      self.hud_renderWeapon7(plr_wgrp, plr_wstate, w7_id, WEAPON7, WEAPON7_DD, WEAPON7_OK, plr_wrel);
      self.hud_renderWeapon8(plr_wgrp, plr_wstate, w8_id, WEAPON8, WEAPON8_DD, WEAPON8_OK, plr_wrel);
      self.hud_renderWeapon9(plr_wgrp, plr_wstate, w9_id, WEAPON9, WEAPON9_DD, WEAPON9_OK, plr_wrel);
      self.hud_targetArmor(trg_am);
      self.hud_targetShield(trg_sh);
      self.hud_targetRange(trg_dist);
      self.hud_targetLock(trg_lock);
      self.hud_targetDirectionPip(trg_dir);
    self = oself;
    
    
    //do sound queue system here
    
   	// draw custom crosshair
  }
};

// called on all console commands, but be sure to registercmd() first so the tab completion works!
// return FALSE to let engine process command, TRUE to eat command
float(string s) CSQC_ConsoleCommand =
{
  centerprint("boop");
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

float() CSQC_Parse_Event={
  centerprint("foo\n");
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
  local float id, sfx;
  id = ReadByte();
  sfx = ReadByte();
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

