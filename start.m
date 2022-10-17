function start()
%%  For testing, we close everything when the program startup
    close all hidden;

%%  TODO: Do not add everything 
    global main_path;
    main_path = mfilename('fullpath'); %   get path of active file
    main_path = main_path(1:end-6);
    addpath(genpath(main_path));
    
    % Clear auto save file of matlab
    clear_asv_files(main_path);
    
    % TODO: Close all BSI toolbox windows

%%  format master clock
    format shortg;
    global time;
    time = clock;
    
%%  Declear global vars
    global results;
    results = Results;
    init_results();
    global pre_algo;
    pre_algo = '';
    global input_data;
    input_data = {};
    
%%  Load MODE GUI
    loader('Opening the application', 'mode');
    try
        F = findall(0, 'type', 'figure', 'tag', 'loader');
        waitbar(1, F, 'Done!');
        close(F);
    catch ME
        disp(ME);
    end