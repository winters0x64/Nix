# Notes about Nix and NixOS

## 1) nixos-rebuild

```nixos-rebuild switch``` This command rebuilds the entire system as specified in the configuration file, and the switch option builds the new system and sets it as boot default in the system's bootloader.

(other options -> man nixos-rebuild)


## 2) Upgrading NixOS

The default channel is stable channel so all you have to do to update the system and switch to the new system is to type the command ```nixos-rebuild switch --upgrade```

## 3) Garbage collection

```nix-collect-garbage``` this cleans up your computer to remove all paths which are unreachable in the nix store,thus freeing space, the command ```nix-collect-garbage -d``` deletes all the older generations as well leaving only the current version behind hence freeing up more space, after this command run
```sudo nixos-rebuild switch``` to actually delete boot entries in grub or systemd-boot and free up space in the /boot/efi partition.
```sudo nix-env --list-generations --profile /nix/var/nix/profiles/system``` to list the generations on the system profile as different users have different profiles.
```df -h```  Not really a nix specific command but this can be handy to keep a watch on your partitions.

## 4) Nix language

These  are some data types that are available in Nix

~ String, networking.hostName = "dexter";

~ Booleans, networking.firewall.enable = false;

~ Integers, boot.kernel.sysctl."net.ipv4.tcp_keepalive_time" = 60;

~ Sets, 
```
{ services = {
    httpd = {
      enable = true;
      adminAddr = "alice@example.org";
    };
  };
}
```
The above set can also be referenced as services.enable = true, ie through a dot.

~ Lists, boot.kernelModules = [ "fuse" "kvm-intel" "coretemp" ]; or swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

~ let and in
```
let
  myVariable = "Hello, world!";
in
  "The value of myVariable is: ${myVariable}"
```

let and in provide a way to create and use local variables in Nix expressions

~ Functions 
```
{
  services.httpd.virtualHosts =
    let
      makeVirtualHost = webroot:
        { documentRoot = webroot;
          adminAddr = "alice@example.org";
        };
    in
      { "example.org" = (makeVirtualHost "/webroot/example.org");
        "example.com" = (makeVirtualHost "/webroot/example.com");
      };
}
```
makeVirtualHost is a function that takes a single argument webroot and returns the configuration for a virtual host.

## Nix channels 

A Nix channel is just a URL that points to a place that contains a set of Nix expressions and a manifest.

```nix-channel --update```  This downloads and unpacks the Nix expressions in every channel.

## Profiles

# Home Manager


# Flakes


**Sources = NixOS manual,manpages**
