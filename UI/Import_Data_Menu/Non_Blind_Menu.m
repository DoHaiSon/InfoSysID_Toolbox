function varargout = Non_Blind_Menu(varargin)
% NON_BLIND_MENU MATLAB code for Non_Blind_Menu.fig
%      NON_BLIND_MENU, by itself, creates a new NON_BLIND_MENU or raises the existing
%      singleton*.
%
%      H = NON_BLIND_MENU returns the handle to a new NON_BLIND_MENU or the handle to
%      the existing singleton*.
%
%      NON_BLIND_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NON_BLIND_MENU.M with the given input arguments.
%
%      NON_BLIND_MENU('Property','Value',...) creates a new NON_BLIND_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Non_Blind_Menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Non_Blind_Menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Non_Blind_Menu

% Last Modified by GUIDE v2.5 17-Sep-2021 11:10:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;

gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Non_Blind_Menu_OpeningFcn, ...
                   'gui_OutputFcn',  @Non_Blind_Menu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Non_Blind_Menu is made visible.
function Non_Blind_Menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)
% varargin   command line arguments to Non_Blind_Menu (see VARARGIN)

global main_path;
jFrame=get(handle(handles.figure1), 'javaframe');
jicon=javax.swing.ImageIcon(fullfile(main_path,'/Resource/Icon/menu_icon.png'));
jFrame.setFigureIcon(jicon);

handles_main = getappdata(0,'handles_main');
axesH = handles_main.board;  % Not safe! Better get the handle explicitly!
img = imread(fullfile(main_path, '/Resource/Dashboard/nonblind_model.png'));
imshow(img, 'Parent', axesH);

set(handles.Nt,'TooltipString','The number of transmit antennas');
set(handles.Nr,'TooltipString','The number of receive antennas');
set(handles.order,'TooltipString','Channel order');
set(handles.multipaths,'TooltipString','The number of multi paths');
set(handles.subcarriers,'TooltipString','K-point FFT');
set(handles.ratio,'TooltipString','The ratio of power between 1 symbol Pilot/Data');

% Set position for this GUI
movegui(hObject, 'west');

% Release system model when cursor not in any UIClass
set(hObject,'WindowButtonDownFcn',{@releasesysmodel});

% Choose default command line output for Non_Blind_Menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Non_Blind_Menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Non_Blind_Menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in domain.
function domain_Callback(hObject, eventdata, handles)
% hObject    handle to domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns domain contents as cell array
    contents = get(hObject, 'Value') - 1;
    if contents == 0
        return;
    end
    if contents == 1
        disp('None Blind - Time Domain');
    else
        disp('None Blind - Frequency Domain');
    end


% --- Executes during object creation, after setting all properties.
function domain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in modulation.
function modulation_Callback(hObject, eventdata, handles)
% hObject    handle to modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

    mod = get(hObject,'Value') -1 ;
    if mod == 0
        return;
    end
    
    disp('OFDM Modulation: 64 sub-carriers');
%     handles_main = getappdata(0,'handles_main');
%     scatter(handles_main.dataaxes, real(data), imag(data));

% --- Executes during object creation, after setting all properties.
function modulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratio as text
%        str2double(get(hObject,'String')) returns contents of ratio as a double


% --- Executes during object creation, after setting all properties.
function ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multipaths_Callback(hObject, eventdata, handles)
% hObject    handle to multipaths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multipaths as text
%        str2double(get(hObject,'String')) returns contents of multipaths as a double


% --- Executes during object creation, after setting all properties.
function multipaths_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multipaths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function order_Callback(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Hints: get(hObject,'String') returns contents of order as text
%        str2double(get(hObject,'String')) returns contents of order as a double


% --- Executes during object creation, after setting all properties.
function order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subcarriers_Callback(hObject, eventdata, handles)
% hObject    handle to subcarriers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user method (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subcarriers as text
%        str2double(get(hObject,'String')) returns contents of subcarriers as a double


% --- Executes during object creation, after setting all properties.
function subcarriers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subcarriers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Get handes form main window
    handles_main = getappdata(0,'handles_main');
    global legends;
        
    Nt    = str2double(get(handles.Nt, 'String'));
    Nr    = str2double(get(handles.Nr, 'String'));
    L     = str2double(get(handles.order, 'String'));
    M     = str2double(get(handles.multipaths, 'String'));
    K     = str2double(get(handles.subcarriers, 'String'));
    ratio = str2double(get(handles.ratio, 'String'));
    
    if (get(handles.methods, 'Value') - 1 == 0)
        return;
    end
    
    % Exec function:
    if (get(handles.methods, 'Value') - 1 == 1)
        loader('Processing');
        [SNR, CRB_op, CRB_op_spec, CRB_SB, CRB_SB_spec] = ULA(Nt, Nr, L, M, K, ratio, 1, ...
            get(handles.domain, 'Value') - 1, 1);

        % Close loader window
        try
            F = findall(0, 'type', 'figure', 'tag', 'loader');
            waitbar(1, F, 'Done!');
            close(F);
        catch ME
            disp(ME);
        end

        global results;         % Be careful 
        
        % GUI to WS
        GUI2WS(SNR);
        GUI2WS(CRB_op);
        
        % Define Figure params
        results.figparams.count = results.figparams.count + 1;
        results.figparams.data(results.figparams.count).x = SNR;
        results.figparams.data(results.figparams.count).y = CRB_op;
        results.figparams.title = 'CRB';
        results.figparams.xlabel = 'SNR(dB)';
        results.figparams.ylabel = 'Normalized CRB';
        results.figparams.gridmode = 'on';
        results.figparams.marker = '-o';
        results.figparams.legends{end + 1} = 'normal OP';
    end
    % Check empty figure
    if ~ishandle(results.fig)
        output = figure('Name', 'CRB', 'Tag', 'outputCRB');
        results.fig = output;
        results.figaxes = axes;
    end
    
    % Check figure mode: Clear/hold on/subfigure
    mode = checkfigmode(handles_main);
    switch(mode)
        case 1
            %clear old figure
            cla(results.figaxes, 'reset');
            results.figparams.count = 0;
            results.mode = 1;
            dispfig(results);
        case 2
            results.mode = 2;
            dispfig(results);
        case 3
            results.mode = 3;
            dispfig(results);
        otherwise
    end
    
    %% Export data to Toolbox Workspace
    global toolboxws;
    toolboxws = [toolboxws; [{true, 'CRB_Nt_2_Nr_16_L_2_M_4_K_64_P_0.3', matrix2char(results.figparams.data(results.figparams.count).x), ...
        matrix2char(results.figparams.data(results.figparams.count).y), ...
        10000}]];
    set(handles_main.toolbox_ws, 'Data', toolboxws);

% --- Executes on selection change in methods.
function methods_Callback(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methods


% --- Executes during object creation, after setting all properties.
function methods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
    set(hObject, 'String', {'            Select method', '                     Pilot', '                 Specular'})


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Nt.
function Nt_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Nt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.Nr, 'Enable', 'inactive');
    params_Nt = Params;
    params_Nt.position = [5 290 60 60];
    params_Nt.linewidth = 2;
    params_Nt.color = 'r';
    
    params2sysmodel(hObject, eventdata, params_Nt);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Nr.
function Nr_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.Nt, 'Enable', 'inactive');
    params_Nr = Params;
    params_Nr.position = [1025 620 60 60];
    params_Nr.linewidth = 2;
    params_Nr.color = 'b';
    params2sysmodel(hObject, eventdata, params_Nr);