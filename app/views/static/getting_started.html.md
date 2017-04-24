## Getting Started

### Downloading Rust

```bash
# Make sure you have Rust installed using rustup.
# https://www.rustup.rs/

# If you already have rustup installed.
$ rustup update

# Use the beta version of Rust.
$ rustup install beta
```

### Building Helix Textify Rails

The best way to see how useful and powerful Helix can be is by seeing it in action.

Let's walk through how to build a simple Rails app, which leverages the speed of Rust by implementing Helix!
We won't do anything too fancy—to start, our app will just take some text, and transform it.

First, we'll need a new rails project.

```bash
$ rails new helix-textify-rails
```

Next, we'll add a very simple `TextTransform` model, which will implement `widen`, `narrow`, and `flip` methods.

```{app/models/text_transform.rb}ruby
class TextTransform
  attr_accessor :content

  def initialize(content)
    @content = content
  end

  def widen
    new_string = ""

    content.each_char do |c|
      new_string += widen_map[c] ? widen_map[c] : c
    end

    new_string
  end

  def narrow
    # narrows the contents of a string
  end

  def flip
    # flips the contents of a string
  end

  private

  def widen_map
    {
      ' ' => '  ', '!' => '！', '"' => '＂', '#' => '＃', '$' => '＄', '%' => '％', '&' => '＆', '\'' => '＇',
      '(' => '（', ')' => '）', '*' => '＊', '+' => '＋', ',' => '，', '-' => '－', '.' => '．', '/' => '／',
      '0' => '０', '1' => '１', '2' => '２', '3' => '３', '4' => '４', '5' => '５', '6' => '６', '7' => '７',
      '8' => '８', '9' => '９', ':' => '：', ';' => '；', '<' => '＜', '=' => '＝', '>' => '＞', '?' => '？',
      '@' => '＠', 'A' => 'Ａ', 'B' => 'Ｂ', 'C' => 'Ｃ', 'D' => 'Ｄ', 'E' => 'Ｅ', 'F' => 'Ｆ', 'G' => 'Ｇ',
      'H' => 'Ｈ', 'I' => 'Ｉ', 'J' => 'Ｊ', 'K' => 'Ｋ', 'L' => 'Ｌ', 'M' => 'Ｍ', 'N' => 'Ｎ', 'O' => 'Ｏ',
      'P' => 'Ｐ', 'Q' => 'Ｑ', 'R' => 'Ｒ', 'S' => 'Ｓ', 'T' => 'Ｔ', 'U' => 'Ｕ', 'V' => 'Ｖ', 'W' => 'Ｗ',
      'X' => 'Ｘ', 'Y' => 'Ｙ', 'Z' => 'Ｚ', '[' => '［', '\\' => '＼', ']' => '］', '^' => '＾', '_' => '＿',
      '`' => '｀', 'a' => 'ａ', 'b' => 'ｂ', 'c' => 'ｃ', 'd' => 'ｄ', 'e' => 'ｅ', 'f' => 'ｆ', 'g' => 'ｇ',
      'h' => 'ｈ', 'i' => 'ｉ', 'j' => 'ｊ', 'k' => 'ｋ', 'l' => 'ｌ', 'm' => 'ｍ', 'n' => 'ｎ', 'o' => 'ｏ',
      'p' => 'ｐ', 'q' => 'ｑ', 'r' => 'ｒ', 's' => 'ｓ', 't' => 'ｔ', 'u' => 'ｕ', 'v' => 'ｖ', 'w' => 'ｗ',
      'x' => 'ｘ', 'y' => 'ｙ', 'z' => 'ｚ', '{' => '｛', '|' => '｜', '}' => '｝', '~' => '～'
    }
  end
end
```

We'll also need a `TextTransform` controller.

```{app/controllers/text_transform_controller.rb}ruby
class TextTransformController
  def index
  end

  def transform
    if params[:widen]
      transformed_text = TextTransform.new(params[:content]).widen
    elsif params[:narrow]
      transformed_text = TextTransform.new(params[:content]).narrow
    elsif params[:flip]
      transformed_text = TextTransform.new(params[:content]).flip
    end

    render json: transformed_text
  end
end
```

In our view, we'll have a form with an input field, with three different `submit_tag`s, each of which will `POST` to a `transform_path`, with either a `widen`, `narrow`, or `flip` param.

When we run our Rails server, we'll see something that looks like this:

<%= image_tag "getting-started/helix-textify-rails.png" %>

Next, we'll want to integrate Helix and add the `helix-rails` gem:

```{Gemfile}ruby
source 'https://rubygems.org'

gem 'helix-rails', '0.0.5'
```

Be sure to run `bundle install` afterwards.

The `helix-rails` gem provides us with generators to get started.

We can run `rails g helix:add_crate text_transform`, which creates a Helix `crates` directory with a `/crates/text_transform` directory inside of it. This is home to a Rust file, which is where we'll store the Rust implementation of our current Ruby code.

Let's take a look at that Rust file:

```{crates/text_transform/src/lib.rs}rust
#[macro_use]
extern crate helix_runtime as helix;

