function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 25-May-2013 23:18:51

% Begin initialization code - DO NOT EDIT

%%
clc
%clear all
%close all

addpath(genpath('.\网络生成'));
addpath(genpath('.\测度程序'));
%%

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
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rule_net.
function rule_net_Callback(hObject, eventdata, handles)
% hObject    handle to rule_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.net=1;  %标记选择了规则网络
set(handles.Node_N,'String','');
set(handles.Node_K,'String','');
set(handles.Node_p,'String','');
set(handles.A,'String','');
set(handles.input_N,'String','请输入网络节点数N：');
set(handles.input_K,'String','请输入与节点左右相邻的K/2的节点数：');
set(handles.input_p,'String','不用输入：');
set(handles.input_A,'String','不用输入');
guidata(hObject, handles);

% --- Executes on button press in ws_net.
function ws_net_Callback(hObject, eventdata, handles)
% hObject    handle to ws_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.net=2;       %标记选择了小世界网络
set(handles.Node_N,'String','');
set(handles.Node_K,'String','');
set(handles.Node_p,'String','');
set(handles.A,'String','');
set(handles.input_N,'String','请输入网络节点数N：');
set(handles.input_K,'String','请输入与节点左右相邻的K/2的节点数:：');
set(handles.input_p,'String','请输入随机重连的概率p：');
set(handles.input_A,'String','不用输入');
guidata(hObject, handles);

% --- Executes on button press in sto_net.
function sto_net_Callback(hObject, eventdata, handles)
% hObject    handle to sto_net (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.net=3;       %标记选择了随机网络
set(handles.Node_N,'String','');
set(handles.Node_K,'String','');
set(handles.Node_p,'String','');
set(handles.A,'String','');
set(handles.input_N,'String','请输入网络节点数N：');
set(handles.input_K,'String','请输入最终链接数 M<=N((N-1)/2)：');
set(handles.input_p,'String','不用输入：');
set(handles.input_A,'String','不用输入');
guidata(hObject, handles);

% --- Executes on button press in input_know.
function input_know_Callback(hObject, eventdata, handles)
% hObject    handle to input_know (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.net=4;       %标记选择了随机网络
set(handles.Node_N,'String','');
set(handles.Node_K,'String','');
set(handles.Node_p,'String','');
set(handles.A,'String','');
set(handles.input_N,'String','不用输入');
set(handles.input_K,'String','不用输入');
set(handles.input_p,'String','不用输入');
set(handles.input_A,'String','请输入邻接矩阵A');
guidata(hObject, handles);

function Node_N_Callback(hObject, eventdata, handles)
% hObject    handle to Node_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Node_N as text
%        str2double(get(hObject,'String')) returns contents of Node_N as a double

%以字符串的形式来存储数据文本框1的内容. 如果字符串不是数字，
input = str2num(get(hObject,'String'));
%检查输入是否为空. 如果为空,则默认显示为0
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Node_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Node_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Node_K_Callback(hObject, eventdata, handles)
% hObject    handle to Node_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Node_K as text
%        str2double(get(hObject,'String')) returns contents of Node_K as a double

%以字符串的形式来存储数据文本框1的内容. 如果字符串不是数字，
input = str2num(get(hObject,'String'));
%检查输入是否为空. 如果为空,则默认显示为0
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Node_K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Node_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Node_p_Callback(hObject, eventdata, handles)
% hObject    handle to Node_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Node_p as text
%        str2double(get(hObject,'String')) returns contents of Node_p as a double

%以字符串的形式来存储数据文本框1的内容. 如果字符串不是数字，
input = str2num(get(hObject,'String'));
%检查输入是否为空. 如果为空,则默认显示为0
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Node_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Node_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function A_Callback(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A as text
%        str2double(get(hObject,'String')) returns contents of A as a double
%以字符串的形式来存储数据文本框1的内容. 如果字符串不是数字，
input = str2num(get(hObject,'String'));
%检查输入是否为空. 如果为空,则默认显示为0
if (isempty(input))
     set(hObject,'String','0')
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function aver_D_Callback(hObject, eventdata, handles)
% hObject    handle to aver_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aver_D as text
%        str2double(get(hObject,'String')) returns contents of aver_D as a double


% --- Executes during object creation, after setting all properties.
function aver_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aver_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N = get(handles.Node_N,'String');
N=str2num(N);
K = get(handles.Node_K,'String');
K=str2num(K);

if handles.net==1
    A=rule_net(N,K,handles);                            %产生规则网络
elseif handles.net==2
    p = get(handles.Node_p,'String');
    p=str2num(p);
    A=ws_net(N,K,p,handles);                            %产生小世界网络
elseif handles.net==3
    A=sto_net(N,K,handles);                             %产生随机网络
elseif handles.net==4
    A=str2num(get(handles.A,'String'));
    N=size(A,1);
    plot_net(N,A,handles);
end


[aver_path,d]=Aver_Path_Length(A);     %计算平均路径长度和直径
[C,aver_C,max_C,min_C]=Clustering(A); %计算聚类系数
[E_ND,Entropy_net]=Entropy(A);            %计算网络的熵
[ND,aver_ND,N_ND]=Node_Degree(A,handles);     %求网络的平均度和度分布图
set(handles.d,'String',d);
set(handles.C,'String',min_C);
set(handles.Entropy,'String',Entropy_net);
set(handles.aver_ND,'String',aver_ND);

set(handles.aver_D,'String',aver_path);
guidata(hObject, handles);
