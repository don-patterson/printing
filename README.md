Learning some OpenSCAD by building up some models and libraries. So far this
is entirely intended for 3d printing.


## Setting up library path
In OpensSCAD, go to Help -> Library Info  and look for "OpenSCAD library path". You'll see something like `~/.local/share/OpenSCAD/libraries`. Inside there, clone BOSL2 and also link to the `lib` directory contained in this repo, if needed.


```
mkdir -p ~/.local/share/OpenSCAD/libraries
cd ~/.local/share/OpenSCAD/libraries
git clone git@github.com:BelfrySCAD/BOSL2.git
ln -s ~/dev/printing/lib don
```

## Installing OpenSCAD nightly
See the instructions at the [OpenSCAD website](https://openscad.org/downloads.html#snapshots).
