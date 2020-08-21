function veteeg = RuidFun(veteeg, sigma, homovar) 
if homovar == 1
    veteeg = veteeg+normrnd(0,sigma,[1,length(veteeg)]);
elseif homovar == 2
    aaa = normrnd(0,sigma,[1,length(veteeg)]);
    aaa = aaa(1:end)*(rand*3);
    veteeg = veteeg+aaa;
end
