function [ statenew ] = SimulateMotion( Vr, Vl, state, b, dt)
%SIMULATEMOTION simulates the motion of a differential drive robot
%   Given Vl, Vr, and the old state, this simulates the differential drive
%   mobile robot. 
%   Vr- Velocity of right wheel, m/s
%   Vl- Velocity of left wheel, m/s
%   state- (xold; yold; thtold) in (m, m, rad). Old state of robot
%   b- track width, m
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

xold = state(1,1);
yold = state(2,1);
thtold = state(3,1);

if abs(Vr-Vl) < 1e-6
    % Motion if w = 0
    xnew = xold + (Vr+Vl)/2*cos(thtold)*dt;
    ynew = yold + (Vr+Vl)/2*sin(thtold)*dt;
    thtnew = thtold;
else
    % Motion if w ~= 0
    xnew = xold + b*(Vr+Vl)/(2*(Vr-Vl))*(sin((Vr-Vl)*dt/b+thtold)-sin(thtold));
    ynew = yold - b*(Vr+Vl)/(2*(Vr-Vl))*(cos((Vr-Vl)*dt/b+thtold)-cos(thtold));
    thtnew = thtold + (Vr-Vl)/b*dt;
end

% % % % Wrap angles 0-2pi
% % % thtnew = mod(thtnew,2*pi);
% Wrap angles -pi to pi
thtnew = CoerceAngle(thtnew);

statenew = [xnew; ynew; thtnew];

end

