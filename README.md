# RPR

RPR displays Ruby's AST on command line.

[![Gem Version](https://badge.fury.io/rb/rpr.svg)](https://badge.fury.io/rb/rpr)
[![Build Status](https://travis-ci.org/pocke/rpr.svg?branch=master)](https://travis-ci.org/pocke/rpr)
[![Coverage Status](https://coveralls.io/repos/github/pocke/rpr/badge.svg?branch=master)](https://coveralls.io/github/pocke/rpr?branch=master)

## Support parsers

- [Ripper](http://ruby-doc.org/stdlib-2.3.0/libdoc/ripper/rdoc/Ripper.html)
  - `sexp`
  - `lex`
  - `tokenize`
- [Parser](https://github.com/whitequark/parser)
- [RuboCop](https://github.com/bbatsov/rubocop)
- [RubyParser](https://github.com/seattlerb/ruby_parser)
- RubyVM::AbstractSyntaxTree (Since Ruby 2.6)
- [MinRuby](https://github.com/mame/minruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rpr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rpr

## Usage

### Basic Usage

```sh
$ echo 'puts "Hello world"' > hello.rb
$ rpr hello.rb
[:program,
 [[:command,
   [:@ident, "puts", [1, 0]],
   [:args_add_block,
    [[:string_literal,
      [:string_content, [:@tstring_content, "Hello world", [1, 6]]]]],
    false]]]]
```

### Specify Parser

The default parser is `sexp`.
You can find all supported parsers with `--help` option.

For example:

```sh
$ rpr hello.rb --parser rubocop
s(:send, nil, :puts,
  s(:str, "Hello world"))
```

```sh
$ rpr hello.rb --method tokenize
["puts", " ", "\"", "Hello world", "\"", "\n"]
```

### Specify output formatter

The default formatter is `pp`.
You can find all supported formatters with `--help` option.

For example:

```sh
$ rpr hello.rb --formatter json
[
  "program",
  [
    [
      "command",
      [
        "@ident",
        "puts",
        [
          1,
          0
        ]
      ],
      [
        "args_add_block",
        [
          [
            "string_literal",
            [
              "string_content",
              [
                "@tstring_content",
                "Hello world",
                [
                  1,
                  6
                ]
              ]
            ]
          ]
        ],
        false
      ]
    ]
  ]
]
```

Inspect an AST with [pry](https://github.com/pry/pry).

```sh
$ rpr hello.rb --formatter pry
[1] pry(#<Array>)> self
=> [:program, [[:command, [:@ident, "puts", [1, 0]], [:args_add_block, [[:string_literal, [:string_content, [:@tstring_content, "Hello world", [1, 6]]]]], false]]]]
[2] pry(#<Array>)> ls
Enumerable#methods:
  all?   chunk_while     detect     each_entry  each_with_index   entries  find_all  grep    group_by  lazy  max_by   min     minmax     none?  partition  slice_after   slice_when
  chunk  collect_concat  each_cons  each_slice  each_with_object  find     flat_map  grep_v  inject    max   member?  min_by  minmax_by  one?   reduce     slice_before  sort_by
Array#methods:
  &  <<   []=    bsearch        collect!     concat  delete_at  drop_while  eql?        first     hash      inspect  length  permutation         product  reject!               reverse       rotate   select!    shuffle!  sort      take_while  to_s       unshift
  *  <=>  any?   bsearch_index  combination  count   delete_if  each        fetch       flatten   include?  join     map     pop                 push     repeated_combination  reverse!      rotate!  shelljoin  size      sort!     to_a        transpose  values_at
  +  ==   assoc  clear          compact      cycle   dig        each_index  fill        flatten!  index     keep_if  map!    pretty_print        rassoc   repeated_permutation  reverse_each  sample   shift      slice     sort_by!  to_ary      uniq       zip
  -  []   at     collect        compact!     delete  drop       empty?      find_index  frozen?   insert    last     pack    pretty_print_cycle  reject   replace               rindex        select   shuffle    slice!    take      to_h        uniq!      |
self.methods: __pry__
locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_
[3] pry(#<Array>)> exit
```

Print an AST as a PNG image with Graphviz.

```sh
$ rpr hello.rb -f dot | dot -Tpng -oast.png
$ open ast.png
```

![ast](https://user-images.githubusercontent.com/4361134/50541128-5fd7bf80-0be2-11e9-81c0-e6f239c4bbd3.png)

### Configuration

Rpr searches config file from `./.rpr` or `~/.config/rpr`. `./.rpr` is priority.

Config file is space separated options.

#### Example.

`./.rpr` or `~/.config/rpr`

```
-f pry
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/rpr.


## Links

- [Ripperをコマンドラインから簡単に使うラッパー rpr を作った - pockestrap](http://pocke.hatenablog.com/entry/2016/05/19/234740) (Japanese Blog)


License
-------

These codes are licensed under CC0.

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.en)
