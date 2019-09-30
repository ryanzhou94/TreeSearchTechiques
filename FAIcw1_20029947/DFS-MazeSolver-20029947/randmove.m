function [addx, addy] = randmove(direction)
    addx = 0;
    addy = 0;
    % sum(direction) > 0
    locations = direction .* floor(100.0 / sum(direction));
    % Choose a random direction
    r = randi([1 100]); % generate a random number from 1 to 100
    if (r <= locations(1))
        addx = -1;  % move up
    elseif (r <= locations(2) + locations(1))
        addx = 1;   % move down
    elseif (r <= locations(3) + locations(2) + locations(1))
        addy = -1;  % move left
    else
        addy = 1;   % move right
    end


