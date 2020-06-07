function love.load()

  -- Set Window properties
  love.window.setTitle("Particles")
  windowWidth = 700
  windowHeight = 700
  love.window.setMode(windowWidth, windowHeight)
  limit_error = 5000
  error_var = 0

  -- Initial value for the particles direction
  local initial_dir = {}
  initial_dir[1] = -1
  initial_dir[2] = 1

  -- Instacianting the particles
  particles = {}
  nParticles = 35
  radius = 10
  for i=1,nParticles do
    particles[i] = {}
    particles[i].x = love.math.random(radius + 1, windowWidth - radius - 1)
    particles[i].y = love.math.random(radius + 1, windowHeight - radius - 1)
    particles[i].speed = 200
    particles[i].vectorX = love.math.random(0, 10)/10 * initial_dir[love.math.random(1, 2)]
    particles[i].vectorY = (1 - particles[i].vectorX^2) * initial_dir[love.math.random(1, 2)]
    particles[i].red = 1
    particles[i].green = 1
    particles[i].blue = 17
    -- Checks if the i particle is inside another particle
    local j = 1
    while (j ~= i) do
      local aux = ((particles[i].x - particles[j].x)^2 + (particles[i].y - particles[j].y)^2)^0.5
      if aux <= 4*radius then
        particles[i].x = love.math.random(radius, windowWidth-radius)
        particles[i].y = love.math.random(radius, windowHeight-radius)
        j = 1
        error_var = error_var + 1
      else
        j = j + 1
      end
      -- Catch infinite loop error
      if (error_var >= limit_error) then
        error_MessageBox = love.window.showMessageBox("Error", "Particles's radius are too big or initial distance between particles is too big", "error", true)
        love.event.quit()
        break
      end
    end

    -- Closes windows if infinite loop error happened
    if (error_var >= limit_error) then
      love.window.close()
      break
    end

  end

  -- Pick one random particle to be red and another to be blue, in order for the
  -- view observe better the movement.
  local aux_color1 = love.math.random(1, table.getn(particles))
  particles[aux_color1].red = 1
  particles[aux_color1].green = 0
  particles[aux_color1].blue = 0
  local aux_color2 = love.math.random(1, table.getn(particles))
  while (aux_color2 == aux_color1) do
      aux_color2 = love.math.random(1, table.getn(particles))
  end
  particles[aux_color2].red = 0
  particles[aux_color2].green = 0
  particles[aux_color2].blue = 1

end

function love.update(dt)

  for i=1,nParticles do

    -- Wall Collisions
    if ((particles[i].x <= radius) and (particles[i].vectorX < 0)) or
       ((particles[i].x >= windowWidth - radius) and (particles[i].vectorX > 0)) then
      particles[i].vectorX = particles[i].vectorX * -1
    end
    if ((particles[i].y <= radius) and (particles[i].vectorY < 0)) or
       ((particles[i].y >= windowHeight - radius) and (particles[i].vectorY > 0)) then
      particles[i].vectorY = particles[i].vectorY * -1
    end

    -- Very Unoptmized collision detection
    for j=1,nParticles do
      if (j == i) then
        break
      end
      local aux = ((particles[i].x - particles[j].x)^2 + (particles[i].y - particles[j].y)^2)^0.5
      if (aux <= 2 * radius) then
        local aux1 = particles[i].vectorX
        local aux2 = particles[i].vectorY
        particles[i].vectorX = particles[j].vectorX
        particles[i].vectorY = particles[j].vectorY
        particles[j].vectorX = aux1
        particles[j].vectorY = aux2
      end
    end
    -- Update position
    particles[i].x = particles[i].x + particles[i].speed * dt * particles[i].vectorX
    particles[i].y = particles[i].y + particles[i].speed * dt * particles[i].vectorY

  end

end

function love.draw()

  -- Draw the particles
  for i=1,nParticles do
    love.graphics.setColor(particles[i].red, particles[i].green, particles[i].blue)
    love.graphics.circle("fill", particles[i].x, particles[i].y, radius)
  end

end
