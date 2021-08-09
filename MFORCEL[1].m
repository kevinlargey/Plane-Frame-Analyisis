function[Q] = MFORCEL(BK,U,Q)

%Function MFORCEL for determining member local force vector.

Q=zeros(2,1);

Q=BK*U;

end


