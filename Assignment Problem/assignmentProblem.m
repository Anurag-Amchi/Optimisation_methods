clc, clearvars;

cost = input('Enter the cost matrix:');
maxim = input('Is it a Maximisation problem?(0 for NO, 1 for YES):');
table=cost;
n=size(table,1);

% Converting to maximization problem
if maxim==1
    table = max(table(:)) - table;
end

rowv=zeros(1,n);
colv=zeros(n,1);

% Modifying table for each row and column to have at least one zero
% had nightmares

while any(colv==0) || any(rowv==0)
    for i=1:n
        [minirow,idx]=min(table(i,:));
        table(i,:)=table(i,:)-minirow;
        colv(i)=sum(table(i,:)==0); % Assign. Dont add.
        for j=1:n % for the corresponding row/col
            if table(i,j)==0
                rowv(j)=sum(table(:,j)==0);
            end
        end
    end
    if all(colv>0) && all(rowv>0)
        break;
    end
    for j=1:n
        [minicol,idx]=min(table(:,j));
        table(:,j)=table(:,j)-minicol;
        rowv(j)=sum(table(:,j)==0); % Dont want to assign? Good luck on your mental health.
        for i=1:n
            if table(i,j)==0
                colv(i)=sum(table(i,:)==0);
            end
        end
    end
end

fprintf('Table before assignment:\n');
disp(table); % bad unprocessed table

% Assignment 

[assign_mat,infeasible]=assignment(rowv,colv,table,n);

if infeasible==1
    fprintf('Infeasible solution obtained. Proceeding further for feasible solution.\n'); % ts pmo
else
    fprintf('Feasible solution Obtained. Assignment matrix:\n');
    disp(assign_mat);
    return;
end

fprintf('Infeasible Assignment matrix:\n');
disp(assign_mat);

% Covering zeroes

markedrow = zeros(1,n);
markedcol = zeros(n,1);

for i=1:n
    if sum(assign_mat(i,:))==0
        markedcol(i)=1;
    end
end

% My personal rankings
% Tralalero Tralala
% Tripi Tropi Tropa Tripa
% Ballerina Cappucina
% Brr Brr patapim
% Bormbardiro Crocodilo
% Trulimero Trulicina

flag=1;
while flag>0
    flag=0;
    for i=1:n
        if markedcol(i)==1
            for j=1:n
                if table(i,j)==0 && assign_mat(i,j)==0 && markedrow(j)==0
                    % enter on 0
                    markedrow(j)=1;
                    flag=1;
                end
            end
        end
    end
    
    for j=1:n
        if markedrow(j) == 1
            for i=1:n
                if table(i,j)==0 && assign_mat(i,j)==1 && markedcol(i)==0
                    % enter on 1
                    markedcol(i)=1;
                    flag=1;
                end
            end
        end
    end
end

crossed_tab = table;

crossed_tab(markedcol == 0,:) = [];
crossed_tab(:,markedrow == 1) = [];

mini=min(crossed_tab(:));

% simple easy assignment

for i=1:n
    for j=1:n
        if markedrow(j)==1 && markedcol(i)==0
            table(i,j)=table(i,j)+mini;
        elseif markedrow(j)==0 && markedcol(i)==1
            table(i,j)=table(i,j)-mini;
        end
    end
end

% Final assignment

for i=1:n
    colv(i)=sum(table(i,:)==0);
end
for j=1:n
    rowv(j)=sum(table(:,j)==0);
end

% SATA ANDAGI

[assign_mat,infeasible]=assignment(rowv,colv,table,n);

if infeasible==1
    fprintf('Infeasible solution obtained. Proceeding further for feasible solution.\n');
else
    fprintf('Final table before assignment:\n');
    disp(table);
    fprintf('Final feasible Assignment matrix:\n');
    disp(assign_mat);
    res=0;
    for i=1:n
        for j=1:n
            if assign_mat(i,j)==1
                res=res+cost(i,j);
            end
        end
    end
    fprintf('Preference score: %d\n',res);
end

% The assignment was not easy indeed istg. 
% Fought a total of 3 mental demons + no water in hostel ts pmo
% Functions

% Almost lost my life savings ($0) crafting ts
function [assign_mat,infeasible] = assignment(rowv,colv,table,n)
    assign_mat=zeros(n,n);
    colzer=colv;
    rowzer=rowv;
    [mini1,idx1]=min(colv);
    [mini2,idx2]=min(rowv);
    infeasible=0;
    
    for i=1:n
        if mini1<mini2 % row dominance fr
            cnt=0;
            for j=1:n % searching for the zero
                if table(idx1,j)==0 && rowzer(j)~=Inf
                    if cnt>0 % bmbclt zero selected
                        rowzer(j)=rowzer(j)-1;
                        if rowzer(j)==0
                            rowzer(j)=Inf;
                        end
                    else 
                        colzer(idx1)=Inf;
                        rowzer(j)=Inf;
                        for k=1:n % scouting for other zeros in that column and making row vectors hard
                            if table(k,j)==0 && colzer(k)~=Inf
                                colzer(k)=colzer(k)-1;
                                if colzer(k)==0
                                    colzer(k)=Inf;
                                end
                            end
                        end
                        assign_mat(idx1,j)=1;
                        cnt=1;
                    end
                end
            end
        else
            cnt=0;
            for j=1:n
                if table(j,idx2)==0 && colzer(j)~=Inf
                    if cnt>0
                        colzer(j)=colzer(j)-1;
                        if colzer(j)==0
                            colzer(j)=Inf;
                        end
                    else
                        rowzer(idx2)=Inf;
                        colzer(j)=Inf;
                        for k=1:n
                            if table(j,k)==0 && rowzer(k)~=Inf
                                rowzer(k)=rowzer(k)-1;
                                if rowzer(k)==0
                                    rowzer(k)=Inf;
                                end
                            end
                        end
                        assign_mat(j,idx2)=1;
                        cnt=1;
                    end
                end
            end
        end
        if all(rowzer==Inf) && all(colzer==Inf) && i~=n
            infeasible=1;
            break;
        end
        [mini1,idx1]=min(colzer);
        [mini2,idx2]=min(rowzer);
    end
end

% It was fun but could have given us extra time considering how late it was

