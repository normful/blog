+++
title = "Nix Pills Notes"
date = 2022-08-05

[taxonomies]
tags = ["nix", "nixos"]
+++

Some notes from reading https://nixos.org/guides/nix-pills/

# Nix Store

- Never change `/nix/store` manually.

## User Environments

- A user environments is a `/nix/store/<hash>-user-environment` folder

### Manifest of a User Environment

- `/nix/store/<hash>-user-environment/manifest.nix (symlink) -> /nix/store/hash-env-manifest.nix (file)`
- Current manifest: `~/.nix-profile/manifest.nix`

## `nix-store`

- Manipulates or queries the Nix store

### Operation `--gc`

### Operation `--realise` (`-r`)

- Ensures output paths of a derivation are valid

### Operation `--query` (`-q`)

#### Querying requisites

These are all equivalent and print the closure (the dependencies) of `man`:
- `nix-store -qR \`which man\``
- `nix-store --query --requisites \`which man\``
- `nix-store --query --requisites ~/.nix-profile/bin/man`

Same thing in form:
- `nix-store --query --tree \`which man\``

## Nix database

- Is a SQLite database at `/nix/var/nix/db` that tracks dependencies between derivations.

## Derivations

- Stored as `/nix/store/hash-name`
- Identified by their hash
- Can have the same name but different hashes (thus derivation names by themselves are ambiguous)

Upgrading a library like glibc means recompiling all applications, because the glibc path is hardcoded.
There's no such global path for plugins, so each application must know the specific Nix store path to each plugin.

### Attribute paths

- Attribute paths: unambiguous
- Derivation names: ambiguous

### Closure of a Derivation

- Is a list of all a derivation's dependencies, recursively

## Profiles

- A set of packages
- Versioned using generations
- A sequence of user environments called generations
- `$HOME/.nix-profile`
    - The user's current profile
    - Usually is a symlink to `/nix/var/nix/profiles/default`
- `nix profile history`
- `nix profile list`

## Nix expressions

- Describe packages and how to build packages
- All expressions are in https://github.com/NixOS/nixpkgs

```sh
downloading Nix expressions from `http://releases.nixos.org/nixpkgs/nixpkgs-14.10pre46060.a1a2851/nixexprs.tar.xz'...
```

## Nix channels

- Are a set of downloadable packages and expressions

## `nix repl`

```nix
nix-repl> :t { abc = "e"; }
a set
```

```nix
nix-repl> :t {arg1, arg2, ...}: {foo = "bar";}
a function
```

## `NIX_PATH`

## `~/.nix-defexpr`

- Has several valid file or directory formats. See `nix-env --help`

## `nix-env`

- Manages environments, profiles and their generations

### Operation `--install` (`-i`)

- `nix-env -iA <attribute paths that select attributes from the not-level Nix expression>`
    - Unambiguous, faster, preferred
- `nix-env -i <derivation names of active Nix expression>`
    - Possibly ambiguous
- `--dry-run` flag
- By default, all outputs of a derivation are installed.

### Operation `--upgrade`

### Operation `--uninstall`

### Operation `--query` (`-q`)

- `nix-env -q --out-path` prints output paths of all derivations of this user's profile's current generation

