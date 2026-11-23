require("constants")
require("digits")
require("game")

local canvas
local title
local info
local clock

local function draw()
    canvas:clear("bg")

    for y = 1, H do
        for x = 1, W do
            local t = board[y][x]

            local px = (x - 1) * CELL
            local py = (y - 1) * CELL

            local color = 0x293B35

            if t.open then
                color = 0x182C25
            end

            canvas:rect(px, py, CELL - 1, CELL - 1, color)

            if t.open then
                if t.mine then
                    canvas:rect(px + 7, py + 7, 6, 6, 0xFF4444)
                elseif t.n > 0 then
                    draw_digit(canvas, px + 5, py + 3, t.n)
                end
            elseif t.flag then
                canvas:rect(px + 7, py + 5, 6, 10, 0xFFCC44)
            end
        end
    end

    -- Cursor
    local px = (cx - 1) * CELL
    local py = (cy - 1) * CELL

    canvas:line(px, py, px + 19, py, 0xFFFFFF)
    canvas:line(px, py, px, py + 19, 0xFFFFFF)
    canvas:line(px + 19, py, px + 19, py + 19, 0xFFFFFF)
    canvas:line(px, py + 19, px + 19, py + 19, 0xFFFFFF)

    info:text(
    "MINES " .. tostring(MINES - flags)
    .. "   FLAGS " .. tostring(flags)
    )

    clock:text("TIME " .. tostring(math.floor(elapsed)) .. "s")

    if finished then
        if victory then
            ui.hint("FIELD CLEARED! SELECT: NEW GAME")
        else
            ui.hint("BOOM! SELECT: RETRY")
        end
    else
        ui.hint("SELECT: OPEN    BACK: FLAG")
    end
end

local function setup()
    -- Initialise badge UI

    ui.bg("bg")

    title = ui.label(8, 3, "BREAKPOINT 2026 // MINES", {
        size = 14,
        color = "green",
        mono = true
    })

    info = ui.label(8, 20, "", {
        size = 12,
        color = "text",
        mono = true
    })

    clock = ui.label(230, 20, "", {
        size = 12,
        color = "aqua",
        mono = true
    })

    canvas = ui.canvas(BOARD_X, BOARD_Y, W * CELL, H * CELL, {
        color = "bg"
    })

    ui.hint("D-PAD MOVE   SELECT OPEN   BACK FLAG")

    new_game()
    draw()
end

setup()

function on_key(key, rep)
    if finished then
        if key == "select" then
            new_game()
            draw()
        elseif key == "back" then
            return false
        end

        return true
    end

    if key == "up" then
        cy = math.max(1, cy - 1)

    elseif key == "down" then
        cy = math.min(H, cy + 1)

    elseif key == "left" then
        cx = math.max(1, cx - 1)

    elseif key == "right" then
        cx = math.min(W, cx + 1)

    elseif key == "select" then
        local t = board[cy][cx]

        if t.open then
            chord(cx, cy)
        else
            reveal(cx, cy)
        end

    elseif key == "back" then
        toggle_flag()

    else
        return false
    end

    draw()
    return true
end

function on_tick(ms)
    if started and not finished then
        elapsed = elapsed + ms / 1000
        clock:text("TIME " .. tostring(math.floor(elapsed)) .. "s")
    end
end
