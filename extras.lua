local Env = select(2, ...)

---Get current talent rank, treating talents sequentially ordered.
---@param tab integer The tree numer. 1-3
---@param num integer The talent index, counted from left to right, line by line.
---@return integer currentRank
function Env.GetTalentRankOrdered(tab, num)
    return select(5, GetTalentInfo(tab, num))
end

-- table extension contains
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

---Return the index of the biggest value in a numerically keyed table of numbers.
---@param table number[]
function Env.TableMaxValIndex(table)
    local idxMax = 1
    for i = 2, #table do
        if table[i] > table[idxMax] then
            idxMax = i
        end
    end
    return idxMax
end
