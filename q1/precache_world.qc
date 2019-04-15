/*
  Quake 1 precache file
  call this before world.main()
*/

void() q1_precache_world={
  // these are just commands the the prog compiler to copy these files
	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");
}