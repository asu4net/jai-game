Build_Params :: struct {
    out        := "game";
    out_dir    := ".bin";
    source     := "src/main.jai";
    debug      := false;
    editor     := false;
}

#run build();

build :: () {
    set_build_options_dc(.{do_output=false});
    collect_params();
    setup_workspace();
    wait_until_workspace_has_finished();
    reset_temporary_storage();
}

collect_params :: () {

    args := get_build_options().compile_time_command_line;
    if !args.count {
        log("Unprovided build params. Compiling with defaults: %\n", params);
        return;
    }

    collect : (*Build_Params, string);

    for args {
        // Collect field;
        if collect && it.count && !begins_with(it, "-") {
            collect(*params, it);
            collect = null;
            continue;
        }
        arg := to_lower_copy(it ,,temp);
        // Collect args.
        if arg == {
            case "-out"     ; collect = (p: *Build_Params, field: string) { p.out = field; };
            case "-out_dir" ; collect = (p: *Build_Params, field: string) { p.out_dir = field; };
            case "-source"  ; collect = (p: *Build_Params, field: string) { p.source = field; };
            case "-debug"   ; params.debug  = true;
            case "-editor"  ; params.editor = true;
            case; log("Unrecognized option % \n", arg);
        }
    }
}

setup_workspace :: () {

    out := ifx  params.debug 
           then join(params.out_dir, "\\", "debug")
           else join(params.out_dir, "\\", "release");

    make_directory_if_it_does_not_exist(out, true);

    w = compiler_create_workspace();
    compiler_begin_intercept(w);

    options := get_build_options(w);
    options.output_path = out;
    options.output_executable_name = params.out;
    
    if params.debug {
        options.backend = .X64;
        set_optimization(*options, .DEBUG);
    } else {
        options.backend = .LLVM;
        set_optimization(*options, .OPTIMIZED);
    }


    // @Note: Don't log build info.
    // options.text_output_flags = 0;

    set_build_options(options, w);
    add_build_file(params.source, w);
    add_build_string(tprint("DEBUG :: %;", params.debug), w);
    add_build_string(tprint("EDITOR :: %;", params.editor), w);
}

wait_until_workspace_has_finished :: () {
    log("Building %...", get_build_options(w).output_executable_name);
    ended_with_errors := false;
    while true {
        message := compiler_wait_for_message();
        if message.kind == .COMPLETE {
            log("Done building.");
            break;
        }
        if message.kind == .ERROR {
            ended_with_errors = true;
            break;
        }
    }
    compiler_end_intercept(w);
    if ended_with_errors 
    then compiler_set_workspace_status(.FAILED);
}

// ===================================================
// @Globals:
// ===================================================

params: Build_Params;
w: Workspace;

// ===================================================
// @Imports:
// ===================================================

#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";
#import "Process";