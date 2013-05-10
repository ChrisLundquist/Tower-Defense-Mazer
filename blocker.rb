class Blocker
  def self.block(maze)
    step = 0
    while path = maze.build_path
      node = path[step]
      return true unless node
      node.block!

      unless maze.build_path
        node.clear!
        step += 1
      end
    end
  end
end
