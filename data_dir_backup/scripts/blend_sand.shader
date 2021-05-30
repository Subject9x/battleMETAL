//=====================================
// Game: battleMETAL
// info: blend_sand.shaders
//=====================================
//
//BLENDS
//  basin_a -> desert_a
//  desert_a -> rock_a
//  desert_a -> basin_a
//  desert_a -> high_a
//  high_a -> rock_a
//
//In a practical sense, you can think of the dotproduct vector ( 0 0 0.9 ) as meaning that all vertex normal 
//vectors pointing straight up along the z-axis ( 0 0 1 ) will have a vertex alpha value of 90% opacity.

//--------------------------------------------------
//  SAND_DESERT_BASIN_A -----------------------------
//--------------------------------------------------
textures/blend/sand/basin_blend_rock_a
{
  qer_editorimage textures/desert/icon/basin_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.9 )
  q3map_alphaMod dotproduct ( 0 0 0.94 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }

  {
    map textures/desert/sand_desert_basin_a.tga
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

//basin_a -> desert_a
textures/blend/sand/basin_blend_sand_a
{
  qer_editorimage textures/desert/icon/basin_a_to_sand_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.45 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_basin_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
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
//  SAND_DESERT_A -----------------------------
//--------------------------------------------------
//desert_a -> rock_a =============================================
textures/blend/sand/sand_blend_rock_a
{
  qer_editorimage textures/desert/icon/sand_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.88 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
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
//desert_a -> basin_a =============================================
textures/blend/sand/sand_blend_basin_a
{
  qer_editorimage textures/desert/icon/sand_a_to_basin_a.tga  
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.4 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }

  {
    map textures/desert/sand_desert_basin_a.tga
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
//desert_a -> high_a =============================================
textures/blend/sand/sand_blend_high_a
{
  qer_editorimage textures/desert/icon/sand_a_to_high_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.6 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_high_a.tga
    tcMod scale 2 2
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
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
//  SAND_DESERT_HIGH_A -----------------------------
//--------------------------------------------------
//high_a -> desert_a
textures/blend/sand/high_blend_sand_a
{
  qer_editorimage textures/desert/icon/high_a_to_sand_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct ( 0 0 0.55 )
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }
  {
    map textures/desert/sand_desert_high_a.tga
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


//high_a -> rock_a
textures/blend/sand/high_blend_rock_a
{
  qer_editorimage textures/desert/icon/high_a_to_rock_a.tga
  q3map_baseShader textures/blend/terrain_base
  q3map_tcGen ivector ( 512 0 0 ) ( 0 512 0 )
  q3map_alphaMod dotproduct2 ( 0 0 0.88 )
  
  //the sharp texture that dotproduct2 points to.
  {
    map textures/desert/sand_desert_rock_a.tga
    tcMod scale 4 4
    rgbGen vertex
  }

  {
    map textures/desert/sand_desert_high_a.tga
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