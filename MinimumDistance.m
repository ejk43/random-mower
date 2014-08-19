function [ min ] = MinimumDistance(line, point)
%MinimumDistance Finds the minimum distance from the point to the line
%                specified by two endpoints
%   line = [ [x1; y1] [x2; y2] ]
%  point = [ x; y]

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

