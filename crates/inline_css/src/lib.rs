#[macro_use]
extern crate helix;

extern crate kuchiki;
extern crate cssparser;

use kuchiki::traits::*;

mod parse_css;
use parse_css::Declaration;

ruby! {
    class InlineCSS {
        def inline(html: String, css: String) -> String {
            inline(&html, &css).unwrap()
        }
    }
}

fn inline(html: &str, css: &str) -> Result<String, Box<std::error::Error>> {
    let doc = kuchiki::parse_html().one(html);
    let mut parser = parse_css::CSSParser::new(css);

    let rules = parser.parse()
        .filter_map(|r| r.map(|(selector, declarations)| Rule::new(&selector, declarations)).ok())
        .collect::<Result<Vec<_>, _>>().unwrap();

    for rule in rules {
        let matching_elements = doc.inclusive_descendants()
            .filter_map(|node| node.into_element_ref())
            .filter(|element| rule.selectors.matches(element));

        for matching_element in matching_elements {
            let style = rule.declarations.iter().map(|&(ref key, ref value)| format!("{}:{};", key, value));
            matching_element.attributes.borrow_mut().insert("style", style.collect());
        }
    }

    let mut out = vec![];
    doc.select("html").unwrap().nth(0).unwrap().as_node().serialize(&mut out)?;
    Ok(String::from_utf8_lossy(&out).to_string())
}

use kuchiki::{Selectors};

#[derive(Debug)]
struct Rule {
    selectors: kuchiki::Selectors,
    declarations: Vec<Declaration>
}

impl Rule {
    pub fn new(selectors: &str, declarations: Vec<Declaration>) -> Result<Rule, ()> {
        Ok(Rule {
            selectors: Selectors::compile(selectors)?,
            declarations
        })
    }
}

