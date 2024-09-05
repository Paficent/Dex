# Dex
The ultimate debugging suite


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
Join our [Discord](https://discord.gg/5CH8CSw2vt)


## Building Locally

- Install [Luau-LSP](https://github.com/JohnnyMorganz/luau-lsp) and optionally [Stylua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) if you plan to contribute to this project
- Install [rokit](https://github.com/rojo-rbx/rokit/releases/latest) (restart your computer afterwards on Windows)
- Run `rokit install` to install the neccessary tools
- Run `lune run install` to install wally packages
- Run `rojo serve` to get Dex working via rojo
- Run `lune run build` to build for production


## TODO

#### Ordered by priority
- [ ] Rewrite Code:
  - [x] Lib and UI
  - [ ] Explorer
  - [ ] Properties
  - [ ] init.luau
- [ ] Implement [Luau Syntax]:
  - [ ] Compound Operators
  - [x] Avoid using `next`, `ipairs` & `pairs`
  - [ ] Type-checking (only for Plugin API and utils)
  - [ ] `if-then-else` expressions
  - [ ] Floor division
- [ ] Update Build Script:
  - [ ] Optimize build for client and studio
  - [ ] Fix whatever is causing wax to bundle RMD and API in the client build
- [ ] Update Console Window:
  - [ ] Remove lua syntax highlighting
  - [ ] Add text color based on error message output
  - [ ] implement a command input at the bottom
- [x] Update README:
  - [x] TODO (that's this)
  - [x] Acknowledgements
  - [ ]  Better Installation and Build Instructions
- [ ] Remote Spy:
  - [ ] Pausing / Resuming Remote Spy
  - [ ] Remotes captured in specific interval, saving this interval to a file with all remotes captured
  - [ ] Some sort of way to view the interval and remotes via a graph, and clicking on a remote in the timestamp to view information
- [ ] Debugger:
  - [ ] Upvalue Scanner
  - [ ] Constant Scanner
  - [ ] Script Scanner
    - [ ] Get protos in GC
    - [ ] ModuleScripts and LocalScripts
- [ ] 3D Viewer:
  - [ ] Use a viewport frame
  - [ ] Mouse controls, should be able to rotate and zoom, basically freecam script
  - [ ] saveinstance within the viewer
- [ ] Settings Window
- [ ] Plugin API
  
# Acknowledgments
> [!IMPORTANT]
> This project is based almost entirely off the works of [Moon][@LorekeeperZinnia], who originally created Dex explorer, which this project is a highly edited fork of. Additional credits include:
> 
> - [FastSignal][FastSignal] by [Lukasmz][@lukasmz].
> - [UniversalSynSaveInstance][USSI] for their README template and open sourced saveinstance script which Dex has custom support for.


\*\*\* View the source code of this file for more credits

[@LorekeeperZinnia]: https://github.com/LorekeeperZinnia
[@lukasmz]: https://github.com/lucasmz-dev

[FastSignal]: https://github.com/RBLXUtils/FastSignal
[USSI]: https://github.com/luau/UniversalSynSaveInstance/tree/main
[Luau Syntax]: https://luau-lang.org/syntax