.. -*- coding: utf-8 -*-

========================
Toggling symbolic links.
========================

:Author: Nathaniel Beaver
:Date: $Date: 2014-10-01 (Thursday, 1 October 2014) $

-------------
What is this?
-------------

This is a ``bash`` script to transform a symbolic link into a text file of the same name containing the target of the symbolic link.

It will also transform a text file into a symbolic link of the same name, provided the text file contains a valid file path.

------------------------------
Why would you want to do this?
------------------------------

Mostly there is no reason, but sometimes it is helpful to disable a symbolic link while retaining its name and target.

For example, `Dropbox always follows symbolic links`_.
This is useful for syncing files outside of the Dropbox folder.

.. _Dropbox always follows symbolic links: https://forums.dropbox.com/topic.php?id=7245

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
it may be expedient to "turn off" symbolic links without deleting them,
and retaining the target so that the symlink can be restored if necessary.

This script provides the means to do exactly that.
