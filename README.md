# nvim-merge-editor
A Neovim plugin for enhanced merge conflict resolution.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
"micahkepe/nvim-merge-editor",
config = function()
require("nvim-merge-editor").setup({
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
require("nvim-merge-editor").setup({
-- your configuration options here
})
```
