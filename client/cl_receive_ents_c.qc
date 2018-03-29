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
    local float wepItr;
    self.plr_sel_hrpnt = ReadByte();
    wepItr = 1;
    while(wepItr <= self.plr_sel_hrpnt){
      if(wepItr == 1){
        self.stat_w1_id = ReadByte();
        self.stat_w1_rel = ReadByte();
      }
      else if(wepItr == 2){
        self.stat_w2_id = ReadByte();
        self.stat_w2_rel = ReadByte();
      }
      else if(wepItr == 3){
        self.stat_w3_id = ReadByte();
        self.stat_w3_rel = ReadByte();
      }
      else if(wepItr == 4){
        self.stat_w4_id = ReadByte();
        self.stat_w4_rel = ReadByte();
      }
      else if(wepItr == 5){
        self.stat_w5_id = ReadByte();
        self.stat_w5_rel = ReadByte();
      }
      else if(wepItr == 6){
        self.stat_w6_id = ReadByte();
        self.stat_w6_rel = ReadByte();
      }
      else if(wepItr == 7){
        self.stat_w7_id = ReadByte();
        self.stat_w7_rel = ReadByte();
      }
      else if(wepItr == 8){
        self.stat_w8_id = ReadByte();
        self.stat_w8_rel = ReadByte();
      }
      else if(wepItr == 9){
        self.stat_w9_id = ReadByte();
        self.stat_w9_rel = ReadByte();
      }
      wepItr = wepItr + 1;
    }
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
      local float wepCount, wepItr;
      wepCount = cl_data.plr_sel_hrpnt;
      wepItr = 1;
      while(wepItr <= wepCount){
        if(wepItr == 1){
          self.stat_w1_id = cl_data.stat_w1_id;
          self.stat_w1_rel = cl_data.stat_w1_rel;
        }
        else if(wepItr == 2){
          self.stat_w2_id = cl_data.stat_w2_id;
          self.stat_w2_rel = cl_data.stat_w2_rel;
        }
        else if(wepItr == 3){
          self.stat_w3_id = cl_data.stat_w3_id;
          self.stat_w3_rel = cl_data.stat_w3_rel;
        }
        else if(wepItr == 4){
          self.stat_w4_id = cl_data.stat_w4_id;
          self.stat_w4_rel = cl_data.stat_w4_rel;
        }
        else if(wepItr == 5){
          self.stat_w5_id = cl_data.stat_w5_id;
          self.stat_w5_rel = cl_data.stat_w5_rel;
        }
        else if(wepItr == 6){
          self.stat_w6_id = cl_data.stat_w6_id;
          self.stat_w6_rel = cl_data.stat_w6_rel;
        }
        else if(wepItr == 7){
          self.stat_w7_id = cl_data.stat_w7_id;
          self.stat_w7_rel = cl_data.stat_w7_rel;
        }
        else if(wepItr == 8){
          self.stat_w8_id = cl_data.stat_w8_id;
          self.stat_w8_rel = cl_data.stat_w8_rel;
        }
        else if(wepItr == 9){
          self.stat_w9_id = cl_data.stat_w9_id;
          self.stat_w9_rel = cl_data.stat_w9_rel;
        }
        wepItr = wepItr + 1;
      }
    }
  
  }
};