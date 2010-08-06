
require "test_base"

class TestSlice < Test::Unit::TestCase
    include TestTreemapBase

    def setup
        @root = setup_root
    end

    def test_slice
        output = Treemap::ImageOutput.new do |o|
            o.width = 800
            o.height = 600
            o.layout = Treemap::SliceLayout.new
        end

        output.to_png(@root, File.dirname(__FILE__) + '/slice_test.png')

        bounds = Treemap::Rectangle.new(0, 0, 800, 600)
        output.layout.process(@root, bounds)

        Treemap::dump_tree(@root)
    end
end
