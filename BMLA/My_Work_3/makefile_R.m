function makefile_R (name,Matrix,matrix_name)
%name : filenames
%Matrix : Real matrix (square)
fid = fopen(name,'w');
if fid < 0
    error("File cannot open(File matrix cannot make)!!!");
end
N = size(Matrix,1);
fprintf(fid,"%s = ...\n",matrix_name);
fprintf(fid,'[');
for i=1:N
    for j=1:N
        fprintf(fid,"%0.6f",Matrix(i,j));
        if (i==N) &&(j==N)
            fprintf(fid,"];");
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

        