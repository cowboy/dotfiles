#!/usr/bin/env python
# gcsms.py - Send SMS to your phone for free using Google Calendar
# Copyright (C) 2013  Mansour <mansour@oxplot.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""Send SMS to your phone for free using Google Calendar."""

from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

__author__ = 'Mansour'
__copyright__ = 'Copyright (C) 2013 Mansour'
__credits__ = ['Mansour']
__email__ = 'mansour@oxplot.com'
__license__ = 'GPLv3'
__maintainer__ = 'Mansour'
__version__ = '1.0'

from datetime import datetime
import argparse
import json
import os
import sys
import time

# Version dependent imports

try:
  from ConfigParser \
    import SafeConfigParser, NoSectionError, NoOptionError
except ImportError:
  from configparser \
    import SafeConfigParser, NoSectionError, NoOptionError

try:
  from urllib2 import urlopen, Request
  from urllib import urlencode
except ImportError:
  from urllib.parse import urlencode
  from urllib.request import urlopen, Request

_CALS_PATH = '/calendars'
_CAL_LIST_PATH = '/users/me/calendarList'
_CAL_URL = 'https://www.googleapis.com/calendar/v3'
_DEV_CODE_ENDPT = 'https://accounts.google.com/o/oauth2/device/code'
_EVENT_PATH = '/calendars/%s/events'
_GLOBAL = 'global'
_GRANT_TYPE = 'http://oauth.net/grant_type/device/1.0'
_PROGNAME = 'gcsms'
_SCOPE = 'https://www.googleapis.com/auth/calendar'
_TOKEN_ENDPT = 'https://accounts.google.com/o/oauth2/token'

class GCSMSError(Exception):
  """GCSMS specific exceptions."""
  pass

def cmd_auth(args, cfg):
  """Authenticate with Google."""

  # Obtain a user code

  req = Request(
    _DEV_CODE_ENDPT,
    data=urlencode({
      'client_id': cfg.get(_GLOBAL, 'client_id'),
      'scope': _SCOPE
    }).encode('utf8')
  )
  ucres = json.loads(urlopen(req).read().decode('utf8'))

  print("Visit %s\nand enter the code '%s'\n"
        "Waiting for you to grant access ..."
        % (ucres['verification_url'], ucres['user_code']))

  # Obtain refresh token by polling token end point

  req = Request(
    _TOKEN_ENDPT,
    data=urlencode({
      'client_id': cfg.get(_GLOBAL, 'client_id'),
      'client_secret': cfg.get(_GLOBAL, 'client_secret'),
      'code': ucres['device_code'],
      'grant_type': _GRANT_TYPE
    }).encode('utf8')
  )

  while True:
    rtres = json.loads(urlopen(req).read().decode('utf8'))
    error = rtres.get('error', None)
    refresh_token = rtres.get('refresh_token', None)
    if error in ('slow_down', 'authorization_pending'):
      time.sleep(int(ucres['interval']))
    elif error:
      raise GCSMSError("got auth error '%s' while polling" % error)
    elif refresh_token:
      break
    else:
      raise GCSMSError('unexpected error while polling')

  # Store the refresh token in the config file

  cfg.set(_GLOBAL, 'refresh_token', refresh_token)
  cfg.write(open(args.config + ".tmp", 'w'))
  os.rename(args.config + ".tmp", args.config)

  print("Successful. You can now use 'gcsms send' to send SMS")

def cmd_send(args, cfg):
  """Send SMS."""

  try:
    refresh_token = cfg.get(_GLOBAL, 'refresh_token')
  except NoOptionError:
    raise GCSMSError("you must first run 'gcsms auth' to authenticate")

  # Obtain an access token

  req = Request(
    _TOKEN_ENDPT,
    data=urlencode({
      'client_id': cfg.get(_GLOBAL, 'client_id'),
      'client_secret': cfg.get(_GLOBAL, 'client_secret'),
      'refresh_token': refresh_token,
      'grant_type': 'refresh_token'
    }).encode('utf8')
  )
  tres = json.loads(urlopen(req).read().decode('utf8'))
  access_token = tres.get('access_token', None)
  if access_token is None:
    raise GCSMSError("you must first run 'gcsms auth' to authenticate")
  

  # Get a list of all calendars

  callist = do_api(
    '%s?minAccessRole=writer&showHidden=true' % _CAL_LIST_PATH,
    access_token
  )['items']
  cal = None
  for c in callist:
    if c['summary'] == _PROGNAME:
      cal = c['id']
      break

  # If our calendar doesn't exist, create one

  if cal is None:
    cres = do_api(_CALS_PATH, access_token, {'summary': _PROGNAME})
    if cres.get('summary', None) == _PROGNAME:
      cal = cres['id']
    else:
      raise GCSMSError('cannot create calendar')

  # Read the stdin and create a calendar event out of it

  text = sys.stdin.read()
  try:
    ts = datetime.utcfromtimestamp(
      time.time() + 65).isoformat(b'T') + 'Z'
  except TypeError:
    ts = datetime.utcfromtimestamp(
      time.time() + 65).isoformat('T') + 'Z'
  event = {
    'start': {'dateTime': ts},
    'end': {'dateTime': ts},
    'reminders': {
      'useDefault': False,
      'overrides': [
        {'method': 'sms', 'minutes': 1}
      ]
    },
    'summary': text,
    'visibility': 'private',
    'transparency': 'transparent'
  }

  cres = do_api(_EVENT_PATH % cal, access_token, event)
  if cres.get('kind', None) != 'calendar#event':
    raise GCSMSError('failed to send SMS')
  
def do_api(path, auth, body = None):
  """Do a calendar API call.

  path -- access URL path
  auth -- access token
  body -- JSON request body

  """

  req = Request(
    '%s%s' % (_CAL_URL, path),
    data=json.dumps(body).encode('utf8') if body else None,
    headers={
      'Authorization': 'Bearer %s' % auth,
      'Content-type': 'application/json'
    }
  )
  return json.loads(urlopen(req).read().decode('utf8'))

def main():
  """Parse command line args and run appropriate command."""

  parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='Send SMS to yourself with Google Calendar'
  )
  parser.add_argument(
    '-c', '--config',
    default=os.path.expanduser('~/.gcsms'),
    metavar='<config>',
    help='path to config file - default is ~/.gcsms'
  )
  subparsers = parser.add_subparsers(
    help='gcsms commands',
    dest='command'
  )
  parser_a = subparsers.add_parser(
    'auth',
    help='authenticate with Google'
  )
  parser_a = subparsers.add_parser(
    'send',
    help='send SMS'
  )
  args = parser.parse_args()

  try:

    cfg = SafeConfigParser()
    if os.path.exists(args.config):
      cfg.read(args.config)
    else:
      raise GCSMSError("config file doesn't exist")

    try:
      cfg.get(_GLOBAL, 'client_id')
      cfg.get(_GLOBAL, 'client_secret')
    except (NoOptionError, NoSectionError):
      raise GCSMSError(
        '"client_id" and/or "client_secret" is missing in config')

    if args.command == 'auth':
      cmd_auth(args, cfg)
    elif args.command == 'send':
      cmd_send(args, cfg)

  except GCSMSError as e:
    print('%s: error: %s' % (_PROGNAME, e.args[0]), file=sys.stderr)
    exit(2)
  except KeyboardInterrupt:
    print('%s: keyboard interrupt' % _PROGNAME)
    exit(2)

if __name__ == '__main__':
  main()
