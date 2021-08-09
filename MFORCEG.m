function[F] = MFORCEG(T,Q,F)

%Function MFORCEG for determining member global force vector.

F=zeros(4,1);

F=T'*Q;


end


