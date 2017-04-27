# Roadmap
{:.no_toc}

{:toc}
{: [start=0] }
1. TOC

---

Helix is still a young project with a lot of work still to be done. To give you
a better sense of where we're at, whether you can use Helix for your project, and
how you can help contribute, we broke down the outstanding work in terms of a few
expected use-cases.

## Greenfield project

You're developing a brand new feature or rewriting a feature inside your app (as
opposed to a public library). Since you have full control over the API, you can
make adjustments to work around current limitations in Helix.

You might use Helix for a CPU-bound algorithm, in a request, mailer or background
job. Problems with a potential for parallelism are an especially good fit.

Because of the limited type coercions available, problems that can communicate
through string or number values are the best fit. Since background jobs and
HTTP requests share this constraint, you can often get a little creative and
model many problems this way.

<%= progress_bar(8, 8) %>

- [X] Define a simple class
- [X] Define multiple classes
- [X] Class methods
- [X] Instance methods
- [X] Support taking/returning basic types (String, boolean, numeric, nil)
- [X] Support taking/returning instances of Helix classes
- [X] Basic exception support
- [X] Instance state

## Drop-in replacement

You're rewriting some code in a public library from Ruby to Rust. The benchmark
example we're using for this use-case is a high-fidelity implementation of
ActiveSupport::Duration written in Rust, and passing all of the Rails tests.

Another example of this use-case is JSON::Pure vs. JSON::Ext in the `json`
library.

Because it has a public API, you need to maintain full compatibility with
exotic Ruby features that are not easy to represent in Rust.

If this is your goal, you can accomplish a lot today by mixing-and-matching
Rust and Ruby. Typically, you would implement the heavy-lifting in Rust and
write sugar for features like optional or keyword arguments in Ruby,
normalizing the inputs and then call into Rust.

However, the long-term goal of the Helix project is to support all of
these features in the `ruby!` macro.

<%= progress_bar(0, 8) %>

- [ ] Module support
- [ ] Optional arguments
- [ ] Rest arguments
- [ ] Keyword arguments
- [ ] Numeric
- [ ] Overloads
- [ ] Support key data structures: Array and Hash
- [ ] Safely call back into Ruby
- [ ] `yield`


## Reopen class

For full fidelity with ActiveSupport, we should support reopening existing classes
directly from Rust.

<%= progress_bar(1, 2) %>

- [X] Basic reopen support
- [ ] Correct `self` type (with coercions to Rust values)

## Ship to production

Once you've integrated Helix into an application, you need to deploy to production.
Since you're in full control of the build environment, you can supply a Rust
compiler in that environment.

In this use-case, Rust compilation is similar to asset compilation: just like you'd
supply a JavaScript runtime or Sass compiler to compile your assets, you'd supply a
Rust compiler to compile your Helix projects.

<%= progress_bar(3, 7) %>

- [X] Rake build tasks
- [X] Heroku buildpack
- [X] Document Helix in Rails
- [ ] Document Helix in other application environments
- [ ] Instructions for non-Heroku deployment
- [X] Support Rust stable
- [ ] `extconf.rb` support

## Binary distribution

If you want to use Helix in a gem, and distribute it to users without requiring
a Rust compiler, you will need to build binary distributions for your target
environment.

We want to support a smooth workflow for specifying your target environments and
getting the binaries for each of them. We are exploring both cross-compilation
solutions, VM-based solutions, and some combination of the two.

<%= progress_bar(0, 7) %>

- [ ] Desktop Platforms
  - [ ] Linux 32-bit
  - [ ] Linux 64-bit
  - [ ] Windows 32-bit
  - [ ] Windows 64-bit
  - [ ] Darwin 64-bit
- [ ] Cross-compilation or VM-based compilation
- [ ] Precompiled binaries on Rubygems

## Non-Traditional Use-Cases

You might want to use Helix in environments other than traditional use-cases for
Ruby. We want to explore good workflows for these use-cases, especially when Rust
and Ruby both support an environment.

<%= progress_bar(0, 4) %>

- [ ] Mobile Platforms
  - [ ] Android
  - [ ] iOS
- [ ] WebAssembly
- [ ] mruby

## Performance parity with C

In general, Rust is in the same performance ballpark as C **for code written in
Rust** (sometimes it's even faster). However, the cost of crossing from Ruby to
Rust is still high (compared to Ruby C extensions).

That being said, because using native code is so much faster than Ruby, you can
recoup the cost difference pretty quickly. This problem is more important for
chatty APIs, or drop-in replacements for Ruby APIs that intrinsically require
a lot of communication with Ruby (e.g. `to_str`).

Those costs are largely not intrinsic, and we're exploring ways to reduce the
costs.

<%= progress_bar(0, 3) %>

- [ ] Set up good benchmarks
- [ ] Inline macros into Rust (either via link-time-optimization or via Rust strategies)
- [ ] Reduce reliance on copying for safety

## Miscellaneous features and QoL improvements

- [X] Generators
- [ ] More types
- [ ] Better syntax errors
- [ ] Lifetimes in methods
- [ ] `mut` method arguments
- [ ] Consuming `self` (no borrow)
- [ ] `#[derive]` on `struct {}`