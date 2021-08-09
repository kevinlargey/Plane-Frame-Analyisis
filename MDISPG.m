function [V] = MDISPG(JB,JE,NDOF,NSC,d,V)

%Function MDISPG for determining member global displacement vector.

V=zeros(4,1);
j=(JB-1)*2;

for i=1:2
    j=j+1;
    N=NSC(j);
    if N<=NDOF
       V(i)=d(N);
    end
end

j=(JE-1)*2;
for i=3:4
    j=j+1;
    N=NSC(j);
    if N<=NDOF
       V(i)=d(N);
    end
end

end 