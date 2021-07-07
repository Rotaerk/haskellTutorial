Haskell Tutorial
================

Offline Reading
---------------

You can read this tutorial directly on GitHub if you would like, but if you want to read it offline, here's how:

First, copy this repository to your machine. To do so, first install [Git](https://git-scm.com/downloads).  Then
open a command-line shell, navigate to where you would like the repository's directory to be created, and run the
following command:

```console
git clone https://github.com/Rotaerk/haskellTutorial 
```

This will create a new folder for the repository called `haskellTutorial`. If any updates to the tutorial are made,
you can update your local copy by running this from the command-line within that repository folder:

```console
git pull
```

Second, you will need a tool that renders Markdown, the format this tutorial is written in.

One option is to use [Visual Studio Code](https://code.visualstudio.com/), suggested below for writing Haskell code.
It supports displaying a preview of Markdown files, so you can read the tutorial and write code all in the same place.

Another option is to use the Python utility called Grip. A benefit of this tool is that it renders Markdown exactly
as GitHub does, so I used it to preview my changes while writing this tutorial. If you would like to use it,
you will first need to install [Python](https://www.python.org/downloads/), and then follow the installation
instructions for [Grip](https://github.com/joeyespo/grip). Once it's installed, open a command-line shell,
navigate into the repository directory that git created earlier, and run `grip`. It should give you a localhost
URL, which you can open in a web browser to view the rendered Markdown.

Tool Installation
-----------------

It is recommended that you actually write, compile, and run the provided haskell code as instructed throughout
the tutorial. To do this, you will need the following tools:

1. A text editor, preferably one with syntax highlighting support for Haskell code. If you need a suggestion,
   try [Visual Studio Code](https://code.visualstudio.com/).
2. Glasgow Haskell Compiler (GHC) - This translates Haskell code into executable programs.
3. Cabal - This manages packages of Haskell code and utilizes GHC to build executables from them. It will be
   the main tool we use.

To obtain GHC and Cabal, go to the official Haskell site's [downloads](https://www.haskell.org/downloads) page
and follow its instructions. You will **not** need the Stack tool, so you can skip the instructions for installing
that. Multiple installation options are provided, but I recommend the Chocolatey instructions for Windows,
and the GHCup instructions for Linux, OS X, and FreeBSD. An alternative on Linux is to use the
[Nix package manager](https://nixos.org/download.html): With Nix installed, just run `nix-shell` from the root
directory of this repository, which contains a shell.nix file. This will start a shell in which GHC and cabal
are available for use.

Chapters
--------

1. [Hello World](Chapter1.md)
2. [WORK IN PROGRESS](Chapter2.md)
