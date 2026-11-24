require("lib.constants")

board = {}
cx, cy = 1, 1
flags = 0
elapsed = 0
started = false
finished = false
victory = false

function new_game()
    board = {}
    flags = 0
    elapsed = 0
    started = false
    finished = false
    victory = false
    cx, cy = 1, 1

    for y = 1, H do
        board[y] = {}
        for x = 1, W do
            board[y][x] = {
                mine = false,
                open = false,
                flag = false,
                n = 0
            }
        end
    end
end

function neighbours(x, y, fn)
    for dy = -1, 1 do
        for dx = -1, 1 do
            local nx = x + dx
            local ny = y + dy

            if nx >= 1 and nx <= W
            and ny >= 1 and ny <= H
            and (dx ~= 0 or dy ~= 0) then
                fn(nx, ny)
            end
        end
    end
end

function generate(sx, sy)
    local placed = 0

    while placed < MINES do
        local x = math.random(1, W)
        local y = math.random(1, H)

        -- First click is always safe
        if not board[y][x].mine
        and (x ~= sx or y ~= sy) then
            board[y][x].mine = true
            placed = placed + 1
        end
    end

    for y = 1, H do
        for x = 1, W do
            local count = 0

            neighbours(x, y, function(nx, ny)
                if board[ny][nx].mine then
                    count = count + 1
                end
            end)

            board[y][x].n = count
        end
    end
end

function reveal(x, y)
    if x < 1 or x > W or y < 1 or y > H then
        return
    end

    local t = board[y][x]

    if t.open or t.flag or finished then
        return
    end

    if not started then
        generate(x, y)
        started = true
    end

    t.open = true

    if t.mine then
        finished = true
        victory = false
        return
    end

    if t.n == 0 then
        neighbours(x, y, function(nx, ny)
            reveal(nx, ny)
        end)
    end

    local remaining = 0

    for yy = 1, H do
        for xx = 1, W do
            local tile = board[yy][xx]

            if not tile.open and not tile.mine then
                remaining = remaining + 1
            end
        end
    end

    if remaining == 0 then
        finished = true
        victory = true
    end
end

function toggle_flag()
    if finished then return end

    local t = board[cy][cx]

    if t.open then return end

    if t.flag then
        t.flag = false
        flags = flags - 1
    elseif flags < MINES then
        t.flag = true
        flags = flags + 1
    end
end

function chord(x, y)
    local t = board[y][x]

    if not t.open or t.n == 0 or finished then
        return
    end

    local adjacent_flags = 0

    neighbours(x, y, function(nx, ny)
        if board[ny][nx].flag then
            adjacent_flags = adjacent_flags + 1
        end
    end)

    -- Only chord when the flag count matches
    if adjacent_flags ~= t.n then
        return
    end

    -- Reveal all neighbouring unflagged cells
    neighbours(x, y, function(nx, ny)
        local neighbour = board[ny][nx]

        if not neighbour.open and not neighbour.flag then
            reveal(nx, ny)
        end
    end)
end
