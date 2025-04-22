clc, clearvars

A=input('Enter the cost matrix:\n');
supply=input('Enter the supply column vector:\n');
demand=input('Enter the demand row vector:\n');

sumSupply=sum(supply);
sumDemand=sum(demand);

table=A;

if sumSupply>sumDemand
    table=[table;demand];
    col=zeros(size(A,1),1);
    col=[col;sumSupply-sumDemand];
    table=[table,col];
    col=[supply;0];
    table=[table,col];
elseif sumDemand>sumSupply
    table=[table,supply];
    row=zeros(1,size(A,2));
    row=[row,sumDemand-sumSupply];
    table=[table;row];
    row=[demand,0];
    table=[table;row];
else
    table=[table,supply];
    row=[demand,0];
    table=[table;row];
end


fprintf("\nInitial transportation table:\n");
disp(table);

% North West Corner rule

tableog=table;
costNWC=0;
i=1;j=1;
while i<=size(A,1) && j<=size(A,2)
    mini=min(table(i,end),table(end,j));
    table(i,end)=table(i,end)-mini;
    table(end,j)=table(end,j)-mini;
    costNWC=costNWC+table(i,j)*mini;
    if table(i,end)>table(end,j)
        j=j+1;
    else 
        i=i+1;
    end
end

fprintf('\nMinimum cost using North West corner rule is:\n')
disp(costNWC);

% Least Cost method

table=tableog;
costLC=0;

while any(table(end,:)>0) && any(table(:,end)>0)
    A=table(1:end-1,1:end-1);
    % fprintf('here\n');
    [mini,idx]=min(A(:));
    [row,col]=ind2sub(size(A),idx);
    % disp([row,col])
    min2=min(table(row,end),table(end,col));
    costLC=costLC+A(row,col)*min2;
    table(row,end)=table(row,end)-min2;
    table(end,col)=table(end,col)-min2;
    if table(row,end)==0
        table(row,:)=[];
    end
    if table(end,col)==0
        table(:,col)=[];
    end
end

fprintf('\nMinimum cost using Least Cost method is:\n')
disp(costLC);




