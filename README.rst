.. -*- coding: utf-8 -*-

========================
Toggling symbolic links.
========================

:Author: Nathaniel Beaver
:Date: $Date: 2014-10-02 (Thursday, 2 October 2014) $
:Description: Shell script to transform symbolic links to text files and back again.

-------------
What is this?
-------------

This is a ``bash`` `script`_ to transform a symbolic link (a.ka. "symlink") into a text file of the same name.
The text file's contents are the target of the symbolic link.

.. _script: ./toggle-symlink.sh

It will also do the inverse,
i.e. transform a text file containing a valid file path
into a symlink pointing to that target.

There is also a `test script`_ to make sure it works properly.

.. _test script: ./test.sh

------------------
How do you use it?
------------------

Like this::

    $ bash toggle-symlink.sh my-symbolic-link

Turning it back into a symlink is the same.

Run ``make`` or ``bash test.sh`` to make a directory with some symbolic links and run some tests.

------------------------------
Why would you want to do this?
------------------------------

Mainly it is just a shell-scripting exercise,
but sometimes it is helpful to disable a symbolic link while retaining its name and target.

For example, `Dropbox always follows symbolic links`_.
This is useful for `syncing files outside of the Dropbox folder`_.

.. _Dropbox always follows symbolic links: https://forums.dropbox.com/topic.php?id=7245
.. _syncing files outside of the Dropbox folder: http://www.dropboxwiki.com/tips-and-tricks/sync-other-folders

However, internal symlinks 
(i.e. symlinks in the Dropbox folder pointing to files or folders inside the same Dropbox folder)
will lead to `nasty`_ `synchronization`_ `problems`_.

.. _nasty: https://getsatisfaction.com/dropbox/topics/symlinks_symbolic_links_to_other_files_inside_dropbox_are_destroyed_on_change
.. _synchronization: http://www.paulingraham.com/dropbox-and-symlinks.html
.. _problems: http://aurelio.net/articles/dropbox-symlinks.html

While Dropbox can selectively sync folders,
it cannot selectively sync individual files,
so there is no workaround for internal file symlink conflicts.

In these sorts of situations,
it may be expedient to "turn off" symbolic links without deleting them.

This script provides the means to do exactly that,
and can also restore the symlinks.

Also, if the path is long and deeply nested and the fix relatively small,
it may be easier to convert it to a text file and apply the fix with a text editor,
then convert it back.
This also avoids the danger of accidentally inverting the source and target.

--------------------------
Has this been done before?
--------------------------

Yes.
For example, ``git`` currently uses this strategy `to handle symlinks on Windows`_.

.. _to handle symlinks on Windows: http://stackoverflow.com/questions/11662868/what-happens-when-i-clone-a-repository-with-symlinks-on-windows

---------------
Is this secure?
---------------

Not especially.

The shell script must remove the original symbolic link using ``rm``,
then output a text file with the same name.
Since this operation is not atomic,
this script is vulnerable to a timing attack.
 
However, much of the damage can be avoided by making sure to quote variables to avoid undesirable expansions,
using ``--`` to end options,
and using shell script settings like ``nounset``, ``errexit``, and ``noclobber``,
and using local variables when possible.

At any rate,
I do not recommend using this for anything important or running it as root.

-----------------
Is this portable?
-----------------

No, it just works with ``bash`` right now.
Pull requests are welcome, though.
