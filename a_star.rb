require "./optimizer"
class AStar
    def initialize(adjacency_func, cost_func, distance_func)
        @adjacency = adjacency_func
        @cost = cost_func
        @distance = distance_func
    end

    def find_path(start, goal)
        been_there = {}
        pqueue = PriorityQueue.new
        pqueue.add(1, [start, [], 0])
        # Less than 25 is arbitrary
        while(!pqueue.empty?)
            spot, path_so_far, cost_so_far = pqueue.next
            next if been_there[spot]
            newpath = path_so_far + [spot]
            return newpath if (spot == goal)
            been_there[spot] = true
            @adjacency.call(spot).each do |newspot|
                next if been_there[newspot]
                tcost = @cost.call(spot, newspot)
                next unless tcost
                newcost = cost_so_far + tcost
                pqueue.add(newcost + @distance.call(goal, newspot),
                    [newspot, newpath, newcost])
            end
        end
        return []
    end

    class PriorityQueue
        attr :list
        def initialize
            @list = []
        end
        def add(priority, item)
            @list << [priority, @list.length, item]
            @list = @list.sort_by { |a| a[0] }
            self
        end
        def <<(pritem)
            add(*pritem)
        end
        def next
            @list.shift[2]
        end
        def empty?
            @list.empty?
        end
    end

end

