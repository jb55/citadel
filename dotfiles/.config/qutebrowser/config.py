#   qute://help/configuring.html
#   qute://help/settings.html
import socket
hostname = socket.gethostname()

config.load_autoconfig(False)

# Uncomment this to still load settings configured via autoconfig.yml
# config.load_autoconfig()

# Aliases for commands. The keys of the given dictionary are the
# aliases, while the values are the commands they map to.
# Type: Dict
c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

config.set('downloads.location.directory', '~/dl')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Disable third-party cookies. Breaks gmail apparently but who cares.
config.set('content.cookies.accept', 'no-3rdparty')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

config.set('content.javascript.clipboard', 'access')

#config.set('fonts.default_family', 'terminus')

if hostname == 'monad':
    config.set('zoom.default', 125)
else:
    config.set('zoom.default', 125)


# Editor (and arguments) to use for the `open-editor` command. The
# following placeholders are defined: * `{file}`: Filename of the file
# to be edited. * `{line}`: Line in which the caret is found in the
# text. * `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
# Type: ShellCommand
c.editor.command = ['edit-gui', '{file}', '+{line}']

# This setting can be used to map keys to other keys. When the key used
# as dictionary-key is pressed, the binding for the key used as
# dictionary-value is invoked instead. This is useful for global
# remappings of keys, for example to map Ctrl-[ to Escape. Note that
# when a key is bound (via `bindings.default` or `bindings.commands`),
# the mapping is ignored.
# Type: Dict
c.bindings.key_mappings = {'<Ctrl+6>': '<Ctrl+^>', '<Ctrl+Enter>': '<Ctrl+Return>', '<Ctrl+j>': '<Return>', '<Ctrl+m>': '<Return>', '<Ctrl+[>': '<Escape>', '<Enter>': '<Return>', '<Shift+Enter>': '<Return>', '<Shift+Return>': '<Return>'}

# Bindings for normal mode
config.unbind('r')
config.bind('(', 'zoom 100')
config.bind(')', 'zoom 150')
config.bind('d', 'scroll-page 0 1')
config.bind('u', 'scroll-page 0 -1')
config.bind('<Ctrl-m>', 'set-mark')
#config.bind('<Ctrl-d>', 'scroll-page 0 1')
#config.bind('<Ctrl-u>', 'scroll-page 0 -1')
#config.bind('d', 'repeat 10 scroll down')
#config.bind('u', 'repeat 10 scroll up')
#config.bind('<Ctrl-d>', 'scroll-page 0 0.5')
#config.bind('<Ctrl-u>', 'scroll-page 0 -0.5')
config.bind('<Ctrl-r>', 'reload')
config.bind('<Ctrl-e>', 'edit-text')

config.bind('e', 'open-editor')
config.bind('co', 'tab-only')
config.bind('gl', 'tab-move +')
config.bind('E', 'tab-focus last')
config.bind('gh', 'tab-move -')

# Remove fixed, sticky elements from pages.
# This is useful to recover full page scrolling
#config.bind(',s', 'jseval javascript:(function(){x=document.querySelectorAll(`*`);for(i=0;i<x.length;i++){elementStyle=getComputedStyle(x[i]);if(elementStyle.position.startsWith("fixed")||elementStyle.position.startsWith("sticky")){x[i].style.position=`absolute`;}}}())')

config.bind(',s', "jseval javascript:(function(){var elements=document.querySelectorAll(`*`);Array.from(elements).forEach(function(element){var style=getComputedStyle(element);if(style.position.startsWith(`fixed`)||style.position.startsWith(`sticky`)){element.style.cssText+=`position: absolute !important;`;}});})()")

config.bind('gF', 'hint all tab-bg')
config.unbind('D')
config.bind('Do', 'download-open')

config.set('downloads.position', 'bottom')
config.set('tabs.select_on_remove', 'last-used')
config.set('tabs.mousewheel_switching', False)

config.set('url.default_page', 'about:blank')
#config.set('colors.webpage.darkmode.enabled', True)
config.set('colors.webpage.preferred_color_scheme', 'light')
#config.set('colors.webpage.preferred_color_scheme', 'dark')


config.set('url.searchengines', {
  'DEFAULT': 'https://google.com/search?q={}',
  #'DEFAULT': 'http://duckduckgo.com/?q={}',
  'star': 'https://github.com/stars?utf8=%E2%9C%93&q={}',
  'so': 'https://google.com/search?q=site:stackoverflow.com {}',
  'gl': 'http://www.google.com/search?q={}&btnI=Im+Feeling+Lucky',
  'nip': 'https://github.com/nostr-protocol/nips/blob/master/{}.md',
  'ghi': 'https://github.com/{}/issues',
  'wa': 'http://www.wolframalpha.com/input/?i={}',
  'ha': 'https://google.com/search?q=site:hackage.haskell.org {}',
  'gamedev': 'http://gamedev.stackexchange.com/search?q={}',
  'npm': 'https://npmjs.org/search?q={}',
  'cargo': 'https://crates.io/search?q={}',
  'zen': 'http://brandalliance.zendesk.com/search?query={}',
  'g': 'https://www.google.com/search?q={}',
  'ud': 'http://www.urbandictionary.com/define.php?term={}',
  'alert': 'http://alrt.io/{}',
  'hackage': 'http://hackage.haskell.org/package/{}',
  'travis': 'https://travis-ci.org/{}',
  'ttx': 'https://testnet.smartbit.com.au/tx/{}/',
  'e': 'https://www.google.com/search?q=site%3Apackage.elm-lang.org+{}&btnI=Im+Feeling+Lucky',
  'key': 'https://www.npmjs.org/browse/keyword/{}',
  'h': 'http://holumbus.fh-wedel.de/hayoo/hayoo.html?query={}',
  'lh': 'http://localhost:8088/?hoogle={} -package:Cabal',
  'hoogle': 'http://www.haskell.org/hoogle/?hoogle={}',
  'github': 'http://github.com/search?q={}',
  'r': 'https://old.reddit.com/r/{}',
  'a': 'http://mempool.space/address/{}',
  'bgg': 'http://www.boardgamegeek.com/metasearch.php?searchtype=game&search={}',
  'pgp': 'http://pgp.mit.edu/pks/lookup?search={}&op=index',
  'gh': 'https://github.com/{}',
  'srht': 'https://sr.ht/~{}',
  'rs': 'https://docs.rs/{}/latest',
  'crate': 'https://crates.io/crates/{}',
  'repo': 'http://npmrepo.com/{}',
  'ec': 'http://package.elm-lang.org/packages/elm-lang/{}/latest',
  'tx': 'https://mempool.space/tx/{}'
})



