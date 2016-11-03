/*
mech Mod
Author: Subject9x
Date: 11/02/2016
Overview: implementation for hud widget callbacks
*/

/*
TODO: fix bar length
TODO: allow for different axis alignments of bar
TODO: allow for different bar types: squares / spheres etc
*/
void() hud_renderEnergy={
  self.value1 = getstati(STAT_ENERGY);
  drawfill(self.origin, self.drawsize,  '0.75 0 0 ', 1, 0 );
  self.drawcolor = colorForVal(self.value1);
  local float grn;
  local vector adj;
  adj = self.drawsize;
  adj_y = self.drawsize_y * (self.value1/100);
  drawfill(self.origin, adj ,  '0 0.75 0 ', 1, 0 );
};

void() hud_renderShield={
};

void() hud_renderPaper={
};
