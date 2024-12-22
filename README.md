# merge.nvim 🛠️

In-development Neovim plugin for enhanced merge conflict resolution.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "micahkepe/merge.nvim",
    lazy = false, -- to make the plugins immediately available
    config = function()
        require("merge").setup {}
    end,
}
```

## Usage

The plugin provides the following commands and keymaps:

- `:MergeEditor` - Open the merge editor UI
- `<leader>mc` - Accept current change
- `<leader>mi` - Accept incoming change
- `<leader>mb` - Accept both changes

## Default Settings

## Configuration

```lua
require("merge").setup({
    -- default setting overrides here
})
```

## TODOs

- [ ] Testing with `plenary.nvim` [testing module](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md)
- [ ] Smart combination strategy
- [ ] Diff syntax highlighting
- [ ] Conflict highlighting, similar to [`git-conflict.nvim`](https://github.com/akinsho/git-conflict.nvim)
