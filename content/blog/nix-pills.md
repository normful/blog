+++
title = "Nix Pills Notes"
date = 2022-08-05

[taxonomies]
tags = ["nix", "nixos"]
+++

Succinct notes from reading https://nixos.org/guides/nix-pills/ and various Nix manual pages.

# Nix Store

- Never change `/nix/store` manually.

## `nix-store` command

<https://nixos.org/manual/nix/stable/command-ref/nix-store.html>

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

# User Environments

- A user environment is a `/nix/store/<hash>-user-environment` folder

## Manifest of a User Environment

- `/nix/store/<hash>-user-environment/manifest.nix (symlink) -> /nix/store/hash-env-manifest.nix (file)`
- Current manifest: `~/.nix-profile/manifest.nix`

# Derivations

A Nix derivation:
- is stored at `/nix/store/hash-name`
- is identified by its hash
- can have the same name as another derivation, but with a different hash
- is ambiguous if specified by its name only
- has static dependencies, with dependencies hardcoded in them (even hardcoded in binaries)
- is often interchangeably referred to as a package

If a derivation X depends on a derivation Y, then it always depends on it. A version of X which depended on Z would be a different derivation.

Upgrading a library like glibc means recompiling all applications, because the glibc path is hardcoded.

There's no such global path for plugins, so each application must know the specific Nix store path to each plugin.

## Attribute paths of a derivation

- Attribute paths: unambiguous
- Derivation names: ambiguous

## Closure of a derivation

- Is a list of all a derivation's dependencies, recursively

# Nix database

- Is a SQLite database at `/nix/var/nix/db` that tracks dependencies between derivations.

# Nix Profiles

A Nix profile is:
- a set of derivations (a set of packages)
- versioned using a a sequence of user environments called generations

`$HOME/.nix-profile` is:
- The user's current profile
- Usually is a symlink to `/nix/var/nix/profiles/default`

## `nix profile` command

- `nix profile history`
- `nix profile list`

# Nix expressions

Nix expressions:
- describe packages and how to build packages
- are all at <https://github.com/NixOS/nixpkgs>

# Nix channels

A Nix channel:
- is a set of downloadable packages and expressions.
- is a URL pointing to a place containing Nix expressions.

## `nix-channel` command

- Manages Nix channels

<https://nixos.org/manual/nix/stable/command-ref/nix-channel.html>

# Common Environment Variables

## `NIX_PATH`

<https://nixos.org/manual/nix/stable/command-ref/env-common.html#env-NIX_PATH>

# `~/.nix-defexpr`

- Has several valid file or directory formats. See `nix-env --help`

# `nix-env` command

- Manages environments, profiles and their generations

<https://nixos.org/manual/nix/stable/command-ref/nix-env.html>

## Operation `--install` (`-i`)

- `nix-env -iA <attribute paths that select attributes from the not-level Nix expression>`
    - Unambiguous, faster, preferred
- `nix-env -i <derivation names of active Nix expression>`
    - Possibly ambiguous
- `--dry-run` flag
- By default, all outputs of a derivation are installed.

## Operation `--upgrade`

- `nix-env -u`
    - Upgrades everything
    - Specifically, it creates a new user environment, based on the current generation of the active profile, with newer versions of all derivations 

- `nix-env -u -A nixpkgs.gcc` is an example of upgrading one package

## Operation `--uninstall`

## Operation `--query` (`-q`)

- `nix-env -q --out-path` prints output paths of all derivations of this user's profile's current generation

# Nix language

In the Nix language:
- There are no statements.
- There are only expressions.
- Values are immutable.
- It's all about creating derivations, which are really just sets of attributes to be passed to build scripts.

## Strings

Things coerceable to a string:
- string
- path
- derivation

You cannot mix strings and integers; you must first do the conversion.

`${expr}` is called antiquotation

Multiline strings:

```nix
nix-repl> "first
          second
          third"
"first\n\second\n\third"
```

Indented strings:

```
nix-repl> ''
          a
          b
          ''
"a\nb\n"
```

Indented strings using `''` are common for shell scripts:

```nix
stdenv.mkDerivation {
  ...
  postInstall =
    ''
      mkdir $out/bin $out/etc
      cp foo $out/bin
      echo "Hello World" > $out/etc/foo.conf
      ${if enableBar then "cp bar $out/bin" else ""}
    '';
  ...
}
```

Escaping `${...}` in `''` is done with `''`:

```
nix-repl> ''test ''${foo} test''
"test ${foo} test"
```

