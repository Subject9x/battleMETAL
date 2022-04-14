/*
battleMETAL
Author: Peter Roohr
Date: 6/26/2018
mod: 07/26/2019
Overview: refactor ui data to file loading, impl
*/

void() ui_data_load_hudnames={
  local float f, idx;
  local string ln;
  idx = 0;
  f = fopen("ui/hud/dir.meta", FILE_READ);
  if (f != -1){ 
    ln = fgets(f);
    while( ln != "" ){
      if( strstrofs(ln, "//", 0) == -1 ){
        if(idx <= GAME_TOTAL_MECHS){
          cacheGlobalString( HUD_DATA_NAMES[idx], ln)
        }
        idx = idx + 1;
      }
      ln = fgets(f);
    } 
  } 
  fclose(f); 
};

//this is for sorting the mechs by size class in a clean way
void() ui_data_load_mechsizes={
  local float total;
  total = 1;
    //TODO - mech limit magic numbers
  while( total <= 5) {
    ui_data_load_mech_info( total, UI_HANGAR_DATA_mech_list );
    MECH_DATA_SIZES[total] = MECH_DATA_SIZE;
    total = total + 1;
    ui_data_cleanup_mechlist_entity( UI_HANGAR_DATA_mech_list );
  }
};
//the easy part is the clearing function
void() ui_data_clear_mechdata={
  MECH_DATA_ID = 0;
  if( MECH_DATA_ABR != "" ){
    MECH_DATA_ABR = "";
  }
  if( MECH_DATA_NAME != "" ){
    MECH_DATA_NAME = "";
  }
  MECH_DATA_SIZE = 0;
  MECH_DATA_TECH = 0;
  if( MECH_DATA_ICON != "" ){
    MECH_DATA_ICON = "";
  }
  MECH_DATA_ENMAX = 0;
  MECH_DATA_ENRATE = 0;
  MECH_DATA_SHMAX = 0;
  MECH_DATA_SHRATE = 0;
  MECH_DATA_HPOINTS = 0;
  MECH_DATA_SPEEDF = 0;
  MECH_DATA_SPEEDS = 0;
  MECH_DATA_SPEEDB = 0;
  MECH_DATA_ACCEL = 0;
  MECH_DATA_HPCT = 0;
  MECH_DATA_HPST = 0;
  MECH_DATA_HPAR = 0;
  MECH_DATA_HPLG = 0;
  MECH_DATA_RAD = 0;
  MECH_DATA_LOCKON = 0;
  if( MECH_DATA_DESC != "" ){
    MECH_DATA_DESC = "";
  }
  
  ui_data_cleanup_mechlist_entity( UI_HANGAR_DATA_mech );
};

/*
  when entity is populated with game data, its child entities are built too,
	so, if we want to re-use this entity, tis better to clean up its data before
	loading the next data set.
*/
void( entity mechEntity ) ui_data_cleanup_mechlist_entity={
  local entity mech_piece;
  local entity rem;
  local float itr;
  
  itr = 1;
  mech_piece = mechEntity.w_slot;
  
  while( mech_piece != world ){
    itr = itr + 1;
    rem = mech_piece;
    mech_piece = mech_piece.w_slot;
    remove(rem);
  }
  
  if( mechEntity.legs ){
    remove(mechEntity.legs);
  }
  
  if( mechEntity.cockpit ){
    remove(mechEntity.cockpit);
  }
  
  if( mechEntity.armLeft ){
    remove(mechEntity.armLeft);
  }
  
  if( mechEntity.armRight ){
    remove(mechEntity.armRight);
  }
  
  if( mechEntity.torsoLeft ){
    remove(mechEntity.torsoLeft);
  }
  
  if( mechEntity.torsoRight ){
    remove(mechEntity.torsoRight);
  }
  
  if( mechEntity.torsoCenter ){
    remove(mechEntity.torsoCenter);
  }
};

