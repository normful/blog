+++
title = "Nix Pills Notes"
date = 2022-08-05

[taxonomies]
tags = ["nix", "nixos"]
+++

Succinct notes from reading https://nixos.org/guides/nix-pills/ and various Nix manual pages.

# Nix Store

- Never change `/nix/store` manually.

## User Environments

- A user environment is a `/nix/store/<hash>-user-environment` folder

### Manifest of a User Environment

- `/nix/store/<hash>-user-environment/manifest.nix (symlink) -> /nix/store/hash-env-manifest.nix (file)`
- Current manifest: `~/.nix-profile/manifest.nix`

## `nix-store` command

- Manipulates or queries the Nix store

### Operation `--gc`

### Operation `--realise` (`-r`)

- Ensures output paths of a derivation are valid

### Operation `--query` (`-q`)

#### Querying requisites

To print the closure, i.e. the dependencies, of `man` (all equivalent commands):
- `nix-store -qR \`which man\``
- `nix-store --query --requisites \`which man\``
- `nix-store --query --requisites ~/.nix-profile/bin/man`

To show the closure of `man` in tree form:
- `nix-store --query --tree \`which man\``

## Nix database

- Is a SQLite database at `/nix/var/nix/db` that tracks dependencies between derivations.

## Derivations

A Nix derivation:
- is stored at `/nix/store/hash-name`
- is identified by its hash
- can have the same name as another derivation, but with a different hash
- is ambiguous if specified by its name only
- has static dependencies, with dependencies hardcoded in them (even hardcoded in binaries)

If a derivation X depends on a derivation Y, then it always depends on it. A version of X which depended on Z would be a different derivation.

Upgrading a library like glibc means recompiling all applications, because the glibc path is hardcoded.

There's no such global path for plugins, so each application must know the specific Nix store path to each plugin.

### Attribute paths

- Attribute paths: unambiguous
- Derivation names: ambiguous

### Closure of a Derivation

- Is a list of all a derivation's dependencies, recursively

## Profiles

A Nix profile is:
- a set of packages
- versioned using generations
- a sequence of user environments called generations

`$HOME/.nix-profile` is:
- The user's current profile
- Usually is a symlink to `/nix/var/nix/profiles/default`

### `nix profile` command

- `nix profile history`
- `nix profile list`

## Nix expressions

Nix expressions:
- describe packages and how to build packages
- are all at https://github.com/NixOS/nixpkgs

## Channels

A Nix channel:
- is a set of downloadable packages and expressions.
- is a URL pointing to a place containing Nix expressions.

### `nix-channel` command

- Manages Nix channels

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
