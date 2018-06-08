function varargout = Apply_DSLR_effect_GUI(varargin)
% APPLY_DSLR_EFFECT_GUI MATLAB code for Apply_DSLR_effect_GUI.fig
%      APPLY_DSLR_EFFECT_GUI, by itself, creates a new APPLY_DSLR_EFFECT_GUI or raises the existing
%      singleton*.
%
%      H = APPLY_DSLR_EFFECT_GUI returns the handle to a new APPLY_DSLR_EFFECT_GUI or the handle to
%      the existing singleton*.
%
%      APPLY_DSLR_EFFECT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APPLY_DSLR_EFFECT_GUI.M with the given input arguments.
%
%      APPLY_DSLR_EFFECT_GUI('Property','Value',...) creates a new APPLY_DSLR_EFFECT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Apply_DSLR_effect_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Apply_DSLR_effect_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Apply_DSLR_effect_GUI

% Last Modified by GUIDE v2.5 12-Oct-2017 12:47:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Apply_DSLR_effect_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Apply_DSLR_effect_GUI_OutputFcn, ...
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


% --- Executes just before Apply_DSLR_effect_GUI is made visible.
function Apply_DSLR_effect_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Apply_DSLR_effect_GUI (see VARARGIN)

% Choose default command line output for Apply_DSLR_effect_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Apply_DSLR_effect_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Apply_DSLR_effect_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DSLR_B_Browse.
function DSLR_B_Browse_Callback(hObject, eventdata, handles)
% hObject    handle to DSLR_B_Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pathname filename;
[filename, pathname]= uigetfile('*.jpg;*.jpeg','Select an Image of your Number Plate');
global iview;
iview=imread(strcat(pathname,filename));
axes(handles.Original_AXES);
imshow(iview);
Main_Func0_If_Delete_Prev_Files();
delete('Data\SRC\*.*');
dimen=size(iview);
    if dimen(1)>1000 || dimen(2)>1000
        iview=imresize(iview,[floor(dimen(1)/3) floor(dimen(2)/3)]);
    end
imwrite(iview,['Data\SRC\abc.jpg']);


% --- Executes on button press in Apply_Effect.
function Apply_Effect_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_Effect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Funcs');
doFrameRemoving = false;
doMAEEval = true;       %Evaluate MAE measure after saliency map calculation
doPRCEval = true;       %Evaluate PR Curves after saliency map calculation

SRC = 'Data/SRC';       %Path of input images
RES = 'Data/Res';       %Path for saving saliency maps
srcSuffix = '.jpg';     %suffix for your input image


if ~exist(RES, 'dir')
    mkdir(RES);
end

files = dir(fullfile(SRC, strcat('*', srcSuffix)));
disp('Code Started .....');

for k=1:length(files)
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
    %% Pre-Processing: Remove Image Frames
    srcImg = imread(fullfile(SRC, srcName));
    
    if doFrameRemoving
        [noFrameImg, frameRecord] = removeframe(srcImg);
        [h, w, chn] = size(noFrameImg);
    else
        noFrameImg = srcImg;
        [h, w, chn] = size(noFrameImg);
        frameRecord = [h, w, 1, h, 1, w];
    end
    
    disp('Please Wait... ');
    
    %% Segment input rgb image into patches (SP/Grid)
    pixNumInSP = 600;                           %pixels in each superpixel
    spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
    
    [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber);
%% Get super-pixel properties
    spNum = size(adjcMatrix, 1);
    meanRgbCol = GetMeanColor(noFrameImg, pixelList);
    
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
    meanPos = GetNormedMeanPos(pixelList, h, w);
    bdIds = GetBndPatchIds(idxImg);
    colDistM = GetDistanceMatrix(meanLabCol);
    posDistM = GetDistanceMatrix(meanPos);
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
    
     %% Saliency Objectness
    [bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
    wCtr = SaliencyObjectness(srcName(1:end-4),h,w,idxImg,pixelList,adjcMatrix,colDistM,clipVal,'010003');
    optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr);
    
    smapName=fullfile(RES, strcat(noSuffixName, '_SObj.png'));
    SaveSaliencyMap(optwCtr, pixelList, frameRecord, smapName, true);  
    
    disp('Image of SObjectness');
   
     %% Geodesic Saliency
    geoDist = GeodesicSaliency(adjcMatrix, bdIds, colDistM, posDistM, clipVal);
    
    smapName=fullfile(RES, strcat(noSuffixName, '_GS.png'));
    SaveSaliencyMap(geoDist, pixelList, frameRecord, smapName, true);
    disp('Image of GS ');
    
     %% Saliency Optimization 
    wCtr = CalWeightedContrast(colDistM, posDistM, bgProb);
    optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr);
    
    smapName=fullfile(RES, strcat(noSuffixName, '_wCtr_Optimized.png'));
    SaveSaliencyMap(optwCtr, pixelList, frameRecord, smapName, true);
    disp('Image of SOpti');

end


disp('Done Creating ALL Images ');

%% to implement 3 types of pics of each image

files = dir(fullfile('Data/Res/*.png'));
pics_name=dir(fullfile('Data/SRC/*.jpg'));

ka=1;
for j=1:length(pics_name)    
    dimen=size(imread(fullfile('Data/Res/',files(ka).name)));
    mid_array=uint8(zeros([dimen(1),dimen(2)]));
    tem=uint8(zeros([dimen(1),dimen(2)]));
    for k=0:2
        t=3;
        tem=floor(imread(fullfile('Data/Res/',files(k+ka).name))/t);
        mid_array=mid_array+tem; 
    end
    ka=ka+k+1;
    imwrite(mid_array,['Data\Proposed\' pics_name(j).name(1:end-4) '.png']);
end

%% smoothen the image

pro_name=dir(fullfile('Data/Proposed/*.png'));
global iview;
for j=1:length(pro_name)  
    tem=imread(fullfile('Data/Proposed/',pro_name(j).name));
    figure,imshow(tem);
    H = fspecial('disk',6.5);	
    smoothen = imfilter(tem,H,'replicate');
    imwrite(smoothen,['Data\Proposed\' pro_name(j).name(1:end-4) '.png']);
    
    Ori=imread(fullfile('Data/SRC/',pics_name(j).name));
    DSLRimage = DSLR_ImageOutput(Ori,smoothen);
    axes(handles.DSLR_AXES);
    imshow(DSLRimage);
    figure,imshow(DSLRimage);
end
