function varargout = TestModel_GUI(varargin)
% TESTMODEL_GUI MATLAB code for TestModel_GUI.fig
%      TESTMODEL_GUI, by itself, creates a new TESTMODEL_GUI or raises the existing
%      singleton*.
%
%      H = TESTMODEL_GUI returns the handle to a new TESTMODEL_GUI or the handle to
%      the existing singleton*.
%
%      TESTMODEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTMODEL_GUI.M with the given input arguments.
%
%      TESTMODEL_GUI('Property','Value',...) creates a new TESTMODEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestModel_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestModel_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestModel_GUI

% Last Modified by GUIDE v2.5 12-Oct-2017 12:28:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestModel_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TestModel_GUI_OutputFcn, ...
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


% --- Executes just before TestModel_GUI is made visible.
function TestModel_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestModel_GUI (see VARARGIN)

% Choose default command line output for TestModel_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestModel_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TestModel_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in TE_B_Start_Testing.
function TE_B_Start_Testing_Callback(hObject, eventdata, handles)
% hObject    handle to TE_B_Start_Testing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Testing_Started,'string','Testing Started...');
pause(2);
set(handles.Fetching_Testing_DataSet,'string','Fetching Testing DataSet...');
pause(2);
Acc=ThirdTestingPart();
set(handles.Calculating_Accuracy_of_Testing_Dataset,'string','Calculating Accuracy of Testing DataSet...');
pause(2);
set(handles.TE_Accuracy1,'string','ACCURACY  :');
set(handles.Accuracy_VAL1,'string',Acc);


% --- Executes on button press in TE_B_Return.
function TE_B_Return_Callback(hObject, eventdata, handles)
% hObject    handle to TE_B_Return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(TestModel_GUI);
