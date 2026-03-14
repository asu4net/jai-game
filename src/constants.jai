WINDOW_TITLE  :: "Game";
WINDOW_WIDTH  :: 1280;
WINDOW_HEIGHT :: 720;
MSAA          :: 8; // @Note(MSAA)
OPENGL        :: true;
OPENGL_MAJOR  :: 4;
OPENGL_MINOR  :: 1;
VSYNC         :: true;

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
// @Notes:
// ===================================================

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