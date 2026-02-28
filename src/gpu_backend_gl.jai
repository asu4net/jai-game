init_gpu_backend :: () {
    gl_create_context(window, OPENGL_MAJOR, OPENGL_MINOR, debug = DEBUG, wanted_msaa = MSAA);
    gl_load(*gl);
    
    #if DEBUG {
        gl_enable_debug_output(break_on_error = true);
        DumpGLErrors(tag = "context");
    }
}

swap_buffers :: (window: Window_Type, vsync := true) {
    #if OS == .WINDOWS {        
        wglSwapIntervalEXT(xx ifx vsync then 1 else 0);
        dc := Windows.GetDC(window);
        Windows.SwapBuffers(dc);
    } else {
        assert(false);
    }
}