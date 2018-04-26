/*
mech Mod
Author: Peter Roohr
Date: 3/13/2018
Overview: impl of all reception of sendent calls, got 
tired of trying to scroll through them all in csmain.

self scope for all is the ent being received
*/

void(float isNew) receive_ent_clientData={
  local float intg;
  local entity client, this;
  intg = ReadShort();
  if(isNew){ 
    self.drawmask = MASK_ENGINE;
    setorigin(self, '0 0 0');
  }
  self.data_type = ReadByte();
  self.i_faction = ReadByte();
  self.flags = ReadByte();
  
  self.entorg_x = ReadCoord();
  self.entorg_y = ReadCoord();
  self.entorg_z = ReadCoord();
  
  setorigin(self, self.entorg);
  
  if(self.data_type == DATA_MECH){
    local string nm;
    nm = ReadString();
    if( self.netname != nm){
      self.netname = strzone(nm);
    }
    self.data_idx = ReadByte();
    self.vec_size = ReadByte();
    self.stat_rdr_mode = ReadByte();
    self.radar_range = ReadLong();
    self.hp_ctor = ReadByte();
    self.hp_leg = ReadByte();
    self.hp_stor = ReadByte();
    self.hp_stor2 = ReadByte();
    self.hp_arm = ReadByte();
    self.hp_arm2 = ReadByte();
    
    self.en_cur = ReadByte();
    self.sh_cur = ReadByte();

    //WEAPON DATA
    self.currentWeaponGroup = ReadLong();
    self.stat_wep_rel = ReadByte();
  
    self.plr_sel_hrpnt = ReadByte();
  }
  if(intg == player_localentnum){
    client = entitybyindex(player_localentnum);
    if(client){
      CLIENTDATA = self;
      if(isNew){
        this = self;
        self = client;
          self.plr_sel_mech = 0;
          self.plr_sel_size = 1;
          self.plr_nex_mech = 0;
          self.plr_sel_list_wep = 0;
          self.plr_nex_wep1 = -1;
          self.plr_nex_wep2 = -1;
          self.plr_nex_wep3 = -1;
          self.plr_nex_wep4 = -1;
          self.plr_nex_wep6 = -1;
          self.plr_nex_wep7 = -1;
          self.plr_nex_wep8 = -1;
          self.plr_nex_wep9 = -1;
          self.plr_nex_grp1 = 0;
          self.plr_nex_grp2 = 0;
          self.plr_nex_grp3 = 0;
          self.plr_nex_grp4 = 0;
          self.plr_nex_grp5 = 0;
          self.stat_w1_id = 0;
          self.stat_w2_id = 0;
          self.stat_w3_id = 0;
          self.stat_w4_id = 0;
          self.stat_w5_id = 0;
          self.stat_w6_id = 0;
          self.stat_w7_id = 0;
          self.stat_w8_id = 0;
          self.stat_w9_id = 0;
          self.plr_nav_pnt = -1;
          self.plr_menu_choice = MENU_BRIEF_ACTIVE;
          self.MSN_SFX_COUNT = 0;
          self.drawme = 0;
          self.ANM_FILE_STATUS = 0;
          self.stat_plr_rep = -1;
        self = this;
      }
    }
  }
};

