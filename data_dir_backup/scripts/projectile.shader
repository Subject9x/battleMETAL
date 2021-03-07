//PROJECTILE - EMP
q3mdl/proj/mdl_proj_emp_b
{
    tesssize 32
		deformVertexes wave 10 triangle 0 .25 0 0.5
		deformVertexes wave -10 triangle 0 .25 0 0.5
		{
				map q3mdl/proj/mdl_proj_emp_b.tga
				tcMod turb 0 0.5 0 .05
				tcMod rotate 10
		}
    {
      map $lightmap
      blendfunc GL_DST_COLOR GL_ZERO
      rgbGen vertex
    }
}

//PROJECTILE - RPLAS
q3mdl/proj/mdl_proj_rpc_b
{
    tesssize 16
		deformVertexes wave 5 square 0 .1 0 .5
    deformVertexes wave -5 square 0 .1 0 .5
		{
				map q3mdl/proj/mdl_proj_rpc_b.tga
				tcMod rotate 10
		}
}