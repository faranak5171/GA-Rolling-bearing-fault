clc; clear; close all;

waitBar;


function waitBar

    f = waitbar(0,'Please wait...');
    pause(.5)

    %% Problem Definition
    problem.costFunc=@(x) objectiveFunc(x);
    problem.nVar = 144;
    problem.varSize = [1, problem.nVar];
    problem.varMax = ones(1, problem.nVar);
    problem.varMin = zeros(1, problem.nVar);

    %% GA parameters
    params.nPop = 30;
    params.maxIt = 10;

    params.pc = 1; % Probability of Crossover or Percentage of children to calculate the number of offsprings
    params.mu = 0.01; % Probability of mutation  
    params.beta = 1; % Beta is used in parent selection to choose them base on the exponential probability



    %% Implement GA

    waitbar(.67,f,'Processing ...');

    [bestFeatures, bestCost] = implementGA(problem, params);

    %% Results section

    x = bestCost; 
    y = bestFeatures; 
    plot(x,y,'-s','MarkerSize', 10, 'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6]);
    xlabel('Minimum Error');
    ylabel("Number of selected features")
    title('Number of selected features in each iteration vs. the minimum error');
    grid on;

    waitbar(1,f,'Finishing');
    pause(1)

    delete(f)
end


