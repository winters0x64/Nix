## These are some of the reasons to use NixOS in my view point.

1) The entire operating system could be defined in a configuration file, this is insanely good for many reasons such as you could see what all things did you install in your system, what all things did you configure in your system, what all changes you made in your system, your dotfiles, The config file could even define kernel modules and many other stuff, all this and more the configuration file does this declaratively this means it's just a matter editing a few variables if you want to enable or disable some services or features.

2) The configuration file is reusable ie, i can just do an install with my already configured configuration file from a previous nixos installation and get to a working new system with ease.Basically cloning a system.

3) The generations concept in NixOS makes it ok to tinker with our system as even if we break some stuff on a newer generation we can rollback to a previous generation and the broken packages will be reverted back to the state when they were all good.

4) Everyone and their grandma uses arch now(thanks to arch install script,btw), but learning Nix and NixOS could be hard and actually gives a sense of achievement when you finally look at your entire system in a flake.Hence giving you the "Cool Kid" status once more.

5) It's way "Cooler".