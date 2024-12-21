# merge.nvim (WIP)

In-development Neovim plugin for enhanced merge conflict resolution.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "micahkepe/merge.nvim",
    config = function()
        require("merge").setup {}
    end,
}
```

## Usage

The plugin provides the following commands and keymaps:

- `:MergeEditor` - Open the merge editor UI
- TODO: following mappings suck
- `<leader>mc` - Accept current change
- `<leader>mi` - Accept incoming change
- `<leader>mb` - Accept both changes

## Default Settings

## Configuration

```lua
require("merge").setup({
    -- your configuration options here
})
```
