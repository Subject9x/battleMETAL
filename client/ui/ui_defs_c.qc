/*
mech Mod
Author: Subject9x
Date: 3/8/2017
Overview:  class file for ui system
*/

/*
  mouse bounds check - 
*/
float(vector mpos, vector org, vector sz) menu_checkMouseInBounds={

  local vector asz;
  asz = org+sz;
  if(((mpos_x > org_x) && (mpos_x < asz_x))
  && ((mpos_y > org_y) && (mpos_y < asz_y))){
    return TRUE;
  }
  return FALSE;
};

/*
  calculates the screen-area of a list, determines if the mouse is within the bounds of one of these
  and returns the index number of the item if any'
*/
float(vector org, vector mpos, vector list_size, vector row_size, float max_items, float space) textListListener={

  local float itr, found;
  local vector interval;
  interval = list_size;
  interval_y = list_size_y / max_items;
  itr = 1;
  found = 0;
  while(itr < max_items+1){
    local float chk;
    local vector sub_org;
    sub_org = org;
    sub_org_y = org_y + (interval_y * itr);
    chk = menu_checkMouseInBounds(mpos, sub_org, row_size);
    if(chk){
      gui_DrawRect(sub_org, sub_org + row_size, '2 2', '1 1 1');
      found = itr;
    }
    itr = itr + 1;
  }
  return found;
};


void() menu_handleFrame={

  local vector mpos;
  mpos_x = cursorpos_x - 2;
  mpos_y = cursorpos_y - 4;

  if(MENU_HANGAR_ACTIVE){
    menu_hangarDrawFrame(); 
  }
  else if(MENU_BRIEF_ACTIVE){
  
  }
  drawfill(mpos, '4 8', '0 1 0', HUD_ALPHA, 0);
};