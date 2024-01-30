# My neovim config...

... works for me :-).

Actually, I don't expect anyone else to use it. In the best case it can be used as inspiration for
your own config. I've tried to keep it as simple as possible, but it's still a lot of stuff.

## Highlights

* Plugin management with [lazy](https://github.com/folke/lazy.nvim)
* Fuzzy file search via [fzf-lua](https://github.com/ibhagwan/fzf-lua)
* Code, snippet, word auto-completion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
* Language server support via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
* Language server management via [mason.nvim](https://github.com/williamboman/mason.nvim)
* Formatting for various languages via [conform.nvim](https://github.com/stevearc/conform.nvim)
* Linting for various languages via [nvim-lint](https://github.com/mfussenegger/nvim-lint)
* Code highlighting via [nvim-treesitter](https://github.com/jdhao/nvim-config)
* Copilot integration via [copilot.lua](https://github.com/zbirenbaum/copilot.lua)
* Git integration via [vim-fugitive](https://github.com/tpope/vim-fugitive).
* Faster code commenting via [vim-commentary](https://github.com/tpope/vim-commentary).
* Spelling checking incl. code action to maintain a local dictionary via [LTeX_extra](https://github.com/barreiroleo/ltex_extra.nvim)

And some more. Have a look at the files below `lua/plugins` for a full list.

## Useful shortcuts

A lot more is available, but I'd like to highlight some of the most useful ones:

* Fuzzy file search: `CTRL+a`
* File history: `CTRL+h`
* Word under cursor:
  * Search in project: `,wf`
  * Go to definition: `,d`
  * List references: `,wc`
  * Replace in current file: `,wr`
  * Show documentation/docstring: `,wd`
  * Open link in browser (or search word): `,wb`
* Comment out current line: `gcc`
* Git
  * Git blame current file: `,gb`
  * Git log of current buffer: `CTRL+l`
* Jump linter findings `CTRL+k`, `CTRL+j`
* Toggle dark/light: `F10`
* Deploy: `F12`

Using `:WhichKey` you can see the available shortcuts.
