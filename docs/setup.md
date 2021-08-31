# Setup

## Compiling from Source

### Linux

#### Step 1 - Build Dependencies

The following dependencies are required to build:

- Chicken Scheme >=5.2 + extensions

To build the documentation, include the following dependencies:

- Mkdocs + Mkdocs-material + Mkdocs-localsearch
- scm2wiki

Typically install with:

``` bash
sudo apt install python-pip libimlib2 libimlib2-dev libgit2-dev mkdocs
```


Get the source:

```sh
git clone https://github.com/markjfisher/aoc-chicken
```

Next,install [Chicken Scheme](https://call-cc.org), version 5.0 or
newer. Chicken is available through most distro package
repositories. However, for advanced users we recommend to build it
from source and do a user install.

After installing Chicken itself, you need to install the following
extensions

```sh
chicken-install args base64 bitstring git imlib2 list-utils matchable simple-md5 srfi-1 srfi-4 srfi-13 srfi-14 srfi-18 srfi-41 srfi-69 stack test
```

To build the documentation, you will need [scm2wiki](https://github.com/utz82/scm2wiki),
[MkDocs](https://www.mkdocs.org/), the [mkdocs-material](https://github.com/squidfunk/mkdocs-material) theme,
and the [mkdocs-localsearch](https://github.com/wilhelmer/mkdocs-localsearch)
extension.

```sh
git clone https://github.com/utz82/scm2wiki.git
cd scm2wiki
chicken-install
pip install --user mkdocs mkdocs-material mkdocs-localsearch
```


#### Step 2 - Application Compilation

```sh
cd build/
make
```

You can `make tests` to run unit tests. If you are using Emacs, you
can run make with an additional `ETAGS=1` argument to generate a
suitable TAGS file in the main directory.


#### Viewing docs

```sh
cd build/
make docs
mkdocs serve
```

And then browse to [the generated docs](http://localhost:8000)
