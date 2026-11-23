local number_colors = {
    0x55BFFF, -- 1
    0x55E68A, -- 2
    0xFFCC55, -- 3
    0xFF7755, -- 4
    0xBB88FF, -- 5
    0x55CCCC, -- 6
    0xFFFFFF, -- 7
    0xAAAAAA  -- 8
}

local DIGITS = {
    ["1"] = {
        "010",
        "110",
        "010",
        "010",
        "111"
    },
    ["2"] = {
        "110",
        "001",
        "010",
        "100",
        "111"
    },
    ["3"] = {
        "110",
        "001",
        "010",
        "001",
        "110"
    },
    ["4"] = {
        "101",
        "101",
        "111",
        "001",
        "001"
    },
    ["5"] = {
        "111",
        "100",
        "110",
        "001",
        "110"
    },
    ["6"] = {
        "011",
        "100",
        "110",
        "101",
        "010"
    },
    ["7"] = {
        "111",
        "001",
        "010",
        "010",
        "010"
    },
    ["8"] = {
        "010",
        "101",
        "010",
        "101",
        "010"
    }
}

function draw_digit(canvas, x, y, digit)
    local pattern = DIGITS[tostring(digit)]
    if not pattern then return end

    for row = 1, 5 do
        for col = 1, 3 do
            if pattern[row]:sub(col, col) == "1" then
                canvas:rect(x + col * 2, y + row * 2, 2, 2, number_colors[digit])
            end
        end
    end
end
