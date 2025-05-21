local M = {}


local function expand_path(path)
    if path:sub(1,1) == "~" then
        return os.getenv("HOME") .. path:sub(2)
    end
    return path
end

local function window_config()
    local width = math.min(math.floor(vim.o.columns * 0.8), 64)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    return {
        relative = "editor",
        width = width,
        height = height,
        col =  col,
        row = row,
        border = "single",
        style = "minimal",
    }

end

local function prompt_create_todo(callback)
    local bufnr = vim.api.nvim_create_buf(false, true)
    local width, height = 3, 3
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        "No todo.md file found...",
        "Would you like to create one?",
        "Press 'y' to create, 'n' to cancel.",
    })
    local win = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        border = "single",
        style = "minimal",
    })

    local function close_prompt()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end
    vim.keymap.set("n", "y", function()
        close_prompt()
        callback(true)
    end, { buffer = bufnr, nowait = true })
    vim.keymap.set("n", "n", function()
        close_prompt()
        callback(false)
    end, { buffer = bufnr, nowait = true })
end





local function get_git_root()
    local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result ~= "" then
            return result:gsub("%s+", "")
        end
        return all
    end

    return nil

end

local function find_todo(git_root)
    local handle = io.popen("find " .. git_root .. " -type f -name 'todo.md' 2>/dev/null")
    if handle then
        local result = handle:read("*l")
        handle:close()
        return result
    end
    return nil
end

local function open_float_file(_)
    local git_root = get_git_root()
    if not git_root then
        vim.notify("Not inside a Git repository", vim.log.levels.WARN)
        return
    end

    local todo_path = find_todo(git_root)
    if not todo_path then
        prompt_create_todo(function(yes)
            if yes then
                local new_path = git_root .. "/todo.md"
                vim.fn.writefile({}, new_path) -- create empty file
                vim.schedule(function()
                    open_float_file(new_path)
                end)
            end
        end)
        return
    end

    local bufnr = vim.fn.bufnr(todo_path, true)
    if bufnr == -1 then
        bufnr = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_buf_set_name(bufnr, todo_path)
    end

    vim.bo[bufnr].swapfile = false

    vim.api.nvim_open_win(bufnr, true, window_config())
end



local function setup_user_commands(opts)
    local meme = opts or {}
    vim.api.nvim_create_user_command("Cat", function()
        open_float_file()
    end, {})
end

M.setup = function(opts)
    local meme = opts or {}
    setup_user_commands(meme)
end


return M
