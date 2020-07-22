# skbd

**S**tark **K**ey **B**ind **D**aemon for macOS.

`skbd` is a simple service that runs in the background that lets you assign
different key binds to different shell commands.

## Installation

To quickest way to get `skbd` installed is using [Homebrew](https://brew.sh).

    brew tap tombell/formulae
    brew install tombell/formulae/skbd

Installing via Homebrew allows you to use `brew services start skbd` to launch
and keep the `skbd` process running.

Alternatively you can build from source, which requires the latest Xcode to be
installed.

    git clone git@github.com:tombell/skbd.git
    cd skbd
    make

If you chose to build from source, you'll need to create your own Launch Agent
`.plist` file to run `skbd` in the background.

## Configuration

`skbd` is configured using a simple configuration file located in
`~/.config/skbd/skbdrc` by default, or can be overridden using the `-c/--config`
flag.

You can declare key binds by specifying the modifier keys and the key to bind to
a command, for example.

    cmd + shift - k: open -a iTerm

The command will be executed using the shell defined by the `$SHELL` environment
variable.

The currently available modifier key string values are:

- `shift`
- `ctrl`/`control`
- `alt`/`opt`/`option`
- `cmd`/`command`
- `hyper`

The `hyper` modifier key, is a shortcut for using `cmd`, `opt`, `shift`, and
`ctrl` all together.

You can also add comments to the configuration file with lines starting with
`#`.
