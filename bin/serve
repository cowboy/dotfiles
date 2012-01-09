#!/usr/bin/env python
import sys, os
import SimpleHTTPServer
args = sys.argv[1:]

if len(args) and (args[0] == "-h" or args[0] == "--help"):
  print """
Serve a file (or the current directory)
http://benalman.com/

Usage: %s [PORT] [FILE]

If a port isn't specified, use 8080. If a file isn't specified, serve the
current directory. Once started, open the specified file (or the current
directory) with the default web browser.

Copyright (c) 2012 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/""" % os.path.basename(sys.argv[0])
  sys.exit()

# Get port, if specified.
port = 8080
if len(args) and args[0].isdigit():
  port = int(args[0])
  args = args[1:] # Shift args.

# Get file, if specified.
file = args[0] if len(args) else ""

# If not in an SSH session, open the URL in the default handler.
if not "SSH_TTY" in os.environ:
  os.system("open 'http://localhost:%d/%s'" % (port, file))

# Redefining the default content-type to text/plain instead of the default
# application/octet-stream allows "unknown" files to be viewable in-browser
# as text instead of being downloaded, which makes me happy.
extensions_map = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map
# Set the default content type to text/plain.
extensions_map[""] = "text/plain"
# Serving everything as UTF-8 by default makes funky characters render
# correctly and shouldn't break anything (per Mathias Bynens).
for key, value in extensions_map.items():
  extensions_map[key] = value + "; charset=UTF-8"

# Start the server using the default .test method, because I'm lazy (the port
# is still grabbed from sys.argv[1]).
sys.argv = [sys.argv[0], port]
SimpleHTTPServer.test()
