require 'kramdown'

module MarkdownHandler
  KRAMDOWN_OPTIONS = {
    input: 'GFM',              # Use GitHub-flavored markdown
    coderay_css: :class,       # Output css classes to style
    toc_levels: (2..3),        # Generate TOC from <h2>s and <h3>s only
    syntax_highlighter_opts: {
      line_number_anchors: false  # Don't add anchors to line numbers
    }
  }

  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(template)
    compiled_source = erb.call(template)
    "Kramdown::Document.new(begin;#{compiled_source};end, ::MarkdownHandler::KRAMDOWN_OPTIONS).to_html"
  end
end

ActionView::Template.register_template_handler :md, MarkdownHandler