void() ui_data_clear_huddata={
  local float itr;
  itr = 1;
  while( itr <= 32 ){
    UI_DATA_UIDS[itr] = 0;
    UI_DATA_POS[itr] = '0 0';
    UI_DATA_SIZE[itr] = '0 0';
    UI_DATA_ALIGN[itr] = 0;
    UI_DATA_LABEL_FLAG[itr] = 0;
    UI_DATA_LABEL_ALIGN[itr] = 0;
    UI_DATA_AXIS_FLAG[itr] = 0;
    UI_DATA_LABEL_OFS[itr] = '0 0';
    UI_DATA_COLOR1[itr] = '0 0';
    UI_DATA_COLOR2[itr] = '0 0';
    
    freeGlobalString(  UI_DATA_IMG[itr] )
    
    UI_DATA_IMG[itr] = ""; //background image if needed
    itr = itr + 1;
  }
};

void() ui_data_clear_item1={

  if( ITEM1_DATA_ID <= 0 ){
    return;
  }
 
  ITEM1_DATA_ID = 0;
  if( ITEM1_DATA_ABBR != "" ){
    ITEM1_DATA_ABBR = "";
  }

  if( ITEM1_DATA_NAME != "" ){
    ITEM1_DATA_NAME = "";
  }
  
  if( ITEM1_DATA_ICON != "" ){
    ITEM1_DATA_ICON = "";
  }
  ITEM1_DATA_DMG = 0;
  ITEM1_DATA_TYPE = 0;
  ITEM1_DATA_EN = 0;
  ITEM1_DATA_RANGE = 0;
  ITEM1_DATA_CLIP = 0;
  ITEM1_DATA_SIZE = 0;
  ITEM1_DATA_TECH = 0;
  if( ITEM1_DATA_DESC != "" ){
    ITEM1_DATA_DESC = "";
  }
};

void() ui_data_clear_item2={

  if( ITEM2_DATA_ID <= 0 ){
    return;
  }
  ITEM2_DATA_ID = 0;
  if( ITEM2_DATA_ABBR != "" ){
    ITEM2_DATA_ABBR = "";
  }
  if( ITEM2_DATA_NAME != "" ){
    ITEM2_DATA_NAME = "";
  }
  if( ITEM2_DATA_ICON != "" ){
    ITEM2_DATA_ICON = "";
  }
  ITEM2_DATA_DMG = 0;
  ITEM2_DATA_TYPE = 0;
  ITEM2_DATA_EN = 0;
  ITEM2_DATA_RANGE = 0;
  ITEM2_DATA_CLIP = 0;
  ITEM2_DATA_SIZE = 0;
  ITEM2_DATA_TECH = 0;
  
  if( ITEM2_DATA_DESC != "" ){
    ITEM2_DATA_DESC = "";
  }
  ITEM2_DATA_UID_ORG = '0 0 0';
};

//difference here is we dont load config data
float(float mechId, entity listEntity) ui_data_load_mech_info={
  
  if( listEntity.data_idx > 0){
    ui_data_clear_mechdata();
  }
  
  data_get_client_mech_( listEntity, mechId );
  listEntity.data_idx = mechId;
  
  MECH_DATA_ID = listEntity.data_idx;
  MECH_DATA_ABR = listEntity.abbrev;
  MECH_DATA_NAME = listEntity.vec_name;
  MECH_DATA_SIZE = listEntity.vec_size;
  MECH_DATA_TECH = listEntity.techLevel;
  MECH_DATA_ICON = listEntity.icon;
  MECH_DATA_ENMAX = listEntity.energyMax;
  MECH_DATA_ENRATE = listEntity.energyRate;
  MECH_DATA_SHMAX = listEntity.shieldMax;
  MECH_DATA_SHRATE = listEntity.shieldRate;
  MECH_DATA_HPOINTS = listEntity.hardpoint_cnt;
  MECH_DATA_SPEEDF = listEntity.data_speed_forward;
  MECH_DATA_SPEEDS = listEntity.data_speed_strafe;
  MECH_DATA_SPEEDB = listEntity.data_speed_backward;
  MECH_DATA_ACCEL = listEntity.data_speed_accel;
  MECH_DATA_HPCT = listEntity.max_health;
  MECH_DATA_HPST = listEntity.torsoLeft.max_health;
  MECH_DATA_HPAR = listEntity.armLeft.max_health;
  MECH_DATA_HPLG = listEntity.legs.max_health;
  MECH_DATA_RAD = listEntity.radar_range;
  MECH_DATA_LOCKON = listEntity.w_firetime;
  MECH_DATA_DESC = listEntity.description;
  
  return TRUE;
};

