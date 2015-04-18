This is solver for the '3D Logic' game available here:
http://www.thatvideogamesite.com/play.php?id=392

All programs in this package are

  Copyright (c) 2007 Zeljko Vrba <http://zvrba.net/contact.html>

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The solver is not very smart: it uses a brute-force method to try all paths
until it finds the solution.  If several solutions exist, only the first one
is printed.

The smallest puzzle (faces size 3) can be represented with the following
(planar) graph:

```
X - X - X -+- X - X - X
|   |   |     |   |   |
X - X - X -+- X - X - X
|   |   |     |   |   |
X - X - X -+- X - X - X
|   |   |     |   |   |
+   +   +     |   |   |
|   |   |     |   |   |
X - X - X-----+   |   |
|   |   |         |   |
X - X - X---------+   |
|   |   |             |
X - X - X-------------+
```

X represents a cell on the face, lines represent connectivity.  The "long"
lines (also broken with a '+') represent transitions from one to another
face. The puzzle description should be entered according to the above graph,
first the top face, then the left face (below the top) and then the right face
(to the right of the top).  Faces must be entered in row-major order, and each
face may be separated from the others by a blank line.  Allowed characters are
'.'  (non-traversable cell), 'x' (traversable cell) and '1' - '9' (endpoints
that should be connected).  There must be no trailing empty lines. See the
provided examples (tests/t??.txt files).

The solver is written in OCaml, so you should install that first to compile
the program.  You can find it here:

http://caml.inria.fr/

The puzzle has an interesting theoretical background: finding disjoint paths
in a graph.  This has been proven to be NP-complete problem, BUT polynomial
time algorithm exists for *planar* graphs and fixed k (number of colors); this
is exactly the case with this puzzle.  However, the algorithm is incredibly
complicated; apart from group theory you also need to find the dual of a
planar graph (which is currently the biggest obstacle for me to implement it).
Nevertheless, the program is pretty fast.

Two papers:

Alexander Schrijver: "Finding k disjoint paths in a directed planar graph"
SIAM J. Comput., Vol. 23, No. 4, pp. 780-788, August 1994

Alexander Schrijver: "A Group-Theoretical Approach to Disjoint Paths in
Directed Graphs"
This document can be fetched here:
http://citeseer.ist.psu.edu/374499.html

The papers give references to other works, also for *nondirected* graphs, but
they are equally complicated.
