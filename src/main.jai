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
        present(game.graphics);
    }
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
    graphics: Graphics_Application;
}

game: Game;

// ===================================================
// @Loads:
// ===================================================

#load "engine.jai";