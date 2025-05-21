<div align="center">

# catdo.nvim

a plugin to solve the problem of moving to the ____ todo file in the git project

lets be real, todo files are great, but going between the 
todo and what you're working on is a pain.

## Features
- [x] open the todo file within your current window, allowing you to quickly add and review tasks


## Installation

</div>

super basic install with lazy.nvim (https://github.com/folke/lazy.nvim)

```lua
{
    -- catdo.lua
    "SivaCaden/catdo.nvim",
    config = function()
        require("catdo").setup()
    end,
    keys = {
        { "<leader>ct", "<cmd>Catdo<cr>", desc = "catdo" },
    },
},
```
using packer.nvim
```lua
use {
    "SivaCaden/catdo.nvim",
    config = function()
        require("catdo").setup()
    end,
    keys = {
        { "<leader>ct", "<cmd>Catdo<cr>", desc = "catdo" },
    },
}
```


this project is still super early in development, so please report any bugs or issues you find
I would love to hear your feedback