float(float id) ui_data_load_mech={
  
  if( UI_HANGAR_DATA_mech.data_idx > 0){
    ui_data_clear_mechdata();
  }
  
  data_get_client_mech_( UI_HANGAR_DATA_mech, id );
  UI_HANGAR_DATA_mech.data_idx = id;
  
  MECH_DATA_ID = UI_HANGAR_DATA_mech.data_idx;
  MECH_DATA_ABR = UI_HANGAR_DATA_mech.abbrev;
  MECH_DATA_NAME = UI_HANGAR_DATA_mech.vec_name;
  MECH_DATA_SIZE = UI_HANGAR_DATA_mech.vec_size;
  MECH_DATA_TECH = UI_HANGAR_DATA_mech.techLevel;
  MECH_DATA_ICON = UI_HANGAR_DATA_mech.icon;
  MECH_DATA_ENMAX = UI_HANGAR_DATA_mech.energyMax;
  MECH_DATA_ENRATE = UI_HANGAR_DATA_mech.energyRate;
  MECH_DATA_SHMAX = UI_HANGAR_DATA_mech.shieldMax;
  MECH_DATA_SHRATE = UI_HANGAR_DATA_mech.shieldRate;
  MECH_DATA_HPOINTS = UI_HANGAR_DATA_mech.hardpoint_cnt;
  MECH_DATA_SPEEDF = UI_HANGAR_DATA_mech.data_speed_forward;
  MECH_DATA_SPEEDS = UI_HANGAR_DATA_mech.data_speed_strafe;
  MECH_DATA_SPEEDB = UI_HANGAR_DATA_mech.data_speed_backward;
  MECH_DATA_ACCEL = UI_HANGAR_DATA_mech.data_speed_accel;
  MECH_DATA_HPCT = UI_HANGAR_DATA_mech.max_health;
  MECH_DATA_HPST = UI_HANGAR_DATA_mech.torsoLeft.max_health;
  MECH_DATA_HPAR = UI_HANGAR_DATA_mech.armLeft.max_health;
  MECH_DATA_HPLG = UI_HANGAR_DATA_mech.legs.max_health;
  MECH_DATA_RAD = UI_HANGAR_DATA_mech.radar_range;
  MECH_DATA_LOCKON = UI_HANGAR_DATA_mech.w_firetime;
  MECH_DATA_DESC = UI_HANGAR_DATA_mech.description;
  
  return TRUE;
};

