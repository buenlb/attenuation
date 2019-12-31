
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData,0,11);

y = atten1000(fragsIdx1000Layers,centerIdx1000);
x = hu(fragsIdx1000Layers);

[p1,r1,~,x1,y1,conf1] = myPolyFit(x,y','poly',1);


[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData,0,20);

y = atten1000(fragsIdx1000Layers,centerIdx1000);
x = hu(fragsIdx1000Layers);

[p2,r2,~,x2,y2,conf2] = myPolyFit(x,y','poly',1);

figure
ax = gca;
shadedErrorBar(x1,y1,conf1','lineprops',{'color',ax.ColorOrder(1,:),'linewidth',2});
hold on
shadedErrorBar(x2,y2,conf2,'lineprops',{'color',ax.ColorOrder(2,:),'linewidth',2});
legend('11dB','20dB')