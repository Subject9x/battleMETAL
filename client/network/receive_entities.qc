/*
battleMETAL
Author: Peter Roohr
Date: 3/13/2018
Overview: impl of all reception of sendent calls, got 
tired of trying to scroll through them all in csmain.

self scope for all is the ent being received
*/

void( float wep, float delt ) client_get_weapon_delta;

void() client_get_info={
  local float localDataType;
  //WARNING:
  //SVC_SETVIEW changes local_playerentum to Camera's Ent ID!
  //client = entitybyindex( getstati(STAT_PLR_ENT_ID) );

  CLIENT_entorg  = te_read_vector();
  CLIENT_radar_range  = ReadLong(); 
  CLIENT_data_type = getstati(STAT_PLR_DTYPE);
  
  localDataType = ReadByte();
  if( localDataType == DATA_MECH ){
    CLIENT_en_cur = ReadShort();
    CLIENT_sh_cur = ReadShort();
    
    CLIENT_hp_ctor = ReadByte(); 
    CLIENT_hp_leg = ReadByte(); 
    CLIENT_hp_stor = ReadByte(); 
    CLIENT_hp_stor2 = ReadByte(); 
    CLIENT_hp_arm = ReadByte(); 
    CLIENT_hp_arm2 = ReadByte();
    
    CLIENT_hardpoint_cnt = ReadByte();
    local float wep;
    wep = 1;
    while( wep <= CLIENT_hardpoint_cnt ){
      client_get_weapon_delta( wep, ReadByte() ); 
      wep = wep + 1;
    }
    
    CLIENT_stat_trg_ent_id = ReadByte();
    if( CLIENT_stat_trg_ent_id != 0 ){
      CLIENT_target_origin = te_read_vector();
      CLIENT_target_shield = ReadByte();
      CLIENT_stat_trg_ct_hp = ReadByte();
      CLIENT_stat_trg_lg_hp = ReadByte();
      CLIENT_stat_trg_lt_hp = ReadByte(); 
      CLIENT_stat_trg_rt_hp = ReadByte(); 
      CLIENT_stat_trg_la_hp = ReadByte();
      CLIENT_stat_trg_ra_hp = ReadByte();
      CLIENT_target_vecsize = ReadShort();
      if( CLIENT_w_icon != "" ){
        strunzone( CLIENT_w_icon );
      }
      CLIENT_w_icon = strzone( ReadString() );
    }
  }
};

void( float wep, float delt ) client_get_weapon_delta={
  switch( wep ){
    case 1:
      CLIENT_stat_w1_rel = delt;
      break;
    case 2:
      CLIENT_stat_w2_rel = delt;
      break;
    case 3:
      CLIENT_stat_w3_rel = delt;
      break;
    case 4:
      CLIENT_stat_w4_rel = delt;
      break;
    case 5:
      CLIENT_stat_w5_rel = delt;
      break;
    case 6:
      CLIENT_stat_w6_rel = delt;
      break;
    case 7:
      CLIENT_stat_w7_rel = delt;
      break;
    case 8:
      CLIENT_stat_w8_rel = delt;
      break;
    case 9:
      CLIENT_stat_w9_rel = delt;
      break;
  }
};

/*
  Handles a Radar Blip TE pushed from the server to a specific client
  blips fade out over a given amount of time 
*/
void() client_get_contact={
  local entity blip;
  
  
  blip = spawn();
  
  setorigin( blip, te_read_vector() );
  blip.radar_range = ReadLong();
  blip.data_type = ReadByte();
  blip.faction = ReadByte();
  
  blip.data_idx = -2; //hack
  //Radar 1 - settings
  //blip.en_cur = time + 6;
  //blip.hardpoint_cnt = 1; //alpha fade
  //blip.radar_time = 0.001;
  
  //Radar 2 - settings
  blip.en_cur = time + 3;
  blip.hardpoint_cnt = 1; //alpha fade
  blip.radar_time = 0.0025;
  
};

void() client_get_hud_highlight={
  local entity hfx;

  hfx = spawn();
  hfx.data_idx = -3;  //more hacks
  hfx.origin = te_read_vector();
  hfx.drawsize = te_read_vector();
  hfx.drawcolor1 = te_read_vector();
  hfx.drawme = time + ReadShort();
  
};

