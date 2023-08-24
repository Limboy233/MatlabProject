
path_Amat = input('Please enter the path of the martix files: ',"s");
index = strlength(path_Amat)-2;

if exist (path_Amat,'file') ~=2
    error("Don not find the file of the martix");
else
    run(path_Amat);%the martix is A
end

%input Method
Method =input("For this martix we use the method == ");
%Checking the matrix is real
if ~isreal(A)
    error("The martix is not real martix!!!");
end

%Checking the matrix is square
N = size(A,1);%This is the number of square matrix
for j = 1:N 
    if length(A(:,1))~=length(A(:,j))
        error('martix isnot square!!!');
    end
end

if Method == 1
    [Q,R]=Method_1(A);
else
    if Method == 2
        [Q,R]=Method_2(A);
    else
        if Method == 3
            [Q,R]=Method_3(A);
        end
    end
end

makefile_R ("Qmat"+path_Amat(index)+".m",Q,'Q');
makefile_R ("Rmat"+path_Amat(index)+".m",R,'R');

function [Q,R]=Method_1(A)
%Method==1 :метод отражений
%A = Q * R
A1=A;   %A_1=(a1,a2,a3,....),ai--vector
A_new=A;
N = size(A,1);%This is the number of square matrix
%martix househoiler
H = zeros(N,N);



I = zeros(N,N);%这个I是给H扩充维度的 I----N*N
for i = 1:N
    I(i,i)=1;
end

R = zeros(N,N);
Q = zeros(N,N);% Let Q = I
for i = 1:N
    Q(i,i)=1;
end
%Aim : Q_tra =Hn-1 *..*H2*H1
Q_tra=zeros(N,N);% Let Q_tra = I
for i = 1:N
    Q_tra(i,i)=1;
end

for i = 1:N-1
    %H=I-2uu':  firstly, Let I
    I_new = zeros(N+1-i,N+1-i);
    for t = 1:N+1-i
        I_new(t,t)=1;
    end
        
    a=A1(:,1);
    if(sum(a)==0)%Judge:? a=(0,0,..,0)
        %Update H=I
        A_new = I * A_new;
        A1 = A_new([i+1,N],[i+1,N]);
    
        %find Q=H1*H2*H2*H3*...Hn-1
        Q = Q * I; 
    
        %find Q_tra=Hn-1*...*H2*H1
        Q_tra = I * Q_tra;
    end
    b = zeros(N+1-i,1);% Ha=b=(||a||,...0,0)'
    b(1)= norm(a);
    
    %Find u
    
    u = (b - a)/norm(b-a);
    
    %Secondly, B=-2uu'
    B = (-2)*u*(u');
    %disp(B);
    
    %Thirdly,H = I+B
    H_new = I_new + B;%H_new----(N+1-i)*(N+1-i)
    %H的扩充
    I_1=I;%I----N*N
    for j=i:N
        for k=i:N
            I_1(j,k)=H_new(j+1-i,k+1-i);
        end
    end
    H = I_1;
    disp(H);
    %Update A1 = H*A1
    
    A_new = H * A_new;
    A1 = A_new([i+1,N],[i+1,N]);
    
    %find Q=H1*H2*H2*H3*...Hn-1
    Q = Q * H; 
    
    %find Q_tra=Hn-1*...*H2*H1
    Q_tra = H * Q_tra;
end

R = Q_tra*A; % A---Original matrix(donnot change)
end

function [Q,R]=Method_2(A)
%Method==2 :Метод вращающейся матрицы (matrix Givens)
%A = Q * R
%idea : a=[a1,a2],ai----vector
%M(t)a=[||ai||,0],t--[0,2PI]
N = size(A,1);%This is the number of square matrix
R=A;
Q=zeros(N,N);
for i = 1:N % Let Q=I
    Q(i,i)=1;
end
%Let givens matrix = I
G=zeros(N,N);
for i = 1:N
    G(i,i)=1;
end


for j=1:N-1
    for i=j+1:N
        a=[R(j,j);R(i,j)];%列向量了
        d=sqrt(a(1)^2+a(2)^2);
        cos = a(1) / d;
        sin = a(2) / d;
        
        %find G(i,j)
        G_now=G;
        G_now(i,i)=cos;
        G_now(i,j)=-sin;
        G_now(j,i)=sin;
        G_now(j,j)=cos;
        
        %Update Q
        Q = Q * G_now;
        R = G_now * R;
    end
end

        
end

function [Q,R]=Method_3(A)
%Method==3 :Modified Gram-Schmidt(MGS)
%idea : A=[a1,a2,..,a3]
%ai----->qi
A3=A;
N = size(A,1);%This is the number of square matrix
Q=zeros(N,N);
R=zeros(N,N);

%step 1 !!!!!!
a1=A(:,1);
a1_norm=norm(a1);
for i = 1:N
    Q(i,1)=a1(i,1)/a1_norm;
end

%step 2---N !!!!
for j = 2:N
    a=A(:,j);
    p=a;
    for i = 1:j-1
        q=Q(:,i);
        p = p - q*((q')*p);
    end
    
    p_norm=norm(p);
    for i = 1:N
        Q(i,j)=p(i)/p_norm;
    end
end

R = (Q') * A;%Q-orthogonal matrix Q'=Q^(-1)

end








    
    
    
    


