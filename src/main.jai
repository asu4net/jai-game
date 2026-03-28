main :: () 
{
    #if DEBUG
    {
        defer report_memory_leaks();
    }

    create_graphics_application(1920, 1080, "Game", wanted_msaa = 8, vsync = true);
    
    // ===================================================
    // @MainLoop:
    // ===================================================

    while running()
    {
        clear_screen();
        present();
    }
}

// ===================================================
// @Loads:
// ===================================================

#load "engine.jai";