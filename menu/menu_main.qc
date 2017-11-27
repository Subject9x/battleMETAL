/*
  author: Peter Roohr
  date: 11/26/2017
  
  overview: what is a menu.dat? time to explore and find out
*/

void() m_init={

};

void(float keynr, float ascii) m_keydown={
  print(strcat(ftos(keynr),"::",ftos(ascii),"\n"));
};

void(float width, float height) m_draw={
  local vector mpos;
  mpos = getmousepos();
  drawcharacter(mpos, 1, '1 1', '1 1 1', 1, 0);
  
};

void(float mode) m_toggle={

};

void() m_shutdown={

};