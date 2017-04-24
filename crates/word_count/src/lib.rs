// Source from https://github.com/dherman/wc-demo/blob/master/native/src/lib.rs

#[macro_use]
extern crate helix;
extern crate rayon;

use std::str;
use std::fs::File;
use std::io::prelude::*;

use rayon::iter::{ParallelIterator, IntoParallelIterator};

fn lines(corpus: &str) -> Vec<&str> {
    corpus.lines()
        //   .map(|line| {
        //       line.splitn(4, ',').nth(3).unwrap().trim()
        //   })
          .collect()
}

fn matches(word: &str, search: &str) -> bool {
    let mut search = search.chars();
    for ch in word.chars().skip_while(|ch| !ch.is_alphabetic()) {
        match search.next() {
            None => { return !ch.is_alphabetic(); }
            Some(expect) => {
                if ch.to_lowercase().next() != Some(expect) {
                    return false;
                }
            }
        }
    }
    return search.next().is_none();
}

fn wc_line(line: &str, search: &str) -> i32 {
    let mut total = 0;
    for word in line.split(' ') {
        if matches(word, search) {
            total += 1;
        }
    }
    total
}

// Also valid, with comparable performance:

/*
fn wc_line(line: &str, search: &str) -> i32 {
    line.split(' ')
        .filter(|word| matches(word, search))
        .fold(0, |sum, _| sum + 1)
}
*/

fn wc_sequential(lines: &Vec<&str>, search: &str) -> i32 {
    lines.into_iter()
         .map(|line| wc_line(line, search))
         .fold(0, |sum, line| sum + line)
}

fn wc_parallel(lines: &Vec<&str>, search: &str) -> i32 {
    lines.into_par_iter()
         .map(|line| wc_line(line, search))
         .sum()
}

ruby! {
    class WordCount {
        def search(path: String, search: String) -> i32 {
            let mut file = File::open(path).expect("could not open file");
            let mut contents = String::new();
            file.read_to_string(&mut contents).expect("could not read file");

            wc_parallel(&lines(contents.as_str()), search.as_str())
        }
    }
}
