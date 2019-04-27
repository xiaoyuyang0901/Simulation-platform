%===============================================================
% MPC模块的非线性约束方程
%===============================================================
function c = MPC_Nonlcon( var,state_0,NP,dt,v_ref )

    x_start     = 0;
    y_start     = x_start + NP;
    phi_start   = y_start + NP;
    cte_start   = phi_start + NP;
    ephi_start  = cte_start + NP;
    delta_start = ephi_start + NP;
    
    x_0     = state_0(1);
    y_0     = state_0(2);
    phi_0   = state_0(3) / 180 * pi;
    v       = v_ref;
%     delta_0 = state_0(5);
    delta_0 = 0;
    lf      = 3;
    
    c = zeros( 6*NP+1,1 );
    for i = 1:1:NP
        if i == 1
            c( x_start + i )    =  var(x_start + i )    -  x_0   -  v * cos( phi_0 ) * dt;
            c( y_start + i )    =  var(y_start + i )    -  y_0   -  v * sin( phi_0 ) * dt;
            c( phi_start + i )  =  var(phi_start + i )  -  phi_0 -  v /lf * tan(  delta_0  ) * dt; 
            % 参考轨迹为 y = 0.5 * sin( 0.1 * pi * x ) 
%             c( cte_start + i )  =  var(cte_start + i )  - (  0.5*sin(0.1*pi*x_0) - var(y_start + i )     );
%             c( ephi_start + i ) =  var(ephi_start + i)  - (  var(phi_start + i ) - 0.05*pi*cos(0.1*pi* x_0)   );
            % 参考轨迹为  y = 1
            c( cte_start + i )  =  var(cte_start + i )  - (  1 - var(y_start + i )     );
            c( ephi_start + i ) =  var(ephi_start + i)  - (  var(phi_start + i ) - 0   );
            c( delta_start + i )=  var(delta_start + i);
            c( delta_start + i + NP)=  var(delta_start + i) -  delta_0 ;
            
        else
            c( x_start + i )    =  var(x_start + i )    -  var(x_start + i-1 )    -   v * cos( var(phi_start + i-1) ) * dt;
            c( y_start + i )    =  var(y_start + i )    -  var(y_start + i-1)     -   v * sin( var(phi_start + i-1) ) * dt;
            c( phi_start + i )  =  var(phi_start + i )  -  var(phi_start + i-1)   -   v/lf * tan(  var(delta_start + i-1)  )  * dt;
            % 参考轨迹为 y = 0.5 * sin( 0.1 * pi * x )  
%             c( cte_start + i )  =  var(cte_start + i )  -  (  0.5*sin(0.1*pi*var(x_start + i)) - var(y_start + i )   + v * sin( var(ephi_start+i-1) ) * dt  );
%             c( ephi_start + i ) =  var(ephi_start + i)  -  (  var(phi_start + i )   - 0.05*pi*cos(0.1*pi*var(x_start + i))  ); 
            % 参考轨迹为  y = 1
            c( cte_start + i )  =  var(cte_start + i )  -  (  1 - var(y_start + i )   + v * sin( var(ephi_start+i-1) ) * dt  );
            c( ephi_start + i ) =  var(ephi_start + i)  -  (  var(phi_start + i ) - 0  );  
            c( delta_start + i )=  var(delta_start + i);
        end     
    end
    
   
end