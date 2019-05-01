clc

%%  CREATING A TEMPERATURE MAP FROM DATA CONTAINED IN MULTIPLE.CSV FILES 
% =========================================================================
% This program creates a coloured temperature plot of a grid (specified as
% 300 by 300 elements) using the data contained in multiple .csv files.
% The .csv files were created in a specific format. The section titled
% 'Organise the data from each robot' must be edited to extract the correct
% data if this format changes. 
%
% The built in pcolor function is used - this requires a matrix with every
% element containing a value. Starting with a matrix of zeros, each 
% temperature point from the .csv is put into its position in the matrix. 
% The leftover zeros (i.e. unobtained temp values) are replaced with NaNs 
% and the externally downloaded function 'inpaint_nans' is used to 
% interpolate the temperature values, creating a complete map. 
%
% The function was written by John D'Errico and can be found at:
%
% https://uk.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans


%% ------------- READING CSV FILE AND EXTRACTING COLUMNS ------------------

% Number of robots mapping
num_robots = 2; 

% Number of files collected so far
num_files = 0; 

% Have we got these files yet?
got1 = "False"; got2 = "False"; got3 = "False"; 

% Check to see whether the files exist yet. Change the file names
% if required. 

while num_files < num_robots 

    if exist('temp_data_0_device_2.csv','file') == 2 && got1 == "False"   
        robot1file = 'temp_data_0_device_2.csv'; 
        M1 = readtable(robot1file); 
        M1 = table2array(M1);
        num_files = num_files + 1;
        got1 = "True";
    end

    if exist('temp_data_0_device_3.csv','file') == 2 && got2 == "False" && num_robots > 1
        robot2file = 'temp_data_0_device_3.csv';
        M2 = readtable(robot2file);
        M2 = table2array(M2);
        num_files = num_files + 1;
        got2 = "True";
    end
    
    if exist('temp_data_0_device_3.csv','file') == 2 && got2 == "False" && num_robots > 2
        robot3file = 'temp_data_0_device_3.csv';
        M3 = readtable(robot3file);
        M3 = table2array(M3);
        num_files = num_files + 1;
        got3 = "True";
    end
        
    % Check for files again after 10 seconds
    if num_files < num_robots 
        pause('on')
        pause(10)  
    end
    
end

% Organise the data from each robot
%----------------------------------

t1 = transpose(M1(:,5));
x1 = transpose(M1(:,6));           
y1 = transpose(M1(:,7));

if num_robots == 2
    t2 = round(transpose(M2(:,5)));
    x2 = transpose(M2(:,6));            
    y2 = transpose(M2(:,7));
    
    ttotal = [t1,t2];
    xtotal = [x1,x2];
    ytotal = [y1,y2];

elseif num_robots == 3
    t2 = round(transpose(M2(:,5)));
    x2 = transpose(M2(:,6));            
    y2 = transpose(M2(:,7));
    
    t3 = round(transpose(M3(:,5)));
    x3 = transpose(M3(:,6));            
    y3 = transpose(M3(:,7));
    
    ttotal = [t1,t2,t3];
    xtotal = [x1,x2,x3];
    ytotal = [y1,y2,y3];

else
    ttotal = [t1];
    xtotal = [x1];
    ytotal = [y1];
    
end


%% -------------- SETTING UP INPUTS FOR PCOLOR FUNCTION -------------------

[xg,yg] = meshgrid(0:300,0:300);  % Grid coordinates required for pcolor         

z = zeros(301);                   % Full matrix to contain temperatures

% Changing individual matrix elements according to .csv file contents

for i = 1:length(x1)    % For every x coordinate recorded
    a = x1(i);          % Obtain i-th x coordinate
    b = y1(i);          % Obtain i-th y coordinate
    z(b,a) = ttotal(i); % At these coordinates, the temperature is t
end

z(z==0) = NaN;          % Ignore unobtained temp values
T = inpaint_nans(z);    % External function downloaded to interpolate NaNs


%% ---------------------------- PLOTTING ----------------------------------

% Temperature map function must know how many points each robot recorded

if num_robots == 1
    num_points = [length(x1),0,0];
elseif num_robots == 2
    num_points = [length(x1),length(x2),0];
elseif num_robots == 3
    num_points = [length(x1),length(x2),length(x3)];
end
    
% Call the function tempmap.m to produce the temperature map
% T must be the correct sized matrix with every element filled

tempmap(xg,yg,T,xtotal,ytotal,num_points,num_robots)  



%% --------------------------- Key Data -----------------------------------

% Number of points collected
num_points = length(xtotal);

% Temperature range recorded
max_temp = max(ttotal);
min_temp = min(ttotal);
temp_range = max_temp - min_temp;



