function varargout = main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

function main_OpeningFcn(hObject, eventdata, handles, varargin)
%Bien toan cuc: data
global data;
%LOGO
logo = imread('Envo/logo.jpg');
axes(handles.LOGO);
imshow(logo);

%Var kiem tra: boolean data.check
data.check=0;

%Var bao bieu: table STT, Ngày, Thoi Gian, BSX
data.TD={'STT','Ngày','Thoi Gian','BSX'};

%Var dem: count
data.count=1;

%Nap du lieu data.mat [a char dirname number]
load data.mat

handles.numbers=numbers;
clear chars numbers
%Webcam
handles.output = hObject;
%Phát hien nguoi di xe máy
set(handles.figure1,'Name','detecting motorbike riders');
camera_ID=imaqhwinfo('winvideo','DeviceIDs');
set(handles.camera,'string',['Camera';camera_ID]);
set(handles.init_button,'enable','off');
%set(handles.preview_button,'enable','off');

set(handles.run_button,'enable','off');
handles.tren=cell(1,8);
handles.duoi=cell(1,8);
handles.tren{1}=handles.ax4t1;
handles.tren{2}=handles.ax4t2;
handles.tren{3}=handles.ax4char;
handles.tren{4}=handles.ax4t4;

handles.duoi{1}=handles.ax4d1;
handles.duoi{2}=handles.ax4d2;
handles.duoi{3}=handles.ax4d3;
handles.duoi{4}=handles.ax4d4;
handles.duoi{5}=handles.ax4d5;

handles.timer1=timer('TimerFcn',{@timer1_function,hObject,handles},...
    'Period',0.01,'ExecutionMode','FixedRate');

%Tiêu de
set(handles.figure1,'Name','Chu de 16: Nhan dien bien so xe gan may');
handles.result={};
handles.count=0;
guidata(hObject, handles);

function text10_CreateFcn(hObject, eventdata, handles)
function text5_CreateFcn(hObject, eventdata, handles)

function main_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function init_button_CreateFcn(hObject, eventdata, handles)
%video
function close_button_Callback(hObject, eventdata, handles)
global vid;
if ~isempty(vid)&& strcmp('on',get(vid,'Running'))
    stop(vid);
end
close;
%video
function camera_Callback(hObject, eventdata, handles)
global ID;
ID=get(hObject,'Value');
if ID==1
    errordlg('Vui lòng chon so');
else
    ID=ID-1;
    set(handles.init_button,'enable','on');
end

function camera_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%video
function preview_button_Callback(hObject, eventdata, handles)
global vid;
preview(vid);
set(handles.clear_button,'enable','on');
%video%video
function init_button_Callback(hObject, eventdata, handles)
stop(handles.timer1);
global ID;
global vid;
global data
vid=videoinput('winvideo',ID,'YUY2_640x480','returnedcolorspace','rgb');
vid.TriggerRepeat = Inf;
triggerconfig(vid, 'manual');
set(vid,'Framespertrigger',1);
start(vid);
set(handles.run_button,'enable','on');
start(handles.timer1);
data.check=1;
%video
function clear_button_Callback(hObject, eventdata, handles)
global vid;
stop(vid);
set(handles.init_button,'enable','off');
set(handles.camera,'enable','on');

%% 1c
function btn_openword_Callback(hObject, eventdata, handles)
winopen('Data/Word/Topic16.docx');

function off_line__Callback(hObject, eventdata, handles)
global data
if strcmp('on',get(handles.timer1,'Running'))
    stop(handles.timer1);
    data.check=1;
end
set(hObject,'Enable','off');
pause(0.25);
%Vùng tr?ng khi Click vào button
%Muc dich, tranh truong hop chay bien so 5 chu so, sau do chay l?i bien so
%4 chu so se b? loi o chu so thu 5
for i=1:8
    set(gcf,'CurrentAxes',handles.tren{i});
    imshow(ones(90,40));
    set(gcf,'CurrentAxes',handles.duoi{i});
    imshow(ones(90,40));
end
set(gcf,'CurrentAxes',handles.ax2);
imshow(ones(90,40))
oldFolder=cd;
% if exist('a.mat','file')
%     load a.mat %link 'E:/23.MatlabWork/Report/BaoCaoBTLon/Topic16/Real/Topic16Plate/Pics'
%     [fName, dirName] = uigetfile({'*.bmp;*.tif;*.jpg;*.tiff;*.png'},'Chon Anh',dirName);
% else
%     [fName, dirName] = uigetfile('*.bmp;*.tif;*.jpg;*.tiff;*.png');
% end
% if dirName~=0
%     save('a.mat','dirName');
% end
% if fName
%     %cd: vao thu muc
%     cd(dirName);
%     data.rgb=imread(fName);
%     cd(oldFolder);
%     set(gcf,'CurrentAxes',handles.Original);
%     imshow(data.rgb);
% end
%% 1a
[filename, path] = uigetfile({'*.png;*.jpg'}, 'Image');
full_path = strcat(path,filename); 

data.rgb = imread(full_path);
axes(handles.Original);
imshow(data.rgb);

