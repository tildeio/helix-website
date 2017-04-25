# Documentation
{:.no_toc}

{::options auto_ids=true /}

{:toc}
1. TOC

---

# The Top Level

The top-level of a Helix declaration is a call to the `ruby! {}` macro.

```{Cargo.toml}ini
[dependencies]
helix = "*"
```

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {

}
```

# Classes

Inside the `ruby!` macro, you create a new class using the `class` keyword.

Classes open with a `{` and close with a `}`.

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Console {

    }
}
```

# Methods

Inside a class, start methods with a `def` followed by the name of the method,
followed by a normal Rust method signature.

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Console {
        def log(message: String) {
            println!("LOG: {:?}", message);
        }
    }
}
```

```ruby
>> require 'console'
>> Console.log("Hi from Rust!");
"LOG: Hi from Rust"
```

## Class Methods vs. Instance Methods

Instance methods take `&self` or `&mut self` as their first parameter, like
Rust instance methods. Class methods don't have any kind of `self` as their
first parameter.

> Bare `self`, without `&` or `&mut`, is not currently supported by
> Helix.
{: .note }

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Console {
        // class method
        def log(message: String) {
            println!("LOG: {:?}", message);
        }

        // instance method
        def warn(&self, message: String) {
            println!("WARN: {:?}", message);
        }
    }
}
```

```ruby
>> require 'console'
>> Console.log("Hi from Rust!");
"LOG: Hi from Rust"
>> Console.new.log("Hi from Rust. Stern warning")
"WARN: Hi from Rust. Stern warning"
```

## Parameters

Methods defined in a Helix class can take any number of parameters formatted the
same way as parameters in normal Rust methods.

> Parameters may not currently have the `mut` modifier. The part of a parameter
> before the colon must be a simple identifier.
{: .note }

### Valid Parameter Types

Helix methods take *Rust* types as parameters, and defines a protocol that
automatically coerces *Ruby* values into the Rust types you specify.

Helix automatically supplies coercions from the Ruby values on the left
of the following table to the Rust values on the right.

| Ruby  | Rust | Rules |
| ----- | ---- | ----- |
| `String` | `String` | Ruby string must be valid UTF-8 |
| `true` or `false` | `bool` | |
| `Float` or `Integer` | `f64` | Ruby Integers must not overflow max safe precision of `f64` |
| `Integer` | `u64`, `i64`, `u32`, `i32` | Ruby Integers must not overflow or underflow the Rust type |
| Any supported value or `nil` | `Option<T>` | |
| Instance of a Helix class | `&HelixClass` or `&mut HelixClass` |
| nil | `()` | |

You can use any of the types in the `Rust` column of the above table in
your methods. Helix will automatically type check any Ruby values passed
to the method, and raise a `TypeError` if any of the Ruby values don't
match the rules for that type.

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Console {
        // class method
        def log(message: String, should_print: bool) {
            if should_print {
                println!("LOG: {:?}", message);
            }
        }
    }
}
```

```bash
>> require 'console'
>> Console.log("Hi from Rust!")
ArgumentError: wrong number of arguments (given 1, expected 2)
>> Console.log(true, true)
TypeError: no implicit conversion from TrueClass into Rust bool
>> Console.log("Hi from Rust", true)
"LOG: Hi from Rust"
>> Console.log("Hi from Rust", false)
>>
```

### Valid Return Types

Similarly, Helix methods use Rust types in their signatures as
*return* types. Helix also defines a protocol for converting
Rust types back into Ruby.

| Rust | Ruby | Rules |
| ----- | ---- | ----- |
| `String` | `String` | Ruby string must be valid UTF-8 |
| `bool` | `true` or `false` | |
| `f64` | `Float` |
| `u64`, `i64`, `u32`, `i32` | `Integer` | |
| `Option<T>` | T or `nil` | If `Some(T)`, coerce the T as normal; if `None`, return `nil` |
| `HelixClass` | Ruby instance of `HelixClass` |
| `()` | `nil` | |


```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Calculator {
        def multiply(left: u64, right: u64) -> u64 {
            left * right
        }
    }
}
```

```bash
>> require 'calculator'
>> Calculator.multiply(100, 10)
1000
```

## Thinking in Helix

Most of the time, the easiest way to think about Helix classes is that you define
methods with Rust arguments and Rust return values, and Ruby code can call those
methods with the Ruby equivalents of those values.

For example, if a method takes a `u64`, it should be documented as a Ruby method
taking an `Integer` that must be smaller than `2 ** 64`. If a method takes a `String`,
it should be documented as a Ruby method taking a `String` that must be valid UTF-8.

Similarly, if a method return `Option<String>`, it should be documented as a
Ruby method that returns either a UTF-8 `String` or `nil`.

# Instance Fields

A Helix class can define Rust fields that its instance methods will have access
to.

These serve the same role as instance variables in Ruby, but can be heavily
optimized by the Rust compiler.

## Defining Fields

A Helix class defines ints fields in a `struct` block, which must be the first
item inside a class.

> The following example won't work until the next section, when we define
> the initializer for this class.
{: .note}

```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Line {
        struct {
            p1: Point,
            p2: Point
        }

        def distance(&self) {
            let (dx, dy) = (self.p1.x - self.p2.x, self.p1.y - self.p2.y);
            dx.hypot(dy)
        }
    }

    class Point {
        struct {
            x: f64,
            y: f64
        }

        join(&self, second: &Point) -> Line {
            // Functional update
            Line {
                p1: Point { x: self.x, y: self.y },
                p2: Point { x: second.x, y: second.y }
            }
        }
    }
}
```

## Initialization

A Helix class with a `struct` must also define an initializer.


```{src/lib.rs}rust
#[use_macros]
extern crate helix;

ruby! {
    class Line {
        struct {
            p1: Point,
            p2: Point
        }

        def initialize(helix, p1: Point, p2: Point) {
            Line { helix, p1, p2 }
        }

        def distance(&self) {
            let (dx, dy) = (self.p1.x - self.p2.x, self.p1.y - self.p2.y);
            dx.hypot(dy)
        }
    }

    class Point {
        struct {
            x: f64,
            y: f64
        }

        def initialize(helix, x: f64, y: f64) {
            Point { helix, x, y }
        }

        join(&self, second: &Point) -> Line {
            // Functional update
            Line {
                p1: Point { x: self.x, y: self.y },
                p2: Point { x: second.x, y: second.y }
            }
        }
    }
}
```

The `initialize` method has a few differences from normal methods:

1. The first parameter must be named `helix` and has no specified type
2. The method has no explicit return type, but must return an instance of the current class
3. The returned struct must have all of the fields specified in `struct`, as well as the
   special `helix` field. You must supply the `helix` parameter in that position.

> The `helix` parameter is an opaque type that wraps internal bookkeeping information
> that Helix needs to seamlessly make your Rust type available to your methods.
{: .note}

# The Coercion Protocol

While Helix supplies a number of coercions for you out of the box (with more
coercions for basic Ruby and Rust types coming all the time), it may sometimes
be important to define your own coercions for your own types.

For example, if you've written a Rust date-time library, you might want to
define the coercion from Ruby's `DateTime`, `Time` and `Date` to your Rust
`DateTime`.

