clc,clearvars

n=input('Enter number of variables: ');
m=input('Enter number of constraints: ');
lessThan=input('Enter the number of less than equal to constraints: ');
equalTo=input('Enter the number of equal to constraints: ');
greaterThan=input('Enter the number of greater than equal to constraints: ');

A=input('Enter the coefficient matrix (in order less than, equal to and greater than):\n');
b=input('Enter the constant column vector (RHS)(in the same way as A):\n');
C=input('Enter the coefficients of objective function:\n');

extraMat=[];
C1=zeros(1,n+lessThan+greaterThan);

% This ordering should be maintained during input
% Also during the code
% Else prepare for a humongous ahh nuke (amoGUS)
for i=1:equalTo+greaterThan
    C1=[C1,-1];
end

for i=1:lessThan
    c=zeros(m,1);
    c(i)=1;
    extraMat=[extraMat,c];
end

for i=1:greaterThan
    c=zeros(m,1);
    c(lessThan+equalTo+i)=-1;
    extraMat=[extraMat,c];
end

for i=1:equalTo
    c=zeros(m,1);
    c(lessThan+i)=1;
    extraMat=[extraMat,c];
end

for i=1:greaterThan
    c=zeros(m,1);
    c(lessThan+equalTo+i)=1;
    extraMat=[extraMat,c];
end

A=[A,extraMat];
table=[A,b];

fprintf('\nInitial Simplex table:\n');
disp(table);
% disp(C1);

% Good luck starting phase without ts
coeffIdx=n+1:n+lessThan;

for i=1:size(C1,2)
    if C1(i)==-1
        coeffIdx=[coeffIdx,i];
    end
end
% disp(coeffIdx);

c1=[];
for i=1:m
    c1=[c1,C1(coeffIdx(i))];
end

Zj_Cj=c1 * A - C1;
fprintf('Zj-Cj:\n')
disp(Zj_Cj);
itr=0;

while any(Zj_Cj<0)
    itr=itr+1;
    [mini,colIdx]=min(Zj_Cj);
    pivotCol=A(:,colIdx);
    if all(pivotCol<=0)
        fprintf('Unbounded Solution\n');
        break;
    end
    xb=table(:,size(table,2));
    ratios= xb ./ (pivotCol + (pivotCol == 0)*eps);
    % disp(ratios);
    if all(ratios<0)
        fprintf('Unbounded Solution\n');
        break;
    end
    ratMin=1e6;
    rowIdx=1;
    for i=1:m
        if ratios(i)<ratMin && ratios(i)>=0
            ratMin=ratios(i);
            rowIdx=i;
        end
    end
    table(rowIdx,:)=table(rowIdx,:)/table(rowIdx,colIdx);
    for i=1:m
        if i~=rowIdx
            table(i,:)=table(i,:)-table(rowIdx,:)*(table(i,colIdx));
        end
    end
    coeffIdx(rowIdx)=colIdx;
    c1=[];
    for i=1:m
        c1=[c1,C1(coeffIdx(i))];
    end
    A=table(:,1:end-1);
    Zj_Cj=c1*A-C1;
    fprintf('Simplex table after iteration %d\n',itr);
    disp(table);
    fprintf('Zj-Cj:\n')
    disp(Zj_Cj);
end

if any(coeffIdx>n+lessThan+greaterThan)
    fprintf('Redundancy occurs\n');
end
while any(coeffIdx>n+lessThan+greaterThan)
    greaterValidx=find(coeffIdx>n+lessThan+greaterThan);
    i=greaterValidx(1);
    if table(i,end)>0
        fprintf('Inconsistent LPP\n');
        return;
    else
        for j=1:n+greaterThan+lessThan
            if any(coeffIdx==j)
                continue;
            else
                table(i,:)=table(i,:)/table(i,j);
                for k=1:m
                    if k~=rowIdx
                        table(k,:)=table(k,:)-table(i,:)*(table(k,j));
                    end
                end
                coeffIdx(i)=j;
                c1=[];
                for k=1:m
                    c1=[c1,C1(coeffIdx(k))];
                end
                A=table(:,1:end-1);
                Zj_Cj=c1*A-C1;
                fprintf('Simplex table after iteration %d\n',itr);
                disp(table);
                fprintf('Zj-Cj:\n')
                disp(Zj_Cj);
                break;
            end
        end
    end
    fprintf('here\n')
end
fprintf('\nPhase 2\n');
% ez extraction as we structured our input
table2=table(:,1:end-greaterThan-equalTo-1);
A2=table2;
table2=[table2,table(:,end)];
fprintf('\nInitial Simplex Table\n');
disp(table2);

c2=[];
C2=[C,zeros(1,greaterThan+lessThan)];
for i=1:m
    c2=[c2,C2(coeffIdx(i))];
end

fprintf('Zj-Cj:\n');
Zj_Cj= c2*A2-C2;
disp(Zj_Cj);

itr=0;

while any(Zj_Cj<0)
    itr=itr+1;
    [mini,colIdx]=min(Zj_Cj);
    pivotCol=A(:,colIdx);
    if all(pivotCol<=0)
        fprintf('Unbounded Solution\n');
        return;
    end
    xb=table2(:,size(table2,2));
    ratios= xb ./ (pivotCol + (pivotCol == 0)*eps);
    % disp(ratios);
    if all(ratios<0)
        fprintf('Unbounded Solution\n');
        return;
    end
    ratMin=1e6;
    rowIdx=1;
    for i=1:m
        if ratios(i)<ratMin && ratios(i)>=0
            ratMin=ratios(i);
            rowIdx=i;
        end
    end
    table2(rowIdx,:)=table2(rowIdx,:)/table2(rowIdx,colIdx);
    for i=1:m
        if i~=rowIdx
            table2(i,:)=table2(i,:)-table2(rowIdx,:)*(table2(i,colIdx));
        end
    end
    coeffIdx(rowIdx)=colIdx;
    c2=[];
    for i=1:m
        c2=[c2,C2(coeffIdx(i))];
    end
    A2=table2(:,1:end-1);
    Zj_Cj=c2*A2-C2;
    fprintf('Simplex table after iteration %d\n',itr);
    disp(table2);
    fprintf('Zj-Cj:\n')
    disp(Zj_Cj);
end

% istg ts pmo ngl
xb=zeros(1,n+lessThan+greaterThan);
for i=1:m
    xb(coeffIdx(i))=table2(i,end);
end

fprintf('Optimum solution:')
disp(xb);
fprintf('Maximum objective value: %d\n',xb*C2');