void() receive_ent_bindData={
  local string name;
  
  name = getstats( STAT_PLR_NAME );
  
  CLIENT_flags = getstati( STAT_ROCKETS );
  
  if( name != CLIENT_netname){
    if( CLIENT_netname != ""){
      strunzone( CLIENT_netname );
    }
    CLIENT_netname = strzone( name );
  }
  
  CLIENT_player_state = getstati( STAT_ARMOR );

  CLIENT_data_type = getstati(STAT_PLR_DTYPE);
  CLIENT_data_idx = getstati(STAT_PLR_DIDX);
  CLIENT_i_faction = getstati( STAT_CELLS );
  CLIENT_stat_lck_stt = getstati(STAT_LCK_STT);
  CLIENT_stat_rdr_mode = getstati(STAT_PLR_RADMOD);
  CLIENT_stat_hit_dirs = getstati(STAT_PLR_HITDIR);
  CLIENT_stat_ret_dist = getstati(STAT_PLR_RETDIST);

  CLIENT_stat_trg_dataidx = getstati(STAT_TRG_DATAIDX);
  CLIENT_stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
  CLIENT_stat_trg_face = getstati(STAT_TRG_FACE);
       
  CLIENT_target_datatype = getstati(STAT_TRG_DATATYPE);
  CLIENT_target_faction = getstati(STAT_TRG_FACTION);
  //CLIENT_target_shield; 
  //CLIENT_stat_trg_ddflg;
    
  CLIENT_stat_w1_id = getstati(STAT_WEP1_ID);
  CLIENT_stat_w2_id = getstati(STAT_WEP2_ID);
  CLIENT_stat_w3_id = getstati(STAT_WEP3_ID);
  CLIENT_stat_w4_id = getstati(STAT_WEP4_ID);
  CLIENT_stat_w5_id = getstati(STAT_WEP5_ID);
  CLIENT_stat_w6_id = getstati(STAT_WEP6_ID);
  CLIENT_stat_w7_id = getstati(STAT_WEP7_ID);
  CLIENT_stat_w8_id = getstati(STAT_WEP8_ID);
  CLIENT_stat_w9_id = getstati(STAT_WEP9_ID);
};

void() client_event_navpoint={
  local float navid, prevState, nexState;
  
  navid = ReadByte();
  prevState = NAVNAMES_ACTIVE[navid];
  nexState = ReadByte();
  NAVNAMES_ORG[navid] = te_read_vector();
  
  if( (prevState == TRUE) && (nexState == 2) ){
    //previous state was 'active unvisit' and next state is 'active and visit'
    //play sound
    te_nav_reach();
  }
  if( (prevState == 2) && (nexState == 1) ){
    //previous state was 'active and visit' and next state is 'active unvisit'
    //ignore state change for this client
    return;
  }
  NAVNAMES_ACTIVE[navid] = nexState;
};

void() client_event_deploypoint={
  local float depid;
  
  depid = ReadByte();
  DEPLOY_POINTS_ACTIVE[depid] = ReadByte();
  DEPLOY_POINTS_ORG[depid] = te_read_vector();
};

void() client_event_objective={
  local float objid, prevState, nexState, type;
  
  objid = ReadByte();
  prevState = OBJECTIVES[objid];
  nexState = ReadByte();
  type = ReadByte();
  
  if( (prevState > FALSE) ){
    if( prevState == TRUE ){
      if( (nexState == -1)  ){
        te_objective_failed();
      }
      if( nexState == 2 ){
       te_objective_complete( type );
      }
    }
  }
  
  OBJECTIVES[objid] = nexState;
};

void() client_event_boundary={
  HUD_WARN_ON = ReadByte();
  HUD_WARN_DIR = ReadAngle();
  if( HUD_WARN_ON ){
    if( time > HUD_WARN_MARK ){
      HUD_WARN_MARK = time + HUD_WARN_TIME;
    }
  }
};


void() client_event_targ_kill={
  
};

void() client_map_cdtrack={

};
