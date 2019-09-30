function [] = DFSMazeSolver(maze)
%% based on A-Star algorithm, greedy algorithm and relevant files
%% initialization
% get the size of the square maze
[MAX_X, MAX_Y] = size(maze);
% OBSTACLE: the matrix of OBSTACLE [x, y] that the node cannot go
OBSTACLE = [];
OBST_COUNT = 1;

% traversing the map and store coordinates of OBSTACLE, start node and end
for x = 1 : MAX_X
    for y = 1 : MAX_Y
        if(maze(x, y) == 3) % check if it is the start node
            xStart = x; % store the coordinate
            yStart = y;
        elseif(maze(x, y) == 4) % check if it is the end node
            xTarget = x; % store the coordinate
            yTarget = y;
        elseif(maze(x, y) ~= 1) % check if it is the path
            OBSTACLE(OBST_COUNT, 1) = x; % store the coordinate of OBSTACLE
            OBSTACLE(OBST_COUNT, 2) = y;
            OBST_COUNT = OBST_COUNT + 1;
        end
    end
end
% add one more edge which is the starting node into the OBSTACLE matrix, at the end of the matrix
OBST_COUNT = size(OBSTACLE, 1);
OBST_COUNT = OBST_COUNT + 1;
OBSTACLE(OBST_COUNT, :) = [xStart, yStart];

% add the start node as the first node (root node) in QUEUE
% QUEUE: [0/1, X val, Y val, Parent X val, Parent Y val, g(n)]
xNode = xStart;
yNode = yStart;
QUEUE = [];
QUEUE_COUNT = 1;
path_cost = 0; % cost g(n): from start node to the the current node n
QUEUE(QUEUE_COUNT, :) = insert(xNode, yNode, xStart, yStart, path_cost);
QUEUE(QUEUE_COUNT, 1) = 0; % 0 stands for a visited node and 1 stands for a unvisited node
QUEUE_COUNT = QUEUE_COUNT + 1;
% the list "NODES" is used to record coordinates of node when it has more than one child node
NODES = []; % initialization
NODES_COUNT = 1;
NODES(:, NODES_COUNT) = [xStart - 1, yStart]; % store the coordinate of the first node
NODES_COUNT = NODES_COUNT + 1;

%% Start the search
while ((xNode ~= xTarget || yNode ~= yTarget) && numel(NODES) > 0)
    % expand the current node to get the direction
    direction = expand(xNode, yNode, OBSTACLE, MAX_X, MAX_Y);
    % traverse the QUEUE to check if the expanded node has benn visited
    if (any(direction) == 0)
        % there is no way to go
        if (xNode == NODES(1, end) && yNode == NODES(2, end))
            % Remove the last node because all positions are exhausted
            NODES = NODES (:, 1 : end - 1);
            NODES_COUNT = NODES_COUNT - 1;  % update the number of NODES
            xNode = NODES(1, end); % return back to the last inflection node
            yNode = NODES(2, end);
        else
            xNode = NODES(1, end);
            yNode = NODES(2, end);
        end
    % there is(are) way(s) to go
    else
        if(sum(direction) > 1)
            % there are two or three directions to go, the current node is an inflection node
            NODES(1, NODES_COUNT) = xNode; % record this node
            NODES(2, NODES_COUNT) = yNode;
            NODES_COUNT = NODES_COUNT + 1;
        end
        [addx, addy] = randmove(direction); % get the movement of position, not the coordinate
        index_parent_node = index(QUEUE, xNode, yNode); % the cost of parent node
        QUEUE(QUEUE_COUNT, :) = insert(xNode + addx, yNode + addy, xNode, yNode, QUEUE(index_parent_node, 6) + 1);
        QUEUE_COUNT = QUEUE_COUNT + 1;
        xNode = xNode + addx; % move 
        yNode = yNode + addy;
        if (xNode == xTarget && yNode == yTarget)
            break;
        end
        OBST_COUNT = OBST_COUNT + 1;
        % update the OBSTACLE matrix because this node has been visited
        % to prevent visit it again
        OBSTACLE(OBST_COUNT, :) = [xNode, yNode]; % add the expanded node into OBSATCLE
        maze(xNode, yNode) = 5;
        dispMaze(maze);
        index_expand = index(QUEUE, xNode, yNode);
        QUEUE(index_expand, 1) = 0;
    end
end

result();





