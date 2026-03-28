#if OS ==
{
    case .WINDOWS; 
        gl_context_win32: HGLRC;
    case .MACOS;
        gl_context_macos: *NSOpenGLContext;
    case .LINUX;
        gl_context_linux: GLXContext;
        glx_window_linux: GLXWindow;
} 

is_graphics_context_created :: () -> bool
{
    #if OS ==
    {
        case .WINDOWS; return gl_context_win32 != null;
        case .MACOS;   return gl_context_macos != null;
        case .LINUX;   return gl_context_linux != null && glx_window_linux != 0;
    } 
}

create_graphics_context :: (window: Window_Type, msaa: s32 = 0) -> bool
{
    if !window
    {
        return false; 
    }
    
    if is_graphics_context_created()
    {
        return true;
    }
    
    #if OS ==
    {
        case .WINDOWS;
        {
            hglrc, hdc, chosen_msaa := wgl_create_context(window, null, OPENGL_MAJOR, OPENGL_MINOR, wanted_msaa = msaa);
            gl_context_win32 = hglrc;
        }
        case .MACOS;
        {
            // @Pending: MSAA.
            gl_context_macos = nsgl_create_context(window, OPENGL_MAJOR, OPENGL_MINOR);
        }
        case .LINUX;
        {
            // @Pending: MSAA.
            glx_context, fb_config, _ /* chosen_msaa */ := glx_create_context(info.window, OPENGL_MAJOR, OPENGL_MINOR);
            gl_context_linux = glx_context;
            glx_window_linux := glXCreateWindow(x_global_display, fb_config, window, null);
        }
    }

    gl_load(*gl);
    
    #if DEBUG 
    {
        gl_enable_debug_output(break_on_error = true);
        DumpGLErrors(tag = "context");
    }
    
    return is_graphics_context_created();
}

swap_buffers :: (window: Window_Type, vsync := true) 
{   
    if !window || !is_graphics_context_created()
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
            NSOpenGLContext.flushBuffer(gl_context_macos);
        }
        case .LINUX;
        {
            // @Pending: V-Sync.
            glXSwapBuffers(x_global_display, glx_window_linux);
        }
    } 
}

clear_screen :: (color := COLOR_CORN_LOWER_BLUE) 
{
    glClearColor(xx color.x, xx color.y, xx color.z, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}