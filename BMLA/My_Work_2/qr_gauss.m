tic;
path_Amat = input('Please enter the path of the martix files: ',"s");
len=strlength(path_Amat);
index = len-2;

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
%matrix:::A
%---------------------------
path_filebvec = input('Please enter the path of vector file:','s');
if exist(path_filebvec,'file') ~=2
    error ('Can not find the file!!!');
end
run(path_filebvec) 
if ~isreal(b)
    error("The vector is not real vector!!!");
end
%vector:::b
%-----------------------------------
Eps=0.000001;

%Check Square
N = size(A,1);
for j = 1:N 
    if length(A(:,1))~=length(A(:,j))
        error('matrix isnot square!!!');
    end
end

%Checking A is not singular
if det(A)<Eps
    error('matrix is singular!!!');
end

%Check :The number of elements in each row of A is the same as that of B
for i=1:N
    if length(A(i,:))~=length(b)
        error('The number of elements in each row of matrix A is different from that of vector b!!!');
    end
end
%----------
%load Q and R
path_Qmat = extractBefore(path_Amat,len-6)+"Qmat"+path_Amat(index)+".m";
disp(path_Qmat);
if exist(path_Qmat,'file') ~=2
    disp("Please run the make_qr first to get the decomposition martix(Please place file Qmat.m and file Amat.c in the same directory)");
    disp("Running make_qr!!!!!!");
    make_qr;
end
run(path_Qmat);

path_Rmat = extractBefore(path_Amat,len-6)+"Rmat"+path_Amat(index)+".m";
disp(path_Rmat);
if exist(path_Rmat,'file') ~=2
    disp("Please run the make_qr first to get the decomposition martix(Please place file Rmat.m and file Amat.c in the same directory)");
    disp("Running make_qr!!!!!!");
    make_qr;
end
run(path_Rmat);

%-----------------------
%Q^(-1)=Q'
x = R\((Q')*b);

path_x = "xvec" +path_Amat(index)+".m";
fid = fopen(path_x,"w");
if fid <0
    error("Canot Creat the file!!!");
end
fprintf(fid,"x = [");
for i=1:N
    fprintf(fid ,'%0.6f',x(i));
    if(i~=N)
        fprintf(fid,';');
    else
        fprintf(fid,"];");
    end
end

times = toc;

if path_Amat(len-6:len) == "Amat9.m" 
    disp(times);
    fid = fopen("task_2c.txt","w");
    if fid <0
    error("Canot Creat the file task_1c.txt!!!");
    end
    fprintf(fid,"WorkTimes(Amat9.m) = %0.6f",times);
end