/*
  CSQC: Load .hud files from /data/ui/hud/
*/
/*
  Ah the sacrifices for easier scripting :)
*/
void() ui_data_hud_ini_tags={
  HUD_TAGS[HUD_UID_IMG_HELM]      = HUD_TAG_IMG_HELM;     
  HUD_TAGS[HUD_UID_ENERGY]        = HUD_TAG_ENERGY;       
  HUD_TAGS[HUD_UID_ARM_PLAYER]    = HUD_TAG_ARM_PLAYER;   
  HUD_TAGS[HUD_UID_SHIELD_PLAYER] = HUD_TAG_SHIELD_PLAYER;
  HUD_TAGS[HUD_UID_ARM_TARGET]    = HUD_TAG_ARM_TARGET;   
  HUD_TAGS[HUD_UID_SHIELD_TARGET] = HUD_TAG_SHIELD_TARGET;
  HUD_TAGS[HUD_UID_WEP_TYPE1]     = HUD_TAG_WEP_TYPE1;    
  HUD_TAGS[HUD_UID_WEP_TYPE2]     = HUD_TAG_WEP_TYPE2;    
  HUD_TAGS[HUD_UID_RADAR_TYPE1]   = HUD_TAG_RADAR_TYPE1;  
  HUD_TAGS[HUD_UID_RADAR_TYPE2]   = HUD_TAG_RADAR_TYPE2;  
  HUD_TAGS[HUD_UID_RADAR_GRAPH]   = HUD_TAG_RADAR_GRAPH;  
  HUD_TAGS[HUD_UID_NAV]           = HUD_TAG_NAV;          
  HUD_TAGS[HUD_UID_TARGET_NAME]   = HUD_TAG_TARGET_NAME;  
  HUD_TAGS[HUD_UID_TARGET_RANGE]  = HUD_TAG_TARGET_RANGE; 
  HUD_TAGS[HUD_UID_ARM_TARG_VEC]  = HUD_TAG_ARM_TARG_VEC; 
  HUD_TAGS[HUD_UID_ARM_TARG_BLD]  = HUD_TAG_ARM_TARG_BLD; 
  HUD_TAGS[HUD_UID_MESSAGE_BOX]   = HUD_TAG_MESSAGE_BOX;  
  HUD_TAGS[HUD_UID_ENVIRO_BOX]    = HUD_TAG_ENVIRO_BOX;   
  HUD_TAGS[HUD_UID_RAM_METER]     = HUD_TAG_RAM_METER;    
  HUD_TAGS[HUD_UID_MSN_CLOCK]     = HUD_TAG_MSN_CLOCK;   
  HUD_TAGS[HUD_UID_CHAT_BOX]      = HUD_TAG_CHAT_BOX;     
};

float(string tag) ui_data_load_hud_tagId={
  local float itr;
  for(itr = 0; itr < 22; itr = itr + 1){
    if( tag == HUD_TAGS[itr] ){
      return itr;
    }
  }
  return 0;
};

float(string tag) ui_data_load_hud_weaponTag={
  local float id;
  id = stof(substring(tag, 3, 4));
  switch(id){
    case 1:
      return WEAPON1;
    case 2:
      return WEAPON2;
    case 3:
      return WEAPON3;
    case 4:
      return WEAPON4;
    case 5:
      return WEAPON5;
    case 6:
      return WEAPON6;
    case 7:
      return WEAPON7;
    case 8:
      return WEAPON8;
    case 9:
      return WEAPON9;
    default:
      return 0;
  }
};


float( float id ) ui_data_load_hud={
  local float flannel, line_tag, hudElementItr;
  local string file, contents, line;
  local string token, value;
  
  ui_data_clear_huddata();
  
  file = strcat(PATH_DATA_UI, "/hud/", HUD_DATA_NAMES[id], ".hud");
  flannel = fopen(file, FILE_READ);
  if(flannel == -1){
    cons_logAString("ERROR", strcat("File[", file,"] NOT FOUND"));  
    return FALSE;
  }
  contents = fgets(flannel);
  hudElementItr = 0;
  line = fgets(flannel);
  while( (line != "") ){ 
    if( (line != "{") && (line != "}") && (substring(line,0, 2) != "//") ){
      line_tag = tokenizebyseparator(line, "  '","'",": ", ",");
      token = argv(1);
      value = argv(3);
      if( token != ""){
        if( token == "uid"){
          //serves as master switch when iterating through hud elements
          UI_DATA_UIDS[hudElementItr] = ui_data_load_hud_tagId(value);
        }
        if( token == "pos"){
          UI_DATA_POS[hudElementItr] = stov(value);
        }
        if( token == "size"){
          UI_DATA_SIZE[hudElementItr] = stov(value);
        }
        if( token == "icon"){
          UI_DATA_IMG[hudElementItr] = strzone(value);
        }
        if( token == "valign"){
          UI_DATA_ALIGN[hudElementItr] = gui_StringToFlag_Align(value);
        }
        if( token == "color1"){
          UI_DATA_COLOR1[hudElementItr] = stov(value);
        }
        if( token == "color2"){
          UI_DATA_COLOR2[hudElementItr] = stov(value);
        }
        if( token == "label"){
          UI_DATA_LABEL[hudElementItr] = strzone(value);
        }
        if( token == "lalign"){
          UI_DATA_LABEL_ALIGN[hudElementItr] = gui_StringToFlag_Align(value);
        }
        if( token == "axis"){
          UI_DATA_AXIS_FLAG[hudElementItr] = gui_StringToFlag_Axis(value);
        }
        if( token == "lblofs"){
          UI_DATA_LABEL_OFS[hudElementItr] = stov(value);
        }
        if( token == "wbit"){
          UI_DATA_WEPBIT[hudElementItr] = ui_data_load_hud_weaponTag(value);
        }
        if( token == "lflag"){
          UI_DATA_LABEL_FLAG[hudElementItr] = stof(value);
        }
      }
    }
    if( line == "{" ){
      hudElementItr = hudElementItr + 1;
    }
    line = fgets(flannel);
  }
  fclose(flannel);
  return TRUE;
};

