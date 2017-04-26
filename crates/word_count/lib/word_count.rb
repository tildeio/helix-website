require "helix_runtime"

begin
  require "word_count/native"
rescue LoadError
  warn "Unable to load word_count/native. Please run `rake build`"
end

# Ported from https://github.com/dherman/wc-demo/blob/master/lib/search.js
module WordCountRuby
  def self.lines(corpus)
    corpus.split(/\n+/)
          # .map{|l| start = nth_index_of(l, ",", 3)+1; l[start..-1] }
  end

  def self.nth_index_of(haystack, needle, n)
    index = -1
    for i in 0...n
      index = haystack.index(needle, index+1);
      return -1 if !index
    end
    index
  end

  def self.skip_punc(word)
    for i in 0...word.length
      break if /[a-zA-Z]/.match(word[i])
    end
    word[i..-1]
  end

  def self.matches(word, search)
    start = skip_punc(word);
    i = 0
    m = start.length
    n = search.length
    return false if m < n
    while i < n
      return false if start[i].downcase != search[i]
      i += 1
    end
    i == m || !/[a-z][A-Z]/.match(start[i])
  end

  def self.wc_line(line, search)
    words = line.split(' ')
    total = 0
    for i in 0...words.length
      total += 1 if matches(words[i], search)
    end
    total
  end

  def self.search(path, search)
    corpus = File.read(path)
    ls = lines(corpus)
    total = 0
    for i in 0...ls.length
      total += wc_line(ls[i], search)
    end
    total
  end
end

class WordCount
  def self.ruby_search(*args)
    WordCountRuby.search(*args)
  end
end
