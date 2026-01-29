# sharpide-flake
A community nix flake for the in-development cross-platform C# IDE, SharpIDE

## In-Development Notice
SharpeIDE is still very early in active development, and this flake is a botch attempt at making it work on NixOS. There may very well be issues. This is my first attempt at a flake, so bear with me. 

## Usage
- Add `sharpide.url = "github:spudnut2000/sharpide-flake";` to your flake inputs
- Enable it with `sharpide.packages.${pkgs.system}.default`
- Run it with the command `sharpide`

## Known Issues with this Flake (Not SharpIDE issues)
- The flake combines .NET SDK versions 8 and 9 from nixpkgs stable, I do not currently have any options to add additional sdks, but you may be able to use some nix magic to override these. 
- Currently, no .desktop file is made, so you can only run it with the `sharpide` command
- SharpIDE uses Godot, and I have noticed with the default Nvidia drivers that my RTX 3070 falls back to OpenGL instead of Vulkan. This shouln't affect performance too much, but I'm looking for a fix.

## Contributing
Contributions are welcome and encouraged, you can use the issues tab or just create a PR. Please refrain from using generative AI.

## Credits
- @MattParkerDev and the SharpIDE team: https://github.com/MattParkerDev/SharpIDE
