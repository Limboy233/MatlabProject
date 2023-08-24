tic;

path_file_M = input('Please enter the path of matrix file:','s');
len=strlength(path_file_M);
index = len-2;
if exist(path_file_M,'file') ~=2
    error ('Can not find the file!!!');
end

run(path_file_M) 
%martix:A
%---------------
path_filebvec = input('Please enter the path of vector file:','s');
if exist(path_filebvec,'file') ~=2
    error ('Can not find the file!!!');
end

run(path_filebvec) 
%vector:b
%----------------

Eps=0.000001;

%Check Square
N = size(A,1);
for j = 1:N 
    if length(A(:,1))~=length(A(:,j))
        error('matrix isnot square!!!');
    end
end

%Check :The number of elements in each row of A is the same as that of B
for i=1:N
    if length(A(i,:))~=length(b)
        error('The number of elements in each row of matrix A is different from that of vector b!!!');
    end
end

%%Check Hermite
for i = 1:N
    for j = 1: N
        
        if i>j
            continue;
        end
        
        if abs(A(i,j) - conj(A(j,i)))>Eps
            error('matrix is not Hermiter!!!');
        end
    end
end
%main matrix minor positive
for n = 1:N
    M = A(1:n,1:n);
    if det(M)<=Eps
        error('principal minor not all positive number!!!');
    end
end

path_Cmat = extractBefore(path_file_M,len-6)+"Cmat"+path_file_M(index)+".m";
disp(path_Cmat);
if exist(path_Cmat,'file') ~=2
    disp("Please run the make_col first to get the decomposition martix(Please place file Cmat.m and file Amat.c in the same directory)");
    disp('Running the make_col!!!!!!!');
    make_col;
end
run(path_Cmat);

x = inv(C')*inv(C)*b;

path_x = "xvec" +path_file_M(index)+".m";
fid = fopen(path_x,"w");
if fid <0
    error("Canot Creat the file!!!");
end

if isreal(A)
    fprintf(fid,"x = [");
    for i=1:N
        fprintf(fid ,'%0.6f',x(i));
        if(i~=N)
            fprintf(fid,';');
        else
            fprintf(fid,"];");
        end
    end
else
    fprintf(fid,"x = complex([");
    for i=1:N
        fprintf(fid ,'%0.16f',real(x(i)));
        if(i~=N)
            fprintf(fid,';');
        else
            fprintf(fid,"],[");
        end
    end
    for i=1:N
        fprintf(fid ,'%0.16f',imag(x(i)));
        if(i~=N)
            fprintf(fid,';');
        else
            fprintf(fid,"]);");
        end
    end
end

times = toc;

if path_file_M(len-6:len) == "Amat4.m" 
    disp(times);
    fid = fopen("task_1c.txt","w");
    if fid <0
    error("Canot Creat the file task_1c.txt!!!");
    end
    fprintf(fid,"WorkTimes(Amat4.m) = %0.6f",times);
end