float(float id) ui_date_load_item1={
  
  ui_data_clear_item1();
  
  data_get_client_item_(UI_ARMING_DATA_item_a, id);
  UI_ARMING_DATA_item_a.data_idx = id;
  
  ITEM1_DATA_ID = UI_ARMING_DATA_item_a.data_idx;
  ITEM1_DATA_ABBR = UI_ARMING_DATA_item_a.abbrev;
  ITEM1_DATA_NAME = UI_ARMING_DATA_item_a.w_name;
  ITEM1_DATA_ICON = precache_pic(UI_ARMING_DATA_item_a.icon, 0);
  ITEM1_DATA_DMG = UI_ARMING_DATA_item_a.damageValue;
  ITEM1_DATA_TYPE = UI_ARMING_DATA_item_a.damageType;
  ITEM1_DATA_EN = UI_ARMING_DATA_item_a.energyRate;
  ITEM1_DATA_RANGE = UI_ARMING_DATA_item_a.w_range;
  ITEM1_DATA_CLIP = UI_ARMING_DATA_item_a.w_clipsize;
  ITEM1_DATA_SIZE = UI_ARMING_DATA_item_a.equipSize;
  ITEM1_DATA_TECH = UI_ARMING_DATA_item_a.techLevel;
  ITEM1_DATA_DESC = UI_ARMING_DATA_item_a.description;

  return TRUE;
};

float(float id) ui_date_load_item2={

  ui_data_clear_item2();
  
  data_get_client_item_(UI_ARMING_DATA_item_b, id);
  UI_ARMING_DATA_item_b.data_idx = id;
  
  ITEM2_DATA_ID = UI_ARMING_DATA_item_b.data_idx;
  ITEM2_DATA_ABBR = UI_ARMING_DATA_item_b.abbrev;
  ITEM2_DATA_NAME = UI_ARMING_DATA_item_b.w_name;
  ITEM2_DATA_ICON = precache_pic(UI_ARMING_DATA_item_b.icon, 0);
  ITEM2_DATA_DMG = UI_ARMING_DATA_item_b.damageValue;
  ITEM2_DATA_TYPE = UI_ARMING_DATA_item_b.damageType;
  ITEM2_DATA_EN = UI_ARMING_DATA_item_b.energyRate;
  ITEM2_DATA_RANGE = UI_ARMING_DATA_item_b.w_range;
  ITEM2_DATA_CLIP = UI_ARMING_DATA_item_b.w_clipsize;
  ITEM2_DATA_SIZE = UI_ARMING_DATA_item_b.equipSize;
  ITEM2_DATA_TECH = UI_ARMING_DATA_item_b.techLevel;
  ITEM2_DATA_DESC = UI_ARMING_DATA_item_b.description;
  
  return TRUE;
};

