 ```
                  ____  ____  ____  _  _  __  ____  _  _ 
                 (_  _)(  __)(  _ \( \/ )(  )(  __)( \/ )
                   )(   ) _)  )   // \/ \ )(  ) _)  )  / 
                  (__) (____)(__\_)\_)(_/(__)(__)  (__/  
            
```

# termify.nvim

## What is Termify?

`termify.nvim` is a simple plugin for Neovim, written completely in Lua. 
It provides the capability to run any script directly in your favorite editor
and display the output in a disposable pop-up window. Termify is customizable
and allows to be extended to any scripting runtime.
 
## Table of Contents
- [Showcase](#showcase)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)

## Showcase 

### Running a Dart file
https://user-images.githubusercontent.com/4450312/188239234-7f4d03f3-01fd-4f17-9911-aa584d27ae75.mp4

### Running a Markdown file
An example of previewing markdown files via the wonderful [Glow](https://github.com/charmbracelet/glow) reader.

https://user-images.githubusercontent.com/4450312/188239266-54115754-1fc0-4122-91df-4b67d084d1ff.mp4

## Installation 
Using [vim-plug](https://github.com/junegunn/vim-plug)
```viml
Plug 'dgyurov/termify.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)
```viml
call dein#add('dgyurov/termify.nvim')
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'dgyurov/termify.nvim' 
```

## Configuration 
Termify comes with the following default configuration:
```lua
{
  -- A table which has file types as keys and executable as value
  -- Note: The executables should be already installed on your system and 
  -- be capable of accepting a file path as an argument. The file path will be
  -- supplied by Termify.
  supportedFiletypes = {
    ['swift'] = "swift",
    ['dart'] = "dart",
    ['python'] = "python",
    ['lua'] = "lua",
    ['md'] = "glow",
  },
  
  -- Key that can be used to close the Termify window.
  closeMappings = { '<esc>', 'q' },
  
  -- Border style of the Termify window.
  -- Possible values: 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
  borderStyle = 'rounded'
}
```

You can override any of the default values by calling the setup function.
```lua
require 'termify'.setup {
  -- You can pass your configuration here
}
```

## Usage
You can open Termify by calling the following Lua function:
```lua
require 'termify'.run()
```

For you convenience you can consider binding it to a keymap. The following keymap for example will save the current file and then run it in Termify.
```lua
vim.api.nvim_set_keymap(
  'n', 
  '<leader>p', 
  '<cmd>silent w<CR><cmd>lua require"termify".run()<CR>', 
  { noremap = true }
)
```

## Credits
Made with love and tears on a Chromebook tablet.
