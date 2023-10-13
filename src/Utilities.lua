function GenerateQuads(spriteSheet, tileWidth, tileHeight)
    local sheetWidth = spriteSheet:getWidth() / tileWidth
    local sheetHeight = spriteSheet:getHeight() / tileHeight
    local sheetCounter = 1
    local spriteSheetQuads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheetQuads[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, spriteSheet:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheetQuads
end

--[[
    Utility function for slicing tables, a la Python.
]]
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

--[[
    This function is specifically made to piece out the paddles from the
    sprite sheet. For this, we have to piece out the paddles a little more
    manually, since they are all different sizes.
]]
function GenerateQuadsPaddles(spriteSheet)
    local x = 0
    local y = 64            -- starting at the blue paddle
    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, spriteSheet:getDimensions())
        counter = counter + 1

        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, spriteSheet:getDimensions())
        counter = counter + 1

        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, spriteSheet:getDimensions())
        counter = counter + 1

        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, spriteSheet:getDimensions())
        counter = counter + 1

        -- prep x & y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end