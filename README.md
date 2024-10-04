# dotfiles
dotfiles

My config that I use for mainly rust and lua development on windows

It's mainly a handful of other configs I've seen and wezterm plugins mashed together but I like it.
I also wouldn't use any of the bindings from helix, I generally just yoink things that look nice and add my own and forget to remove the ones that don't feel good

If you want to use the wezterm config be aware that the 'Platform specific config' section has paths specific to me and you'll need to edit the config.background to remove the background image


Other tools I use regularly: 
* [https://github.com/sxyazi/yazi](yazi) - File manager
* [https://github.com/talwat/lowfi](lowfi) - Lofi music player, just found this and I like it a lot.
* [https://github.com/ajeetdsouza/zoxide](zoxide) - Smarter cd command for navigating the filesystem rapidly
* [https://github.com/altsem/gitu](gitu) - Magit inspired git tui 
* [https://starship.rs/](starship) - Colorful prompt using catppuccin theme
* PowerShell 7
* [scoop.sh](scoop) - Packages installed in user space with easy updating and removal and no leftover registry entrys when you delete a folder. I love scoop

Tools I'm on the lookout for:
* Some kind of cli notebook or journalling that feels good 
* Helix plugin system, lisp is always fun
* Declarative package manager or a config file for scoop for making reproducible shells
* An alternative to musikcube for tui music playing using vim bindings

Scoop + Wezterm + Rust is truly a blessed development environment 

Side note you can also get tiling windows using something like komorebi or GlazeWM but I found that they sometimes just mess with the windows and make them unresponsive.
Powertoys Fancy Zones also works but you won't get hotkeys and a statusline.

...
Still holding on to the pipe-dream that is a exwm/nxwm windows experience.

I'm not using wsl2 either but it's easily possible with Wezterms built in wsl support
