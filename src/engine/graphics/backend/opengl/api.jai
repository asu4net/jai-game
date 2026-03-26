#if OS ==
{
    case .WINDOWS; Graphics_API :: HGLRC;
    case .MACOS;   Graphics_API :: *NSOpenGLContext;
    case;          Graphics_API :: *void;
} 

create_graphics_api :: (window: Window_Type, msaa: s32 = 0) -> Graphics_API
{
    api: Graphics_API;

    if !window
    {
        return api; 
    }
    
    #if OS ==
    {
        case .WINDOWS;
        {
            hglrc, hdc, chosen_msaa := wgl_create_context(window, null, OPENGL_MAJOR, OPENGL_MINOR, wanted_msaa = msaa);
            api = hglrc;
        }
        case .MACOS;
        {
            // @Pending: MSAA.
            api = nsgl_create_context(window, OPENGL_MAJOR, OPENGL_MINOR);
        }
    }

    gl_load(*gl);
    
    #if DEBUG 
    {
        gl_enable_debug_output(break_on_error = true);
        DumpGLErrors(tag = "context");
    }

    return api;
}

swap_buffers :: (window: Window_Type, api: Graphics_API, vsync := true) 
{   
    if !window || !api
    {
        return;
    }

    #if OS ==
    {
        case .WINDOWS;
        {
            wglSwapIntervalEXT(xx ifx vsync then 1 else 0);
            dc := GetDC(window);
            SwapBuffers(dc);
        }
        case .MACOS;
        {
            // @Pending: V-Sync.
            NSOpenGLContext.flushBuffer(api);
        }
    } 
}

clear_screen :: (color := COLOR_CORN_LOWER_BLUE) 
{
    glClearColor(xx color.x, xx color.y, xx color.z, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}