require 'kramdown'
require 'kramdown/parser'

module Kramdown
  module Parser
    class Extras < GFM
      FENCED_CODEBLOCK_PLUS_START = /^[ ]{0,3}[~`]{3,}\{?/
      FENCED_CODEBLOCK_PLUS_MATCH = /^[ ]{0,3}(([~`]){3,})(?:\{(\S+)\})?\s*?((\S+?)(?:\?\S*)?)?\s*?\n(.*?)^[ ]{0,3}\1\2*\s*?\n/m

      def initialize(*)
        super

        {:codeblock_fenced_gfm => :codeblock_fenced_gfm_plus}.each do |current, replacement|
          i = @block_parsers.index(current)
          @block_parsers.delete(current)
          @block_parsers.insert(i, replacement)
        end
      end

      def update_elements(element)
        super

        element.children.map! do |child|
          if child.type == :header && options[:auto_ids]
            wrapped = Element.new(:a, nil, { href: "##{child.attr['id']}" }).tap do |el|
              el.children = child.children
            end
            child.children = [wrapped]
            child.attr['data-autolink'] = ""
            child
          elsif child.type == :li
            p = child.children[0]
            text = p.children[0]

            next child unless text && text.type == :text

            task = text.value.match(/^\[(?<checked>[xX ])\]/)

            next child unless task

            child.attr['class'] = 'task'
            text.value = text.value[4..-1]
            p.children = [
              Element.new(:html_element, :input, {
                type: 'checkbox',
                checked: task[:checked] != ' ' ? '' : nil,
                disabled: '',
               }, category: :block),
              *p.children
            ]
            child
          else
            child
          end
        end
      end

      define_parser(:codeblock_fenced_gfm_plus, FENCED_CODEBLOCK_PLUS_START, nil, 'parse_codeblock_fenced')

      def parse_codeblock_fenced
        if @src.check(self.class::FENCED_CODEBLOCK_PLUS_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          el = new_block_el(:codeblock, @src[6], nil, :location => start_line_number)

          if @src[3]
            el.attr['data-filename'] = @src[3]
          end

          lang = @src[4].to_s.strip
          unless lang.empty?
            el.options[:lang] = lang
            el.attr['class'] = "language-#{@src[5]}"
          end
          @tree.children << el
          true
        else
          false
        end
      end
    end
  end
end

module MarkdownHandler
  KRAMDOWN_OPTIONS = {
    input: 'Extras',
    hard_wrap: false
  }

  ERB = ActionView::Template.registered_template_handler(:erb)

  def self.call(template)
    compiled_source = ERB.call(template)
    "Kramdown::Document.new(begin;#{compiled_source};end, ::MarkdownHandler::KRAMDOWN_OPTIONS).to_html"
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
