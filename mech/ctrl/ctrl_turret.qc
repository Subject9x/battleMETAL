/*
mech Mod
Author: Peter Roohr
Date: 11/02/2017
Overview: controller file for all turret stuff
*/

void() ctrl_updateTurret={
  local float diff;
 // add code to find closest power plant and attempt to draw power

  if(self.en_cur >= 0){
    self.en_cur = self.en_cur + self.en_rate;
    if(self.en_cur > self.en_max){
      self.en_cur = self.en_max;
    }
  }

  if(self.sh_cur < self.sh_max){
    if(time > self.sh_hit){
      if(self.en_cur > 0){
        self.sh_cur = self.sh_cur + self.sh_rate;
        self.en_cur = self.en_cur - self.sh_rate;
        if(self.sh_cur > self.sh_max){
          self.sh_cur = self.sh_max;
        }
      }
    }
  }
  if(self.en_cur < 0){
    self.en_cur = 0;
  }
  else if(self.en_cur > self.en_max){
    self.en_cur = self.en_max;
  }
};