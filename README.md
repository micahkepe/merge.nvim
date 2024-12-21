# merge.nvim

A Neovim plugin for enhanced merge conflict resolution.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "micahkepe/merge.nvim",
    config = function()
        require("merge.nvim").setup({
            -- your configuration options here
        })
    end,
}
```

## Usage

The plugin provides the following commands and keymaps:

- `:MergeEditor` - Open the merge editor UI
- `<leader>mc` - Accept current change
- `<leader>mi` - Accept incoming change
- `<leader>mb` - Accept both changes

## Configuration

```lua
require("merge.nvim").setup({
    -- your configuration options here
})
```
