Graphics_Application :: struct
{
    window: Window_Type;
    api: Graphics_API;
    vsync: bool;
}

create_graphics_application :: (width: s32 = 1920, height: s32 = 1080, title: string = "Window", wanted_msaa: s32 = 8, vsync: bool = true) -> Graphics_Application
{
    graphics: Graphics_Application;

    #if OS == .WINDOWS 
    {
        SetProcessDPIAware(); // @Note(SetProcessDPIAware)
        timeBeginPeriod(1);   // @Note(timeBeginPeriod)
    }

    graphics.vsync = vsync;

    graphics.window = create_window(width, height, title, wanted_msaa = wanted_msaa); // @Note(MSAA)
    assert(graphics.window != null, "Error: Window bad.");

    graphics.api = create_graphics_api(graphics.window, wanted_msaa);
    assert(graphics.api != null, "Error: Context bad.");

    return graphics;
}

present :: inline (graphics: Graphics_Application)
{
    swap_buffers(graphics.window, graphics.api, graphics.vsync);
}

// ===================================================
// @Constants:
// ===================================================

OPENGL        :: true;
OPENGL_MAJOR  :: 4;
OPENGL_MINOR  :: 1;
DEFAULT_MSAA  :: 8;

COLOR_WHITE            :: Vector4.{ 1.000, 1.000, 1.000, 1.000 };
COLOR_WHITE_FADED      :: Vector4.{ 1.000, 1.000, 1.000, 0.000 };
COLOR_BLACK            :: Vector4.{ 0.000, 0.000, 0.000, 1.000 };
COLOR_CORN_LOWER_BLUE  :: Vector4.{ 0.388, 0.584, 0.933, 1.000 };
COLOR_BLUE             :: Vector4.{ 0.000, 0.000, 1.000, 1.000 };
COLOR_LIGHT_BLUE       :: Vector4.{ 0.300, 0.300, 1.000, 1.000 };
COLOR_CYAN             :: Vector4.{ 0.000, 1.000, 1.000, 1.000 };
COLOR_GRAY             :: Vector4.{ 0.500, 0.500, 0.500, 1.000 };
COLOR_DARK_GRAY        :: Vector4.{ 0.200, 0.200, 0.200, 1.000 };
COLOR_GREEN            :: Vector4.{ 0.000, 1.000, 0.000, 1.000 };
COLOR_LIGHT_GREEN      :: Vector4.{ 0.300, 1.000, 0.300, 1.000 };
COLOR_CHILL_GREEN      :: Vector4.{ 0.047, 0.651, 0.408, 1.000 };
COLOR_MAGENTA          :: Vector4.{ 1.000, 0.000, 1.000, 1.000 };
COLOR_RED              :: Vector4.{ 1.000, 0.000, 0.000, 1.000 };
COLOR_LIGHT_RED        :: Vector4.{ 1.000, 0.300, 0.300, 1.000 };
COLOR_YELLOW           :: Vector4.{ 1.000, 0.920, 0.016, 1.000 };
COLOR_ORANGE           :: Vector4.{ 0.970, 0.600, 0.110, 1.000 };

// ===================================================
// @Loads:
// ===================================================

#if OPENGL
{
    #load "graphics/backend/opengl/api.jai";
}
else
{
    #assert(false);
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

// @Note(MSAA)

// En videojuegos cuando pintamos triángulos, sobretodo
// en pixeles que caen en una diagonal vemos que se genera
// "aliasing", "dientes de sierra":

// [][][] 
//   [][] 
//     [] 

// MSAA (Multisample Anti-Alisasing):

// Es una ténica de suavizado que puede activarse
// en las API Gráficas para reducir los "dientes" de
// sierra en polígonos a cambio de un coste mínimo 
// de rendimiento. Popular en el desarrollo de juegos
// en Android. Funciona calculando cuánto de un pixel
// está cubierto por un triángulo, tomando muestras, y
// pintando píxeles circundantes para suavizar.
//
// Con MSAA x8 se toman 8 muestras por cada píxel.