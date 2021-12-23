/*
battleMETAL
Author: Peter Roohr
Date: 12/06/2021
Overview:
  Breaking client_main into pieces for better maintainability.
*/

// parse tempentity if it suits your fancy, return TRUE to tell engine you have finished parsing the 
//tempentity, return FALSE to tell engine to parse tempentity itself (it will reset parse position automatically)
/*
  In Quake, there's a entity type called 'temp entity' - these are incredibly brief entities that last maybe a frame or two.
  battleMETAL uses custom temp ents for some network communications and particle effects.
*/
float() CSQC_Parse_TempEntity =
{
  local float id;
  id = ReadByte();

  switch( id ){
    case TE_PLAYER_CRIT:
      client_handle_crit( ReadByte(), ReadLong() );
      return TRUE;
      
    case TE_CLIENT_INFO:
      client_campaign_end_data();
      return TRUE;
      
    case TE_CLIENT_INFO_DM:
      client_dm_end_data();
      return TRUE;
    
    case TE_UI_BOX:
      client_get_hud_highlight();
      return TRUE;
      
    case TE_FOG_SET:
      cl_get_new_fog();
      return TRUE;
    
    case TE_ISMENU:
      cl_set_menu();
      return TRUE;
    
    case TE_MSN_BOUND:
      client_event_boundary();
      return TRUE;
      
    case TE_MISSION_END:
      client_event_debrief_active( ReadByte(), ReadShort(), ReadShort(), ReadShort(), ReadShort() );
      return TRUE;
      
    case TE_VFX_EXPLODE:
      particle_missile_explode( te_read_vector(), ReadByte(), te_read_vector(), ReadByte() );
      return TRUE;
    
    case TE_MSG_INFO:
      client_event_info_box( ReadString(), CLR_DEF_TXT_GRAY_SMOOTH, ReadLong(), '14 14 0');
      return TRUE;
      
    case TE_REPAIRS_ON:
      if( ReadByte() ){
        hud_event_enqueue( HUD_EVENT_REPAIRS_ON, 1) ;
      }
      else{
        hud_event_enqueue( HUD_EVENT_REPAIRS_OFF, 1) ;
      }
      return TRUE;
      
    case TE_VFX_POINT:
      pointparticles( ReadShort(), te_read_vector(), te_read_vector(), ReadShort());
      return TRUE;
      
    case TE_VFX_RAIL:
      trailparticles( world, ReadShort(), te_read_vector(), te_read_vector() );
      return TRUE;
     
    case TE_PARTICLE_CUBE:
      particle_box_ini();
      return TRUE;
  } 
	return FALSE;
};

/*
  (Darkplaces)
  if string is interesting, deal with it, otherwise pass it to localcmd() and let engine parse it (note: will not be executed immediately).

  (battleMETAL)
  All low-delta Client/Server commands go here, mostly stuff dealing with menu commands reaching the 
  server.
*/
void(string s) CSQC_Parse_StuffCmd =
{
  local float argc;
  
  if( cvar("developer") ){
    dprint(sprintf("CSQC_Parse_StuffCmd().s = %s\n", s));  //debug
  }
  argc = tokenize(s);
  if(argv(0) == "m"){
    if(argv(1) == "msn"){
      cl_get_msnfile( argv(2) );
      return;
    }
    if(argv(1) == "anm"){
      cl_get_animfile( argv(2) );
      ANM_SERV_TRIG = TRUE;
      return;
    }
    if(argv(1) == "ini"){
      cl_ini_event(s);
      return;
    }
  }
  else{  
    localcmd(s);
  }
};

// if string is interesting, deal with it, otherwise pass it to print() to invoke the engine code.
/*
an svc_print with a leading byte with value 1 will make the text red and play the chat beep sound... I guess you could call such prints as chat...
just beware that 2 and 3 have meanings too, at least in DP
this of course means that with sneaky naming you can get all your deaths to play chat sounds too, of course.
  -Spoike

I crufted my own message schema
see:
  common/data/data_values_game.qc
    Server<->Client string message layer
  
  CHAT_TYPE_MSG1 
  CHAT_TYPE_MSG2 
  CHAT_TYPE_SERVR
*/
void(string s) CSQC_Parse_Print =
{
  local string clientId;
  
  if( infoget(s, RSP_SRC) == SV_PRINT ){
    if( infoget(s, RSP_TYPE) == SAY_MSG1 ){
      clientId = infoget(s, RSP_CID);
      
      menu_chat_receive_new(CHAT_TYPE_MSG1, getplayerkeyvalue(stof(clientId) - 1, "name"), infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SAY_MSG2 ){
      clientId = infoget(s, RSP_CID);
      if( rint(stof(getplayerkeyvalue(stof(clientId) - 1, "colors"))) == CLIENT_faction ){
        menu_chat_receive_new(CHAT_TYPE_MSG2, getplayerkeyvalue(stof(clientId) - 1, "name"), infoget(s, RSP_BODY));
      }
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_CONN ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_KSELF ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    if( infoget(s, RSP_TYPE) == SV_CL_DSCON ){
      menu_chat_receive_new(CHAT_TYPE_SERVR, "SERVER", infoget(s, RSP_BODY));
      return;
    }
    return;
  }
	print(s);
};


// if string is interesting, deal with it, otherwise pass it to centerprint() to invoke the engine code.
void(string s) CSQC_Parse_CenterPrint =
{
  //TODO - how much string meta-data can we handle to actually take advantage of this function? <grumble>
  if( cvar("developer") ){
    if( strstrofs(s, " to go...", 0) != -1 ){
      //cons_logAFloat("caught fun string", 1); //debug
    }
  }
	centerprint(s);
};
