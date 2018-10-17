/*
mech Mod
Author: Peter Roohr
Date: 3/13/2018
Overview: impl of all reception of sendent calls, got 
tired of trying to scroll through them all in csmain.

self scope for all is the ent being received
*/

void( entity client, float wep, float delt ) client_get_weapon_delta;

void() client_get_info={
  local entity client;
  //WARNING:
  //SVC_SETVIEW changes local_playerentum to Camera's Ent ID!
  PLAYER_ENTITYNUM = ReadByte();
  client = entitybyindex( PLAYER_ENTITYNUM );
  
  client.entorg = te_read_vector();
  client.radar_range = ReadLong(); 
  client.data_type = ReadByte();
  
  if( client.data_type == DATA_MECH ){
    client.en_cur = ReadByte();
    client.sh_cur = ReadByte();
    
    client.hp_ctor = ReadByte(); 
    client.hp_leg = ReadByte(); 
    client.hp_stor = ReadByte(); 
    client.hp_stor2 = ReadByte(); 
    client.hp_arm = ReadByte(); 
    client.hp_arm2 = ReadByte();
    
    client.hardpoint_cnt = ReadByte();
    local float wep;
    wep = 1;
    while( wep <= client.hardpoint_cnt ){
      client_get_weapon_delta( client, wep, ReadByte() ); 
      wep = wep + 1;
    }
    
    client.stat_trg_ent_id = ReadByte();
    if( client.stat_trg_ent_id != 0 ){
      client.target_origin = te_read_vector();
      client.target_shield = ReadByte();
      client.stat_trg_ct_hp = ReadByte();
      client.stat_trg_lg_hp = ReadByte();
      client.stat_trg_lt_hp = ReadByte(); 
      client.stat_trg_rt_hp = ReadByte(); 
      client.stat_trg_la_hp = ReadByte();
      client.stat_trg_ra_hp = ReadByte();
      client.target_vecsize = ReadShort();
      if( client.w_icon != "" ){
        strunzone( client.w_icon );
      }
      client.w_icon = strzone( ReadString() );
    }
  }
};

void( entity client, float wep, float delt ) client_get_weapon_delta={
  switch( wep ){
    case 1:
      client.stat_w1_rel = delt;
      break;
    case 2:
      client.stat_w2_rel = delt;
      break;
    case 3:
      client.stat_w3_rel = delt;
      break;
    case 4:
      client.stat_w4_rel = delt;
      break;
    case 5:
      client.stat_w5_rel = delt;
      break;
    case 6:
      client.stat_w6_rel = delt;
      break;
    case 7:
      client.stat_w7_rel = delt;
      break;
    case 8:
      client.stat_w8_rel = delt;
      break;
    case 9:
      client.stat_w9_rel = delt;
      break;
  }
};

/*
  Handles a Radar Blip TE pushed from the server to a specific client
  blips fade out over a given amount of time 
*/
void() client_get_contact={
  local entity player, blip;
  
  player = entitybyindex( PLAYER_ENTITYNUM );
  
  blip = spawn();
  
  setorigin( blip, te_read_vector() );
  blip.radar_range = ReadLong();
  blip.data_type = ReadByte();
  blip.i_faction = ReadByte();
  
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
  self.netname = getstats( STAT_PLR_NAME );
  self.flags = getstati( STAT_ROCKETS );
  self.player_state = getstati( STAT_ARMOR );

  self.data_type = getstati(STAT_PLR_DTYPE);
  self.data_idx = getstati(STAT_PLR_DIDX);
  self.i_faction = getstati( STAT_CELLS );
  self.stat_lck_stt = getstati(STAT_LCK_STT);
  self.stat_rdr_mode = getstati(STAT_PLR_RADMOD);
  self.stat_hit_dirs = getstati(STAT_PLR_HITDIR);
  self.stat_ret_dist = getstati(STAT_PLR_RETDIST);
  
  self.stat_trg_dataidx = getstati(STAT_TRG_DATAIDX);
  self.stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
  self.stat_trg_face = getstati(STAT_TRG_FACE);
    
  if(self.stat_trg_dataidx > 0){
    self.target_datatype = getstati(STAT_TRG_DATATYPE);
    self.target_faction = getstati(STAT_TRG_FACTION);

  }
  else{
    self.target_shield = 0;
    self.target_datatype = 0;
    self.target_faction = 0;
    self.stat_trg_ddflg = -1;
  }
    self.stat_w1_id = getstati(STAT_WEP1_ID);
    self.stat_w2_id = getstati(STAT_WEP2_ID);
    self.stat_w3_id = getstati(STAT_WEP3_ID);
    self.stat_w4_id = getstati(STAT_WEP4_ID);
    self.stat_w5_id = getstati(STAT_WEP5_ID);
    self.stat_w6_id = getstati(STAT_WEP6_ID);
    self.stat_w7_id = getstati(STAT_WEP7_ID);
    self.stat_w8_id = getstati(STAT_WEP8_ID);
    self.stat_w9_id = getstati(STAT_WEP9_ID);
};      // 1 = active, 2 = complete, -1 = failed.

void() client_event_navpoint={
  local float navid;
  
  navid = ReadByte();
  NAVNAMES_ACTIVE[navid] = ReadByte();
  NAVNAMES_ORG[navid] = te_read_vector();
};

void() client_event_deploypoint={
  local float depid;
  
  depid = ReadByte();
  DEPLOY_POINTS_ACTIVE[depid] = ReadByte();
  DEPLOY_POINTS_ORG[depid] = te_read_vector();
};

void() client_event_objective={
  local float objid;
  
  objid = ReadByte();
  OBJECTIVES[objid] = ReadByte(); //TODO - MSN_OBJ_STATUS overlap
};


//TODO - deprecate
void( float isnew ) receive_ent_navPoint={
  if(isnew){
    self.ui_org = '0 0 0'; 
    self.ui_size = '0 0 0';
    self.classname = "data";
    self.drawmask = MASK_ENGINE;
    self.value1 = 0;
    self.isActive = 0;
  }
  self.data_type = DATA_NAVP;
  self.nav_name = ReadByte();
  self.i_faction = ReadByte();
  self.value1 = self.isActive;
  self.isActive = ReadByte();
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  setorigin(self, self.origin);
  self.w_name = gui_getNavName(self.nav_name);
  snd_hud_vfx_navpointlistener(self.value1, self.isActive);
};

void( float isnew ) receive_ent_mapObjective={
  if(isnew){
    self.classname = "data";
    self.data_type = DATA_OBJT;
    self.drawmask = MASK_ENGINE;
    self.ui_org = '0 0 0'; 
    self.ui_size = '0 0 0';
    self.value1 = 0;
    self.isActive = 0;
    self.data_idx = 0;
  }
  self.data_idx = ReadByte();
  self.i_faction = ReadByte();
  self.value1 = self.isActive;
  self.isActive = ReadByte();
  setorigin(self, self.origin);
  snd_hud_vfx_objectivelistener(self.value1, self.isActive);
};

void( float isnew ) receive_ent_mapDeployPoint={
  if(isnew){
    self.ui_org = '0 0 0'; 
    self.ui_size = '0 0 0';
    self.classname = "data";
    self.drawmask = MASK_ENGINE;
    self.value1 = 0;
    self.isActive = 0;
  }
  self.data_type = DATA_DEPL;
  self.nav_name = ReadByte();
  self.i_faction = ReadByte();
  self.isActive = ReadByte();
  self.origin_x = ReadCoord();
  self.origin_y = ReadCoord();
  self.origin_z = ReadCoord();
  setorigin(self, self.origin);
};
