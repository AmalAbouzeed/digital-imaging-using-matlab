X=imread('eid.jpeg');
Y=rgb2gray(X);
imshow(Y),title ('grey image' );

cd=double(X);
figure, imshow (cd),title ('doubled image' )
figure, imshow (cd/255),title ('original image' )
figure, imshow (cd/512),title('low contrast image' )
figure, imshow (cd/128),title ('high contrast image' );

y0=imresize (imresize (X, 1/2) , 2) ;
%% 
yl=imresize (imresize (X, 1/4) , 4) ;
y2=imresize (imresize (X, 1/8) , 8) ;
y3=imresize (imresize (X, 1/16) , 16) ;
y4=imresize (imresize (X, 1/32) , 32) ;
subplot (2, 3, 1) , imshow (X) , title ('original image' )
subplot (2, 3, 2) , imshow (y0) , title ('128*128')
subplot (2, 3, 3) , imshow (yl) , title ('64*64' )
subplot (2, 3, 4) , imshow (y2) , title ('32*32')
subplot (2, 3, 5) , imshow (y3) , title ('16*16')
subplot (2, 3, 6) , imshow (y4) , title ('8*8')
%% 

testFile = 'eid.jpeg';
ORG = imread(testFile);
[height, width] = size(ORG);
imgOut = zeros(height,width);
hBlank = 20;
% make sure we have enough vertical blanking to filter the histogram
vBlank = ceil(2^14/(width+hBlank));
for frame = 1:2
    disp(['working on frame: ', num2str(frame)]);
    for y_in = 0:height+vBlank-1
        %disp(['frame: ', num2str(frame), ' of 2, row: ', num2str(y_in)]);
        for x_in = 0:width+hBlank-1
            if x_in < width && y_in < height
                pixel_in = double(ORG(y_in+1, x_in+1));
            else
                pixel_in = 0;
            end
            
            [x_out, y_out, pixel_out] = ...
                mlhdlc_heq(x_in, y_in, pixel_in, width, height);
                       
            if x_out < width && y_out < height
                imgOut(y_out+1,x_out+1) = pixel_out;
            end
        end
    end
    % normalize image to 255
    imgOut = round(255*imgOut/max(max(imgOut)));
    
    figure(1)
    subplot(2,2,1); imshow(ORG, [0,255]);
    title('Original Image');
    subplot(2,2,2); imshow(imgOut, [0,255]);
    title('Equalized Image');
    subplot(2,2,3); hist(double(ORG(:)),2^14-1);
    axis([0, 255, 0, 1500])
    title('Histogram of original Image');
    subplot(2,2,4); hist(double(imgOut(:)),2^14-1);
    axis([0, 255, 0, 1500])
    title('Histogram of equalized Image');
end
