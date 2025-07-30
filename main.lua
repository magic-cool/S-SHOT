function love.load()
    love.window.setIcon(love.image.newImageData("assets/icon.png"))
    love.window.getTitle("S-SHOT")
    love.window.setFullscreen(true)
    love.graphics.setBackgroundColor(0.05,0.05,0.05)

    images = {
        player = love.graphics.newImage("assets/art/player.png");
        bullet = love.graphics.newImage("assets/art/bullet.png");
    }

    configuration = {
        recoilpower = 250;
        walkspeed = 10;
        firecooldown = 0.25;
        bulletspeed = 1000;
    }

    plr = {
        r = 0;
        x = 0;
        y = 0;
        dx = 0;
        dy = 0;
        
        recoilamount = 0;

        firedebounce = false;
        firesound = love.audio.newSource("assets/sfx/fire_basic.ogg","static");
        hitsound = love.audio.newSource("assets/sfx/bullet_destroy.ogg","static");
    }

    bullets = {}

    task = require"libraries/tick"
end

local function Lerp(a,b,t)
    return a + (b - a) * t
end
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

local function UpdateMovement(dt)
    plr.x = plr.x + plr.dx
    plr.y = plr.y + plr.dy

    plr.dx = plr.dx * (dt*115)
    plr.dy = plr.dy * (dt*115)

    plr.recoilamount = plr.recoilamount * (dt*115)
end

function love.update(dt)
    UpdateMovement(dt)
    task.update(dt)

    for i,v in ipairs(bullets) do
        cos = math.cos(v.r)
        sin = math.sin(v.r)

        v.x = v.x + configuration.bulletspeed * cos * dt
        v.y = v.y + configuration.bulletspeed * sin * dt
        
        local w,h = love.window.getDesktopDimensions()
        
        if (v.x > w) or (v.x < 0) then
            table.remove(bullets,i)
            love.audio.play(plr.hitsound)
        elseif (v.y > h) or (v.y < 0) then
            table.remove(bullets,i)
            love.audio.play(plr.hitsound)
        end
    end

    -- Input Checking
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        plr.dx = plr.dx + configuration.walkspeed/100
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        plr.dy = plr.dy + configuration.walkspeed/100
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        plr.dx = plr.dx - configuration.walkspeed/100
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        plr.dy = plr.dy - configuration.walkspeed/100
    end


    print(love.mouse.getRelativeMode())
    local mx, my = love.mouse.getPosition()
    plr.r = math.atan2(my - plr.y, mx - plr.x)

    
    cos = math.cos(plr.r)
    sin = math.sin(plr.r)

    plr.x = plr.x + plr.recoilamount * cos * dt
    plr.y = plr.y + plr.recoilamount * sin * dt

    
    -- Firing
    if (love.mouse.isDown(1) and plr.firedebounce == false) then
        
        plr.firedebounce = true
        task.delay(function() plr.firedebounce = false end,configuration.firecooldown) 
        
        love.audio.play(plr.firesound)
        plr.recoilamount = plr.recoilamount + -configuration.recoilpower

        local bullet = {
            x = plr.x;
            y = plr.y;
            r = plr.r;
        }
        
        table.insert(bullets,bullet)

    end
end

function love.draw()
    love.graphics.draw(images.player,plr.x,plr.y,plr.r,0.1,0.1,images.player:getWidth()/2,images.player:getHeight()/2)
    
    for i,v in ipairs(bullets) do
        love.graphics.draw(images.bullet,v.x,v.y,v.r,0.1,0.1,images.bullet:getWidth()/2,images.bullet:getHeight()/2)
    end
end