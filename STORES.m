function [S] = STORES(JB,JE,NDOF,NSC,GK,S)

%Function STORES for storing member global stiffness matrix in structure
%stiffness matrix.

for i=1:4
    if i<=2
        i1=(JB-1)*2+i;
    else
        i1=(JE-1)*2+(i-2);
    end
    n1=NSC(i1);
        if n1<=NDOF
            for j=1:4
                if j<=2
                    i1=(JB-1)*2+j;
                else
                    i1=(JE-1)*2+(j-2);
                end          
                n2=NSC(i1);                                 
                    if n2<=NDOF
                        S(n1,n2)=S(n1,n2)+GK(i,j);                                            
                    end
            end
        end     
        
end
end
    