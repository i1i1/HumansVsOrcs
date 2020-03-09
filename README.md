# [IAI Assignment 1 -- Humans vs Orcs](https://github.com/i1i1/HumansVsOrcs)

This is assignment of Ryibin Ivan, student of Innopolis University, from group 5.

As algorithmes for traversing I've choosen:
* [Random search](./rand.pl)
* [Backtracking](./backtracking.pl)
* [BFS](./breadth.pl)

In general bactracking is much faster because of the internals of swipl prolog (e.g. bfs wastes a lot of time in nanosleep system call). Generally they are ranked by performance like this:
1. Backtracking (0 ms)
2. BFS (28 ms)
3. Random search (737 ms, fail rate 30%)

## Running
``` sh
docker build . -t ass1
./gen_map --human 20 --orc 20 --size 20
docker run -v $PWD/map:/map ass1
```
