#if OS ==
{
    case .WINDOWS; Graphics_Context :: HGLRC;
    case .MACOS;   Graphics_Context :: *NSOpenGLContext;
    case;          Graphics_Context :: *void;
} 

create_graphics_context :: (window: Window_Type) -> Graphics_Context
{
    graphics_context: Graphics_Context;

    if !window
    {
        return graphics_context; 
    }
    
    #if OS ==
    {
        case .WINDOWS;
        {
            hglrc, hdc, chosen_msaa := wgl_create_context(window, null, OPENGL_MAJOR, OPENGL_MINOR, wanted_msaa=MSAA);
            graphics_context = hglrc;
        }
        case .MACOS;
        {
            // @Pending: MSAA.
            graphics_context = nsgl_create_context(window, OPENGL_MAJOR, OPENGL_MINOR);
        }
    }

    gl_load(*gl);
    
    #if DEBUG 
    {
        gl_enable_debug_output(break_on_error = true);
        DumpGLErrors(tag = "context");
    }

    return graphics_context;
}

swap_buffers :: (window: Window_Type, graphics_context: Graphics_Context, vsync := true) 
{   
    if !window || !graphics_context
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
            NSOpenGLContext.flushBuffer(graphics_context);
        }
    } 
}