float( float mechId, float fileNum ) ui_mech_config_switch={
  local float cfg, itr;
  local entity hardpoint;
  local entity oself;
  
  if( CLIENT_MENU_sel_mech > 0 ){
    data_mech_config_save( CLIENT_MENU_sel_mech, CFG_INDEX_PREV );
    data_mech_config_clearBuffer();
  }
  
  ui_data_load_mech( mechId );
  
  //Config 1, Config 2, Config 3 are now DEFAULTs
  if(fileNum > 3){
    //Attempt to load and validate the desired config
    cfg = data_mech_config_load( mechId, fileNum );
    if( cfg ){
      cfg = data_mech_config_valid();
    }
    
    //hm, desired config has errors, try the DEFAULT? you did keep the default around....right?
    if( !cfg ){
      cfg = data_mech_config_load( mechId, 0 );
      cfg = data_mech_config_valid();
      
    }
  }
  else{
    cfg = TRUE;
    oself = self;
    self = UI_HANGAR_DATA_mech;
      //GROUPS - zero it out first
      self.w_group1 = 0;
      self.w_group2 = 0;
      self.w_group3 = 0;
      self.w_group4 = 0;
      if( fileNum == 1 ){
        if(self.config_default_regular){
          self.config_default_regular();
        }
      }
      else if( fileNum == 2){
        if(self.config_default_missile){
          self.config_default_missile();
        }
      }
      else{
        if(self.config_default_brawl){
          self.config_default_brawl();
        }
      }
           
      //INV_HAS_NONE conditions - maybe EMPTY should not be 0...
      self.next_wepn1 = max(0, self.next_wepn1);
      self.next_wepn2 = max(0, self.next_wepn2);
      self.next_wepn3 = max(0, self.next_wepn3);
      self.next_wepn4 = max(0, self.next_wepn4);
      self.next_wepn5 = max(0, self.next_wepn5);
      self.next_wepn6 = max(0, self.next_wepn6);
      self.next_wepn7 = max(0, self.next_wepn7);
      self.next_wepn8 = max(0, self.next_wepn8);
      self.next_wepn9 = max(0, self.next_wepn9);
      //
    self = oself;
    DATA_CONFIG_BUFFER_WEPS[1] = UI_HANGAR_DATA_mech.next_wepn1;
    DATA_CONFIG_BUFFER_WEPS[2] = UI_HANGAR_DATA_mech.next_wepn2;
    DATA_CONFIG_BUFFER_WEPS[3] = UI_HANGAR_DATA_mech.next_wepn3;
    DATA_CONFIG_BUFFER_WEPS[4] = UI_HANGAR_DATA_mech.next_wepn4;
    DATA_CONFIG_BUFFER_WEPS[5] = UI_HANGAR_DATA_mech.next_wepn5;
    DATA_CONFIG_BUFFER_WEPS[6] = UI_HANGAR_DATA_mech.next_wepn6;
    DATA_CONFIG_BUFFER_WEPS[7] = UI_HANGAR_DATA_mech.next_wepn7;
    DATA_CONFIG_BUFFER_WEPS[8] = UI_HANGAR_DATA_mech.next_wepn8;
    DATA_CONFIG_BUFFER_WEPS[9] = UI_HANGAR_DATA_mech.next_wepn9;
    
    DATA_CONFIG_BUFFER_GRPS[0] = UI_HANGAR_DATA_mech.w_group1;
    DATA_CONFIG_BUFFER_GRPS[1] = UI_HANGAR_DATA_mech.w_group2;
    DATA_CONFIG_BUFFER_GRPS[2] = UI_HANGAR_DATA_mech.w_group3;
    DATA_CONFIG_BUFFER_GRPS[3] = UI_HANGAR_DATA_mech.w_group4;
  }
  
  //welp, here goes, lets make the switch
  if( cfg ){
    SELECT_MECH = mechId;
    CLIENT_MENU_sel_mech = SELECT_MECH;
    CLIENT_MENU_sel_size = UI_HANGAR_DATA_mech.vec_size;
    cleanHardPoints();
    CLIENT_MENU_nex_grp1 = DATA_CONFIG_BUFFER_GRPS[0];
    CLIENT_MENU_nex_grp2 = DATA_CONFIG_BUFFER_GRPS[1];
    CLIENT_MENU_nex_grp3 = DATA_CONFIG_BUFFER_GRPS[2];
    CLIENT_MENU_nex_grp4 = DATA_CONFIG_BUFFER_GRPS[3];
    
    itr = 1;
    hardpoint = UI_HANGAR_DATA_mech.w_slot;
    while( hardpoint ){
      data_get_client_item_(hardpoint, DATA_CONFIG_BUFFER_WEPS[itr]);
      itr = itr + 1;
      hardpoint = hardpoint.w_slot;
    }
    GROUP_ENE_1 = calc_energy_draw(CLIENT_MENU_nex_grp1);
    GROUP_ENE_2 = calc_energy_draw(CLIENT_MENU_nex_grp2);
    GROUP_ENE_3 = calc_energy_draw(CLIENT_MENU_nex_grp3);
    GROUP_ENE_4 = calc_energy_draw(CLIENT_MENU_nex_grp4);
  }
  return TRUE;
};

