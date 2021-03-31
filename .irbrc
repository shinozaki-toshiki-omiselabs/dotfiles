# require 'irb/completion'
require 'pp'
require 'rubygems'
require 'active_support/all'
require 'readline'

IRB.conf[:AUTO_INDENT]=true
IRB.conf[:SAVE_HISTORY]=50000
IRB.conf[:USE_READLINE] = true

require 'wirble'
Wirble.init
Wirble.colorize

