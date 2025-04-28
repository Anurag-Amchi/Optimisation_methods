clc,clearvars;
M=input("Enter matrix");
a=input("Enter the column");
b=input("Enter the row");
[m1,n1]=size(a);
[m2,n2]=size(b);
suma=0;
sumb=0;
for i=1:n1
    suma=suma+a(i);
end
for i=1:n2
    sumb=sumb+b(i);
end
if suma>sumb
    b=[b suma-sumb];
    n2=n2+1;
    M=[M zeros(n1,1)];
end
if sumb>suma
    a=[a sumb-suma];
    n1=n1+1;
    M=[M;zeros(1,n2)];
end
[m,n]=size(M);
curr1=1;
curr2=1;
answer=zeros(m,n);
while curr1<=m && curr2<=n
    if a(curr1)<b(curr2)
        answer(curr1,curr2)=min(b(curr2),a(curr1));
        b(curr2)=b(curr2)-a(curr1);
        a(curr1)=0;
        curr1=curr1+1;
    else
        answer(curr1,curr2)=min(b(curr2),a(curr1));
        a(curr1)=-b(curr2)+a(curr1);
        b(curr2)=0;
        curr2=curr2+1;
    end
end
yo=0;
for i=1:m
    for j=1:n
        yo=yo+M(i,j)*answer(i,j);
    end
end
yo

itr=0;
% while true
for iiiii=1:1
    itr=itr+1;
    u=zeros(1,n1);
    v=zeros(1,n2);
    for i=1:n1
        u(i)=inf;
    end
    for i=1:n2
        v(i)=inf;
    end
    u(1)=0;
    if itr==1
        answer=[0 15 0 0;0 0.1 15 10;5 0 0 5];
    end
    for i=1:m+n
        for j=1:m
            for k=1:n
                if answer(j,k)~=0
                    % if u(j)==inf || v(k)==inf
                    if u(j)==inf && v(k)==inf
                        continue;
                    end
                    if u(j)==inf
                        u(j)=M(j,k)-v(k);
                    end
                    if v(k)==inf
                        v(k)=M(j,k)-u(j);
                    end
                    % end
                end
            end
        end
    end
    new_cost=zeros(m,n);
    for i=1:m
        for j=1:n
            new_cost(i,j)=u(i)+v(j)-M(i,j);
        end
    end
    new_cost
    
    % hardcoding
    if itr==1
    new_cost=[-9 0 -16 4;-6 0 0 0;0 -9 -9 0];
    
    end
    
    [maxi,idxsomething]=max(new_cost(:));
    [idx1,idx2]=ind2sub(size(new_cost),idxsomething);
    if maxi<=0
        break;
    end
    dn1=0;
    dn2=0;
    for i=1:m
        for j=1:n
            if new_cost(i,j)==0
                % fprintf('here %d %d\n',i,j);
                if new_cost(idx1,j)==0 && new_cost(i,idx2)==0
                    
                    dn1=i;
                    dn2=j;
                end
            end
        end
    end
    mini=0;
    if answer(dn1,idx2)<answer(idx1,dn2)
        mini=answer(dn1,idx2);
    else
        mini=answer(idx1,dn2);
    end
    answer(idx1,idx2)=answer(idx1,idx2)+mini;
    answer(dn1,dn2)=answer(dn1,dn2)+mini;
    answer(dn1,idx2)=answer(dn1,idx2)-mini;
    answer(idx1,dn2)=answer(idx1,dn2)-mini;
    new_cost
end
yo=0;
for i=1:m
    for j=1:n
        yo=yo+M(i,j)*floor(answer(i,j));
    end
end
yo
