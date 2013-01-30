Sprint.ly Workflow for Alfred 2
===============================

Installation
------------

**Requirements:** Ruby 1.9.x must be installed with RVM: <https://rvm.io/>

**sly setup {email} {api_key}** - Your API key can be obtained from <https://sprint.ly/account/profile/>


Commands
--------

**sly product** - List products, `return` to switch active product, `alt+return` to view in browser

**sly list {status}** - List items, `return` to view in browser

**sly start** - List Backlog items, `return` to move item to Current, `alt+return` to view in browser

**sly new {type} _{size}_ {title} _{#tag}_ _{@name}_** - Add a new item to Backlog


Tips
----

Whenever results/suggestions appear they can be filtered by typing

`cmd+c` on a highlighted product or item will copy its #ID to the clipboard (useful for commit messages)

Story titles can be entered shorthand as: _**aa** user **iw** this **st** that_

`tab` has the same effect as `return`

Rspec tests can be run with `$ rake` in the root directory