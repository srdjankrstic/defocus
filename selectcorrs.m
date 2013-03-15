function varargout = selectcorrs(varargin)
% SELECTCORRS MATLAB code for selectcorrs.fig
%      SELECTCORRS, by itself, creates a new SELECTCORRS or raises the existing
%      singleton*.
%
%      H = SELECTCORRS returns the handle to a new SELECTCORRS or the handle to
%      the existing singleton*.
%
%      SELECTCORRS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTCORRS.M with the given input arguments.
%
%      SELECTCORRS('Property','Value',...) creates a new SELECTCORRS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectcorrs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectcorrs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectcorrs

% Last Modified by GUIDE v2.5 14-Mar-2013 03:32:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectcorrs_OpeningFcn, ...
                   'gui_OutputFcn',  @selectcorrs_OutputFcn, ...
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

function formatted = format_output(handles)
outdata = [];
for i = 1:handles.total
    if handles.outdata{i}
        outdata = [outdata,...
                   struct('num', i,...
                          'left', handles.cam1files{i},...
                          'right', handles.cam2files{i},...
                          'pts1', handles.outdata{i}(:,1:2),...
                          'pts2', handles.outdata{i}(:,3:4))];
    end
end
formatted = outdata;


function show_image(handles)
%if (handles.current_image > 1)
%    close(handles.figure1);
%end
im1 = imread(handles.cam1files{handles.current_image});
im2 = imread(handles.cam2files{handles.current_image});
imshow([im1 im2]);
set(handles.label, 'String', strcat(num2str(handles.current_image),...
                                    '/',...
                                    num2str(handles.total)));

% --- Executes just before selectcorrs is made visible.
function selectcorrs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectcorrs (see VARARGIN)

handles.cam1files = extractfield(dir('cam1*'), 'name');
handles.cam2files = extractfield(dir('cam2*'), 'name');
if (size(handles.cam1files) ~= size(handles.cam2files))
    error('different number of left and right camera views');
end

%axes(handles.axes1);
handles.current_image = 1;
handles.total = size(handles.cam1files, 2);
handles.outdata = cell(1, handles.total);

show_image(handles);

% Choose default command line output for selectcorrs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selectcorrs wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = selectcorrs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = format_output(handles);
delete(hObject);

% --- Executes on button press in selectbtn.
function selectbtn_Callback(hObject, eventdata, handles)
% hObject    handle to selectbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im1 = imread(handles.cam1files{handles.current_image});
im2 = imread(handles.cam2files{handles.current_image});
[pts1 pts2] = cpselect(im1, im2, 'Wait', true);

handles.outdata{handles.current_image} = [pts1 pts2];

guidata(hObject, handles);


% --- Executes on button press in nextbtn.
function nextbtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.current_image < handles.total
    handles.current_image = handles.current_image + 1;
    show_image(handles)
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in prevbutton.
function prevbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prevbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.current_image > 1
    handles.current_image = handles.current_image - 1;
    show_image(handles);
    guidata(hObject, handles);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume();
