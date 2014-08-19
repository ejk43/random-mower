function [ min ] = MinimumDistance(line, point)
%MinimumDistance Finds the minimum distance from the point to the line
%                specified by two endpoints
%   line = [ [x1; y1] [x2; y2] ]
%  point = [ x; y]
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


v = line(:,1);
w = line(:,2);
p = point;

line_len = norm(w-v);   % Check the distance of the line
if line_len == 0
    min = norm(p-v);    % v == w case, return distance from p to v
    return   
end

dist = dot(p-v,w-v)/line_len; % Find the magnitude of the projection

if dist < 0.0           % If < 0
    min = norm(p-v);   % Use the distance to v
    return
end
if dist > line_len      % If > line_len
    min = norm(p-w);   % Use the distance to w
    return
end

% Find the point on the line that is perpendicular to p
% start at v, add dist * unit_vector
p2 = v + dist*(w-v)/line_len; 
min = norm(p-p2);
return
end

