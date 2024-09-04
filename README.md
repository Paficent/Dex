```lua
local repo = "Paficent/Dex"

local Dex = game:HttpGet(string.format("https://github.com/%s/releases/latest/download/Dex.luau", repo))
local config = loadstring(game:HttpGet(string.format("https://raw.githubusercontent.com/%s/main/src/config.luau", repo)))(1)
local DexConfig = {
    saveinstance = config.saveinstance.universalSyn(),
    decompiler = config.decompiler.default(),
}

loadstring(Dex)(DexConfig)
```

```lua
local Dex = game:GetService("ReplicatedStorage").Dex
local config = require(Dex.config)
local DexConfig = {
    saveinstance = config.saveinstance.default(),
    decompiler = config.decompiler.default(),
}

require(Dex)(DexConfig)
```

## Building for Local Development

- Install [Luau-LSP](https://github.com/JohnnyMorganz/luau-lsp) and optionally [Stylua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) if you plan to contribute to this project
- Install [rokit](https://github.com/rojo-rbx/rokit/releases/latest) (restart your computer afterwards on Windows)
- Run `rokit install` to install the neccessary tools
- Run `lune run install` to install wally packages
- Run `rojo serve` to get Dex working via rojo
- Run `lune run build` to build for production
