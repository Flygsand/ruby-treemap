#
# html_output.rb - RubyTreemap
#
# Copyright (c) 2006 by Andrew Bruno <aeb@qnot.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
#

require 'cgi'
require File.dirname(__FILE__) + "/output_base"
require File.dirname(__FILE__) + "/slice_layout"

class Treemap::HtmlOutput < Treemap::OutputBase
    attr_accessor(:full_html, :base_font_size, :center_labels_at_depth, :center_labels_at_z, :stylesheets, :javascripts)

    def initialize
        super

        # default options for HtmlOutput
        @full_html = true
        @center_labels_at_depth = nil
        @center_labels_at_z = 100
        @stylesheets = ""
        @javascripts = ""
        @base_font_size = 14

        yield self if block_given?

        @layout.position = :absolute
    end

    def default_css
        css = <<CSS
.node {
    border: 1px solid black;
}
.label {
    color: #FFFFFF;
    font-size: 11px;
}
.label-heading {
    color: #FFFFFF;
    font-size: 14pt;
    font-weight: bold;
    text-decoration: underline;
}
CSS
    end

    def node_label(node)
        CGI.escapeHTML(node.label)
    end

    def node_color(node)
        color = "#CCCCCC"

        if(!node.color.nil?)
            if(not Numeric === node.color)
                color = node.color
            else
                color = "#" + @color.get_hex_color(node.color)
            end
        end

        color
    end

    def to_html(node)
        @bounds = self.bounds

        @layout.process(node, @bounds)

        draw_map(node)
    end

    def draw_map(node)
        html = ""

        if(@full_html)
            html += "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" "
            html += "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
            html += "<html><head>"
            html += "<title>Treemap - #{node_label(node)}</title>"
            html += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
            html += "<style type=\"text/css\">" + default_css + "</style>"
            html += self.stylesheets
            html += self.javascripts
            html += "</head><body>"
        end

        html += draw_node(node)

        if(@full_html)
            html += "</body></html>"
        end

        html
    end

    def draw_label(node)
        label= "<span"
        if(!@center_labels_at_depth.nil? and @center_labels_at_depth == node.depth)
            px_per_point = 20
            label_size = node.label.length * px_per_point

            label += " style=\""
            label += "overflow: hidden; position: absolute;"
            label += "margin-top: " + (node.bounds.height/2 - node.font_size(@base_font_size)/2).to_s + "px;"

            left_margin = 0
            if(label_size < node.bounds.width)
                left_margin = (node.bounds.width - label_size) / 2
            end
            label += "margin-left: " + left_margin.to_s + "px;"
            #label += "left: #{node.bounds.x1}px; top: #{node.bounds.y1}px;"
            label += "left: 0px; top: 0px;"
            label += "z-index: #{@center_labels_at_z};"
            label += "font-size:#{node.font_size(@base_font_size)}px;"
            label += "\""
            label += " class=\"label-heading\""
        else
            label += " class=\"label\""
            label += " style=\"font-size:#{node.font_size(@base_font_size)}px\""
        end
        label += ">"
        label += node_label(node)
        label += "</span>"

        label
    end

    # Subclass can override to add more html inside <div/> of node
    def draw_node_body(node)
        draw_label(node)
    end

    def draw_node(node)
        return "" if node.bounds.nil?

        html = "<div id=\"node-#{node.id}\"" 
        html += " style=\""
        html += "overflow: hidden; position: absolute; display: inline;"
        html += "left: #{node.bounds.x1}px; top: #{node.bounds.y1}px;"
        html += "width: #{node.bounds.width}px; height: #{node.bounds.height}px;"
        html += "background-color: " + node_color(node) + ";"
        if(!@center_labels_at_depth.nil? and @center_labels_at_depth == node.depth)
            html += "border: 1px solid black;"
        end
        html += "\" class=\"node\""
        html += ">"

        html += draw_node_body(node)

        if(!node.children.nil? and node.children.size > 0)
            node.children.each do |c|
                html += draw_node(c)
            end
        end

        html += "</div>"
    end
end
