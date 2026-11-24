local MINE_COLOUR = 0xFF4444
local FLAG_COLOUR = 0xFFCC44
local WHITE = 0xFFFFFF
local CELL_OPEN_COLOUR = 0x182C25
local CELL_DEFAULT_COLOUR = 0x293B35

local info
local clock
local canvas

function initialise_ui()
    ui.bg("bg")

    info = ui.label(8, 1, "", {
        size = 12,
        color = "text",
        mono = true
    })

    clock = ui.label(230, 1, "", {
        size = 12,
        color = "aqua",
        mono = true
    })

    canvas = ui.canvas(BOARD_X, BOARD_Y, W * CELL, H * CELL, {
        color = "bg"
    })

    ui.hint("D-PAD MOVE   SELECT OPEN   BACK FLAG")
end

function draw()
    canvas:clear("bg")

    for y = 1, H do
        for x = 1, W do
            local t = board[y][x]

            local px = (x - 1) * CELL
            local py = (y - 1) * CELL

            local color = CELL_DEFAULT_COLOUR

            if t.open then
                color = CELL_OPEN_COLOUR
            end

            canvas:rect(px, py, CELL - 1, CELL - 1, color)

            if t.open then
                if t.mine then
                    canvas:rect(px + 7, py + 7, 6, 6, MINE_COLOUR)
                elseif t.n > 0 then
                    draw_digit(canvas, px + 5, py + 3, t.n)
                end
            elseif t.flag then
                canvas:rect(px + 7, py + 7, 6, 6, FLAG_COLOUR)
            end
        end
    end

    -- Cursor
    local px = (cx - 1) * CELL
    local py = (cy - 1) * CELL

    canvas:line(px, py, px + 19, py, WHITE)
    canvas:line(px, py, px, py + 19, WHITE)
    canvas:line(px + 19, py, px + 19, py + 19, WHITE)
    canvas:line(px, py + 19, px + 19, py + 19, WHITE)

    info:text(
    "MINES " .. tostring(MINES - flags)
    .. "   FLAGS " .. tostring(flags)
    )

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

function update_clock_ui(elapsed)
    clock:text("TIME " .. tostring(math.floor(elapsed)) .. "s")
end
