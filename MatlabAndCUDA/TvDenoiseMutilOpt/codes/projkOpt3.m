function u = projkOpt3(g, lambda, niter)

tau = 0.25;

[uy, ux] = size(g);

dhtp = zeros(uy, ux);
dvtp = zeros(uy, ux);
dhvt = zeros(uy, ux);


% ��An Algorithm for Total Variation Minimization and Applications����3ҳ
for i = 1:niter
    % �� dhvt = -opQt(pn) - g ./ lambda
    dhvt = - dhvt - g ./ lambda;
    
    % �� S = opQ(dhvt) = opQ(-opQt(pn) - g ./ lambda)
    dh = conv2c(dhvt, [1 -1 0]);
    dv = conv2c(dhvt, [1 -1 0]');
    
    % �� R = (1 + tau * modulo(S))
    R = 1 + tau * sqrt((dh.^2 + dv.^2));
    
    % �� pn = [dht dvt]
    dhtp = (dhtp + tau * dh) ./ R;
    dvtp = (dvtp + tau * dv) ./ R;
    
    % �� dhvt = opQt(pn)
    dht = conv2c(dhtp, [0 -1 1]);
    dvt = conv2c(dvtp, [0 -1 1]');
    dhvt = dht + dvt;
end

% �� u = -lambda .* opQt(pn)
u = -lambda .* dhvt;

