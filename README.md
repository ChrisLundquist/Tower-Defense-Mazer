# Description
Make your tower defense mazes optimally long.

You can use a poorly implemented genetic algorithm approach
or a structured approach.

Note: I considered diagonal a valid move.
I construct the edges for each node by selecting all nodes within Math.sqrt(2)

If you don't want diagonals, change that to distance 1.

## Usage

```bash
irb(main):001:0> require "./optimizer"
=> true
irb(main):002:0> maze = Maze.new(10,10)
=> ..........
..........
..........
..........
..........
..........
..........
..........
..........
..........
maze.calculate_fitness
=> 9.899494936611667

irb(main):003:0> Blocker.block(maze)
=> true
irb(main):004:0> maze
=> ..........
#########.
.........#
.#########
.#........
.#.######.
.#.#.....#
.#.#.#####
.#.#.#.#..
..##..#.#.

irb(main):005:0> maze.fitness
=> nil
irb(main):006:0> maze.calculate_fitness
=> 49.38477631085022
irb(main):007:0> maze.fitness
=> 49.38477631085022
```

fitness is the length traveled.
