
require "test_base"

class TestColor < Test::Unit::TestCase
    def test_color
        g = Treemap::GradientColor.new do |g|
            g.min_color = "FC0404"
            g.mean_color = "DBD9DC"
            g.max_color = "0092C8"
            g.increment = 0.5 
        end

        File.open(File.dirname(__FILE__) + '/color_test.html', "w") do |f|
            f.puts g.to_html
        end
    end
end
