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
method: <code>search</code>. This methods takes a path to a file and a search string
as input, performing a count of search string in the source file.
