# IAI Assignment 1 -- Humans vs Orcs
# Running
``` sh
docker build . -t ass1
./gen_map --human 20 --orc 20 --size 20
docker run -v $PWD/map:/map ass1
```
