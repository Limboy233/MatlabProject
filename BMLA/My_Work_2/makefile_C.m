function makefile_C(name,Matrix,matrix_name)
%name : filenames
%Matrix : Real matrix (square)
fid = fopen(name,'w');
if fid < 0
    error("File cannot open(File matrix cannot make)!!!");
end
N = size(Matrix,1);
fprintf(fid,"%s = complex([",matrix_name);
for i=1:N
    for j=1:N
        if real(Matrix(i,j))==0
            fprintf(fid,"0");
        else
            fprintf(fid,"%0.16f",real(Matrix(i,j)));
        end
        if (i==N) &&(j==N)
            fprintf(fid,"],[");
            break;
        end
        if j==N
            fprintf(fid,";\n");
        else
            fprintf(fid," ");
        end
    end
end
for i=1:N
    for j=1:N
        if imag(Matrix(i,j))==0
            fprintf(fid,"0");
        else
            fprintf(fid,"%0.16f",imag(Matrix(i,j)));
        end
        if (i==N) &&(j==N)
            fprintf(fid,"]);");
            break;
        end
        if j==N
            fprintf(fid,";\n");
        else
            fprintf(fid," ");
        end
    end
end
fclose(fid);
end