/*
  Not-so-great .contains(id) function idea
*/
float(float itemId) ui_data_inventory_find_item={
  local float i;
  while( i <=  UNLOCKED_ITEMS_TOTAL ){
    if( itemId == UNLOCKED_ITEMS[i]){
      return UNLOCKED_ITEMS[i];
    }
    i = i + 1;
  }
  return FALSE;
};

//brute force
void() ui_data_has_items={
  INV_HAS_light_autocannon = ui_data_inventory_find_item(UID_ITEM_light_autocannon);
  INV_HAS_emp = ui_data_inventory_find_item(UID_ITEM_emp);          
  INV_HAS_light_laser = ui_data_inventory_find_item(UID_ITEM_light_laser);    
  INV_HAS_rocket_launcher = ui_data_inventory_find_item(UID_ITEM_rocket_launcher);
  INV_HAS_quantum_rifle = ui_data_inventory_find_item(UID_ITEM_quantum_rifle);     
  INV_HAS_rotary_plasma = ui_data_inventory_find_item(UID_ITEM_rotary_plasma);
  INV_HAS_particle_cannon = ui_data_inventory_find_item(UID_ITEM_particle_cannon);
  INV_HAS_electro_repeater = ui_data_inventory_find_item(UID_ITEM_electro_repeater);  
  INV_HAS_missile_laserguide = ui_data_inventory_find_item(UID_ITEM_missile_laserguide);
  INV_HAS_missile_activeradar = ui_data_inventory_find_item(UID_ITEM_missile_activeradar);
  INV_HAS_snub_artillery = ui_data_inventory_find_item(UID_ITEM_snub_artillery);
  INV_HAS_flak = ui_data_inventory_find_item(UID_ITEM_flak);         
  INV_HAS_ion_coil = ui_data_inventory_find_item(UID_ITEM_ion_coil);
  INV_HAS_missile_swarm = ui_data_inventory_find_item(UID_ITEM_missile_swarm);     

  INV_HAS_adv_reload = ui_data_inventory_find_item(UID_ITEM_adv_reload);
  INV_HAS_energy_battery = ui_data_inventory_find_item(UID_ITEM_energy_battery);
  INV_HAS_shield_emitter = ui_data_inventory_find_item(UID_ITEM_shield_emitter);
  INV_HAS_heatsink = ui_data_inventory_find_item(UID_ITEM_heatsink);
  INV_HAS_shield_capacitor = ui_data_inventory_find_item(UID_ITEM_shield_capacitor);
  INV_HAS_recharge_capacitor = ui_data_inventory_find_item(UID_ITEM_recharge_capacitor);
  INV_HAS_turbo_charger = ui_data_inventory_find_item(UID_ITEM_turbo_charger);
};