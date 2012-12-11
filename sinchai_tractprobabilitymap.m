clear all
load('/home1/image/image_data/070208D1_noASSET/tracts/072408/frontal_occipital_tracts_center_filtered_right.mat')
numberOfSlices = length(g_tract);

factor = 1;
%g_vol_dim = [ 512 512 120 ]
g_vol_dim = g_vol_dim.*factor;
g_tractp.sf = g_tractp.sf./factor;

% TPmap is indexed by (y,x,z) (MATLAB convention)
TPmap = zeros(g_vol_dim);
error = [ 0 0 0 ];

for i=1:numberOfSlices
        fprintf(['Processing slice number:....' num2str(i) '\n']);
    tracts = g_tract{i};
    numberOfTracts = length(tracts);
    for j=1:numberOfTracts
       %fprintf(['Processing tract number:....' num2str(j) '\n']);
       tractPoints = double(tracts{j}{2});
       col = tractPoints(:,1)/g_tractp.sf(1) + 0.5 + g_vol_dim(1)/2;
       col = round(col);
       
       row = - tractPoints(:,2)/g_tractp.sf(2) + 0.5 + g_vol_dim(2)/2;
       row = round(row);
       
       slice = tractPoints(:,3)/g_tractp.sf(3);
       slice = round(slice) + 1;
       try
            %TPmap(row,col,slice) = TPmap(row,col,slice) + 1;
            for k=1:length(row)
                TPmap(row(k),col(k),slice(k)) = TPmap(row(k),col(k),slice(k)) + 1;
            end
       catch
           err = row>g_vol_dim(2) | row<1;
           error = [ error ; row(err) col(err) slice(err) ];

           err = col>g_vol_dim(1) | col<1;
           error = [ error ; row(err) col(err) slice(err) ];

           err = slice>g_vol_dim(3) | slice<1;
           error = [ error ; row(err) col(err) slice(err) ];
           
           fprintf('\n error detected \n');
           
       end
           
    end

end
save '/home1/image/image_data/070208D1_noASSET/tracts/072408/tractCountMap.mat' TPmap error;
%save '/home/dti4/image_data/072208D1_noASSET/tractProbResults.mat' TPmap error;