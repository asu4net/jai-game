main :: () 
{
    #if DEBUG
    {
        defer report_memory_leaks();
    }

    create_window_and_context();

    // ===================================================
    // @MainLoop:
    // ===================================================

    while running()
    {
        clear_screen();
        
        present();
    }
}

create_window_and_context :: ()
{
    #if OS == .WINDOWS 
    {
        SetProcessDPIAware(); // @Note(SetProcessDPIAware)
        timeBeginPeriod(1);   // @Note(timeBeginPeriod)
    }

    game.window = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE, wanted_msaa = MSAA);
    assert(game.window != null, "Error: Window bad.");

    game.graphics_context = create_graphics_context(game.window);
    assert(game.graphics_context != null, "Error: Context bad.");
}

present :: inline ()
{
    swap_buffers(game.window, game.graphics_context, VSYNC);
}

running :: () -> bool
{
    update_window_events();
    // @Pending: Time step.    

    Quit :: () #expand
    {
        game.quit = true;
        break;
    }

    for events_this_frame
    {
        #if DEBUG 
        {
            if it.key_code == .ESCAPE
            {
                Quit();
            }
        }
        if it.type == .QUIT
        {
            Quit();
        }
    }
    
    return !game.quit;
}

// ===================================================
// @Globals:
// ===================================================

Game :: struct
{
    quit: bool;
    window: Window_Type;
    graphics_context: Graphics_Context;
}

game: Game;

// ===================================================
// @Loads:
// ===================================================
#load "constants.jai";

#if OPENGL 
{
    #load "context_gl.jai";
    #load "functions_gl.jai";
} 
else 
{
    #assert(false);
}

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
    #import "GL"(DUMP_GL_ERRORS = DEBUG, DEFAULT_MSAA = MSAA);
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
}

// ===================================================
// @Notes:
// ===================================================

// @Note(Windows.SetProcessDPIAware):

// DPI (Dots Per Inch): Indican cuántos píxeles hay en una
// pulgada física de pantalla. Windows en monitores con alto
// DPI puede llegar a escalar automáticamente tu ventana para 
// que los elementos con pocos píxeles se continuen viendo.
// Con esta llamada le comunicas a Windows "I got u, buddy".

// @Note(Windows.timeBeginPeriod):

// El Kernel de windows tiene un tick rate con el que actualiza
// como el cambio de hilos (await/sleep) y la actualización de los
// timers. Con esta llamada especificas que lo haga con una frecuencia