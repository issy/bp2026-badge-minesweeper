local info

function draw(canvas)
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
