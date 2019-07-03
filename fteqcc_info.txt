FTC QuakeC Compiler (FTEQCC) Version 1.00
http://www.fteqw.com/

This software is licensed under the GPL. Read the included LICENSE file for details.

Notes:
What makes fteqcc different from id's qcc
- warnings for just about everything
- "local" is not required before local variables
- semicolon after function body is optional
- redundant semicolons at file scope are allowed
- empty statements are allowed
- empty curly braces are allowed
- C-style function declarations and definitions are allowed
- hexadecimal numeric constants are understood
- varargs builtin functions with some required parms are supported.
  e.g. "void bprint(float level, string s, ...)"
- Supports working nested function calls.
- Supports code like this: a = a-5;
- Supports a bucket load of warnings. It's still possible to make a progs without default warnings.
- Support for arrays
    float anarray[64];
    for (i = 0; i < 64; i++)
        anarray[i] = somecomplexfunction(i);
    blah = anarray[floor(random()*64)];
- preprocessor functionality:
    - Defines
        #define <name> [<value>]
      creates a new define - value is optional
        #undef <name>
      delete an existing define
        #define name(a,b) ((a)*(b))
      creates a new macro which multiplies a and b. Consider it as a function call
      this is usable to create inline functions, eg: #define crandom() (random()-0.5)*2
    - Reserved Defines
      the internally defined FTEQCC is always present and can be used to detect
        the compiler, e.g.
          #ifndef FTEQCC
          #error "Code may only be compiled with fteqcc!"
          #endif
    - Conditional expressions for defines (nested conditions are allowed):
        #ifdef <name>
          <statements if name is defined>
        #else
          <statements if name is not defined>
        #endif
      or
        #ifndef <name>
          <statements if name is not defined>
        #else
          <statements if name is defined>
        #endif
      The #else cases are optional;
    - Message-Output
        #error "<Error Message>"
      print out the given message and stop the compilation.
        #message "<Normal Message>"
        #pragma message "<Normal Message>"
      (synonyms) prints out the given message and continue compilation
        #warning "<msg>"
        #pragma warning "<msg>"
      Displays a warning in a consistant way.
    - The copyright pragma
        #pragma copyright "<blah>"
      Causes text output into the progs just after the header. This will be the first thing anyone is able to read when opened in a text editor.
      This is really useful when you have many targets all with the same filename.
    - The target pragma
        #pragma target <targetname>
      Targets supported:
      - H2       Hexen2 compatable output. Note that fteqcc is able to compile hexenc code. This target must be specified (normally on the commandline) for hexen2 engines to function properly.
      - KK7      (mostly) 32 bit output which is compatable with kkqwsv.
      - FTE      FTE specific target. The advantage of this target is down to additional operations and thus many optimisations
      - FTE32    32 bit form of the FTE target. This allows much larger output files as well as the same operations added for the FTE target
      - Standard The default.
      Note that switching targets on the fly is not always possible (and certainly not recommended).
      Any switching of targets should be done before any functions or definitions are found.
    - The progs_dat pragma
        #pragma progs_dat "../progs.dat"
      Allows you to change the name of the produced progs file mid compilation.
      If the first non-comment characture of the progs.src file is a #, progs.src is treated as a .qc file, and this pragma is required.
      This is useful for small mods or addons. It is advised to use this pragma to specify.
    - #include precompiler directive:
        #include "blah.qh"
    - #eof
      Causes fteqcc to ignore any following lines in the current file.
    - The warning pragma
      This pragma allows you to disable/enable display of various warnings
        #pragma warning disable Q120
      Will disable the warning for unrecognised pragmas.
        #pragma warning disable Q201
      Will disable the assignment in conditional warnings.
        #pragma warning disable Q205
      Will prevent warnings about hanging ; charactures (indications of additional ones, eg: if (blah); )
        #pragma warning disable Q302
      Will prevent fteqcc from warning when variables were not used.
    - Limits for preprocessor defines:
      - max. 2048 defines are allowed
      - in progs.src only allowed after first valid line (after definition of the output filename)
      - defines may not only be used in #ifdef conditions but can also be expanded from anywhere.
      - the stringify macro operator (#) and the concatinate macro operator (##) are supported, but only in macros.
- Support for c-like switch statements
        switch(somevariable)
        {
        case 0:
            dostuff();
            break;
        case 1:
            dootherstuff();
            break;
        default:
            dounknownstuff();
            break;
        }
- Support for c-like 'for' statements, with continue and break.
      For statements are similar to while statements, though with a small difference
      Think of a for statement and for ( <initialisation> ; <while> ; <increment> ) {dostuff();}
      The initialisation is done straight away, and only once. The code then loops until <while> becomes false.
      Each time the end of the statement block is encountered, the <increment> is executed.
      Thus to call a function 5 times, use this: for (i = 0; i < 5; ++i) dostuff();
- Support for += -= /= *= operations.
- Support for both prefix and postfix forms of ++ and --.
      Note that the postfix form is less efficient than the prefix form.
- Support for gotos.
      Note that gotos are evil and should only be used as a last resort. :)
- More optimisations than any other qc compiler.
- Enhanced $frame macros.
    - $framevalue X    specifies the next value for a $frame
       Useful for defining seperate frames for different models within the same qc file.
    - $framesave x    saves off the current next value
       Saves the nextmacro value to a name for restoring later.
    - $framerestore x    restores a saved framemacro next.
       Restores the nextmacro value from a name. This is useful when you have multiple models with some indentical frames.
    - $flush    wipes all macros, and all saved indexes.
    -  if not flushed, frame macros can be used in subsequent qc files.
- Straight forward Multiple-Document Interface for simpler browsing of code.
- locals marshalling, an opt which stores all locals in one section of pr_globals,
      reducing it further, current problems are not yet known with this opt but
      has been tested to be fairly reliable despite the experimental warning
      - accessible by using -Olm on command line
- vector calls, uses 3 floats instead of vectors for vector parameters into functions,
      decreases the number of globals in the compiled progs for code using an abnormally
      huge number of vector calls, but in general substantially increases the progs size.
      This is a special case opt.
      - accessible by using -Ovc on command line