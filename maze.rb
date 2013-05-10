require "./optimizer"
class Maze
  attr_accessor :length, :width, :nodes, :start, :finish, :path

  ADJACENCY_FUNC = lambda { |spot| spot.edges }
  COST_FUNC      = lambda { |from,to| from.distance(to) }
  DISTANCE_FUNC  = lambda { |from,to| from.distance(to) }

  def initialize(x_size, y_size)
    build_node_array(x_size, y_size)
    @start = @nodes[0][0]
    @finish = @nodes[x_size - 1 ][y_size - 1]

    @path_finder = AStar.new(ADJACENCY_FUNC, COST_FUNC, DISTANCE_FUNC)
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

  def fitness
    build_path.each_cons(2).map { |a,b| a.distance(b) }.reduce { |sum, i| sum + i }
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
