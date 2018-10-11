function seekerDataMovie(data,varargin)

startTime = 1;
stopTime = 10;
makeMovie = false;
fileName = 'seekerMovie.avi';

parsing = false;

xRT = 1.0;

if (nargin == 1)
    error('Need to at least pass in the CDL object');
elseif nargin > 1
    for i = 1:nargin-1
        if ~isnumeric(varargin{i}) && parsing == false
            parsing = true;
        elseif parsing == true
            parsing = false;
            switch lower(varargin{i-1})
                case 'starttime'
                    startTime = varargin{i};
                case 'stoptime'
                    stopTime = varargin{i};
                case 'makemovie'
                    makeMovie = varargin{i};
                case 'filename'
                    fileName = varargin{i};
                case 'xrt'
                    xRT = varargin{i};
                otherwise
                    error('Unknown String Pair: %s',varargin{i});
            end
        elseif i == 1
            startTime = varargin{i};
        elseif i == 2
            stopTime = varargin{i};
        end
    end
end

%need to get the actual indices for start and stop times
startIndex = startTime;
stopIndex = stopTime;
startTime = startTime/60;
stopTime = stopTime/60;
totalTime = (stopTime - startTime);
totalFrames = stopIndex - startIndex;
frameRate = xRT*totalFrames/totalTime;

%create the seekerFigure
h = seekerFigure();

%initialize the start/stop times
seekerData.startTime = startTime;
seekerData.stopTime = stopTime;
seekerData.azAxisXLimit = [startTime stopTime];
seekerData.elAxisXLimit = [startTime stopTime];
seekerData.errorAxisXLimit = [startTime stopTime];
seekerData.altAxisXLimit = [startTime stopTime];
seekerData.squintAxisXLimit = [startTime stopTime];

%initialize empty data arrays
seekerData.azData = [];
seekerData.elData = [];
seekerData.azErrorData = [];
seekerData.elErrorData = [];
seekerData.time = [];
seekerData.altData = [];
seekerData.trajXData = [];
seekerData.trajYData = [];
seekerData.squintData = [];
seekerData.updateLimits = true;

if makeMovie == true
    v = VideoWriter(fileName);
    v.Quality = 100;
    v.FrameRate = frameRate;
    v.open();
end

for i = startIndex:stopIndex
   
    %get the seekerData structure for the corresponding index
    seekerData = cdl2SeekerData(data,seekerData,i);

    %pack the data structure buffers for the gimbal az/el and errors
    seekerData.time = [seekerData.time seekerData.currentTime];
    seekerData.azData = [seekerData.azData; seekerData.currentAz];
    seekerData.elData = [seekerData.elData; seekerData.currentEl];
    seekerData.azErrorData = [seekerData.azErrorData; seekerData.currentAzError];
    seekerData.elErrorData = [seekerData.elErrorData; seekerData.currentElError];
    seekerData.altData = [seekerData.altData; seekerData.currentAlt];
    seekerData.trajXData = [seekerData.trajXData; seekerData.currentTrajX];
    seekerData.trajYData = [seekerData.trajYData; seekerData.currentTrajY];
    seekerData.squintData = [seekerData.squintData; seekerData.currentSquint];
    
    %update the values in the gui
    updateSeekerFigure(seekerData,h, seekerData.updateLimits);
    %reset the updateLimits flag
    seekerData.updateLimits = false;
    
    if makeMovie == true
        frame = getframe(h.hfig);
        writeVideo(v,frame);
    end
      
end

if makeMovie == true
    v.close();
end
