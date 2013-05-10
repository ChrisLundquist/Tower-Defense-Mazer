require "./optimizer"
class Maze
  attr_accessor :x_size, :y_size, :nodes, :start, :finish, :path, :fitness

  ADJACENCY_FUNC = lambda { |spot| spot.edges }
  COST_FUNC      = lambda { |from,to| from.distance(to) }
  DISTANCE_FUNC  = lambda { |from,to| from.distance(to) }

  def initialize(x_size, y_size)
    @x_size = x_size
    @y_size = y_size
    build_node_array(x_size, y_size)
    @start = @nodes[0][0]
    @finish = @nodes[y_size - 1 ][x_size - 1]

    @path_finder = AStar.new(ADJACENCY_FUNC, COST_FUNC, DISTANCE_FUNC)
  end

  def to_s
    string = ""
    nodes.each do |row|
      row.each do |node|
        string << (node.blocked? ? "#" : ".")
      end
      string << "\n"
    end
    string
  end

  def build_node_array(x_size, y_size)
   @nodes = []

   y_size.times do |y|
     @nodes << []
     x_size.times do |x|
       @nodes[y] << Node.new(x,y)
     end
   end
  end

  def build_path
    build_node_edges
    @path = @path_finder.find_path(@start,@finish)[1...-1]
  end

  def calculate_fitness
    given_path = build_path || []
    @fitness = given_path.each_cons(2).map { |a,b| a.distance(b) }.reduce { |sum, i| sum + i }.to_f
  end

  def randomize!
    self.nodes.flatten.each do |node|
      [true,false].sample ? node.clear! : node.block!
    end
  end

  def mate(other_maze)
    child = Maze.new(x_size,y_size)
    new_nodes = []

    y_size.times do |y|
      new_nodes << []
      x_size.times do |x|
        new_nodes[y][x] = [self.nodes[y][x], other_maze.nodes[y][x]].sample
      end
    end

    child.nodes  = new_nodes
    child
  end

  def evolve!
    randomize!
    randomize! until calculate_fitness > 0.0
  end

  def invalid?
    start.blocked? or finish.blocked?
  end

  def build_node_edges
    all_nodes = @nodes.flatten
    all_nodes.each do |node|
      node.build_edges(all_nodes)
    end
  end

  def [](index)
    nodes[index]
  end
end
