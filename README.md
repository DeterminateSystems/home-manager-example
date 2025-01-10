# Home Manager Example with FlakeHub Cache

This repository demonstrates how to build and cache Nix Home Manager configurations using FlakeHub Cache and GitHub CI for both macOS and Ubuntu systems.
It showcases a powerful approach to deploying Nix configurations by pre-building and caching fully evaluated closures.

## Overview

The repository uses [FlakeHub Cache](https://docs.determinate.systems/flakehub/cache) to store pre-built Nix closures of Home Manager configurations.
This enables rapid deployment of configurations using the `fh` CLI tool, significantly reducing the time and computational resources needed during deployment.

## How It Works

1. **Configuration Structure**
   - The repository defines Home Manager configurations for both macOS and Ubuntu in a single flake
   - Configurations are parameterized by `username` and `hostname`
   - System-specific packages are conditionally included based on the target platform

2. **Build Process**
   - GitHub CI builds the configurations for both platforms
   - The build process fully evaluates and realizes the Nix closures
   - FlakeHub Cache stores these pre-built closures for later use

3. **Deployment**
   - Users can quickly deploy configurations using:
   ```bash
   # Resolve the pre-built closure from FlakeHub Cache
   fh resolve "determinatesystems/home-manager-example/*#homeConfigurations.linuxUsername@linuxHostname"
   /nix/store/4rl65vxv427k17nv3fkgqjgpah548b9j-home-manager-generation

   # Apply the configuration
   fh apply home-manager /nix/store/4rl65vxv427k17nv3fkgqjgpah548b9j-home-manager-generation
   ```

## Benefits of Pre-built Closures

Traditional Nix deployments require each machine to:
1. Evaluate the Nix expressions
2. Realize the closures
3. Download or build missing dependencies

Using pre-built closures from FlakeHub Cache offers several advantages:
- **Faster Deployments**: Skip local evaluation and building
- **Reduced Resource Usage**: No need for local compilation
- **Consistent Environments**: Guarantee identical outputs across machines
- **Lower Bandwidth**: Download only the required closure
- **CI-Verified**: Configurations are pre-tested in CI

## Repository Structure

```
.
├── flake.nix              # Main flake configuration
├── home-manager/
│   └── default.nix        # Home Manager configuration
└── lib/                   # Helper functions
```

## Key Components

### Flake Inputs
```nix
inputs = {
  determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";
  home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.2411.*";
  nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
};
```

### Configuration Outputs

```nix
homeConfigurations = {
  "macUsername@macHostname" = helper.mkHome {
    username = "macUsername";
    hostname = "macHostname";
    platform = "darwin-aarch64";
  };
  "linuxUsername@linuxHostname" = helper.mkHome {
    username = "linuxUsername";
    hostname = "linuxHostname";
    platform = "linux-x86_64";
  };
};
```

## Beyond Home Manager

This same technique can be extended to:
- **NixOS Configurations**: Cache system configurations for faster server deployments
- **nix-darwin Configurations**: Pre-build macOS system configurations
- **Development Environments**: Cache development shells and tooling

The benefits of using FlakeHub Cache become even more pronounced with these larger configurations, as they typically involve more packages and longer build times.

## Getting Started

1. Fork this repository
2. Update the usernames and hostnames in `flake.nix`
3. Modify the Home Manager configuration in `home-manager/default.nix`
4. Push your changes to trigger the CI build
5. Deploy using `fh resolve` and `fh apply home-manager`

## Further Reading

- [FlakeHub Publishing Guide](https://docs.determinate.systems/flakehub/publishing)
- [FlakeHub Cache Documentation](https://docs.determinate.systems/flakehub/cache)
- [FlakeHub Store Paths](https://docs.determinate.systems/flakehub/store-paths)
