function MyPano(IML,IMR,TRANSFORMATION,TYPE)

if TYPE == 'a'
    IML = cast(IML,'uint8');
    IMR = cast(IMR,'uint8');
    iml_size = size(IML);
    imr_size = size(IMR);
    RA = imref2d(iml_size);
    RB = imref2d(imr_size);

    tform = affine2d([TRANSFORMATION(1),TRANSFORMATION(2),0
                  TRANSFORMATION(3),TRANSFORMATION(4),0
                  TRANSFORMATION(5),TRANSFORMATION(6),1]);
    [iml_tform, RAT] = imwarp(IML,RA,tform);


    [imr_tform, ~] = imwarp(IMR,tform);
    imshowpair(iml_tform,RAT,imr_tform,RB,'blend');
end

if TYPE == 'h'
    IML = cast(IML,'single');
    IMR = cast(IMR,'single');
    iml_size = size(IML);
    imr_size = size(IMR);
    RA = imref2d(iml_size);
    RB = imref2d(imr_size);    

    tform = projective2d(TRANSFORMATION);
    
    [iml_tform, RAT] = imwarp(IML,tform);

    [imr_tform, RBT] = imwarp(IMR,RB,tform);
    %imshowpair(iml_tform,RAT,imr_tform,RB);
    imshow(cast(iml_tform,'uint8'),[]);
    imshowpair(cast(iml_tform,'uint8'),RAT,cast(imr_tform,'uint8'),RB,'blend');
end


