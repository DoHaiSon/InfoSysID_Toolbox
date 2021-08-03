function start()
%   add path to this toolbox
    global main_path;
    main_path = matlab.desktop.editor.getActiveFilename; %   get path of active file
    main_path = main_path(1:end-8);
    addpath(genpath(main_path));

%   format master clock
    format shortg;
    global time;
    time = clock;
    
%   Load main GUI
    loader('Opening the application', 'main', 1);
    try
        F = findall(0, 'type', 'figure', 'tag', 'loader');
        waitbar(1, F, 'Done!');
        close(F);
    catch ME
        disp(ME);
    end