%% Bat loi
try
    xu_ly(hObject,eventdata,handles);
catch e
    errordlg(e.message);
end
set(hObject,'enable','on');
if data.check==1
    start(handles.timer1);
end
guidata(hObject,handles);

%% Bai Lam
function xu_ly(hObject,eventdata,handles)
load data.mat;
global data;
thresh_bw = get(handles.thresh_bw,'string');
thresh_bw = str2num(thresh_bw);
%Nen trang: White Background 
% %Chay bien so trên
% for i=1:8
%     set(gcf,'CurrentAxes',handles.tren{i});
%     imshow(ones(90,40));
% end
% 
% %Chay bien so duoi
% for j =1:8
%     set(gcf,'CurrentAxes',handles.duoi{i});
%     imshow(ones(90,40));
% end

%Chay ca tren duoi
% for i=1:8
%     set(gcf,'CurrentAxes',handles.tren{i});
%     imshow(ones(90,40));
%     set(gcf,'CurrentAxes',handles.duoi{i});
%     imshow(ones(90,40));
% end

%Chuyen ve anh nhi phan
% %% 1b
% thresh_bw = get(handles.thresh_bw,'string');
% thresh_bw = str2num(thresh_bw);
binIma = im2bw(data.rgb,thresh_bw);
axes(handles.ax1b);
imshow(binIma);
% binImg = thuxem(data.rgb);
% axes(handles.ax1b);
% imshow(binImg);

%% 2
axes(handles.ax2);
imshow(imread('Envo/Srouce/wait.jpg'));
pause(0.15);

%Lay chieu dai cua anh (r)
[r,rac_ruoi]=size(data.rgb);
if r>680
    a=imresize(binIma,[680 NaN]); %NaN: Tu dong tinh toan cot (Dong dang)
end
%%---------------------------
%function inputanh cat anh
Image=inputanh(data.rgb);
%%---------------------------
% set(gcf,'CurrentAxes',handles.ax2);

axes(handles.ax2);
imshow(im2bw(Image,thresh_bw));

%% 3
%function angle xoay anh
%Xoay anh bang phuong phap HOUGH TRANSFROM

axes(handles.ax3);
imshow(imread('Envo/Srouce/wait.jpg'));
pause(0.15);

Image_Xoay=houghangle(Image);
axes(handles.ax3);
imshow(im2bw(Image_Xoay,thresh_bw));

%% 4
%phan loai
[tren, duoi]=separation(Image_Xoay);
n1=length(tren);
if n1>0
    S1='';
for i=1:n1
    set(gcf,'CurrentAxes',handles.tren{i});
    tren{i}=imresize(tren{i},[90,40]);
    %dong dau: {1}{2} - {3} {4}
    %{1}{2}: so
    %{3}: chu
    %{4}: so
    switch i
        case 1
            x=my_num_recog(tren{i},numbers);
            S1=cat(2,S1,x);
        case 2
            x=my_num_recog(tren{i},numbers);
            S1=cat(2,S1,x);
        case 3
            x=my_num_recog(tren{i},chars);
            S1=cat(2,S1,x);
        case 4
            x=my_num_recog(tren{i},numbers);
            S1=cat(2,S1,x);
    end
    imshow(tren{i});
end
end
n2=length(duoi);
if n2>0
    S2='';
    for i=1:n2
        set(gcf,'CurrentAxes',handles.duoi{i});
        duoi{i}=imresize(duoi{i},[90,40]);
        x=my_num_recog(duoi{i},numbers);
        S2=cat(2,S2,x);
        imshow(duoi{i});
    end

end
set(handles.text5,'string',sprintf('%s-%s',S1,S2));
data.count=data.count+1;
a=clock;
s1=sprintf('%d - %d - %d',a(3),a(2),a(1));
s2=sprintf('%d:%d:%d',a(4),a(5),round(a(6)));
data.TD{data.count,1}=num2str(data.count-1);
data.TD{data.count,2}=s1;
data.TD{data.count,3}=s2;
data.TD{data.count,4}=sprintf('%s-%s',S1,S2);
set(handles.uitable1,'Data',data.TD);
pause(0.25);

function get_camera_Callback(hObject, eventdata, handles)
global vid
if get(hObject,'value')
    if ~isempty(vid)&& strcmp('on',get(vid,'Running'))
        set(handles.run_button,'enable','on');
        set(handles.off_line_,'enable','off');
        set(handles.analysic_button,'enable','off');
        set(handles.radiobutton1,'value',0);
    else
        errordlg('Camera chua san sang, chon lai camera!');
        set(hObject,'value',0);
    end
else
    set(handles.run_button,'enable','off');
    set(handles.off_line_,'enable','on');
    set(handles.analysic_button,'enable','on')
end

%% Xem Video
function run_button_Callback(hObject, eventdata, handles)
global data;
global vid
stop(handles.timer1);
trigger(vid);
data.rgb=getdata(vid);
try
    xu_ly(hObject,eventdata,handles);
catch e
    errordlg(e.message);
    start(handles.timer1);
