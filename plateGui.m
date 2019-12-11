function varargout = plateGui(varargin)
% PLATEGUI MATLAB code for plateGui.fig
%      PLATEGUI, by itself, creates a new PLATEGUI or raises the existing
%      singleton*.
%
%      H = PLATEGUI returns the handle to a new PLATEGUI or the handle to
%      the existing singleton*.
%
%      PLATEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLATEGUI.M with the given input arguments.
%
%      PLATEGUI('Property','Value',...) creates a new PLATEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plateGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plateGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plateGui

% Last Modified by GUIDE v2.5 11-Dec-2019 23:40:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plateGui_OpeningFcn, ...
                   'gui_OutputFcn',  @plateGui_OutputFcn, ...
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


% --- Executes just before plateGui is made visible.
function plateGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plateGui (see VARARGIN)

% Choose default command line output for plateGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plateGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plateGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image; %declare globally to use by other events
[Filename , Pathname] = uigetfile({'*.jpg';'*.png';'*.bmp'},'File Selector'); %selector to select the image from file manager
image = imread([Pathname , Filename]); %read the selected image

axes(handles.axes1); %set the axis 1 to show the image to user
imshow(image); % command to show the image


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image; %get the global variable 

grayImage = rgb2gray(image) %covert the above image to gray
axes(handles.axes2); % set it on sxis 2 and show the image on the screen
imshow(grayImage);

imbin = imbinarize(grayImage); %binarise the the gray image for the threshold value
axes(handles.axes3);% set it on axis 3
imshow(imbin)

im = edge(grayImage, 'prewitt'); % use edge horizonatal edge detecttion to detect the edges
axes(handles.axes4); % set it on axis 4
imshow(im)

%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');

area = Iprops.Area;
counter = numel(Iprops); %get no of element from the area and set the counter for the loops

max= area; %set as a flag

boundingBox = Iprops.BoundingBox; %set the bounding box

for i=1:counter %loop upto counter
   if max<Iprops(i).Area
       max=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end 

im = imcrop(imbin, boundingBox);%crop the number plate area
im = bwareaopen(~im, 500); %remove some object if it width is too long or too small than 500
axes(handles.axes5);

[h, w] = size(im);%get width
imshow(im); %show the number plate image

%now cut different letters
Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
counter = numel(Iprops);
noPlate=[]; % Initializing the variable of number plate string.

for i=1:counter
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       noPlate=[noPlate letter] % Appending every subsequent character in noPlate variable.
       set(handles.text8,'String' ,noPlate) % give us the array of string of the number plate and show it as the static text on screen
   end
end
