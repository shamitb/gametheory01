function [fireSize, density] = ForestFire(N, pGrow, pFire, fireCount, videoFile)

fireSize = zeros(fireCount, 1);
density = zeros(fireCount, 1);

N2 = N * N;
world = zeros(N2, 1, 'uint32');

up    = uint32((0:N2-1) + N * (mod(1:N2, N) == 1));
down  = uint32((2:N2+1) - N * (mod(1:N2, N) == 0));
left  = uint32(mod((1:N2) - N - 1, N2) + 1);
right = uint32(mod((1:N2) + N - 1, N2) + 1);
neighborhood = [up; down; left; right];

muFire = 1 / (N2 * pFire);
muGrow = 1 / (N2 * pGrow);

untilFire = ExpRand(muFire);
untilGrow = ExpRand(muGrow);

if videoFile
    im = struct('cdata', ones(N, N),...
                'colormap', [0 0 0; 1 0 0; 0 1 0]);
    vw = VideoWriter(videoFile, 'Indexed AVI');
    vw.FrameRate = 15;
    open(vw);
end
    

while fireCount > 0
        
    location = randi(N2);
    
    if untilGrow < untilFire
        untilFire = untilFire - untilGrow;
        untilGrow = ExpRand(muGrow);
        
        if ~world(location);
            adjacent = world(neighborhood(:, location))';
            adjacent = adjacent(adjacent>0);
            if adjacent
                extent = any(bsxfun(@eq, world, adjacent),2);
                world(extent) = location;
            end    
            world(location) = location;
            if videoFile
                im.cdata(location) = 3;
            end
        end
        
    else
        untilGrow = untilGrow - untilFire;
        untilFire = ExpRand(muFire);
        
        strike = world(location);
        if strike
            extent = world == strike;
            density(fireCount) = N2 - sum(~world);
            fireSize(fireCount) = sum(extent);
            world(extent) = 0;
            fireCount = fireCount - 1;
            
            if videoFile
                im.cdata(extent) = 2;
                writeVideo(vw, im);
                im.cdata(extent) = 1;
            end
        end
    end
end

if videoFile
    close(vw);
end
