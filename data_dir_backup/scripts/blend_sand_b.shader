//=====================================
// Game: battleMETAL
// info: blend_sand.shaders
//=====================================
//
//BLENDS
//  basin_b -> desert_b
//  desert_b -> rock_b
//  desert_b -> basin_b
//  desert_b -> high_b
//  high_b -> rock_b
//
//In a practical sense, you can think of the dotproduct vector ( 0 0 0.9 ) as meaning that all vertex normal 
//vectors pointing straight up along the z-axis ( 0 0 1 ) will have a vertex alpha value of 90% opacity.

//--------------------------------------------------
//  SAND_BASIN_B -----------------------------
//--------------------------------------------------
textures/blend/sand/basin_blend_rock_b
{
  qer_editorimage textures/desert/icon/basin_b_to_rock_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  {
    map textures/desert/sand_desert_rock_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_basin_b.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//basin_b -> desert_b
textures/blend/sand/basin_blend_sand_b
{
  qer_editorimage textures/desert/icon/basin_b_to_sand_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.45 )
  {
    map textures/desert/sand_basin_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_b.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}

//--------------------------------------------------
//  SAND_DESERT_B -----------------------------
//--------------------------------------------------
//desert_b -> rock_b =============================================
textures/blend/sand/sand_blend_rock_b
{
  qer_editorimage textures/desert/icon/sand_b_to_rock_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.95 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_rock_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_b.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
//desert_b -> basin_b =============================================
textures/blend/sand/sand_blend_basin_b
{
  qer_editorimage textures/desert/icon/sand_b_to_basin_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.55 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_basin_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }

  {
    map textures/desert/sand_desert_b.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  } 

}
//desert_b -> high_b =============================================
textures/blend/sand/sand_blend_high_b
{
  qer_editorimage textures/desert/icon/sand_b_to_high_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.6 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_high_b.tga
    tcMod scale 1 1
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_b.tga
    tcMod scale 2 2
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}
//--------------------------------------------------

//--------------------------------------------------
//  SAND_DESERT_HIGH_B -----------------------------
//--------------------------------------------------
//high_b -> desert_b
textures/blend/sand/high_blend_sand_b
{
  qer_editorimage textures/desert/icon/high_b_to_sand_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.55 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_high_b.tga
    tcMod scale 1 1
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}


//high_b -> rock_b
textures/blend/sand/high_blend_rock_b
{
  qer_editorimage textures/desert/icon/high_b_to_rock_b.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.9 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_rock_b.tga
    tcMod scale 2 2
    rgbGen vertex
  }

  {
    map textures/desert/sand_desert_high_b.tga
    tcMod scale 1 1
    blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
    alphaGen vertex
    rgbGen vertex
  }
  
  {
    map $lightmap
    blendFunc GL_DST_COLOR GL_ZERO
    rgbGen identity
  }
}