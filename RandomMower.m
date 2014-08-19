function [Trun, hist_mowed, hist_state] = RandomMower(width)
% RandomMower
% Runs a single random mower simulation using the supplied width
% 
% Input: 
%   Width: width of lawnmower (meters)
% Outputs: 
%   Trun: time of the run (seconds)
%
%
% Copyright (c) 2014 EJ Kreinar
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.


% INITIALIZE TIMING
dt = .1;    %Dt
T = 1000;     % Sim time
Trun = 0;
b = .5;     %Track Width

% INITIAL VALUES for the robot state
x0 = 0;     % Initial x
y0 = 0;     % Initial y
tht0 = 2*pi*rand(1)-pi;   % Initial theta
x_true = [x0; y0; tht0];

% BOUNDARIES... assumes RECTANGULAR field!!
bounds = [ [-5;-5] [-5;5] [5;5] [5;-5] [-5;-5] ];
% bounds = [ [-10;-10] [-10;10] [10;10] [10;-10] [-10;-10] ];
% bounds = [ [-20;-20] [-20;20] [20;20] [20;-20] [-20;-20] ];
bounds_lft = [ bounds(:,1) bounds(:,2) ];
bounds_top = [ bounds(:,2) bounds(:,3) ];
bounds_rgt = [ bounds(:,3) bounds(:,4) ];
bounds_dwn = [ bounds(:,4) bounds(:,5) ];
hit_dist = .06;

% Mapping
cell_width = .05; % 10cm width
w = norm(bounds_top(:,2)-bounds_top(:,1));
h = norm(bounds_rgt(:,2)-bounds_rgt(:,1));
cw = ceil(w/cell_width);
ch = ceil(h/cell_width);
numcells = cw*ch;
grass = zeros(cw,ch);

% Mower Width
% width = .5;
mw_cells = width/cell_width; % mower width in cells
mw = round((mw_cells-1)/2)*2+1; % round to nearest odd number
rloc_last = 0;
cloc_last = 0;
mowed = 0;

% Initialize the history
len = T/dt;
% hist_state = zeros(len+1,3);
% hist_mowed = zeros(len+1,1);
% hist_state(1,:) = x_true;
hist_mowed(1,:) = 0;
hist_state = x_true';

dMow = 50;
i = 0;
imow = 0;
while (mowed < .95) && (i < 10000/dt) % Wait until 95%, or until we run for 10,000 seconds
    i = i+1;
    Trun = Trun + dt;
    
    % Choose values for the new Vr and Vl
    Vr = .5;
    Vl = .5;
    
    % Simulates the motion here- save the new state
    x_true = SimulateMotion(Vr,Vl,x_true,b,dt);
%     hist_state(i+1,:) = x_true;
    
    % Check if collided with a boundary
    d_lft = MinimumDistance(bounds_lft,x_true(1:2,1));
    d_top = MinimumDistance(bounds_top,x_true(1:2,1));
    d_rgt = MinimumDistance(bounds_rgt,x_true(1:2,1));
    d_dwn = MinimumDistance(bounds_dwn,x_true(1:2,1));
    
    % Change the angle if we collided with a boundary
    if (d_lft < hit_dist)
        hit = 1;
        x_true(3) = (pi-pi/90)*rand-(pi/2-pi/180);
        hist_state = [hist_state; x_true'];
    end
    if (d_top < hit_dist)
        hit = 1;
        x_true(3) = (pi-pi/90)*rand-(pi-pi/180);
        hist_state = [hist_state; x_true'];
    end
    if (d_rgt < hit_dist)
        hit = 1;
        x_true(3) = (pi-pi/90)*rand+(pi/2-pi/180);
        hist_state = [hist_state; x_true'];
    end
    if (d_dwn < hit_dist)
        hit = 1;
        x_true(3) = (pi-pi/90)*rand+(pi/180);
        hist_state = [hist_state; x_true'];
    end
    
    % Set the deck thingy shadow
    rloc = round((x_true(1,1)-bounds(1,1))/cell_width);
    cloc = round((x_true(2,1)-bounds(2,1))/cell_width);
    if (rloc ~= rloc_last) && (cloc ~= cloc_last)
        for r=1:mw
            for c=1:mw
                rr = rloc - floor(mw/2) + r - 1;
                cc = cloc - floor(mw/2) + c - 1;
                if (rr > 0) && (cc > 0) && (rr <= ch) && (cc <= ch)
                    grass(rr,cc) = grass(rr,cc) || 1;
                end
            end
        end
    end
    rloc_last = rloc;
    cloc_last = cloc;
    
    if mod(i,dMow) == 0 %% Store the percent mowed every 5 seconds
        imow = imow + 1;
        mowed = sum(sum(grass))/numcells;
        hist_mowed(imow+1,:) = mowed;
    end
end


%% Plots
% close all
figure(1)
clf; hold on;
plot(hist_state(:,1),hist_state(:,2),'b','LineWidth',2)
plot(bounds(1,:),bounds(2,:),'r','LineWidth',3)
title('True Path (blue)');
xlabel('x')
ylabel('y');

figure(2)
plot(0:dMow*dt:(length(hist_mowed)-1)*dt*dMow,hist_mowed(:,1));
title('Percentage of Area Mowed Over Time');
xlabel('Time (s)')
