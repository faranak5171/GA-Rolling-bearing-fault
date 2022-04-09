function [bestFeatures, bestCost]  = implementGA(problem, params)
    
    % Problem
    costFunc = problem.costFunc;
    nVar = problem.nVar;
    varMin = problem.varMin;
    varMax = problem.varMax;

    % Parameters
    nPop = params.nPop;
    maxIt = params.maxIt;
    pc = params.pc;
    nc = round((pc*nPop)/2)*2; % number of offsprings should be even
    mu = params.mu;
    beta = params.beta;


    %% Initialize Population

    % create random population or parents
    r=rand(nPop,nVar);
    pop=zeros(nPop,nVar);
    for i=1:nVar
        pop(:,i)=r(:,i)*(varMax(i)-varMin(i))+varMin(i);
    end

    % calculate cost function and the number of selected features for each parent
    pop_cost = zeros(1,nPop);
    pop_numFeatures = zeros(1,nPop);
    for i=1:nPop     
        y = costFunc(pop(i,:));
        pop_cost(1,i) = y(1);
        pop_numFeatures(1,i) = y(2);

    end

    %% Create Offsprings, Crossover, Mutation
    
    % Save best Cost at every Iteration
    bestCost = nan(maxIt,1);
    bestFeatures = nan(maxIt,1);
    
    popc_cost = zeros(1,nPop);
    popc_numFeatures = zeros(1,nPop);
    for it=1:maxIt

        % Initialize offspring
        popc1 = zeros(nc/2 ,nVar);
        popc2 = zeros(nc/2 , nVar);
        
        % crossover
        for k=1:nc/2
            
            % Selection probability
            c = [pop_cost];
            avgc = mean(pop_cost(:));
            if avgc ~=0
                c = c/avgc;
            end
            probs = exp(-beta*c);



            % select paranets
            p1 = pop(RouletteWheelSelection(probs),:);
            p2 = pop(RouletteWheelSelection(probs),:);

            [popc1(k,:), popc2(k,:)] = UniformCrossOver(p1, p2);
        end

            % Convert popc to single-column Matrix
            popc = [popc1; popc2];
            
            % Mutation
            for l=1:nc

                % Perform Mutation
                popc(l) = Mutate(popc(l), mu);

                % Evaluate Solution
                y = costFunc(popc(l,:));
                popc_cost(l) = y(1);
                popc_numFeatures(l) = y(2);
    
                
            end
            

            %% Merge, Sort, Remove Extra Population
            

             % Merge Population, costs and MinFeatures
             pop = [pop; popc];
             Total_Cost = horzcat(pop_cost, popc_cost);
             Total_MinFeatures = horzcat(pop_numFeatures, popc_numFeatures);
             % Sort population
             [~, so] = sort(Total_Cost);
             pop = pop(so,:);
             Total_Cost = Total_Cost(so);
             Total_MinFeatures = Total_MinFeatures(so);
 
              % Remove Extra Individuals
             pop = pop(1:nPop,:);
             Total_MinFeatures = Total_MinFeatures(1:nPop);
             Total_Cost = Total_Cost(1:nPop);
             
             bestFeatures(it,1) = Total_MinFeatures(1);
             bestCost(it,1) = Total_Cost(1);
        
    end

end
