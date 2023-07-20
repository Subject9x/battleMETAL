textures/radicals/mineral_a
{
	qer_editorimage textures/radicals/mineral_a.tga
  surfaceparm nolightmap
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/radicals/mineral_a.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/radicals/mineral_a_brush
{
	qer_editorimage textures/radicals/mineral_a.tga
  q3map_surfaceLight 512
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/radicals/mineral_a.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/radicals/radiate_a
{
	qer_editorimage textures/radicals/radiate_a.tga
  deformVertexes wave 10 sin 0 .1 0 .25
  deformVertexes wave -10 sin 0 .1 .25 .5
  surfaceparm nolightmap
  {
      map models/map/rads/rad_base_lg.tga
      tcMod turb 0 0.1 0 .01
      tcMod rotate 0.25
      rgbGen lightingDiffuse
  }
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/radicals/radiate_a.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/radicals/radiate_a_brush
{
	qer_editorimage textures/radicals/radiate_a.tga
  deformVertexes wave 10 sin 0 .1 0 .25
  deformVertexes wave -10 sin 0 .1 .25 .5
  q3map_surfaceLight 512
  {
      map models/map/rads/rad_base_lg.tga
      tcMod turb 0 0.1 0 .01
      tcMod rotate 0.25
      rgbGen lightingDiffuse
  }
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/radicals/radiate_a.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

textures/radicals/quantum_a
{
	qer_editorimage textures/radicals/quantum_a.tga
  tesssize 32
  deformVertexes wave 10 square 0 .5 0 1
  {
    map textures/radicals/quantum_a.tga
    tcMod turb 0 0.5 0 .05
    tcMod rotate 1
  }
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen vertex
  }
	{
		map textures/radicals/quantum_a.tga
		tcMod scale 1 1
		blendFunc GL_DST_COLOR GL_ZERO
		rgbGen identity
	}
}

//Map Entity - qtm_base_sm / md/ lg
models/map/rads/qtm_base
{
    dpNoShadow
    dpReflect 0.5 0.7 0.15 0.5 0.33
    dpNoRtlight
    tesssize 32
    surfaceparm nolightmap
		deformVertexes wave 10 square 0 .5 0 1
		{
				map models/map/rads/qtm_base.tga
				tcMod turb 0 0.5 0 .05
				tcMod rotate 1
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}

//Map Entity -Min_base_sm / md/ lg
models/map/rads/min_base
{
		{
				map models/map/rads/min_base.tga
				rgbGen lightingDiffuse
		}
}


//Map Entity - rad_base_sm / md/ lg
models/map/rads/rad_base_lg
{
  dpNoShadow
  q3map_tessSize 5
  surfaceparm nolightmap
  deformVertexes wave 5 sin 0 .1 0 .25
  deformVertexes wave -5 sin 0 .1 .25 .5
  {
    map models/map/rads/rad_base_lg.tga
    tcMod turb 0 0.1 0 .01
    tcMod rotate 0.25
    rgbGen lightingDiffuse
  }
}

//EXPLOSION SHELLS - SHIELD
models/fx/explosions/te_shield_hit
{
  dpNoShadow
  q3map_tessSize 2
  surfaceparm nolightmap
  deformVertexes wave 3 sin 0 .75 0 1.0
  {
    map models/fx/explosions/te_shield_hit.tga
    rgbGen lightingDiffuse
  }   
  //{
  //  map $lightmap
  //  blendfunc GL_DST_COLOR GL_ZERO
  //  rgbGen vertex
  //}
}
models/fx/explosions/te_shield_exp
{
  dpNoShadow
  q3map_tessSize 4
  surfaceparm nolightmap
  deformVertexes wave 5 sin 0 .75 0 1.0
  {
    map models/fx/explosions/te_shield_exp.tga
    rgbGen lightingDiffuse
  }   
  //{
  //  map $lightmap
  //  blendfunc GL_DST_COLOR GL_ZERO
  //  rgbGen vertex
  //}
}

//EXPLOSION SHELLS - EXPLODE
models/fx/explosions/te_missile_explode
{
  dpNoShadow
  q3map_tessSize 3
  surfaceparm nolightmap
  deformVertexes wave 3 sin 0 .75 0 1.0
  {
      map models/fx/explosions/te_missile_explode.tga
      tcMod rotate 15
      rgbGen vertex
  }
  {
    map $lightmap
    blendfunc GL_DST_COLOR GL_ZERO
    rgbGen vertex
  }
}

//DEBRIS - DEBRIS1
models/fx/debris1/skin_debris1
{
  dpNoShadow
  surfaceparm nolightmap
		{
      map models/fx/debris1/skin_debris1.tga
      tcMod turb 0 0.25 0 0.25
      rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
//DEBRIS - DEBRIS2
models/fx/debris2/skin_debris2
{
  dpNoShadow
  surfaceparm nolightmap
		{
      map models/fx/debris1/skin_debris1.tga
      tcMod turb 0 0.25 0 0.25
      rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
//DEBRIS - DEBRIS3
models/fx/debris3/skin_debris3
{
  dpNoShadow
  surfaceparm nolightmap
		{
      map models/fx/debris1/skin_debris1.tga
      tcMod turb 0 0.25 0 0.25
      rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}