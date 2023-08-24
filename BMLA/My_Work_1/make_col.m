
path_file = input('Please enter the path of martix file:','s');
index = strlength(path_file)-2;
if exist(path_file,'file') ~=2
    error ('Can not find the file!!!');
end
run(path_file) 
Eps=0.000001;
%Check Square
N = size(A,1);
for j = 1:N 
    if length(A(:,1))~=length(A(:,j))
        error('martix isnot square!!!');
    end
end

%Check Hermite
for i = 1:N
    for j = 1: N
        %Cut a half
        if i>j
            continue;
        end
        
        if abs(A(i,j) - conj(A(j,i)))>Eps
            error('martix is not Hermiter!!!');
        end
    end
end

%main matrix minor positive
for n = 1:N
    M = A(1:n,1:n);
    if det(M)<=Eps
        error('main matrix minor isnot positive');
    end
end

% Cholesky decomposition
if isreal(A(1,1))
    C = zeros(N,N);
    for t=1:N
        C(t,t)=sqrt(A(t,t)-C(t,:)*C(t,:)');
        for h =t+1:N
            C(h,t)=(A(h,t)-C(h,:)*C(t,:)')/C(t,t);
        end
    end

else
    C_R = zeros(N,N);
    C_C = zeros(N,N);
    A_R=real(A);
    A_C=real(A);
    for t=1:N
        C_R(t,t)=sqrt(A_R(t,t)-C_R(t,:)*C_R(t,:)');
        for h =t+1:N
            C_R(h,t)=(A_R(h,t)-C_R(h,:)*C_R(t,:)')/C_R(t,t);
        end
    end
    for t=1:N
        C_C(t,t)=sqrt(A_C(t,t)-C_C(t,:)*C_C(t,:)');
        for h =t+1:N
            C_C(h,t)=(A_C(h,t)-C_C(h,:)*C_C(t,:)')/C_C(t,t);
        end
    end
    C = C_R + C_C*i;
end



if isreal(A)
    makefile_R("Cmat"+path_file(index)+".m",C,'C');
else
    makefile_C("Cmat"+path_file(index)+".m",C,'C');
end



        





            
         
