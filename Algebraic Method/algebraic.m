clc, clearvars;

n=input('Enter the number of variables: ');
m=input('Enter the number of constraints: ');
lessThan=input('Enter the nummber of less than equal to constraints ');
greaterThan=input('Enter the number of greater than equal to constraints: ');

A=input('Enter the coefficient matrix(in less than, greater than, equal to order): \n');
b=input('Enter the constant column vector (RHS)(in the same way as A): \n');
C=input('Enter the coefficients of the objective function: \n');

extraMat=[];
for i = 1 : lessThan 
    col = zeros(m, 1);
    col(i) = 1;
    extraMat = [extraMat, col];
end
for i = 1 : greaterThan
    col = zeros(m, 1);
    col(i) = -1;
    extraMat = [extraMat, col];
end

A=[A,extraMat];
C=[C, zeros(1,lessThan+greaterThan)];

combinations=nchoosek(1:size(A,2),m);

fprintf('All possible basic variables: \n');
for i=1:size(combinations,1)
    for j=1:m
        fprintf('x%d ', combinations(i,j));
    end
    fprintf('\n');
end

fprintf('\nCoefficient matrix A:\n ');
disp(A);

solIdx=1;
optSol=-1e6;
basicSols=[];
fprintf('All the basis matrices are:\n');
for i=1:size(combinations,1)
    Bi=[];
    for j=1:m
        Bi=[Bi,A(:,combinations(i,j))];
    end
    xb=Bi\b;
    fprintf('\nB%d:\n',i );
    disp(Bi);
    fprintf('Basic solution:\n');
    for j=1:m
        fprintf('x%d = %d\n',combinations(i,j),xb(j));
    end
    basicSols=[basicSols;xb'];
    if any(xb<0)
        fprintf('Not feasible solution\n');
    else
        fprintf('Feasible solution\n');
        z=0;
        for k=1:m
            z=z+xb(k)*C(combinations(i,k));
        end
        fprintf('Objective value: %d\n',z);
        if z>optSol
            optSol=z;
            solIdx=i;
        end
    end
end
% disp(basicSols)
fprintf('\nOptimum objective value = %d\nFor\n', optSol);
for i=1:m
    fprintf('x%d = %d\n', combinations(solIdx,i),basicSols(solIdx,i));
end


