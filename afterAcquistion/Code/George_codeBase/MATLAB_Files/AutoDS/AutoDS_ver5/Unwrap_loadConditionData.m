function data = Unwrap_loadConditionData(d)

n=-1;
while true
    if ischar(d.framePaths{1})
        n = length(d.framePaths);
        break
    else
        d.framePaths = d.framePaths{1};
    end
end
assert(n>0);

data(n) = struct;

for ii = 1:n
    data(ii).source = d.source;
    data(ii).channels = d.channels;
    data(ii).framerate = d.framerate;
    data(ii).imagesize = d.imagesize;
    data(ii).movieLength = 1;
    data(ii).markers = d.markers;
    data(ii).pixelSize = d.pixelSize;
    data(ii).dz = d.dz;
    data(ii).zAniso = d.zAniso;
    data(ii).angle = d.angle;
    data(ii).objectiveScan = d.objectiveScan;
    data(ii).reversed = d.reversed;
    
    while true
        if ischar(d.framePaths{ii})
            data(ii).framePaths = {d.framePaths{ii}};
            break
        else
            d.framePaths = d.framePaths{ii};
        end
    end
    
    while true
        if ischar(d.maskPaths{ii})
            data(ii).maskPaths = {d.maskPaths{ii}};
            break
        else
            d.maskPaths = d.maskPaths{ii};
        end
    end
    
    while true
        if ischar(d.framePathsDS{ii})
            data(ii).framePathsDS = {d.framePathsDS{ii}};
            break
        else
            d.framePathsDS = d.framePathsDS{ii};
        end
    end
   
    
   while true
        if ischar(d.framePathsDSR{ii})
            data(ii).framePathsDSR = {d.framePathsDSR{ii}};
            break
        else
            d.framePathsDSR = d.framePathsDSR{ii};
        end
    end
    
end



end


%{ 
Input:


  struct with fields:

           source: '/nfs/scratch/George/LoadBalancer/_sh/compiled/20210331/source/Ex01_488nm_100mW_560nm_200mW_642nm_50mW_z0p5/'
         channels: {'/nfs/scratch/George/LoadBalancer/_sh/compiled/20210331/source/Ex01_488nm_100mW_560nm_200mW_642nm_50mW_z0p5/'}
             date: '202103'
        framerate: 0
        imagesize: [768 400 101]
      movieLength: 30
          markers: {'gfp'}
       framePaths: {{30×1 cell}}
        maskPaths: {30×1 cell}
        pixelSize: 0.1040
               dz: 0.5000
           zAniso: 2.5120
            angle: 31.5000
    objectiveScan: 0
         reversed: 0
     framePathsDS: {{30×1 cell}}
    framePathsDSR: {{30×1 cell}}


Output:
data = Unwrap_loadConditionData(dataCompiled)

data = 

  1×30 struct array with fields:

    source
    channels
    framerate
    imagesize
    movieLength
    markers
    pixelSize
    dz
    zAniso
    angle
    objectiveScan
    reversed
    framePaths
    maskPaths
    framePathsDS
    framePathsDSR


%}