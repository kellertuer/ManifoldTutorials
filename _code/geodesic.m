
M = spherefactory(2);

p = [0.0, 0.0, 1.0]
q = [0.0, 1.0, 0.0]
X = [0.0, 3*pi/2, 0.0]

t = 0:0.1:1

Y = M.log(p,q)
pts = zeros(3,length(t));
for i=1:length(t)
    pts(:,i) = M.exp(p, Y, t(i));
end

pts2 = zeros(3,length(t));
for i=1:length(t)
    pts2(:,i) = M.exp(p, X, t(i));
end


