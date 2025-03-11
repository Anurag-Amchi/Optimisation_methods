clc, clearvars

n=input('Enter the number of variables: ');
m=input('Enter the number of constraints: ');
lessThan=input('Enter the number of less than equal constraints: ');
equalTo=input('Enter the number of equal to constraints: ');
greaterThan=input('Enter the number of greater than constraints: ');

A=input('Enter the coefficient matrix: \n');
b=input('Enter the constant column vector(RHS): \n');
C=input('Enter the coefficient of objective function:\n');

extraMat=[];

for i=1:lessThan
    col=zeros(m,1);
    col(i)=1;
    extraMat=[extraMat,col];
end

for i=1:greaterThan
    col=zeros(m,1);
    col(lessThan+equalTo+i)=-1;
    extraMat=[extraMat,col];
end

for i=1:equalTo
    col=zeros(m,1);
    col(lessThan+i)=1;
    extraMat=[extraMat,col];
end

for i=1:greaterThan
    col=zeros(m,1);
    col(lessThan+equalTo+i)=1;
    extraMat=[extraMat,col];
end

A=[A,extraMat];
table=[A,b];

M=1e7;
C=[C,zeros(1,lessThan+greaterThan)];
for i=1:greaterThan+equalTo
    C=[C,-M];
end

coeffIdx=n+1:n+lessThan;
for i=1:size(C,2)
    if C(i)==-M
        coeffIdx=[coeffIdx,i];
    end
end

c1=[];
for i=1:m
    c1=[c1,C(coeffIdx(i))];
end

Zj_Cj= c1*A-C;

fprintf('\nInitial Simplex table\n');
disp(table);
fprintf('Zj-Cj:\n');
disp(Zj_Cj);

itr=0;
while any(Zj_Cj<0)
    itr=itr+1;
    [mincol,colIdx]=min(Zj_Cj);
    pivotCol=table(:,colIdx);
    if all(pivotCol<0)
        fprintf('Unbounded Solution\n');
        return;
    end
    ratios=table(:,end) ./ (pivotCol + (pivotCol==0)*eps);
    minRat=1e6;
    rowIdx=1;
    for i=1:m
        if ratios(i)<minRat && ratios(i)>0
            minRat=ratios(i);
            rowIdx=i;
        end
    end

    table(rowIdx,:)=table(rowIdx,:) / table(rowIdx,colIdx);
    for i=1:m
        if i~=rowIdx
            table(i,:)=table(i,:)-table(i,colIdx)*table(rowIdx,:);
        end
    end
    coeffIdx(rowIdx)=colIdx;
    c1=[];
    for i=1:m
        c1=[c1,C(coeffIdx(i))];
    end
    A=table(:,1:end-1);

    Zj_Cj=c1*A-C;
    fprintf('Simplex table after iteration %d\n',itr);
    disp(table);
    fprintf('Zj-Cj:\n')
    disp(Zj_Cj);    
end

xb=zeros(1,n+lessThan+greaterThan);
for i=1:m
    xb(coeffIdx(i))=table(i,end);
end

fprintf('Optimum solution:\n');
disp(xb);
C=C(:,1:end-equalTo-greaterThan);
fprintf('Maximum objective value: %d\n',xb*C');
