function [status, SNR, Err] = Run_py_script ( file_path, varargin)

%% [status, SNR, Err] = Run_py_script(file_path, varargin): Run python program and return the Error rate.
%
%% Input:
    % 1. file_path: (char) - location of target python program
    % 2. varargin: (char) - list of input params
%
%% Output:
    % 1. status: (bool) - True/False
    % 2. SNR: (array) - working SNR
    % 3. Err: (array) - output error rate
%
%% Require R2013A
%
% Author: Do Hai Son - AVITECH - VNU UET - VIETNAM
% Last Modified by Son 13-May-2023 14:42:13 
    
status = 0;
[dir_path, file_name, ext] = fileparts(file_path);

% Determine if version is for Windows/Linux/MacOS platform
os     = checkOS();
if strcmp(os, 'macos')
    python = 'python3 ';
elseif strcmp(os, 'linux')
    python = 'python3 ';
elseif strcmp(os, 'windows')
    python = 'python ';
else
    error('Platform not supported');
end

args = '';

if (nargin == 1)
    cmd = [python, file_path];
else
    for i=1:nargin-1
        args = [args ' ' parse_arg2py(varargin{i})];
    end
    cmd = [python, file_path, args];
end

[status, stdout] = system(cmd);

disp(stdout);

%% Read result
% Check status
split_output = strsplit(stdout, '\n');
if (strcmp(split_output{end-1}, 'True'))
    file_name = ['result_' split_output{end - 2} '.txt'];
    result_file = fullfile(dir_path, file_name);

    % Read file
    fop = fileread(result_file);

    split_fop = strsplit(fop, ']');

    SNR = str2num([regexprep(split_fop{1},'\s+',' ') ']']);
    Err = str2num([regexprep(split_fop{2},'\s+',' ') ']']);
    
    if strcmp(type_of(SNR), 'array') && strcmp(type_of(Err), 'array')
        status = 1;
    end
else
    error('Run python script failed.')
end

end