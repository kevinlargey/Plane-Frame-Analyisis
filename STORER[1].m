function[R] = STORER(JB,JE,NDOF,NSC,F,R)

%Function STORER for storing member global forces in support reaction
%vector.

for i=1:4
    if i<=2
        i1=(JB-1)*2+i;
    else
        i1=(JE-1)*2+(i-2);
    end
    
    N=NSC(i1);
    
    if N>NDOF
        R(N-NDOF)=R(N-NDOF)+F(i);
    end
    
end

end
