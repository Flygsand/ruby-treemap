
require "test_base"

class TestSimple < Test::Unit::TestCase
    def setup 
        @root = Treemap::Node.new
        @root.new_child(:size => 6)
        @root.new_child(:size => 6)
        @root.new_child(:size => 4)
        @root.new_child(:size => 3)
        @root.new_child(:size => 2)
        @root.new_child(:size => 2)
        @root.new_child(:size => 1)
    end

    def test_simple
        output = Treemap::ImageOutput.new do |o|
            o.width = 600
            o.height = 400
            o.layout = Treemap::SquarifiedLayout.new
        end

        bounds = Treemap::Rectangle.new(0, 0, 600, 400)
        output.layout.process(@root, bounds)

        Treemap::dump_tree(@root)

        output.to_png(@root, File.dirname(__FILE__) + '/simple_test.png')
    end
end
