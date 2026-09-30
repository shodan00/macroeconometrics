%Data load 
%clear all
%close all

addpath('./Lp_function/');
addpath('./Var_function/');
addpath('./Plot_function/');

file  = "Data/Data_FRED.xlsx";
sheet = "quarterly";

T = readtable(file,"Sheet",sheet,"PreserveVariableNames",true);

T.observation_date = datetime(T.observation_date,"InputFormat","yyyy-MM-dd");

% if values are like "9,835" (thousands separators)
T.OUTNFB  = str2double(erase(string(T.OUTNFB),","));
T.HOANBS  = str2double(erase(string(T.HOANBS),","));
T.CNP16OV = str2double(erase(string(T.CNP16OV),","));

% keep only 1948-01-01 ... 2025-07-01 (inclusive)
mask = T.observation_date >= datetime("1948-01-01") & ...
       T.observation_date <= datetime("2025-07-01");
T = T(mask,:);

OUTNFB  = T(:,["observation_date","OUTNFB"]);
HOANBS  = T(:,["observation_date","HOANBS"]);
CNP16OV = T(:,["observation_date","CNP16OV"]);


OUTNFB = OUTNFB{:,2};
HOANBS = HOANBS{:,2};
CNP160V_filtered = CNP16OV{:,2};


yt = log( OUTNFB ./ HOANBS );
ht = log( HOANBS ./ CNP160V_filtered );

delta_yt = diff(yt);
delta_ht = diff(ht);

