Learning some OpenSCAD by building up some models and libraries. So far this
is entirely intended for 3d printing.


## Managing libraries

The `bin/library` script manages the OpenSCAD user library path (auto-detected via `openscad --info`).
For this repo, you'll need the following:

```
./bin/library add git@github.com:BelfrySCAD/BOSL2.git
./bin/library add git@github.com:kennetek/gridfinity-rebuilt-openscad.git gridfinity-rebuilt
./bin/library add "$PWD"/lib don
```

### You can also update all git-managed libraries with:
```
./bin/library update
```

## Installing OpenSCAD nightly
See the instructions at the [OpenSCAD website](https://openscad.org/downloads.html#snapshots).
