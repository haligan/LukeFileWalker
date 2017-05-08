# LukeFileWalker
Discovers all duplicate and blank files on a filesystem

OS Ubuntu 16.04
which ruby = usr/bin/ruby

ruby -v = ruby 2.3.1.p112 (2016-04-26)

Digest ships with this so no need to download a gem.

Call it from any directory you'd like to be the top level dir like this ruby /path/to/LukeFilewalker.rb If you run it outside of ~/ use sudo (it's not malicious code)

It writes blanks to /tmp/blanks.txt (or something like that) and dups to /tmp/duplicates.txt

Lastly, I'm trying to learn version control. Any chance we could work on this through a repo I just created? If you use github you could clone it from here https://github.com/haligan/LukeFileWalker
