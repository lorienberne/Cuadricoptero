function med = alphaFilter(this,sigma1,sigma2,medidas)
  alpha = sigma2^2/(sigma1^2 + sigma1^2);
  med   = [alpha (1-alpha)]*medidas;
end