URIs can be written without surrounding `"`, but is considered an [anti-pattern](https://nix.dev/anti-patterns/language#unquoted-urls).

## Paths

A path must have at least one `/`.

A path can be specified between angle brackets, e.g. `<nixpkgs>`.

```
nix-repl> :t <nixpkgs>
a path
```

However, `<nixpkgs>` is [not reproducible](https://nix.dev/anti-patterns/language#search-path) unless Nixpkgs is [pinned](https://nix.dev/reference/pinning-nixpkgs).

A path to the current directory:

```
nix-repl> :t ./.
a path
```

However, `./.` is an [anti-pattern](https://nix.dev/anti-patterns/language#attr1-attr2-merge-operator) because it relies on the name of the folder where the code was built. Use the `builtins.path` function instead.

A path containing antiquotation:

```
nix-repl> foo = "x"

nix-repl> :t ./${foo}nix
a path
```

<https://nixos.org/manual/nix/stable/expressions/language-values.html#simple-values>

## Lists

Example:

```nix
[ 123 ./foo.nix "abc" (f { x = y; }) ]
```

A list element that is the result of a function call, must be enclosed in round parentheses.

Lists are immutable, like everything else in Nix.

Adding or removing elements from a list is possible, but will return a new list.

Lists are lazy in values and strict in length.

## Sets (a.k.a. attribute sets)

Sets are the core of the language.

```
nix-repl> :t {unquoted="b";        "quoted" = "d"; }
a set
```

A set is a list of name/value pairs (called attributes) enclosed in curly braces.

Each value is an expression terminated by a semicolon.

Attribute names are strings, and they may be unquoted.

Attribute ordering is irrelevant.

Attribute names may occur only once.

Attributes can be selected from a set using the `.` operator.

The `or` keyword provides a default value in an attribute selection.

```nix
{ foo = 123; }.${bar} or 456
```

This will evaluate to 123 if bar evaluates to "foo" when coerced to a string and 456 otherwise (again assuming bar is antiquotable).

<https://nixos.org/manual/nix/stable/expressions/language-values.html#sets>

Inside a set, you cannot normally refer to elements of the same set:

```
nix-repl> { a = 3; b = a+4; }
error: undefined variable `a' at (string):1:10
```

### Recursive Sets (a.k.a. Recursive Attribute Sets): `rec`

```
nix-repl> rec { a = 3; b = a+4; }
{ a = 3; b = 7; }
```

In a recursive set, attributes are added to the lexical scope of that same set.

Can cause an infinite recursion error if used improperly.

Using `rec` is considered an [anti-pattern](https://nix.dev/anti-patterns/language#rec-expression) and can be replaced with a let-expression.

### Argument Sets

Argument sets are used in functions.

## Let-expressions

The `let` construct adds the variable assignments to the lexical scope of the expression after `in`:

```
nix-repl> let a = 3; b = 4; in a + b
7
```

Two let expressions, one inside the other:

```
nix-repl> let a = 3; in let b = 4; in a + b
7
```

Nested let expressions can have shadowed variables:

```
nix-repl> let a = 3; in let a = 8; in a
8
```

## With-expressions

A with-expression takes a `set1` and includes symbols from `set1` in the scope of expression `expr2`:

```nix
with set1; expr2
```

Examples:

```
nix-repl> longName = { a = 3; b = 4; }
nix-repl> with longName; a + b
7
```

```nix
let blah = { x = "foo"; y = "bar"; }; in
  with blah; x + y
```

evaluates to "foobar".

The most common use of `with` is in conjunction with the import function:

```nix
with (import ./definitions.nix); ...
```

makes all attributes defined in `definitions.nix` available as if they were defined locally in a let-expression.


## Inheriting attributes: `inherit`

```nix
let x = 123; in
{ inherit x;
  y = 456;
}
```

is equivalent to

```
let x = 123; in
{ "x" = x;
  "y" = 456;
}
```

and both evaluate to `{ x = 123; y = 456; }`.

-- 

The following fragment:

``
inherit x y z;
inherit (src-set) a b c;

```

is equivalent to the fragment:

```
x = x; y = y; z = z;
a = src-set.a; b = src-set.b; c = src-set.c;
```

when used while defining local variables in a let-expression or while defining a set.

<https://nixos.org/manual/nix/stable/expressions/language-constructs.html#inheriting-attributes>

## Functions



<!-- TODO(norman): Continue from here https://nixos.org/manual/nix/stable/expressions/language-constructs.html#functions -->

















## Conditionals

```nix
if e1 then e2 else e3
```

where `e1` is an expression that should evaluate to a Boolean value (`true` or `false`).

## `with` expressions

<!-- TODO(norman): Add notes about https://nix.dev/anti-patterns/language#with-attrset-expression -->

## Operators


The `set1 // set2` operator is considered an [anti-pattern](https://nix.dev/anti-patterns/language#search-path) because a nested set in `set1` is replaced by a nested set in `set2`, not merged together. Use the `pkgs.lib.recursiveUpdate` function instead.


# `nix-build` command

Builds a Nix store derivation from a Nix expression.

<https://nixos.org/manual/nix/stable/command-ref/nix-build.html>

Runs:
1. `nix-instantiate` to translate a high-level Nix expression to a low-level store derivation
2. `nix-store --realise` to build the store derivation

# Common Command Options

<https://nixos.org/manual/nix/stable/command-ref/opt-common.html>

<!-- TODO(norman): Read in this order:

https://nixos.org/guides/nix-pills/functions-and-imports.html

https://github.com/tazjin/nix-1p

https://github.com/justinwoo/nix-shorts/tree/master/posts

https://nix.dev/tutorials/declarative-and-reproducible-developer-environments 

https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55
-->
