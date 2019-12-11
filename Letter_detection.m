function letter=readLetter(snap) % function taking an image

load NewTemplates %load the template file containing bmp letters for comparing
snap=imresize(snap,[42 24]); 
rec=[ ];

for n=1:length(NewTemplates) %end upto the length
    correlation=corr2(NewTemplates{1,n},snap);  %correlate each image with the mew templates images
    rec=[rec correlation];  % save result in rec array against index
end

index=find(rec==max(rec)); %find the max record
display(index); % display on cli

%chose alphabets or number against it and return to plate gui
% Alphabets listings.
if index==1 || index==2
    letter='A';
elseif index==3 || index==4
    letter='B';
elseif index==5
    letter='C';
elseif index==6 || index==7
    letter='D';
elseif index==8
    letter='E';
elseif index==9
    letter='F';
elseif index==10
    letter='G';
elseif index==11
    letter='H';
elseif index==12
    letter='I';
elseif index==13
    letter='J';
elseif index==14
    letter='K';
elseif index==15
    letter='L';
elseif index==16
    letter='M';
elseif index==17
    letter='N';
elseif index==18 || index==19
    letter='O';
elseif index==20 || index==21
    letter='P';
elseif index==22 || index==23
    letter='Q';
elseif index==24 || index==25
    letter='R';
elseif index==26
    letter='S';
elseif index==27
    letter='T';
elseif index==28
    letter='U';
elseif index==29
    letter='V';
elseif index==30
    letter='W';
elseif index==31
    letter='X';
elseif index==32
    letter='Y';
elseif index==33
    letter='Z';
    %*-*-*-*-*
% Numerals listings.
elseif index==34
    letter='1';
elseif index==35
    letter='2';
elseif index==36
    letter='3';
elseif index==37 || index==38
    letter='4';
elseif index==39
    letter='5';
elseif index==40 || index==41 || index==42
    letter='6';
elseif index==43
    letter='7';
elseif index==44 || index==45
    letter='8';
elseif index==46 || index==47 || index==48
    letter='9';
else
    letter='0';
end
end