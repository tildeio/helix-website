#[macro_use]
extern crate helix;

ruby! {
    class Line {
        struct {
            x1: f64,
            y1: f64,
            x2: f64,
            y2: f64
        }

        def initialize(helix, p1: &Point, p2: &Point) {
            Line { helix, x1: p1.x, y1: p1.y, x2: p2.x, y2: p2.y }
        }

        def distance(&self) -> f64 {
            let (dx, dy) = (self.x1 - self.x2, self.y1 - self.y2);
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

        def join(&self, second: &Point) -> Line {
            Line::new(self, second)
        }

        def x(&self) -> f64 {
            self.x
        }

        def y(&self) -> f64 {
            self.y
        }
    }
}
