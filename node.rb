require "./optimizer"

class Node
  attr_accessor :type, :x, :y, :edges

  PASSABLE = :passable
  BLOCKED  = :blocked

  TYPES = [
    :passable,
    :blocked,
  ]

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @type = PASSABLE
    @edges = []
  end

  def to_s
    "<Node #{coordinates}, #{type}>"
  end

  def coordinates
    "(#{x},#{y})"
  end

  def build_edges(nodes)
    self.edges = []
    neighbors = nodes.select do |node|
      self != node and
      node.passable? and
      self.distance(node) <= Math.sqrt(2)
    end
    self.edges += neighbors
  end

  def distance(other_node)
    delta_x_squared = (x - other_node.x) * (x - other_node.x)
    delta_y_squared = (y - other_node.y) * (y - other_node.y)

    total_delta = delta_x_squared + delta_y_squared

    Math.sqrt(total_delta)
  end

  def passable?
    type == PASSABLE
  end

  def blocked?
    type == BLOCKED
  end

  def clear!
    @type = PASSABLE
  end

  def block!
    @type = BLOCKED
  end

end
