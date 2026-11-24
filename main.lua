require("lib.constants")
require("lib.digits")
require("lib.game")
require("lib.ui")

local clock
local canvas

local function setup()
    -- Initialise badge UI

    ui.bg("bg")

    info = ui.label(8, 3, "", {
        size = 12,
        color = "text",
        mono = true
    })

    clock = ui.label(230, 3, "", {
        size = 12,
        color = "aqua",
        mono = true
    })

    canvas = ui.canvas(BOARD_X, BOARD_Y, W * CELL, H * CELL, {
        color = "bg"
    })

    ui.hint("D-PAD MOVE   SELECT OPEN   BACK FLAG")

    new_game()
    draw(canvas)
end

setup()

function on_key(key, rep)
    if finished then
        if key == "select" then
            new_game()
            draw(canvas)
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

    draw(canvas)
    return true
end

function on_tick(ms)
    if started and not finished then
        elapsed = elapsed + ms / 1000
        clock:text("TIME " .. tostring(math.floor(elapsed)) .. "s")
    end
end
