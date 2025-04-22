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

tableog=table;
ibfs=[];
cost=0;

while any(table(end,:)>0) && any(table(:,end)>0) 
    rowpen=[];
    for i=1:size(table,1)-1
        [rowval, idx] = sort(table(i,1:end-1)); 
        if size(rowval,2)>1
            rowpen=[rowpen,rowval(2)-rowval(1)];
        else
            rowpen=[rowpen,rowval(1)];
        end
    end
    
    colpen=[];
    for j=1:size(table,2)-1
        [colval,idx]=sort(table(1:end-1,j));
        if size(colval,1)>1
            colpen=[colpen,colval(2)-colval(1)];
        else
            colpen=[colpen,colval(1)];
        end
    end
    
    [maxr,idxr]=max(rowpen);
    [maxc,idxc]=max(colpen);
    
    if maxr>maxc
        [mini,idx]=min(table(idxr,:));
        mini2=min(table(idxr,end),table(end,idx));
        table(idxr,end)=table(idxr,end)-mini2;
        table(end,idx)=table(end,idx)-mini2;
        cost=cost+table(idxr,idx)*mini2;
        ibfs=[ibfs;idxr,idx,mini2];
        if table(idxr,end)==0
            table(idxr,:)=[];
        else
            table(:,idx)=[];
        end
    else
        [mini,idx]=min(table(:,idxc));
        mini2=min(table(idx,end),table(end,idxc));
        table(idx,end)=table(idx,end)-mini2;
        table(end,idxc)=table(end,idxc)-mini2;
        cost=cost+table(idx,idxc)*mini2;
        ibfs=[ibfs;idx,idxc,mini2];
        if table(end,idxc)==0
            table(:,idxc)=[];
        else
            table(idx,:)=[];
        end
    end
    % disp(table);
end

fprintf("\nInitial basic feasible solution cost:\n")
disp(cost);
disp(ibfs);

