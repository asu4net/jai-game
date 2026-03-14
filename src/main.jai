main :: () 
{
    #if OS == .WINDOWS 
    {
        SetProcessDPIAware(); // @Note(SetProcessDPIAware)
        timeBeginPeriod(1);   // @Note(timeBeginPeriod)
    }

    #if DEBUG
    {
        defer report_memory_leaks();
    }

    window = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE, wanted_msaa = MSAA);
    gpu_backend_init();

    // ===================================================
    // @MainLoop:
    // ===================================================
    while !quit 
    {
        update_window_events();

        for events_this_frame 
        {
            if it.type == .QUIT 
            {
                quit = true;
            }
            if it.type == .KEYBOARD 
            {
                if it.key_pressed == 0 
                {
                    continue;
                }
                #if DEBUG 
                {
                    if it.key_code == .ESCAPE 
                    {
                        quit = true;
                    }
                }
            }
        }
        
        gpu_clear_screen();
        gpu_swap_buffers(window, VSYNC);
    }
}

// ===================================================
// @Globals:
// ===================================================

quit: bool;
window: Window_Type;

// ===================================================
// @Loads:
// ===================================================
#load "constants.jai";

#if OPENGL 
{
    #load "gpu_backend_gl.jai";
    #load "gpu_calls_gl.jai";
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
    // @Note: Hay que importar esto antes que  Por algún motivo.
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

// @Note(SetProcessDPIAware):

// DPI (Dots Per Inch): Indican cuántos píxeles hay en una
// pulgada física de pantalla. Windows en monitores con alto
// DPI puede llegar a escalar automáticamente tu ventana para 
// que los elementos con pocos píxeles se continuen viendo.
// Con esta llamada le comunicas a Windows "I got u, buddy".

// @Note(timeBeginPeriod):

// El Kernel de windows tiene un tick rate con el que actualiza
// como el cambio de hilos (await/sleep) y la actualización de los
// timers. Con esta llamada especificas que lo haga con una frecuencia
// de un milisegundo, en vez de la default. Esto hace que esas 
// actualizaciones sucedan con más frecuencia. A coste de más consumo
// de CPU se gana más estabilidad en las partes de la aplicación que
// dependen de esto.
//
// SRC: https://hero.handmade.network/forums/game-discussion/t/8612-what_does_timebeginperiod_actually_do