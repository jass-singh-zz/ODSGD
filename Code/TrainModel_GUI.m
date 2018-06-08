function varargout = TrainModel_GUI(varargin)
% TRAINMODEL_GUI MATLAB code for TrainModel_GUI.fig
%      TRAINMODEL_GUI, by itself, creates a new TRAINMODEL_GUI or raises the existing
%      singleton*.
%
%      H = TRAINMODEL_GUI returns the handle to a new TRAINMODEL_GUI or the handle to
%      the existing singleton*.
%
%      TRAINMODEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINMODEL_GUI.M with the given input arguments.
%
%      TRAINMODEL_GUI('Property','Value',...) creates a new TRAINMODEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrainModel_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrainModel_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrainModel_GUI

% Last Modified by GUIDE v2.5 14-Oct-2017 00:14:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrainModel_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrainModel_GUI_OutputFcn, ...
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


% --- Executes just before TrainModel_GUI is made visible.
function TrainModel_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrainModel_GUI (see VARARGIN)

% Choose default command line output for TrainModel_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrainModel_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrainModel_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in TR_B_Start_Training.
function TR_B_Start_Training_Callback(hObject, eventdata, handles)
% hObject    handle to TR_B_Start_Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Training_Started,'string','Training Started...');
pause(2);
set(handles.Fetching_images,'string','Fetching Images Information and creating DataSet...');
pause(0.002);
FirstDataSetCreation();
set(handles.Creating_Training_DataSet,'string','Training Model...');
Acc=SecondTrainingPart();
pause(2);
set(handles.Model_Trained,'string','Model Trained...');
pause(4);
set(handles.Calculating_Accuracy_of_Testing_Dataset,'string','Calculating Accuracy of Training DataSet...');
pause(2);
set(handles.TR_Accuracy,'string','ACCURACY  :');
set(handles.TR_Accuracy_VAL,'string',Acc);



% --- Executes on button press in TR_B_Return.
function TR_B_Return_Callback(hObject, eventdata, handles)
% hObject    handle to TR_B_Return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(TrainModel_GUI);
