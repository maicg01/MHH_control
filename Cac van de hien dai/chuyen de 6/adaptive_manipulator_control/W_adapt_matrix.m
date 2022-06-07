function [ W ] = W_adapt_matrix(q,dq,ddq)

  persistent params 
  persistent P_mat
  persistent K_mat
  

  com_upper_leg = 0.5;
  com_lower_leg = 0.5;
  mass_upper_leg = 1;
  mass_lower_leg = 1;
  l_upper_leg = 1;
  l_lower_leg = 1;
  g=9.8;
  
  % this is what we are trying to identify
  target_params = [ 1 ; 1 ; 1 ; 1 ; 1]*0.8;
  
  %com_adjustments = [1; 1; 1; 1; 1];
  
  % forgetting factor
  l = ones(5,1);
  
  
  %com_adjustments = params;
  
  W_ca4_1 = 0;
  W_ca4_2 = 0;
  W_ca4_5 = 0;
  W_adapt(1,1)=com_upper_leg^2*(ddq(1)*mass_upper_leg + ddq(3)*mass_upper_leg*sin(q(2)) + 2*dq(3)*...
         dq(2)*mass_upper_leg*cos(q(2)) - ddq(1)*mass_upper_leg*cos(q(3))^2*cos(q(2))^2 + dq(2)^2*mass_upper_leg*...
         cos(q(3))*sin(q(3))*sin(q(2)) - 2*dq(3)*dq(2)*mass_upper_leg*cos(q(3))^2*cos(q(2)) - ddq(2)*mass_upper_leg*...
         cos(q(3))*cos(q(2))*sin(q(3)) + 2*dq(3)*dq(1)*mass_upper_leg*cos(q(3))*cos(q(2))^2*sin(q(3)) + 2*dq(2)*dq(1)*...
         mass_upper_leg*cos(q(3))^2*cos(q(2))*sin(q(2)));
  W_adapt(1,2)=0;
  W_adapt(1,3)=com_lower_leg^2*(ddq(1)*mass_lower_leg*cos(q(2))^2 + ddq(1)*mass_lower_leg*...
         cos(q(4))^2 + ddq(3)*mass_lower_leg*cos(q(4))^2*sin(q(2)) - ddq(1)*mass_lower_leg*cos(q(2))^2*cos(q(4))^2 -...
          dq(2)*dq(1)*mass_lower_leg*sin(2*q(2)) - dq(1)*dq(4)*mass_lower_leg*sin(2*q(4)) + ddq(4)*mass_lower_leg*...
         cos(q(2))*sin(q(3)) + 2*dq(3)*dq(4)*mass_lower_leg*cos(q(3))*cos(q(2)) + 2*dq(3)*dq(2)*mass_lower_leg*...
         cos(q(2))*cos(q(4))^2 - ddq(1)*mass_lower_leg*cos(q(3))^2*cos(q(2))^2*cos(q(4))^2 + dq(3)^2*mass_lower_leg*...
         cos(q(2))*cos(q(4))*sin(q(3))*sin(q(4)) - dq(2)^2*mass_lower_leg*cos(q(2))*cos(q(4))*sin(q(3))*sin(q(4)) + 2*...
         dq(1)*dq(4)*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(2)) + 2*dq(2)*dq(1)*mass_lower_leg*cos(q(3))*...
         cos(q(4))*sin(q(4)) - 2*dq(3)*dq(4)*mass_lower_leg*cos(q(4))*sin(q(2))*sin(q(4)) + dq(2)^2*mass_lower_leg*...
         cos(q(3))*cos(q(4))^2*sin(q(3))*sin(q(2)) - 2*dq(3)*dq(4)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))^2 + 2*...
         dq(2)*dq(1)*mass_lower_leg*cos(q(2))*cos(q(4))^2*sin(q(2)) + 2*dq(1)*dq(4)*mass_lower_leg*cos(q(2))^2*...
         cos(q(4))*sin(q(4)) - 2*dq(2)*dq(4)*mass_lower_leg*cos(q(4))^2*sin(q(3))*sin(q(2)) - ddq(3)*mass_lower_leg*...
         cos(q(3))*cos(q(2))*cos(q(4))*sin(q(4)) - ddq(2)*mass_lower_leg*cos(q(4))*sin(q(3))*sin(q(2))*sin(q(4)) - 2*...
         dq(3)*dq(2)*mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4))^2 - ddq(2)*mass_lower_leg*cos(q(3))*cos(q(2))*...
         cos(q(4))^2*sin(q(3)) - 4*dq(1)*dq(4)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))^2*sin(q(2)) - 4*dq(2)*dq(1)*...
         mass_lower_leg*cos(q(3))*cos(q(2))^2*cos(q(4))*sin(q(4)) - 2*ddq(1)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*...
         sin(q(2))*sin(q(4)) + 2*dq(3)*dq(1)*mass_lower_leg*cos(q(3))*cos(q(2))^2*cos(q(4))^2*sin(q(3)) + 2*dq(2)*...
         dq(1)*mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4))^2*sin(q(2)) + 2*dq(1)*dq(4)*mass_lower_leg*...
         cos(q(3))^2*cos(q(2))^2*cos(q(4))*sin(q(4)) + 2*dq(2)*dq(4)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*...
         sin(q(3))*sin(q(4)) + 2*dq(3)*dq(1)*mass_lower_leg*cos(q(2))*cos(q(4))*sin(q(3))*sin(q(2))*sin(q(4)));
  W_adapt(1,4)=-com_lower_leg*(2*dq(1)*dq(4)*l_upper_leg*mass_lower_leg*sin(q(4)) - 2*ddq(3)*...
         l_upper_leg*mass_lower_leg*cos(q(4))*sin(q(2)) - 2*ddq(1)*l_upper_leg*mass_lower_leg*cos(q(4)) + ddq(3)*...
         l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(4)) - ddq(4)*l_upper_leg*mass_lower_leg*cos(q(2))*...
         cos(q(4))*sin(q(3)) + ddq(2)*l_upper_leg*mass_lower_leg*sin(q(3))*sin(q(2))*sin(q(4)) - dq(3)^2*l_upper_leg*...
         mass_lower_leg*cos(q(2))*sin(q(3))*sin(q(4)) + dq(2)^2*l_upper_leg*mass_lower_leg*cos(q(2))*sin(q(3))*sin(q(4)) +...
          dq(4)^2*l_upper_leg*mass_lower_leg*cos(q(2))*sin(q(3))*sin(q(4)) - 4*dq(3)*dq(2)*l_upper_leg*mass_lower_leg*...
         cos(q(2))*cos(q(4)) - 2*dq(2)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))*sin(q(4)) + 2*dq(3)*dq(4)*...
         l_upper_leg*mass_lower_leg*sin(q(2))*sin(q(4)) + 2*ddq(1)*l_upper_leg*mass_lower_leg*cos(q(3))^2*cos(q(2))^2*...
         cos(q(4)) + 2*ddq(2)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(3)) + 2*ddq(1)*l_upper_leg*...
         mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(2))*sin(q(4)) - 2*dq(1)*dq(4)*l_upper_leg*mass_lower_leg*cos(q(3))^2*...
         cos(q(2))^2*sin(q(4)) - 2*dq(2)^2*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(3))*sin(q(2)) + 2*dq(2)*...
         dq(4)*l_upper_leg*mass_lower_leg*cos(q(4))*sin(q(3))*sin(q(2)) + 4*dq(3)*dq(2)*l_upper_leg*mass_lower_leg*...
         cos(q(3))^2*cos(q(2))*cos(q(4)) + 4*dq(2)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))^2*sin(q(4)) + 2*...
         dq(1)*dq(4)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(2)) - 2*dq(2)*dq(4)*...
         l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(3))*sin(q(4)) - 2*dq(3)*dq(1)*l_upper_leg*mass_lower_leg*...
         cos(q(2))*sin(q(3))*sin(q(2))*sin(q(4)) - 4*dq(3)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))^2*...
         cos(q(4))*sin(q(3)) - 4*dq(2)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4))*sin(q(2)));
  W_adapt(1,5)=ddq(1)*l_upper_leg^2*mass_lower_leg + ddq(3)*l_upper_leg^2*mass_lower_leg*sin(q(2)) +...
          2*dq(3)*dq(2)*l_upper_leg^2*mass_lower_leg*cos(q(2)) - ddq(1)*l_upper_leg^2*mass_lower_leg*...
         cos(q(3))^2*cos(q(2))^2 - 2*dq(3)*dq(2)*l_upper_leg^2*mass_lower_leg*cos(q(3))^2*cos(q(2)) - ddq(2)*...
         l_upper_leg^2*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(3)) + dq(2)^2*l_upper_leg^2*mass_lower_leg*cos(q(3))*...
         sin(q(3))*sin(q(2)) + 2*dq(3)*dq(1)*l_upper_leg^2*mass_lower_leg*cos(q(3))*cos(q(2))^2*sin(q(3)) + 2*dq(2)*...
         dq(1)*l_upper_leg^2*mass_lower_leg*cos(q(3))^2*cos(q(2))*sin(q(2));
  W_adapt(2,1)=-com_upper_leg^2*(dq(3)*dq(2)*mass_upper_leg*sin(2*q(3)) - ddq(2)*mass_upper_leg*...
         cos(q(3))^2 + dq(1)^2*mass_upper_leg*cos(q(3))^2*cos(q(2))*sin(q(2)) + 2*dq(3)*dq(1)*mass_upper_leg*cos(q(3))^2*...
         cos(q(2)) + ddq(1)*mass_upper_leg*cos(q(3))*cos(q(2))*sin(q(3)));
  W_adapt(2,2)=-com_upper_leg*g*mass_upper_leg*cos(q(3))*sin(q(2));
  W_adapt(2,3)=-com_lower_leg^2*(ddq(4)*mass_lower_leg*cos(q(3)) - ddq(2)*mass_lower_leg + ddq(2)*...
         mass_lower_leg*cos(q(4))^2 - (dq(1)^2*mass_lower_leg*sin(2*q(2)))/2 - 2*dq(3)*dq(4)*mass_lower_leg*sin(q(3)) -...
          ddq(2)*mass_lower_leg*cos(q(3))^2*cos(q(4))^2 - dq(2)*dq(4)*mass_lower_leg*sin(2*q(4)) + dq(3)^2*...
         mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(4)) + dq(1)^2*mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(4)) - 2*dq(1)*...
         dq(4)*mass_lower_leg*sin(q(3))*sin(q(2)) + dq(1)^2*mass_lower_leg*cos(q(2))*cos(q(4))^2*sin(q(2)) + 2*...
         dq(3)*dq(4)*mass_lower_leg*cos(q(4))^2*sin(q(3)) + ddq(3)*mass_lower_leg*cos(q(4))*sin(q(3))*sin(q(4)) -...
          2*dq(1)^2*mass_lower_leg*cos(q(3))*cos(q(2))^2*cos(q(4))*sin(q(4)) + 2*dq(3)*dq(2)*mass_lower_leg*...
         cos(q(3))*cos(q(4))^2*sin(q(3)) + 2*dq(2)*dq(4)*mass_lower_leg*cos(q(3))^2*cos(q(4))*sin(q(4)) + 2*dq(1)*...
         dq(4)*mass_lower_leg*cos(q(4))^2*sin(q(3))*sin(q(2)) + dq(1)^2*mass_lower_leg*cos(q(3))^2*cos(q(2))*...
         cos(q(4))^2*sin(q(2)) + ddq(1)*mass_lower_leg*cos(q(4))*sin(q(3))*sin(q(2))*sin(q(4)) + 2*dq(3)*dq(1)*...
         mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4))^2 + ddq(1)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))^2*...
         sin(q(3)) + 2*dq(3)*dq(1)*mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(2))*sin(q(4)) - 2*dq(1)*dq(4)*...
         mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(3))*sin(q(4)));
  W_adapt(2,4)=-com_lower_leg*(ddq(4)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(4)) - g*...
         mass_lower_leg*cos(q(2))*sin(q(4)) + ddq(3)*l_upper_leg*mass_lower_leg*sin(q(3))*sin(q(4)) - 2*ddq(2)*l_upper_leg*...
         mass_lower_leg*cos(q(3))^2*cos(q(4)) + dq(3)^2*l_upper_leg*mass_lower_leg*cos(q(3))*sin(q(4)) + dq(1)^2*...
         l_upper_leg*mass_lower_leg*cos(q(3))*sin(q(4)) - dq(4)^2*l_upper_leg*mass_lower_leg*cos(q(3))*sin(q(4)) + g*...
         mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(2)) + 2*dq(2)*dq(4)*l_upper_leg*mass_lower_leg*cos(q(3))^2*sin(q(4)) +...
          ddq(1)*l_upper_leg*mass_lower_leg*sin(q(3))*sin(q(2))*sin(q(4)) - 2*dq(1)^2*l_upper_leg*mass_lower_leg*...
         cos(q(3))*cos(q(2))^2*sin(q(4)) + 2*ddq(1)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*...
         sin(q(3)) + 4*dq(3)*dq(2)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(3)) + 2*dq(3)*dq(1)*l_upper_leg*...
         mass_lower_leg*cos(q(3))*sin(q(2))*sin(q(4)) + 2*dq(1)^2*l_upper_leg*mass_lower_leg*cos(q(3))^2*cos(q(2))*...
         cos(q(4))*sin(q(2)) + 4*dq(3)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4)) - 2*dq(1)*...
         dq(4)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(3))*sin(q(4)));
  W_adapt(2,5)=ddq(2)*l_upper_leg^2*mass_lower_leg*cos(q(3))^2 - g*l_upper_leg*mass_lower_leg*...
         cos(q(3))*sin(q(2)) - dq(3)*dq(2)*l_upper_leg^2*mass_lower_leg*sin(2*q(3)) - dq(1)^2*l_upper_leg^2*...
         mass_lower_leg*cos(q(3))^2*cos(q(2))*sin(q(2)) - 2*dq(3)*dq(1)*l_upper_leg^2*mass_lower_leg*cos(q(3))^2*cos(q(2)) -...
          ddq(1)*l_upper_leg^2*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(3));
  W_adapt(3,1)=com_upper_leg^2*(ddq(3)*mass_upper_leg + ddq(1)*mass_upper_leg*sin(q(2)) + (dq(2)^2*...
         mass_upper_leg*sin(2*q(3)))/2 - dq(1)^2*mass_upper_leg*cos(q(3))*cos(q(2))^2*sin(q(3)) + 2*dq(2)*dq(1)*...
         mass_upper_leg*cos(q(3))^2*cos(q(2)));
  W_adapt(3,2)=-com_upper_leg*g*mass_upper_leg*cos(q(2))*sin(q(3));
  W_adapt(3,3)=-com_lower_leg^2*(dq(3)*dq(4)*mass_lower_leg*sin(2*q(4)) - ddq(1)*mass_lower_leg*...
         cos(q(4))^2*sin(q(2)) - ddq(3)*mass_lower_leg*cos(q(4))^2 - dq(2)^2*mass_lower_leg*cos(q(3))*cos(q(4))^2*...
         sin(q(3)) + 2*dq(2)*dq(4)*mass_lower_leg*cos(q(4))^2*sin(q(3)) + ddq(2)*mass_lower_leg*cos(q(4))*sin(q(3))*...
         sin(q(4)) + 2*dq(1)*dq(4)*mass_lower_leg*cos(q(4))*sin(q(2))*sin(q(4)) + 2*dq(1)*dq(4)*mass_lower_leg*...
         cos(q(3))*cos(q(2))*cos(q(4))^2 + ddq(1)*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(4)) + dq(1)^2*...
         mass_lower_leg*cos(q(3))*cos(q(2))^2*cos(q(4))^2*sin(q(3)) - 2*dq(2)*dq(1)*mass_lower_leg*cos(q(3))^2*cos(q(2))*...
         cos(q(4))^2 - 2*dq(2)*dq(1)*mass_lower_leg*cos(q(3))*cos(q(4))*sin(q(2))*sin(q(4)) + dq(1)^2*mass_lower_leg*...
         cos(q(2))*cos(q(4))*sin(q(3))*sin(q(2))*sin(q(4)));
  W_adapt(3,4)=-com_lower_leg*(ddq(2)*l_upper_leg*mass_lower_leg*sin(q(3))*sin(q(4)) - 2*ddq(1)*...
         l_upper_leg*mass_lower_leg*cos(q(4))*sin(q(2)) - 2*ddq(3)*l_upper_leg*mass_lower_leg*cos(q(4)) + g*...
         mass_lower_leg*cos(q(2))*cos(q(4))*sin(q(3)) + 2*dq(3)*dq(4)*l_upper_leg*mass_lower_leg*sin(q(4)) + ddq(1)*...
         l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*sin(q(4)) - 2*dq(2)^2*l_upper_leg*mass_lower_leg*cos(q(3))*...
         cos(q(4))*sin(q(3)) + 2*dq(2)*dq(4)*l_upper_leg*mass_lower_leg*cos(q(4))*sin(q(3)) + 2*dq(1)*dq(4)*...
         l_upper_leg*mass_lower_leg*sin(q(2))*sin(q(4)) + dq(1)^2*l_upper_leg*mass_lower_leg*cos(q(2))*sin(q(3))*...
         sin(q(2))*sin(q(4)) + 2*dq(1)*dq(4)*l_upper_leg*mass_lower_leg*cos(q(3))*cos(q(2))*cos(q(4)) - 2*dq(2)*dq(1)*...
         l_upper_leg*mass_lower_leg*cos(q(3))*sin(q(2))*sin(q(4)) + 2*dq(1)^2*l_upper_leg*mass_lower_leg*cos(q(3))*...
         cos(q(2))^2*cos(q(4))*sin(q(3)) - 4*dq(2)*dq(1)*l_upper_leg*mass_lower_leg*cos(q(3))^2*cos(q(2))*cos(q(4)));
  W_adapt(3,5)=ddq(3)*l_upper_leg^2*mass_lower_leg + (dq(2)^2*l_upper_leg^2*mass_lower_leg*sin(2*...
         q(3)))/2 + ddq(1)*l_upper_leg^2*mass_lower_leg*sin(q(2)) - g*l_upper_leg*mass_lower_leg*cos(q(2))*sin(q(3)) -...
          dq(1)^2*l_upper_leg^2*mass_lower_leg*cos(q(3))*cos(q(2))^2*sin(q(3)) + 2*dq(2)*dq(1)*l_upper_leg^2*...
         mass_lower_leg*cos(q(3))^2*cos(q(2));
  W_adapt(4,1)=W_ca4_1*com_upper_leg^2;
  W_adapt(4,2)=W_ca4_2*com_upper_leg;
  W_adapt(4,3)=com_lower_leg^2*mass_lower_leg*(ddq(4) + (dq(3)^2*sin(2*q(4)))/2 - (dq(2)^2*sin(2*...
         q(4)))/2 + (dq(1)^2*sin(2*q(4)))/2 - ddq(2)*cos(q(3)) + ddq(1)*cos(q(2))*sin(q(3)) + dq(2)^2*cos(q(3))^2*...
         cos(q(4))*sin(q(4)) - dq(1)^2*cos(q(2))^2*cos(q(4))*sin(q(4)) + 2*dq(3)*dq(2)*cos(q(4))^2*sin(q(3)) - dq(1)^2*...
         cos(q(3))*cos(q(2))*sin(q(2)) - 2*dq(2)*dq(1)*sin(q(3))*sin(q(2)) + 2*dq(3)*dq(1)*cos(q(3))*cos(q(2))*...
         cos(q(4))^2 + 2*dq(2)*dq(1)*cos(q(4))^2*sin(q(3))*sin(q(2)) - dq(1)^2*cos(q(3))^2*cos(q(2))^2*cos(q(4))*...
         sin(q(4)) + 2*dq(3)*dq(1)*cos(q(4))*sin(q(2))*sin(q(4)) + 2*dq(1)^2*cos(q(3))*cos(q(2))*cos(q(4))^2*sin(q(2)) -...
          2*dq(2)*dq(1)*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(3))*sin(q(4)));
  W_adapt(4,4)=com_lower_leg*mass_lower_leg*(dq(3)^2*l_upper_leg*sin(q(4)) + dq(1)^2*l_upper_leg*...
         sin(q(4)) + g*cos(q(4))*sin(q(2)) - g*cos(q(3))*cos(q(2))*sin(q(4)) + dq(2)^2*l_upper_leg*cos(q(3))^2*...
         sin(q(4)) - ddq(2)*l_upper_leg*cos(q(3))*cos(q(4)) + 2*dq(3)*dq(2)*l_upper_leg*cos(q(4))*sin(q(3)) + 2*dq(3)*...
         dq(1)*l_upper_leg*sin(q(2))*sin(q(4)) + ddq(1)*l_upper_leg*cos(q(2))*cos(q(4))*sin(q(3)) - dq(1)^2*...
         l_upper_leg*cos(q(3))^2*cos(q(2))^2*sin(q(4)) + 2*dq(3)*dq(1)*l_upper_leg*cos(q(3))*cos(q(2))*cos(q(4)) +...
          dq(1)^2*l_upper_leg*cos(q(3))*cos(q(2))*cos(q(4))*sin(q(2)) - 2*dq(2)*dq(1)*l_upper_leg*cos(q(3))*cos(q(2))*...
         sin(q(3))*sin(q(4)));
  W_adapt(4,5)=W_ca4_5;

  
%  error = delta_tau - W_adapt * params_prev;
%  gf = (P_prev * params_prev) ./ (l + W_adapt * P_prev * (W_adapt'))
%  params = params_prev  + gf*error;
%  P = P_prev - (gf*W_adapt*P_prev) ./ l;
%params = [ 1 ; 1 ; 1 ; 1 ; 1]  

if(isempty(params))
    params = random('normal', 1, 0.1, 5, 1); 
    P_mat = eye(5);
    %K_mat = P_mat *  W_adapt' * inv(W_adapt*P_mat*W_adapt' + eye(5));
    W = W_adapt * params;
    W = [W ; (params-target_params).^2];
    return 
end

tau = W_adapt * target_params;
K_mat = P_mat *  W_adapt' * inv(W_adapt*P_mat*W_adapt' + eye(4));
params = params + K_mat*(tau - W_adapt * params);
P_mat = P_mat - K_mat*W_adapt*P_mat;

W = W_adapt * params;
W = [W ; (params-target_params).^2];

