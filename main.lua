--PLaftorm by Me
--Game Developer: Me

--My Game Code

--Load will run the code once the game is loaded
function love.load()
    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/MapTest.lua')

    Font = love.graphics.newFont("/assets/fonts/cartoon.ttf", 18)
    Fontz = love.graphics.newFont("/assets/fonts/PinkChicken.ttf", 20)
    love.window.setTitle("Plaftorm")

    sounds = {}
    sounds.music = love.audio.newSource("/assets/music/Animal-Crossing-Trap-Remix.mp3", "stream")
    sounds.music:setLooping(true)

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 5
    player.spritesheet = love.graphics.newImage('/assets/player-sheet.png')
    player.grid = anim8.newGrid( 12, 18, player.spritesheet:getWidth(), player.spritesheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.left

    background = love.graphics.newImage('/assets/others/BG.png')

    sounds.music:play()
end

--Update will run the code once every frame
function love.update(dt)
    local isMoving = false

    fps = love.timer.getFPS()

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Right border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    -- Bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end

--Draw will display stuff in the screen
function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Others"])
        love.graphics.setFont(Font)
        player.anim:draw(player.spritesheet, player.x, player.y, nil, 5, nil, 6, 9)
    cam:detach()

    love.graphics.print("FPS: "..fps, 0, 20)
        love.graphics.print("X: "..player.x, 0, 40)
        love.graphics.print("Y: "..player.y, 0, 60)

end