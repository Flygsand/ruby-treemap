
require "test/unit"
require "treemap"
begin
    require "RMagick"
    require "treemap/image_output" 
    require "treemap/svg_output" 
rescue LoadError
end

module TestTreemapBase
    def setup_root
        root = Treemap::Node.new(:size => 100, :label => "all")

        root.new_child(:size => 12, :label => "Child1")
        root.new_child(:size => 8, :label => "Child2")

        child3 = Treemap::Node.new(:size => 10, :label => "Child3")
        [2,2,2,3,1].each do |n|
            child3.new_child(:size => n, :label => "Child3-"+n.to_s)
        end
        root.add_child(child3)

        child4 = Treemap::Node.new(:size => 70, :label => "Child4")
        [5, 40].each do |n|
            child4.new_child(:size => n, :label => "Child4-"+n.to_s)
        end

        child5 = Treemap::Node.new(:size => 25, :label => "Child5")
        [6,8,11].each do |n|
            child5.new_child(:size => n, :label => "Child5-"+n.to_s)
        end

        child4.add_child(child5)
        root.add_child(child4)

        root
    end
end
