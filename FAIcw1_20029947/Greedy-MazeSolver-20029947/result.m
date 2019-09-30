%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimal path: starting from the last node, backtrack to
% its parent nodes until it reaches the start node
% 04-26-2005    Copyright 2009-2010 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QUEUE_COUNT = size(QUEUE, 1);
xval = QUEUE(QUEUE_COUNT, 2);
yval = QUEUE(QUEUE_COUNT, 3);

temp = QUEUE_COUNT; 

% QUEUE has been updated and it contains optimal path
% use while loop to find the target, "temp > 0" is used to keep safe
while(((xval ~= xTarget + 1) || (yval ~= yTarget)) && temp > 0)
    temp = temp - 1;
    xval = QUEUE(temp, 2);
    yval = QUEUE(temp, 3);
end


if ((xval == xTarget + 1) && (yval == yTarget))
    maze(xval, yval) = 6;
    dispMaze(maze);
end

inode = 0;
% Traverse QUEUE and determine the parent nodes
parent_x = QUEUE(index(QUEUE, xval, yval), 4);
parent_y = QUEUE(index(QUEUE, xval, yval), 5);

while(parent_x ~= xStart || parent_y ~= yStart)
    maze(parent_x, parent_y) = 6;
    dispMaze(maze);
    inode = index(QUEUE, parent_x, parent_y); % find the grandparents
    parent_x = QUEUE(inode, 4);
    parent_y = QUEUE(inode, 5);
end

% % find the index of target point
% index_Target = index(QUEUE, xTarget, yTarget);
% % extract gn of target point from QUEUE which is the total path cost
% QUEUE(index_Target, 6)
% % show the number of discovered nodes
% discovered_nodes = size(QUEUE, 1);
% discovered_nodes
% % select the nodes that has a value of '0' in the first place in QUEUE
% expanded_nodes = 0;
% for i = 1 : QUEUE_COUNT
%     if (QUEUE(i, 1) == 0)
%         expanded_nodes = expanded_nodes + 1;
%     end
% end
% % show the number of expanded nodes
% expanded_nodes
