# P6's POSIX.2: p6df-java

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-java

##### p6df-java/init.zsh

- `p6df::modules::java::deps()`
- `p6df::modules::java::external::brew()`
- `p6df::modules::java::home::symlink()`
- `p6df::modules::java::init(_module, dir)`
- `p6df::modules::java::langs()`
- `p6df::modules::java::vscodes()`
- `str str = p6df::modules::java::prompt::env()`
- `str str = p6df::modules::java::prompt::lang()`

#### p6df-java/lib

##### p6df-java/lib/jenv.sh

- `p6df::modules::java::jenv::latest::installed()`

## Hierarchy

```text
.
├── init.zsh
├── lib
│   └── jenv.sh
├── README.md
└── share

3 directories, 3 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
