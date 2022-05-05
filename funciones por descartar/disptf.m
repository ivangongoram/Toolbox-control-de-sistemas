function [] =disptf(numi,deni)
pretty(vpa(numi/deni,4))
disp(strcat('transfer function-',char(symvar(numi/deni))))
end