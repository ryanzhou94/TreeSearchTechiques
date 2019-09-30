function [] = AStarMazeSolver(maze)
%% based on A_Star.m and other relevant files
%% initialization
% get the size of the square maze
[MAX_X, MAX_Y] = size(maze);
% OBSTACLE: the matrix of OBSTACLE [x, y] that the node cannot go
OBSTACLE = [];
OBST_COUNT = 1;

% traversing the map and store coordinates of OBSTACLE, start node and target
for x = 1 : MAX_X
    for y = 1 : MAX_Y
        if(maze(x, y) == 3) % check if it is the start node
            xStart = x; % store the coordinate
            yStart = y;
        elseif(maze(x, y) == 4) % check if it is the end node
            xTarget = x; % store the coordinate
            yTarget = y;
        elseif(maze(x, y) ~= 1) % check if it is the path
            OBSTACLE(OBST_COUNT, 1) = x; % store the coordinates of OBSTACLE
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
% QUEUE: [0/1, X val, Y val, Parent X val, Parent Y val, g(n),h(n), f(n)]
xNode = xStart;
yNode = yStart;
QUEUE = [];
QUEUE_COUNT = 1;
path_cost = 0; % cost g(n): from start node to the the current node n
goal_distance = distance(xNode, yNode, xTarget, yTarget); % cost h(n): heuristic cost of n which is the straight line distance
QUEUE(QUEUE_COUNT, :) = insert(xNode, yNode, xNode, yNode, path_cost, goal_distance, goal_distance);
QUEUE(QUEUE_COUNT, 1) = 0; % 0 stands for a visited node and 1 stands for a unvisited node

%% Start the search
while(xNode ~= xTarget || yNode ~= yTarget)
    % if the target has not benn reached, then expand the current node to obtain child nodes
    exp = expand(xNode, yNode, path_cost, xTarget, yTarget, OBSTACLE, MAX_X, MAX_Y);
    exp_count = size(exp, 1);
    % Update QUEUE with child nodes; exp: [X val, Y val, g(n), h(n), f(n)]
    for i = 1 : exp_count
        flag = 0; % flag = 0 stands for no valid nodes to expand
        for j = 1 : QUEUE_COUNT
            % check if the new expanded children nodes are in QUEUE
            if(exp(i, 1) == QUEUE(j, 2) && exp(i, 2) == QUEUE(j, 3))
                QUEUE(j, 8) = min(QUEUE(j, 8), exp(i, 5)); % QUEUE(j, 8) and exp(i, 5) are f(n)
                if QUEUE(j, 8) == exp(i, 5)
                    % update parents, g(n) and h(n)
                    QUEUE(j, 4) = xNode; % parent
                    QUEUE(j, 5) = yNode; % parent
                    QUEUE(j, 6) = exp(i, 3); % g(n)
                    QUEUE(j, 7) = exp(i, 4); % h(n); f(n) have been updated before
                end % end of minimum f(n) check
                flag = 1;
            end
        end
        if flag == 0 
            % update QUEUE and QUEUE_COUNT by adding the node's one neighbor each time
            QUEUE_COUNT = QUEUE_COUNT + 1;
            QUEUE(QUEUE_COUNT, :) = insert(exp(i, 1), exp(i, 2), xNode, yNode, exp(i, 3), exp(i, 4), exp(i, 5));
        end % end of inserting new element into QUEUE
    end

    % A*: find the node in QUEUE with the smallest f(n), returned by min_fn
    index_min_node = min_fn(QUEUE, QUEUE_COUNT);
    % set current node (xNode, yNode) to the node with minimum f(n)
    xNode = QUEUE(index_min_node, 2);
    yNode = QUEUE(index_min_node, 3);
    if (xNode == xTarget && yNode == yTarget) % to prevent the end point be colored in red
        break
    end
    path_cost = QUEUE(index_min_node, 6); % cost g(n)
    % move the node to OBSTACLE
    OBST_COUNT = OBST_COUNT + 1;
    OBSTACLE(OBST_COUNT, :) = [xNode, yNode]; % add the expanded node into OBSATCLE
    % target the current node and update the maze
    % the value 5 stands for all the routes that A* has processed
    maze(xNode, yNode) = 5;
    % display the updated maze in each iteration
    dispMaze(maze);
    QUEUE(index_min_node, 1) = 0; % 0 means this node has been visited
end

% to indicate and show the final optimal path
result();
