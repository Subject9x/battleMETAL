//=====================================
// Game: battleMETAL
// info: heightmaps.shaders

//=====================================

//root shaders

//blendwork


//q3map_alphaMod dotproduct ( X Y Z )
textures/terrain/terrain_test
{
    q3map_nonplanar
    q3map_shadeangle 150
}

textures/terrain_t3
{
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 0.5 0.5
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_high_a.tga
    tcMod scale 0.5 0.5
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphagen vertex
  }
  
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}


models/terrain/terrain3/botright
{
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 7 7
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 10 10
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphagen vertex
  }
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}


models/terrain/terrain3/botleft
{
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 1 )
  
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 5 5
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 7 7
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphagen vertex
  }
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

models/terrain/terrain3/topleft
{
  q3map_terrain
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 1 )
  
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 5 5
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 7 7
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphagen vertex
  }
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//test slice
models/terrain/terrain3/topright
{
  q3map_nonplanar
  q3map_shadeangle 179
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 3 3
    rgbGen vertex
  } 
  {
    map textures/desert/sand_desert_high_a.tga
    tcMod scale 3 3
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphagen vertex
  }
  
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
