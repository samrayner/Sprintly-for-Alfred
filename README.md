#Sprintly Workflow for Alfred 2 - [Download](https://dl.dropbox.com/s/e6f6zvkpihylasd/Sprintly.alfredworkflow)

Installation
------------

**Requirements:** Ruby >= 1.9.x must be installed with [RVM][] or [rbenv][].

**sly setup {email} {api_key}** - Your API key can be obtained from <https://sprint.ly/account/profile/>


Commands
--------

{foo} = required argument   
_{bar}_ = optional argument

**sly product _{filter}_** - List products, `return` to switch active product, `alt+return` to view in browser

**sly list {status} _{@name}_ _{filter}_** - List items (optionally filtered by person), `return` to view in browser

**sly start _{filter}_** - List Backlog items, `return` to move item to Current, `alt+return` to view in browser. Also copies a `git branch` command for the item to the clipboard and starts a [TicToc][] task if TicToc is running.

**sly finish _{filter}_** - List Current items, `return` to move item to Completed, `alt+return` to view in browser. Also stops the TicToc task for the item if one was started.

**sly new {type} _{size}_ {title} _{#tag}_ _{@name}_** - Add a new item to Backlog (hit `return` when done)

**sly item #{id}** - Preview an item by ID, `return` to view in browser


Screenshots
-----------

[![][1]][1]
[![][2]][2]
[![][3]][3]
[![][4]][4]
[![][5]][5]
[![][6]][6]

[1]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/1.%20Main%20Options.jpg
[2]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/2.%20Listing%20Items.jpg
[3]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/3.%20Adding%20an%20Item.jpg
[4]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/4.%20Scoring%20a%20New%20Item.jpg
[5]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/5.%20Previewing%20a%20New%20Item.jpg
[6]: http://samrayner.com/app/cache/files/collections/Sprintly%20for%20Alfred/6.%20Assigning%20an%20Item%20to%20a%20User.jpg


Tips
----

`cmd+c` on a highlighted product or item will copy its #ID to the clipboard (useful for commit messages)

Story titles can be entered shorthand as: _**aa** user **iw** this **st** that_

`tab` has the same effect as `return`

[rvm]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv/
[tictoc]: http://overcommitted.com/tictoc/
