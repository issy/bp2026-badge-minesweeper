require("lib.constants")
require("lib.digits")
require("lib.game")
require("lib.ui")

local function setup()
    initialise_ui()
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
        update_clock_ui(elapsed)
    end
end
