## Roadmap

...

#### Greenfield project

* Developing a new feature, or a rewrite
* You control the API, can make minor adjustments to the API to workaround current limitations
* CPU-bound algorithm, potential for parallelism
* e.g. background job

<%= progress_bar(1, 2) %>

- [X] Define a simple class
- [X] Define multiple classes
- [X] Class methods
- [X] Instance methods
- [X] Support taking/returning basic types (String, boolean, numeric, nil)
- [X] Support taking/returning instances of Helix classes
- [X] Basic exception support
- [X] Instance state

#### Drop-in replacement

... you can always use wrapper code as a workaround ...

<%= progress_bar(7, 48) %>

- [ ] Optional arguments
- [ ] Rest arguments
- [ ] Keyword arguments
- [ ] Numeric
- [ ] Overloads
- [ ] Support key data structures: Array and Hash
- [ ] Safely call back into Ruby
- [ ] `yield`

#### Ship to production

* Distributing a Helix project to your
* You control the API, can make minor adjustments to the API to workaround current limitations
* CPU-bound algorithm, potential for parallelism
* e.g. background job

<%= progress_bar(1, 17) %>

- [X] Rake build tasks
- [X] Heroku buildpack
- [ ] Instructions for non-Heroku deployment
- [ ] Support Rust stable (we currently require beta)


#### Reopen class

- [ ] ?

#### Binary distribution

- [ ] Desktop Platforms
  - [ ] Linux 32-bit
  - [ ] Linux 64-bit
  - [ ] Windows 32-bit
  - [ ] Windows 64-bit
  - [ ] Darwin 64-bit
- [ ] Cross-compilation or VM-based compilation
- [ ] Precompiled binaries on Rubygems

#### Non-Traditional Use-Cases

- [ ] Mobile Platforms
  - [ ] Android
  - [ ] iOS
- [ ] WebAssembly
- [ ] mruby

#### Performance parity with C

- [ ] ?

#### Miscellaneous features and QoL improvements

- [ ] Generators
- [ ] More types
- [ ] Better syntax errors
- [ ]
