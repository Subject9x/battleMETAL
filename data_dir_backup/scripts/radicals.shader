textures/radicals/mineral_a
{
	qer_editorimage textures/radicals/mineral_a.tga

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
  {
      map q3mdl/map/rads/rad_base_lg.tga
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
q3mdl/map/rads/qtm_base
{
    tesssize 32
		deformVertexes wave 10 square 0 .5 0 1
		{
				map q3mdl/map/rads/qtm_base.tga
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
q3mdl/map/rads/min_base
{
		{
				map q3mdl/map/rads/min_base.tga
				rgbGen lightingDiffuse
		}
}


//Map Entity - rad_base_sm / md/ lg
q3mdl/map/rads/rad_base_lg
{
		deformVertexes wave 10 sin 0 .1 0 .25
		deformVertexes wave -10 sin 0 .1 .25 .5
		{
				map q3mdl/map/rads/rad_base_lg.tga
				tcMod turb 0 0.1 0 .01
				tcMod rotate 0.25
				rgbGen lightingDiffuse
		}
}

//EXPLOSION SHELLS - SHIELD
q3mdl/fx/explosions/te_shield_explode
{
		deformVertexes wave 4 sin 0 .75 0 1.0
		{
				map q3mdl/fx/explosions/te_shield_explode.tga
				tcMod turb 0 0.25 0 0.25
				tcMod rotate 10
				rgbGen vertex
		}   
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
q3mdl/fx/explosions/te_shield_explode_red
{
		deformVertexes wave 7 sin 0 .75 0 1.0
		{
				map q3mdl/fx/explosions/te_shield_explode_red.tga
				tcMod turb 0 0.25 0 0.25
				tcMod rotate 10
				rgbGen vertex
		}   
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
//EXPLOSION SHELLS - EXPLODE
q3mdl/fx/explosions/te_missile_explode
{
		deformVertexes wave 7 sin 0 .75 0 1.0
		{
				map q3mdl/fx/explosions/te_missile_explode.tga
				tcMod turb 0 0.25 0 0.25
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
q3mdl/fx/debris1/skin_debris1
{
		{
				map q3mdl/fx/debris1/skin_debris1.tga
				tcMod turb 0 0.25 0 0.25
				tcMod rotate 15
				rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
//DEBRIS - DEBRIS2
q3mdl/fx/debris2/skin_debris2
{
		{
				map q3mdl/fx/debris1/skin_debris1.tga
				tcMod turb 0 0.25 0 0.25
				tcMod rotate 15
				rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}
//DEBRIS - DEBRIS3
q3mdl/fx/debris3/skin_debris3
{
		{
				map q3mdl/fx/debris1/skin_debris1.tga
				tcMod turb 0 0.25 0 0.25
				tcMod rotate 15
				rgbGen lightingDiffuse
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}