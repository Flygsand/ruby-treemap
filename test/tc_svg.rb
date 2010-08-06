
require "test_base"

class TestSvgOutput < Test::Unit::TestCase
    include TestTreemapBase

    def setup
        @root = setup_root
    end

    def test_svg_output
        output = Treemap::SvgOutput.new do |o|
            o.width = 800
            o.height = 600
        end

        File.open(File.dirname(__FILE__) + '/svg_test.svg', "w") do |f|
            f.puts output.to_svg(@root)
        end
    end
end
