# Sprintly Workflow for Alfred 2 - [Download](https://github.com/samrayner/Sprintly-for-Alfred/releases/download/v1.0.4/Sprintly.alfredworkflow)

Installation
------------

**Requirements:** System Ruby must be >= 1.9.x

**sly setup {email} {api_key}** - Your API key can be obtained from <https://sprint.ly/account/profile/>


Commands
--------

{foo} = required argument   
_{bar}_ = optional argument

**sly product _{filter}_** - List products, `return` to switch active product, `alt+return` to view in browser

**sly list {status} _{@name}_ _{filter}_** - List items (optionally filtered by person), `return` to view in browser

**sly start _{filter}_** - List Backlog items, `return` to move item to Current, `alt+return` to view in browser. Also copies a `git checkout` command for the item to the clipboard and starts a [TicToc][] task if TicToc is running.

**sly finish _{filter}_** - List Current items, `return` to move item to Completed, `alt+return` to view in browser. Also stops the TicToc task for the item if one was started.

**sly new {type} _{size}_ {title} _{#tag}_ _{@name}_** - Add a new item to Backlog (hit `return` when done)

**sly item #{id}** - Preview an item by ID, `return` to view in browser

**sly git _{filter}_** - List Current items, `return` to copy a `git checkout` command for the item to the clipboard, `alt+return` to view in browser


Screenshots
-----------
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/1.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/1.jpg" alt="" width="100" height="100" /></a> 
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/2.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/2.jpg" alt="" width="100" height="100" /></a> 
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/3.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/3.jpg" alt="" width="100" height="100" /></a> 
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/4.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/4.jpg" alt="" width="100" height="100" /></a> 
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/5.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/5.jpg" alt="" width="100" height="100" /></a> 
<a href="http://www.samrayner.com/images/galleries/sprintly-for-alfred/6.jpg" target="_blank"><img src="http://www.samrayner.com/images/galleries/sprintly-for-alfred/6.jpg" alt="" width="100" height="100" /></a>


Tips
----

`cmd+c` on a highlighted product or item will copy its #ID to the clipboard (useful for commit messages)

Story titles can be entered shorthand as: _**aa** user **iw** this **st** that_

`tab` has the same effect as `return`

[rvm]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv/
[tictoc]: http://overcommitted.com/tictoc/
