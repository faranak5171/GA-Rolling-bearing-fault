function y=objectiveFunc(x)
    x = round(x);
    index = find(x==1);    
    
    error =  neuralNetwork(index);
    
    numf=length(index);
    y=[error numf];
end