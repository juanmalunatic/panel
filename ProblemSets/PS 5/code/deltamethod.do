logit union educ, vce(cluster nr)
mat V= e(V)
sum educ
global educmean = r(mean)
global p = exp(_b[_cons]+_b[educ]*$educmean)/(1+exp(_b[_cons]+_b[educ]*$educmean))
mat G = [$p*(1-$p)+_b[educ]*(1-2*$p)*$p*(1-$p)*$educmean, _b[educ]*(1-2*$p)*$p*(1-$p)]
mat Vmge = G*V*G'
disp in red "SE Marginal Effect " sqrt(Vmge[1,1])