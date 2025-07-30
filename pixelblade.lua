for i,v in pairs(game:GetDescendants()) do
    if v:IsA("LocalScript") then
        print("Found LocalScript:", v:GetFullName())
        -- If it isn't protected
        local success, source = pcall(function()
            return getscriptbytecode and getscriptbytecode(v)
        end)
        if success then
            print("Bytecode available")
        else
            print("Source not accessible (probably sandboxed)")
        end
    end
end
