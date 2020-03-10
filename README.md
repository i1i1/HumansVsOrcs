# [IAI Assignment 1 -- Humans vs Orcs](https://github.com/i1i1/HumansVsOrcs)

This is assignment of Ryibin Ivan, student of Innopolis University, from group 5.

As algorithmes for traversing I've choosen:
* [Random search](./rand.pl)
* [Backtracking](./backtracking.pl)
* [BFS](./breadth.pl)

In general bactracking is much faster because of the internals of swipl prolog (e.g. BFS wastes a lot of time in nanosleep system call, investigated via strace/ltrace). Generally they are ranked by performance like this:
1. Backtracking (0 ms)
2. BFS (28-200 ms)
3. Random search (500-10000 ms, fail rate usually not less than 30%)

## Part 2
With the new ability to see in two yards changes in time saving can be counted only for BFS and only [sometimes](Example 1), in some [examples](Example 2) it only makes in worse.

You can switch between different visions in [main.pl](./main.pl) file in `touchdown_nearby` predicate.

Vision change won't allow new maps to be solved, because alogithmes doesn't use vision apart from detecting touchdown.

### Example 1
```
   |-----------------------------------------|
19 | . . . O H O . H H H . . O H H H . . O . |
18 | O . . O . . O . . . . O H O T O . . . . |
17 | O . . . . . . . . . . H O . . O H H . . |
16 | . H . O . . O O . O . O . . O . . H H O |
15 | . O . O . . . O O O H . . . H . O . H . |
14 | . H . O . . . H . . O . . . . . . . O . |
13 | . . . H . . O . . . O . . . . . . O . . |
12 | . . H . O . H . . . . . H O O . . O . . |
11 | . . O H . . H . O H . . O . . . . . . H |
10 | . . . . . . O . . O . . H . . . H . . . |
 9 | . . O . . . . . H . O . O . O . . . . O |
 8 | . . . . . . . . . . O . H . . H H . . . |
 7 | O . . O H . H . O H . . O . O . . . . . |
 6 | . . O . H . . . . . . . . . . H . H . . |
 5 | . . . . O . . O O . . . . . . O . O . O |
 4 | H . . O . . . . O . . . . . . . . . H . |
 3 | O O O . . . . . . . . H . O H O . . . H |
 2 | O . O . O . . O . O . . H O . . . O . . |
 1 | O . . . H . H . H H . . O . . . . . . . |
 0 | B . . H . . . . O O . . O . . O . O . . |
---|-----------------------------------------|
Y/X| 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 |
```

BFS for this map from 90 msec to 75 msec.

### Example 2
```
   |-----------------------------------------|
19 | . H H . H H . O . . O . H O . H . O O O |
18 | . . . O . . . . . . O O O . . . O H . . |
17 | O T O . H . O . H . . H . . O O O . H . |
16 | O . O . O O . . . . H H H . H O . . H O |
15 | . . . . O . H . . O . . . . . . . O H . |
14 | O . H . . . . O H . . H O . . H . O . O |
13 | . . O O . O . . H . H . . O H . O . . H |
12 | O . O O . H . H . H O . . . O . . O O . |
11 | . . . . O . O . . . H . O H . . O H O . |
10 | . . O H O O H . . . O . H . . H . . . . |
 9 | O . . . . . O . . O . . O H O O O . . . |
 8 | . H . . O . . . . . O . . H O O . . . . |
 7 | O . H O . . . . . O O . . . . . . . . H |
 6 | . O . . . . . . . O O . . . H . O . O H |
 5 | O H H O . . . . O O O . . . . H . . . H |
 4 | O O . . . H . . O . . . O . . . . O O . |
 3 | H . . . . H . . H . . . H . . . O . . O |
 2 | . . . . O O O . . O . . . H O . . . O . |
 1 | . O H O . O O . O O . . . H . . . . H H |
 0 | B . . . . . . H . O O . . H . . . O . H |
---|-----------------------------------------|
Y/X| 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 |
```

BFS for this map from 96 msec to 125 msec.

## Running
``` sh
docker build . -t i1i1/ass1
./gen_map --human 20 --orc 20 --size 20
docker run -v $PWD/map:/map i1i1/ass1
```
