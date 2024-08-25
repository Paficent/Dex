```lua
local repo = "Paficent/Dex"
local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/%s/main/src/config.luau":format(repo)))(1)

local DexConfig = { -- I'll eventually write up a specific readme for the config format
    decompiler = config.decompiler.default()
}
--// Studio dex will be loaded via a require
loadstring(game:HttpGet(`https://github.com/{repo}/releases/latest/download/Dex.luau`))(DexConfig)
```


## Roadmap
Everything here is ordered by priority

- [x] Add Executor Window
    - [x] use Fiu and Luauception for studio compilation
- [ ] Update build script
    - [ ] Optimize build for client and studio
    - [ ] Fix whatever the fuck is causing wax to bundle RMD and API in the client build
- [] Update Console Window
    - [ ] change styling differently
    - [ ] implement a command input at the bottom
- [] Modularize Code
    - [x] Lib and UI
    - [ ] Explorer
    - [ ] Properties
- [ ] 3d viewer - Paficent
    - [ ] Use a viewport frame
    - [ ] Saveinstance within the viewer    
- [ ] Update README
    - [x] Roadmap (that's this)
    - [ ] Proper credits
    - [ ] Install and building instructions
    - [ ]
- [ ] Remote Spy
    - [ ] yh
- [ ] Debugger
    - [ ] Upvalue Scanner
    - [ ] Constant Scanner
    - [ ] Script Scanner
        - [ ] Get protos in GC
        - [ ] ModuleScripts and LocalScripts
- [ ] Http Spy (Might scratch this cuz detections)
    - [ ] Undetectable (hopefully) http spy
    - [ ] Possibly an option in the console window? not sure
    - [ ] Off by default
- [ ] Rewrite init.luau

## Building for Local Development
- Install [Luau-LSP](https://github.com/JohnnyMorganz/luau-lsp) and optionally [Stylua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) if you plan to contribute to this project
- Install [rokit](https://github.com/rojo-rbx/rokit/releases/latest) (restart your computer afterwards on window)
- Run `rokit install` to install the neccessary tools
- Run `lune run install` to install wally packages
- Run `rojo serve` to get Dex working via rojo
- Run `lune run build` to build for production



### For the love of god oogway, 