require "data"

local grid = {}
local paused = true

local function set_title()
    if paused then
        love.window.setTitle("Jogo da Vida de Conway (paused)")
    else
        love.window.setTitle("Jogo da Vida de Conway")
    end
end

local function reset_grid()
    local new_grid = {}
    for i = 0, ROWS do
        local row = {}
        for j = 0, COLS do
            table.insert(row, false)
        end
        table.insert(new_grid, row)
    end
    grid = new_grid
end

function love.load()
    reset_grid()
    set_title()
end

local function count_neighbors(x, y)
    local neighbours = 0

    if  x > 1 then
        if y > 1
        and grid[x - 1][y - 1]
        then neighbours = neighbours + 1 end

        if grid[x - 1][y]
        then neighbours = neighbours + 1 end

        if y < COLS
        and grid[x - 1][y + 1]
        then neighbours = neighbours + 1 end
    end

    if  y > 1
    and grid[x][y - 1]
    then neighbours = neighbours + 1 end

    if  y < COLS
    and grid[x][y + 1]
    then neighbours = neighbours + 1 end

    if x < ROWS then
        if y > 1
        and grid[x + 1][y - 1]
        then neighbours = neighbours + 1 end

        if grid[x + 1][y]
        then neighbours = neighbours + 1 end

        if y < COLS
        and grid[x + 1][y + 1]
        then neighbours = neighbours + 1 end
    end

    return neighbours
end

local timer = 0
local time_run = 30

function love.update(dt)
    if paused then return end

    if timer > time_run then
        timer = 0
    else
        timer = timer + 1 + dt
        return
    end

    local new_grid = {}
    for x = 1, ROWS do
        table.insert(new_grid, {})
        for y = 1, COLS do
            local is_alive = grid[x][y]
            local alive_neighbours = count_neighbors(x, y)

            -- subpopulacao (solidao)
            if is_alive and alive_neighbours < 2
            then is_alive = false end

            -- superpopulacao
            if is_alive and alive_neighbours > 3
            then is_alive = false end

            -- reproducao
            if not is_alive and alive_neighbours == 3
            then is_alive = true end

            table.insert(new_grid[x], is_alive)
        end
    end
    grid = new_grid
end

function love.mousepressed(x, y, button)
    local nx = math.floor(x / UNIT)
    local ny = math.floor(y / UNIT)
    if button == 1
    then grid[nx][ny] = not grid[nx][ny] end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space"
    then
        paused = not paused
        set_title()
    end

    if key == "0"
    then reset_grid() end
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 0.2)

    for i = 0, ROWS
    do love.graphics.line( i * UNIT, 0, i * UNIT, HEIGHT ) end

    for i = 0, COLS
    do love.graphics.line( 0, i * UNIT, WIDTH, i * UNIT ) end

    love.graphics.setColor(1, 1, 1)
    for x, row in ipairs(grid) do
        for y, cell in ipairs(row) do
            if cell then
                love.graphics.rectangle("fill", UNIT * x, UNIT * y, UNIT, UNIT)
            end
        end
    end
end