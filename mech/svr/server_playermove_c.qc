/*
mech Mod
Author: Subject9x
Date: 8/28/2016
Overview: header for the different player move type functions
*/

void() mh_svr_pmove_fly_pre={
   local float vel1, yaw_diff, up_z;
   local vector dir, dir2;

   makevectors (self.v_angle);

   if ( (self.flags & FL_FLY) && (self.velocity_x || self.velocity_y) )
   {
      vel1 = vlen (self.velocity); // its current speed
      dir = self.velocity;
      dir2 = vectoangles (dir);

      // This corrects an ID mistake.  They had the pitch angle in
      // reverse.
      dir2_x = dir2_x * -1;

      yaw_diff = dir2_y - self.v_angle_y;

      if (yaw_diff > 180)
         yaw_diff = yaw_diff - 360;

      if (fabs (self.v_angle_x) > 24)
      {
         up_z = TRUE;  // movement in z direction (up/down)

         if (fabs (fabs (yaw_diff) - 180) < 2)
         {
            dir = v_forward * -1;
         }
         else if (fabs (yaw_diff) < 2)
         {
            dir = v_forward;
         }
         else
         {
            up_z = FALSE;
         }
      }
      self.velocity = normalize (dir) * vel1;

      if (up_z)
      {
         if (vlen (self.velocity) > 10)
         {
            vel1 = cvar ("sv_maxspeed");
            self.velocity = normalize (dir) * vel1;
         }
      }
   }
};

void() mh_svr_pmove_fly_post={
  local float g;
  g = cvar ("sv_gravity") * frametime;

  if (self.flags & FL_FLY)
  {
    if (self.velocity_z > 0)
    {
       self.velocity_z = self.velocity_z - g;
    }

    if (self.velocity_z < 0)
    {
       self.velocity_z = self.velocity_z + g;
    }

    if (fabs (self.velocity_z) < g)
    {
       self.velocity_z = 0;
    }
  }
};

void() mh_svr_pmove_walk={
  
};