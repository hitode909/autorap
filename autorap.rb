Bundler.require
require 'shellwords'

YAHOO_API_TOKEN = ENV['YAHOO_API_TOKEN']
HATENA_KEYWORD_CSV_PATH = ENV['HATENA_KEYWORD_CSV_PATH']

module AutoRap
  class Word
    attr_reader :word, :yomi
    def initialize(yomi, word)
      @yomi = yomi
      @word = word
    end

    def length
      yomi.length
    end

    def match(rule)
      yomi.match(rule)
    end

    def to_s
      word
    end

    def replace_with(another)
      @yomi = another.yomi
      @word = another.word
    end
  end

  class RhymeDictionary
    def initialize(csv_path)
      @words = open(csv_path).read.encode('UTF-8', 'EUC-JP', :undef => :replace, :replace => "")
        .split(/\n/)
        .map{|line| line.chomp.split(/\t/) }
        .select{|line| line[0].length > 0 && line[0] =~ // }
        .map{|line| Word.new(line[0], line[1]) }
    end

    def words_like(word)
      n = (word.length * (0.5 + rand*0.5)).to_i
      while n > 0
        words = words_like_last_n(word, n)
        return words if words.length > 0
        n -= 1
      end
      []
    end

    def words_like_last_n(word, n)
      last_n = Regexp.quote(word[-n..-1])
      same_length = @words.select{|w| w.yomi.length == word.length && w.yomi != word }
      same_length.select{|w| w.yomi.match(last_n) }
    end
  end

  class Analyzer
    def initialize(api_key)
      @api_key = api_key
    end

    # sentence -> [ Word ]
    def analyze(sentence)
      conn = Faraday.new(url: 'http://jlp.yahooapis.jp')

      data = {
        appid: @api_key,
        sentence: sentence,
      }
      res = conn.get '/MAService/V1/parse', data
      Nokogiri(res.body).search('word').map{|node|
        Word.new(node.at('reading').content, node.at('surface').content)
      }
    end
  end

  class Rapper
    attr_reader :lyric
    def initialize(lyric)
      @analyzer = Analyzer.new(YAHOO_API_TOKEN)
      @dictionary = RhymeDictionary.new(HATENA_KEYWORD_CSV_PATH)
      @lyric = lyric
    end

    def say
      system "say #{ Shellwords.escape(lyric) } &> /dev/null"
    end

    def rhyme!
      replaced = false
      words = @analyzer.analyze(lyric)

      words.each{|word|
        next if rand > 0.5
        next if word.yomi.length < 2
        # puts "#{word} -> #{@dictionary.words_like(word.yomi).join(' ')}"
        new_one = @dictionary.words_like(word.yomi).sample
        word.replace_with new_one if new_one
      }
      @lyric = words.join("")
    end
  end
end

rapper = AutoRap::Rapper.new(ARGV.first)

loop do
  puts rapper.lyric
  rapper.say
  rapper.rhyme!
end
