{::options auto_ids="false" /}

# Native Ruby Extensions **Without Fear**

## Helix makes writing Ruby classes in Rust **safe** and **fun**.

<div markdown="1" class="code-samples">

```{src/lib.rs}rust
#[macro_use]
extern crate helix;

ruby! {
    class Console {
        def log(string: &str) {
            println!("LOG: {:?}", string);
        }
    }
}
```

```ruby
$ irb
>> require "console"
>> Console.log("I'm in your Rust")
LOG: "I'm in your Rust"
```

</div>

<%= render partial: "creatures" %>

<section markdown="1" id="fast">

### BLAZING FAST

Helix lets you offload performance-critical code to Rust without leaving your Ruby workflow.

```{app/controllers/expensive.rb}ruby
class CountWordsController < ApplicationController
  def index
    # WordCount is written in Rust
    render json: {
      count: WordCount.search("shakespeare-plays.txt", "thee")
    }
  end
end
```

</section>

<section markdown="1" id="ecosystem">

### USE RUST LIBRARIES

Easily use all of the production-ready crates on crates.io right inside your Rails app.

```{crates/scrape-hn/lib.rs}rust
// import scraper, which uses HTML and CSS
// libraries built for Servo
extern crate scraper;

ruby! {
  class ScrapeHN {
    def scrape(url: String) -> String {
      // TODO
    }
  }
}
```

</section>

<section markdown="1" id="how">

### HOW DOES IT WORK?



</section>

{: .hi-five}
<%= image_tag "ruby-rust-hi-five.png", class: "hi-five" %>