void() receive_ent_bindData={
  local entity cl_data;
  cl_data = CLIENTDATA;

  self.player_state = getstati(STAT_PLR_STT);
  self.vec_size = getstati(STAT_PLR_VECSIZE);
  self.data_type = getstati(STAT_PLR_DTYPE);
  self.data_idx = getstati(STAT_PLR_DIDX);  
  self.stat_lck_stt = getstati(STAT_LCK_STT);
  self.stat_rdr_mode = getstati(STAT_PLR_RADMOD);
  self.stat_hit_dirs = getstati(STAT_PLR_HITDIR);
  self.stat_ret_dist = getstati(STAT_PLR_RETDIST);
  
  self.stat_trg_dataidx = getstati(STAT_TRG_DATAIDX);
  self.stat_trg_ent_id = getstati(STAT_TRG_ENT_ID);
  self.stat_trg_face = getstati(STAT_TRG_FACE);
  
  if(self.stat_trg_dataidx > 0){
    local entity targ;
    self.target_origin_x = getstatf(STAT_TRG_ORG_X);
    self.target_origin_y = getstatf(STAT_TRG_ORG_Y);
    self.target_origin_z = getstatf(STAT_TRG_ORG_Z);
    self.target_vecsize = getstati(STAT_TRG_VECSIZE);
    self.target_shield = getstatf(STAT_TRG_SHIELD);
    self.target_datatype = getstati(STAT_TRG_DATATYPE);
    self.target_faction = getstati(STAT_TRG_FACTION);
    self.stat_trg_lg_hp = getstatf(STAT_TRG_LG_HP);
    self.stat_trg_ct_hp = getstatf(STAT_TRG_CT_HP);
    self.stat_trg_lt_hp = getstatf(STAT_TRG_LT_HP);
    self.stat_trg_rt_hp = getstatf(STAT_TRG_RT_HP);
    self.stat_trg_la_hp = getstatf(STAT_TRG_LA_HP);
    self.stat_trg_ra_hp = getstatf(STAT_TRG_RA_HP);
    self.stat_trg_ddflg = getstati(STAT_TRG_DDFLG);
  }
  else{
    self.target_origin_x = 0;
    self.target_origin_y = 0;
    self.target_origin_z = 0;
    self.target_vecsize = 0;
    self.target_shield = 0;
    self.target_datatype = 0;
    self.target_faction = 0;
    self.stat_trg_ddflg = -1;
  }
  
  if(cl_data != world){
    self.i_faction = cl_data.i_faction;
    if(cl_data.data_type == DATA_MECH){
      local string nm;
      nm = cl_data.netname;
      if( self.netname != nm){
        self.netname = nm;
      }
      
      self.radar_range = cl_data.radar_range;
      self.hp_ctor = cl_data.hp_ctor;
      self.hp_leg = cl_data.hp_leg;
      self.hp_stor = cl_data.hp_stor;
      self.hp_stor2 = cl_data.hp_stor2;
      self.hp_arm = cl_data.hp_arm;
      self.hp_arm2 = cl_data.hp_arm2;
      
      self.en_cur = cl_data.en_cur;
      self.sh_cur = cl_data.sh_cur;
      
      self.stat_plr_rep = getstatf(STAT_PLR_REP);
      
      //WEAPON DATA
      self.currentWeaponGroup = cl_data.currentWeaponGroup;
      self.stat_wep_rel = cl_data.stat_wep_rel;
      
      self.stat_w1_id = getstati(STAT_WEP1_ID);
      self.stat_w2_id = getstati(STAT_WEP2_ID);
      self.stat_w3_id = getstati(STAT_WEP3_ID);
      self.stat_w4_id = getstati(STAT_WEP4_ID);
      self.stat_w5_id = getstati(STAT_WEP5_ID);
      self.stat_w6_id = getstati(STAT_WEP6_ID);
      self.stat_w7_id = getstati(STAT_WEP7_ID);
      self.stat_w8_id = getstati(STAT_WEP8_ID);
      self.stat_w9_id = getstati(STAT_WEP9_ID);
      
      self.stat_w1_rel = getstatf(STAT_WEP1_REL);
      self.stat_w2_rel = getstatf(STAT_WEP2_REL);
      self.stat_w3_rel = getstatf(STAT_WEP3_REL);
      self.stat_w4_rel = getstatf(STAT_WEP4_REL);
      self.stat_w5_rel = getstatf(STAT_WEP5_REL);
      self.stat_w6_rel = getstatf(STAT_WEP6_REL);
      self.stat_w7_rel = getstatf(STAT_WEP7_REL);
      self.stat_w8_rel = getstatf(STAT_WEP8_REL);
      self.stat_w9_rel = getstatf(STAT_WEP9_REL);
    }
  }
};