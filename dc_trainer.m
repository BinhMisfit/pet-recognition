function [result,w,U,S,V,threshold]=dc_trainer(dog0,cat0,feature)
    nd=length(dog0(1,:));
    nc=length(cat0(1,:));
    [U,S,V] = svd([dog0,cat0],0); % reduced SVD
    animals = S*V';
    U = U(:,1:feature);
    dogs = animals(1:feature,1:nd);
    cats = animals(1:feature,nd+1:nd+nc);
    
    md = mean(dogs,2);
    mc = mean(cats,2);
    
    Sw=0; % within class variances
    for i=1:nd
        Sw = Sw + (dogs(:,i)-md)*(dogs(:,i)-md)';
    end
    for i=1:nc
        Sw = Sw + (cats(:,i)-mc)*(cats(:,i)-mc)';
    end
    
    Sb = (md-mc)*(md-mc)'; % between class
    [V2,D] = eig(Sb,Sw); % linear discriminant analysis
    [lambda,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    vdog = w'*dogs; vcat = w'*cats;
    result = [vdog,vcat];
    
    if mean(vdog)>mean(vcat)
        w = -w;
        vdog = -vdog;
        vcat = -vcat;
    end
    sortdog = sort(vdog);
    sortcat = sort(vcat);
    t1 = length(sortdog);
    t2 = 1;
    while sortdog(t1)>sortcat(t2)
        t1 = t1-1;
        t2 = t2+1;
    end
    threshold = (sortdog(t1)+sortcat(t2))/2;
end