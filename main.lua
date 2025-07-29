function love.load()
    love.window.setIcon(love.image.newImageData("assets/icon.png"))
    love.window.getTitle("S-SHOT")
    love.window.setFullscreen(true)
    love.graphics.setBackgroundColor(0.05,0.05,0.05)

    Player = love.graphics.newImage("assets/art/player.png")

    plr = {
        r = 0;
        x = 0;
        y = 0;
        dx = 0;
        dy = 0;

        firedebounce = false;
        firecooldown = 0.5;
        firesound = love.audio.newSource("assets/sfx/fire_basic.ogg","static")
    }
end

local function UpdateMovement(dt)
    plr.x = plr.x + plr.dx
    plr.y = plr.y + plr.dy

    plr.dx = plr.dx * (dt*110)
    plr.dy = plr.dy * (dt*110)
end

function love.update(dt)
    UpdateMovement(dt)

    -- Input Checking
    if love.keyboard.isDown("d") then
        plr.dx = plr.dx + 0.25
    end
    if love.keyboard.isDown("s") then
        plr.dy = plr.dy + 0.25
    end
    if love.keyboard.isDown("a") then
        plr.dx = plr.dx - 0.25
    end
    if love.keyboard.isDown("w") then
        plr.dy = plr.dy - 0.25
    end

    -- Firing
    if (love.mouse.isDown(1) and plr.firedebounce == false) then
        love.audio.play(plr.firesound)
    end

    print(love.mouse.getRelativeMode())
    local mx, my = love.mouse.getPosition()
    plr.r = math.atan2(my - plr.y, mx - plr.x)
end

function love.draw()
    love.graphics.draw(Player,plr.x,plr.y,plr.r,0.1,0.1,Player:getWidth()/2,Player:getHeight()/2)
end