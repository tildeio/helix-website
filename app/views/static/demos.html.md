# Demos

## <%= link_to "Textify", demos_textify_url %>

Textify uses the <code><%= github_link "text_transform", "crates/text_transform" %></code>
crate, which defines a very simple class that implements several class
methods – <code>widen</code>, <code>narrowen</code> and <code>flip</code>.
These methods takes a string as input, perform some interesting
transfomration and return the transformed string.

## <%= link_to "WordCount", demos_word_count_url %>

WordCount uses the <code><%= github_link "word_count", "crates/word_count" %></code>
crate, which defines a very simple class that implements a single class
method: <code>search</code>. This method takes a path to a file and a search string
as input, performing a count of search string in the source file.

## <%= link_to "InlineCSS", demos_inline_css_url %>

InlineCSS uses the <code><%= github_link "inline_css", "crates/inline_css" %></code>
crate, which uses Servo's [cssparser][cssparser] and [html5ever][html5ever] crates
to inline a CSS file into an HTML file.

## <%= link_to "Line and Point", demos_line_point_url %>

Line and Point uses the <code><%= github_link "line_point", "crates/line_point" %></code>
crate, which defines classes that use Helix's `struct` support.

[cssparser]: https://github.com/servo/rust-cssparser
[html5ever]: https://github.com/servo/html5ever