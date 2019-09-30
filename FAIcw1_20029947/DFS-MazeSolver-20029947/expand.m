function direction = expand(node_x, node_y, OBSTACLE, MAX_X, MAX_Y)
    % at the beginning, each direction can go
    direction = [1 1 1 1]; % Up, down, left, right
    c2 = size(OBSTACLE, 1);
    for c1 = 1 : c2
        % Check up
        if ((node_x - 1 == OBSTACLE(c1, 1) && node_y == OBSTACLE(c1, 2)) || node_x - 1 <= 0)
            direction(1) = 0;
        end

        % Check down
        % node_x + 1 >= MAX_X is to make sure the node won't go out the map at the first beginning
        if ((node_x + 1 == OBSTACLE(c1, 1) && node_y == OBSTACLE(c1, 2)) || node_x + 1 >= MAX_X)
            direction(2) = 0;
        end

        % Check left
        if ((node_x == OBSTACLE(c1, 1) && node_y - 1 == OBSTACLE(c1, 2)) || node_y - 1 <= 0)
            direction(3) = 0;
        end
        
        % Check right
        if ((node_x == OBSTACLE(c1, 1) && node_y + 1 == OBSTACLE(c1, 2)) || node_y + 1 >= MAX_Y)
            direction(4) = 0;
        end
    end
   

