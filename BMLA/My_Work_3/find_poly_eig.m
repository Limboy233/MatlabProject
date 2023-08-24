path_Amat = input('Please enter the path of the martix files: ',"s");
index = strlength(path_Amat)-3;

if exist (path_Amat,'file') ~=2
    error("Don not find the file of the martix");
else
    run(path_Amat);%the martix is A
end

N = size(A,1);
for j = 1:N 
    if length(A(:,1))~=length(A(:,j))
        error('martix isnot square!!!');
    end
end
Eps=0.000001;
Flag = 1;%------------Is Hermite
%Check Hermite
for i = 1:N
    for j = 1: N
        %Cut a half
        if i>j
            continue;
        end
        
        if abs(A(i,j) - conj(A(j,i)))>Eps
            Flag = 0; %Isnot Hermite
        end
    end
end
G=zeros(N,N);
for i = 1:N
    G(i,i)=1;
end
C=A;
if Flag == 1
    for k=3:N
        for l=1:k-2
            u = 2*A(k,l)/(A(k,k)-A(l,l));
            a = sqrt(0.5*(1+1/sqrt(1+u^2)));
            b = sign(u)*sqrt(0.5*(1-1/sqrt(1+u^2)));
            G(k,k)=a;
            G(k,l)=(-1)*conj(b);
            G(l,k)=b;
            G(l,l)=a;
            C = (G')*C*G;
        end
    end
    [M,W]=eig(C);%M----vector  %W-----eig
    nmd=diag(W);
    
    path_x = "cvec" +path_Amat(index)+path_Amat(index+1)+".m";
    fid = fopen(path_x,"w");
    if fid <0
        error("Canot Creat the file!!!");
    end
    fprintf(fid,"x = [");
    for i=1:N
        fprintf(fid ,'%0.6f',nmd(i));
        if(i~=N)
            fprintf(fid,';');
        else
            fprintf(fid,"];");
        end
    end
    
else
    %step:1
    for q = 1:N
        N1=eye(N,N);
        N2=eye(N,N);
        for i = 2:N-q
            v=A(q+i,q)/A(q+1,q);
            N1(q+i,q+1)=v;
            N2(q+i,q+1)=-v;
        end
        
        B = N2*A*N1;
    end
        makefile_R ("Bmat"+path_Amat(index)+".m",B,'B');
     %step:2
    for q = 1:N
        M1=eye(N,N);
        M2=eye(N,N);
        for j = 2:N-q
            v=B(q,j)/B(q,q+1);
            M1(q+1,q+j)=-v;
            M2(q+1,q+j)=v;
        end
        
        H = M2*B*M1;
    end
    syms x;
    P=det(H-x*eye(N,N));
    coeff=sym2poly(P);
    
    path_x = "Acoeff" +path_Amat(index)+path_Amat(index+1)+".m";
    fid = fopen(path_x,"w");
    if fid <0
        error("Canot Creat the file!!!");
    end
    fprintf(fid,"x = [");
    for i=1:N+1
        fprintf(fid ,'%0.6f',coeff(i));
        if(i~=N+1)
            fprintf(fid,';');
        else
            fprintf(fid,"];");
        end
    end
        
end