end
start(handles.timer1);
%% input anh
function edit18_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit21_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_button_Callback(hObject, eventdata, handles)
s=get(handles.name_edit,'string');
s=sprintf('%s.xls',s);
xlswrite(s,handles.result);
set(handles.open_button,'enable','on');

function c1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y = my_num_recog(bw,numbers)
n1=length(numbers);
s1=zeros(1,n1);
for i=1:n1
    tem1=abs(numbers{i,1}-bw);
    tem2=sum(sum(tem1));
    s1(i)=tem2;
end
x=s1==min(s1);
y=numbers{x,2}(1);
        
function y = my_char_recog(bw,chars)
n1=length(chars);
s1=zeros(1,n1);
for i=1:n1
    tem1=abs(chars{i,1}-bw);
    tem2=sum(sum(tem1));
    s1(i)=tem2;
end
x=s1==min(s1);
y=chars{x,2}(1);

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);

function figure1_DeleteFcn(hObject, eventdata, handles)
global vid;
if ~isempty(vid)&& strcmp('on',get(vid,'Running'))
    stop(vid);
end

function time_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% 
function timer1_function(obj,event,hObject,handles,varargin)
global vid
trigger(vid);
im=getdata(vid);
im=imresize(im,0.5);
imshow(im,'Parent',handles.Original);

function recognize_button_Callback(hObject, eventdata, handles)
X='';
for i=1:length(handles.digits1)
   x=my_num_recog(handles.digits1{i},handles.numbers,handles.chars,1);
   X=cat(2,X,x);
end
Y='';
for i=1:length(handles.digits2)
   y=my_num_recog(handles.digits2{i},handles.numbers,handles.chars,2);
   Y=cat(2,Y,y);
end
s=sprintf('%s - %s',X,Y);
handles.count=handles.count+1;
handles.result{handles.count,1}=s;
set(handles.text5,'string',s);
set(handles.save_button,'enable','on');

guidata(hObject,handles);

function name_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function open_button_Callback(hObject, eventdata, handles)
s=get(handles.name_edit,'string');
s=sprintf('%s.xls',s);
try
    winopen(s); % mo file
catch e
    errdlg(e.message);
end

function pushbutton39_Callback(hObject, eventdata, handles)
global data;
set(hObject,'Enable','off');
pause(0.25);
xlswrite('Data/Excel/data.xls',data.TD);
winopen('Data/Excel/data.xls');
set(hObject,'Enable','off');

function pushbutton40_Callback(hObject, eventdata, handles)
stop(handles.timer1);
global ID;
global vid;
global data
vid=videoinput('winvideo',ID,'YUY2_640x480','returnedcolorspace','rgb');
vid.TriggerRepeat = Inf;
triggerconfig(vid, 'manual');
set(vid,'Framespertrigger',1);
start(vid);
set(handles.run_button,'enable','on');
start(handles.timer1);
data.check=1;

function ax4t1_ButtonDownFcn(hObject, eventdata, handles)
axis off
function ax4t2_ButtonDownFcn(hObject, eventdata, handles)
axis off
function ax4d1_ButtonDownFcn(hObject, eventdata, handles)
axis off

function uitable1_CreateFcn(hObject, eventdata, handles)
function uitable1_DeleteFcn(hObject, eventdata, handles)
function text1_CreateFcn(hObject, eventdata, handles)
function Original_CreateFcn(hObject, eventdata, handles)
axis offv
function Original_DeleteFcn(hObject, eventdata, handles)
axis off

function uipanel1_CreateFcn(hObject, eventdata, handles)

function ax4t1_CreateFcn(hObject, eventdata, handles)
axis off

function ax4t2_CreateFcn(hObject, eventdata, handles)
axis off

function ax4char_CreateFcn(hObject, eventdata, handles)
axis off

function ax4t4_CreateFcn(hObject, eventdata, handles)
axis off

function ax4d1_CreateFcn(hObject, eventdata, handles)
axis off

function ax4d2_CreateFcn(hObject, eventdata, handles)
axis off
function ax4d3_CreateFcn(hObject, eventdata, handles)
axis off

function ax4d4_CreateFcn(hObject, eventdata, handles)
axis off

function ax4d5_CreateFcn(hObject, eventdata, handles)
axis off

function ax2_CreateFcn(hObject, eventdata, handles)
axis off

function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton43_Callback(hObject, eventdata, handles)
clear camObject;

% --- Executes on mouse press over axes background.
function Original_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function thresh_bw_Callback(hObject, eventdata, handles)
% hObject    handle to thresh_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh_bw as text
%        str2double(get(hObject,'String')) returns contents of thresh_bw as a double


% --- Executes during object creation, after setting all properties.
function thresh_bw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in R.
function R_Callback(hObject, eventdata, handles)
    xu_ly(hObject,eventdata,handles);


% --- Executes on key press with focus on thresh_bw and none of its controls.
function thresh_bw_KeyPressFcn(hObject, eventdata, handles)
currChar = get(handles.figure1,'CurrentCharacter');
   if isequal(currChar,char(13)) %char(13) == enter key
       R_Callback(hObject, eventdata, handles)
   end
