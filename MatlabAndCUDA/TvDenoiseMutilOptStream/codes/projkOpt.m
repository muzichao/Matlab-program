function u = projkOpt(g, lambda, niter)

tau = 0.25;

[uy, ux] = size(g);

dh = zeros(uy, ux);
dv = zeros(uy, ux);
dht = zeros(uy, ux);
dvt = zeros(uy, ux);
dhtp = zeros(uy, ux);
dvtp = zeros(uy, ux);
dhvt = zeros(uy, ux);

idxNew = [2:ux, 1];
idxOld = 1:ux;
idyNew = [2:uy, 1];
idyOld = 1:uy;


% ��An Algorithm for Total Variation Minimization and Applications����3ҳ
for i = 1:niter
    % �� dhvt = -opQt(pn) - g ./ lambda
    dhvt = - dhvt - g ./ lambda;
    
    % �� S = opQ(dhvt) = opQ(-opQt(pn) - g ./ lambda)
    dh(:, idxOld) = dhvt(:, idxNew) - dhvt(:, idxOld);
    dv(idyOld, :) = dhvt(idyNew, :) - dhvt(idyOld, :);
    
    % �� R = (1 + tau * modulo(S))
    R = 1 + tau * sqrt((dh.^2 + dv.^2));
    
    % �� pn = [dht dvt]
    dhtp = (dhtp + tau * dh) ./ R;
    dvtp = (dvtp + tau * dv) ./ R;   
    
    % �� dhvt = opQt(pn)
    dht(:, idxNew) = dhtp(:, idxOld) - dhtp(:, idxNew);
    dvt(idyNew, :) = dvtp(idyOld, :) - dvtp(idyNew, :);
    dhvt = dht + dvt;
end

% �� u = -lambda .* opQt(pn)
u = -lambda .* dhvt;
