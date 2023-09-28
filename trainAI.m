function AI_Probs  = trainAI(origNumSticks)
% Simulates two AI plaing the Game of Stics against each other
% and learning what choices help them win the game
% INPUT:
%   origNumSticsk - integer, the number of sticks on the board when the game begins  
% RETURNs
%   AI_Probs - origNumStics x 3 matrix of probabilities
%              of what choice of 1,2 or 3 sticks the AI should choose
%              based on the number of sticks on the board


numSimulations = 10000;

%AI gets its hats
hats = repmat([1,2,3], origNumSticks, 1);
hats = num2cell(hats,2);
AI1_hats = hats;
AI2_hats = hats;


for i = 1:numSimulations %playing that many games!
    AI1_savedHats = AI1_hats;
    AI2_savedHats = AI2_hats;

    sticksOnBoard  = origNumSticks;
    gameOver = false;

    while ~gameOver
        % AI1 plays
        [ AISticks, gameOver, AI1_hats ] = AITurnTrain( sticksOnBoard, AI1_hats);
        sticksOnBoard = sticksOnBoard - AISticks;
        if gameOver %AI1 lost the game
            %throw away results
            AI1_hats = AI1_savedHats;
        else %AI2 can play
            [ AISticks, gameOver, AI2_hats ] = AITurnTrain( sticksOnBoard, AI2_hats);
            sticksOnBoard = sticksOnBoard - AISticks;

            if gameOver %AI2 LOST
                %throw away its results
                AI2_hats = AI2_savedHats;
            end
        end
    end
end


% Process the AI choices
AI_Probs = repmat([1/3,1/3,1/3], origNumSticks, 1);
for i=1:origNumSticks
    row = AI1_hats{i};
    rowLength = length(row);
    AI_Probs(i,1) = length(row(row == 1))/rowLength;
    AI_Probs(i,2) = length(row(row == 2))/rowLength;
    AI_Probs(i,3) = length(row(row == 3))/rowLength;
end

AI_Probs(1,:) =  [1 0 0 ]; % if 1 stick then pick it up.

end



function [ AISticks, gameOver, hats ] = AITurnTrain( sticksOnBoard, hats)
% Simulates the turn of an AI
% INPUT: 
%   sticksOnBoard - integer, the number of sticks on the board BEFORE the AI turn
%   hats - sticksOnBoard x 1 Cell Array, which contains the AI current hats (one hat for each possible amount of sticks on the
%   board)
% RETURNS
%   AISticks - integer, how many sticks the AI will pick up from the borad
%   gameOver - logical type, FALSE if game is NOT over, TRUE if game is over
%   hats -- the UPDATED hats for this AI


% AI picks its hat for this number of sticks
currentHat = [hats{sticksOnBoard}];

% if there are less than 3 or 2 sticks on board,
% then only pick the possible number of sticks
currentHat = currentHat( currentHat <= sticksOnBoard );

% makes random choice from the possible stick choices
AISticks = currentHat ( randi( length(currentHat) ) );

% updates the hats for this AI to record this choice of sticks
hats{sticksOnBoard} =  [hats{sticksOnBoard} AISticks];

if (sticksOnBoard - AISticks <= 0)
    gameOver = true;
else
    gameOver = false;
end

end