// ruby! {
//     class MyClass {
//         def hello(&self) {
//             println!("Hello!");
//         }
//     }
// }
```

This is where we'll re-implement our Ruby code in Rust!

We'll start by adding a widen method, which we can denote as an instance method by passing in `&self`:

```{crates/text_transform/src/lib.rs}rust
#[macro_use]
extern crate helix_runtime as helix;

ruby! {
    class TextTransform {
        def widen(&self, text: String) -> String {
        }
    }
}
```

Then, we can re-implement our Ruby `widen` method:

```{crates/text_transform/src/lib.rs}rust
#[macro_use]
extern crate helix_runtime as helix;

ruby! {
    class TextTransform {
        def widen(&self, text: String) -> String {
            text.chars().map(|char| {
                match char {
                    ' ' => '\u{3000}', '!' => '！', '"' => '＂', '#' => '＃', '$' => '＄', '%' => '％', '&' => '＆', '\'' => '＇',
                    '(' => '（', ')' => '）', '*' => '＊', '+' => '＋', ',' => '，', '-' => '－', '.' => '．', '/' => '／',
                    '0' => '０', '1' => '１', '2' => '２', '3' => '３', '4' => '４', '5' => '５', '6' => '６', '7' => '７',
                    '8' => '８', '9' => '９', ':' => '：', ';' => '；', '<' => '＜', '=' => '＝', '>' => '＞', '?' => '？',
                    '@' => '＠', 'A' => 'Ａ', 'B' => 'Ｂ', 'C' => 'Ｃ', 'D' => 'Ｄ', 'E' => 'Ｅ', 'F' => 'Ｆ', 'G' => 'Ｇ',
                    'H' => 'Ｈ', 'I' => 'Ｉ', 'J' => 'Ｊ', 'K' => 'Ｋ', 'L' => 'Ｌ', 'M' => 'Ｍ', 'N' => 'Ｎ', 'O' => 'Ｏ',
                    'P' => 'Ｐ', 'Q' => 'Ｑ', 'R' => 'Ｒ', 'S' => 'Ｓ', 'T' => 'Ｔ', 'U' => 'Ｕ', 'V' => 'Ｖ', 'W' => 'Ｗ',
                    'X' => 'Ｘ', 'Y' => 'Ｙ', 'Z' => 'Ｚ', '[' => '［', '\\' => '＼', ']' => '］', '^' => '＾', '_' => '＿',
                    '`' => '｀', 'a' => 'ａ', 'b' => 'ｂ', 'c' => 'ｃ', 'd' => 'ｄ', 'e' => 'ｅ', 'f' => 'ｆ', 'g' => 'ｇ',
                    'h' => 'ｈ', 'i' => 'ｉ', 'j' => 'ｊ', 'k' => 'ｋ', 'l' => 'ｌ', 'm' => 'ｍ', 'n' => 'ｎ', 'o' => 'ｏ',
                    'p' => 'ｐ', 'q' => 'ｑ', 'r' => 'ｒ', 's' => 'ｓ', 't' => 'ｔ', 'u' => 'ｕ', 'v' => 'ｖ', 'w' => 'ｗ',
                    'x' => 'ｘ', 'y' => 'ｙ', 'z' => 'ｚ', '{' => '｛', '|' => '｜', '}' => '｝', '~' => '～', _ => char,
                }
            }).collect()
        }
    }
}
```

Since we now have our Rust implementation ready to go, we can remove our Ruby implementation of this entirely. This means that our Rails model now looks much simpler:

```{app/models/text_transform.rb}ruby
class TextTransform
end
```

We'll have these methods available to us through Helix's binding, and since we've named them the same, everything just works. This means that we can call our methods in the same way we did before, just slightly changing how we pass in our content string:

```{app/controllers/text_transform_controller.rb}ruby
class TextTransformController
  def index
  end

  def transform
    if params[:widen]
      transformed_text = TextTransform.new(params[:content]).widen
    elsif params[:narrow]
      transformed_text = TextTransform.new(params[:content]).narrow
    elsif params[:flip]
      transformed_text = TextTransform.new(params[:content]).flip
    end

    render json: transformed_text
  end
end
```

We're finally ready to run Rust in our Rails application!

When we go back to our application and refresh the page, however, we run into this error:

<%= image_tag "getting-started/helix-textify-rails-error.png" %>

This just means that we need to recompile our Rust code!

If we run `rake build` and restart our Rails server, we should see our app load as expected. Let's try widening some text:

<%= image_tag "getting-started/helix-textify-rails-input.png" %>

When we submit our form, the widened string that is returned to us comes from our Helix!

<%= image_tag "getting-started/helix-textify-rails-output.png" %>

With Helix, you can use the same Ruby classes that you know and love, but in Rust, and without having to write the glue yourself!

You can view live the demo Helix text transform app [here](https://github.com/tildeio/helix-textify-rails).

If you'd like to use Helix in your own project, check out our [documentation](/documentation).
