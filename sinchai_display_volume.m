function sinchai_display_volume(varargin)

if nargin == 1
    volume = varargin{1};
    if ndims(volume)==3
        for i=1:size(volume,3)
            imshow(volume(:,:,i),[]);
            i
            pause;
            if i== size(volume,3)
                close;
            end
        end
    elseif ndims(volume)==4
        for i=1:size(volume,4)
            imshow(volume(:,:,:,i));
            i
            pause;
        end
    end
elseif nargin == 2
    volume = varargin{1};
    range = varargin{2};
    for i=1:size(volume,3)
        imshow(volume(:,:,i),range);
        i
        pause;
        if i== size(volume,3)
            close;
        end
    end
end