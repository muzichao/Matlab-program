function [aver_D,d]=Aver_Path_Length(A) %求网络的平均路径长度和直径
%  A————————网络图的邻接矩阵
%  D————————返回值：网络图的距离矩阵
%  aver_D———————返回值：网络图的平均路径长度
%  d————————网络的直径
 N=size(A,2);
 D=A;
 D(find(D==0))=inf;    %将邻接矩阵变为邻接距离矩阵，两点无边相连时赋值为inf，自身到自身的距离为0.
 for i=1:N           
     D(i,i)=0;       
 end   
 for k=1:N            %Floyd算法求解任意两点的最短距离
     for i=1:N
         for j=1:N
             if D(i,j)>D(i,k)+D(k,j)
                D(i,j)=D(i,k)+D(k,j);
             end
         end
     end
 end
 aver_D=sum(sum(D))/(N*(N-1));  %平均路径长度
 d=max(max(D));
 if aver_D==inf
     disp('该网络图不是连通图');
 end
         
 
 
 
 