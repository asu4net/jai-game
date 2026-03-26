// ===================================================
// @Loads:
// ===================================================

#load "engine/graphics.jai";

// ===================================================
// @Imports:
// ===================================================

#import "Basic"()(MEMORY_DEBUGGER = DEBUG);
#import "Window_Creation";
#import "Input";
#import "Math";

#if OPENGL 
{
    // @Note: Hay que importar esto antes que Windows. Por algún motivo.
    #import "GL"(DUMP_GL_ERRORS = DEBUG, DEFAULT_MSAA = DEFAULT_MSAA);
}

#if OS ==
{
    case .WINDOWS;
    {
        #import "Windows";
    }
    case .MACOS;
    {
        #import "Objective_C";
        #import "Objective_C/AppKit";
    }
    case .LINUX;
    {
        #import "X11";
    }
}