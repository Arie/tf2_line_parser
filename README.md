# TF2 line parser [![Build Status](https://travis-ci.org/Arie/tf2_line_parser.png?branch=master)](http://travis-ci.org/Arie/tf2_line_parser) [![Dependency Status](https://gemnasium.com/Arie/tf2_line_parser.png)](https://gemnasium.com/Arie/tf2_line_parser) [![Code Climate](https://codeclimate.com/github/Arie/tf2_line_parser.png)](https://codeclimate.com/github/Arie/tf2_line_parser) [![Coverage Status](https://coveralls.io/repos/Arie/tf2_line_parser/badge.png?branch=master)](https://coveralls.io/r/Arie/tf2_line_parser)

A TF2 log line parser. Unlike the other log parsers I've found, this one parses the line and returns a plain old ruby object to describe the event of the line.
I plan to use this for my own stats parsing tool.

## Requirements
* Ruby

## Missing events
* Connect
* Disconnect
* Enter game

## Credits
* nTraum, I stole most of the regexes from his [TF2Stats](https://github.com/nTraum/tf2stats/) project.
