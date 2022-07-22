# Copilot.vim

GitHub Copilot uses OpenAI Codex to suggest code and entire functions in
real-time right from your editor. Trained on billions of lines of public code,
GitHub Copilot turns natural language prompts including comments and method
names into coding suggestions across dozens of languages.

Copilot.vim is a Vim plugin for GitHub Copilot.  For now, it requires Neovim
0.6 (for virtual lines support) and a Node.js installation.

To learn more, visit [aka.ms/copilot-learn-more](https://aka.ms/copilot-learn-more)

## Subscription

Once GitHub Copilot is generally available,
it will require a subscription.
It will be free for verified students and
maintainers of popular open source projects on GitHub.


## Getting started

1.  Install [Neovim][].

2.  Install [Node.js][] version 16.  (Other versions should work too, except
    Node 18 which isn't supported yet.)

3.  Install `github/copilot.vim` using vim-plug, packer.nvim, or any other
    plugin manager.  Or to install directly:

        git clone https://github.com/github/copilot.vim.git \
          ~/.config/nvim/pack/github/start/copilot.vim

4.  Start Neovim and invoke `:Copilot setup`.

[Node.js]: https://nodejs.org/en/download/
[Neovim]: https://github.com/neovim/neovim/releases/latest

Suggestions are displayed inline and can be accepted by pressing the tab key.
See `:help copilot` for more information.

