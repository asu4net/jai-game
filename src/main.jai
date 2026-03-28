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

running :: () -> bool
{
    update_window_events();
    // @Pending: Time step.    

    for events_this_frame
    {
        #if DEBUG 
        {
            if it.key_code == .ESCAPE
            {
                game.quit = true;
                break;
            }
        }
        if it.type == .QUIT
        {
            game.quit = true;
            break;
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
}

game: Game;

// ===================================================
// @Loads:
// ===================================================

#load "engine.jai";