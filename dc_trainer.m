function [result,w,U,S,V,threshold]=dc_trainer(dog0,cat0,feature)
    nd=length(dog0(1,:));
    nc=length(cat0(1,:));
    [U,S,V] = svd([dog0,cat0],0); % reduced SVD
    animals = S*V';
    U = U(:,1:feature);
    dogs = animals(1:feature,1:nd);
    cats = animals(1:feature,nd+1:nd+nc);
    
    for j=1:4
        subplot(2,2,j)
        ut1=reshape(U(:,j),32,32);
        ut2=ut1(32:-1:1,:);
        pcolor(ut2)
        set(gca,'Xtick',[],'Ytick',[])
    end
    
    figure(2)
    subplot(2,1,1)
    plot(diag(S),'ko','Linewidth',[2])
    set(gca,'Fontsize',[14],'Xlim',[0 80])
    subplot(2,1,2)
    semilogy(diag(S),'ko','Linewidth',[2])
    set(gca,'Fontsize',[14],'Xlim',[0 80])
    figure(3)
    for j=1:3
    subplot(3,2,2*j-1)
    plot(1:40,V(1:40,j),'ko-')
    subplot(3,2,2*j)
    plot(81:120,V(81:120,j),'ko-')
    end
    subplot(3,2,1), set(gca,'Ylim',[-.15 0],'Fontsize',[14]), title('dogs')
    subplot(3,2,2), set(gca,'Ylim',[-.15 0],'Fontsize',[14]), title('cats')
    subplot(3,2,3), set(gca,'Ylim',[-.2 0.2],'Fontsize',[14])
    subplot(3,2,4), set(gca,'Ylim',[-.2 0.2],'Fontsize',[14])
    subplot(3,2,5), set(gca,'Ylim',[-.2 0.2],'Fontsize',[14])
    subplot(3,2,6), set(gca,'Ylim',[-.2 0.2],'Fontsize',[14])
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
    % dog < threshold < cat
    sortdog = sort(vdog);
    sortcat = sort(vcat);
    t1 = length(sortdog);
    t2 = 1;
    while sortdog(t1)>sortcat(t2)
        t1 = t1-1;
        t2 = t2+1;
    end
    threshold = (sortdog(t1)+sortcat(t2))/2;
    
    figure(4)
    subplot(2,2,1)
    hist(sortdog,30); hold on, plot([18.22 18.22],[0 10],'r')
    set(gca,'Xlim',[-200 200],'Ylim',[0 10],'Fontsize',[14])
    title('dog')
    subplot(2,2,2)
    hist(sortcat,30,'r'); hold on, plot([18.22 18.22],[0 10],'r')
    set(gca,'Xlim',[-200 200],'Ylim',[0 10],'Fontsize',[14])
    title('cat')

end