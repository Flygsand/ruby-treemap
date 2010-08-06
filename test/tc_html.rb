
require "test_base"

class TestHTMLOutput < Test::Unit::TestCase
    include TestTreemapBase

    def setup
        @root = setup_root
    end

    def test_html_output
        output = Treemap::HtmlOutput.new do |o|
            o.width = 800
            o.height = 600
            o.center_labels_at_depth = 1
        end

        File.open(File.dirname(__FILE__) + '/html_test.html', "w") do |f|
            f.puts output.to_html(@root)
        end
    end
end
