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


local function open_float_file(target)
    local exp_filepath = expand_path(target)
    if vim.fn.filereadable(exp_filepath) == 0 then
        vim.notify("File " .. exp_filepath .. " does not exist. Creating it now.", vim.log.levels.INFO)
        vim.cmd("silent !touch " .. exp_filepath)
    end

    local bufnr = vim.fn.bufnr(exp_filepath, true)
    if bufnr == -1 then
        bufnr = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_buf_set_name(bufnr, exp_filepath)
    end

    vim.bo[bufnr].swapfile =  false
    vim.bo[bufnr].buflisted = false

    local win = vim.api.nvim_open_win(bufnr, true, window_config())

end

local function setup_user_commands(opts)
    local meme = opts or {}
    local target = meme.target or "todo.md"
    vim.api.nvim_create_user_command("Cat", function()
        open_float_file(target)
    end, {})
end

M.setup = function(opts)
    local meme = opts or {}
    setup_user_commands(meme)
end


return M
