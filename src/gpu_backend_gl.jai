gpu_backend_init :: () 
{
    #if OS == .WINDOWS 
    {
        hglrc, hdc, chosen_msaa := wgl_create_context(window, null, OPENGL_MAJOR, OPENGL_MINOR, wanted_msaa=MSAA);
        gl_context = hglrc;
    }
    else #if OS == .MACOS 
    {
        gl_context = nsgl_create_context(window, OPENGL_MAJOR, OPENGL_MINOR, wanted_msaa=MSAA);
    }

    gl_load(*gl);
    
    #if DEBUG 
    {
        gl_enable_debug_output(break_on_error = true);
        DumpGLErrors(tag = "context");
    }
}

gpu_swap_buffers :: (window: Window_Type, vsync := true) 
{
    #if OS == .WINDOWS 
    {        
        wglSwapIntervalEXT(xx ifx vsync then 1 else 0);
        dc := GetDC(window);
        SwapBuffers(dc);
    } 
    else #if OS == .MACOS 
    {
        NSOpenGLContext.flushBuffer(gl_context);
    }
}

#if OS == .WINDOWS 
{
    gl_context: HGLRC;
} 
else #if OS == .MACOS 
{
    gl_context: *NSOpenGLContext;
}