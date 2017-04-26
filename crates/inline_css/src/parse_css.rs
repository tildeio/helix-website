use cssparser;

pub struct CSSRuleListParser;
struct CSSDeclarationListParser;

pub type Declaration = (String, String);
pub type QualifiedRule = (String, Vec<Declaration>);

fn exhaust(input: &mut cssparser::Parser) -> String {
    let start = input.position();
    while let Ok(_) = input.next() {}
    return input.slice_from(start).to_string();
}

impl cssparser::QualifiedRuleParser for CSSRuleListParser {
    type Prelude = String;
    type QualifiedRule = QualifiedRule;

    fn parse_prelude(&mut self, input: &mut cssparser::Parser) -> Result<Self::Prelude, ()> {
        Ok(exhaust(input))
    }

    fn parse_block(&mut self, prelude: Self::Prelude, input: &mut cssparser::Parser) -> Result<Self::QualifiedRule, ()> {
        let parser = cssparser::DeclarationListParser::new(input, CSSDeclarationListParser);
        let mut decls = vec![];

        for item in parser {
            if let Ok(decl) = item {
                decls.push(decl);
            }
        }

        Ok((prelude, decls))
    }

}

impl cssparser::DeclarationParser for CSSDeclarationListParser {
    type Declaration = Declaration;

    fn parse_value(&mut self, name: &str, input: &mut cssparser::Parser) -> Result<Self::Declaration, ()> {
        Ok((name.to_string(), exhaust(input)))
    }
}

impl cssparser::AtRuleParser for CSSRuleListParser {
    type Prelude = String;
    type AtRule = QualifiedRule;
}

impl cssparser::AtRuleParser for CSSDeclarationListParser {
    type Prelude = String;
    type AtRule = Declaration;
}

pub struct CSSParser<'input> {
    input: cssparser::Parser<'input, 'input>
}

impl<'input> CSSParser<'input> {
    pub fn new<'css>(css: &'css str) -> CSSParser<'css> {
        CSSParser { input: cssparser::Parser::new(css) }
    }

    pub fn parse<'a>(&'a mut self) -> cssparser::RuleListParser<'input, 'input, 'a, CSSRuleListParser> {
        cssparser::RuleListParser::new_for_stylesheet(&mut self.input, CSSRuleListParser)
    }
}
