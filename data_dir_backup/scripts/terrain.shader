//=====================================
// Game: battleMETAL
// info: terrain.shaders

//=====================================

textures/terrain/asphalt1
{
  qer_editorimage textures/terrain/asphalt1.tga
  {
		map $lightmap
		rgbgen identity
	}
  {
    map textures/terrain/asphalt1.tga   
  }
}

textures/terrain/asphalt2
{
  qer_editorimage textures/terrain/asphalt2.jpg
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/asphalt2.jpg
  }
}


textures/terrain/asphalt3
{
  qer_editorimage textures/terrain/asphalt3.jpg
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/asphalt3.jpg
  }
}

textures/terrain/cliff1
{
  qer_editorimage textures/terrain/cliff1.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/cliff1.tga
  }
}

textures/terrain/mud1
{
  qer_editorimage textures/terrain/mud1.jpg
  {
		map $lightmap
		rgbgen identity
	}
  {
    map textures/terrain/mud1.jpg 
  }
}

textures/terrain/sand1
{
  qer_editorimage textures/terrain/sand1.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/sand1.tga
  }
}

textures/terrain/sand2
{
  qer_editorimage textures/terrain/sand2.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/sand2.tga
  }
}


//Env: Desert
//Series: A
//Pale Yellow Desert
textures/terrain/d_a_s_basin
{
  qer_editorimage textures/terrain/d_a_s_basin.tga
  q3map_tcMod scale 1 1
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/d_a_s_basin.tga
  }
}

textures/terrain/d_a_s_cliff
{
  qer_editorimage textures/terrain/d_a_s_cliff.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/d_a_s_cliff.tga
  }
}

textures/terrain/d_a_s_cracked
{
  qer_editorimage textures/terrain/d_a_s_cracked.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/d_a_s_cracked.tga
  }
}

textures/terrain/d_a_s_dune
{
  qer_editorimage textures/terrain/d_a_s_dune.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/d_a_s_dune.tga
  }
}

textures/terrain/d_a_s_top
{
  qer_editorimage textures/terrain/d_a_s_top.tga
  {
		map $lightmap
		rgbgen identity      
	}
  {
    map textures/terrain/d_a_s_top.tga
  }
}

textures/terrain/desert_fog
{
	qer_editorimage textures/terrain/desert_fog.tga
	qer_trans 0.85
	surfaceparm nomarks
	surfaceparm trans
	surfaceparm water
	surfaceparm nolightmap
	q3map_globaltexture
	{
		map textures/terrain/desert_fog.tga
		tcmod scale 0.0025 0.025
		tcMod scroll 0.005 0.005
		blendfunc blend
	}
}