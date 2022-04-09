function error = neuralNetwork(index)

    % Select Random Features as input to our NN
    input = xlsread("FMn1000.xlsx");
    out = xlsread("out.xlsx");
    input = input(:,index(1,:)); 
    net = patternnet(6); % one hidden layer of 6 nodes
    net.trainParam.showWindow=0;
    net = train(net,input',out');
    outnet=sim(net,input');
    [~,t1]=max(outnet);
    for i=1:size(out,1)
        t2(i)=find(out(i,:)==1);
    end
    error=length(find((t1==t2)==0));
    error=error/size(out,1);

    
end