--------------------------------------------
title: htop, kills, and collateral damage
date: 2014-08-19
--------------------------------------------

`htop` ([official website] [1], [github repository] [2], [wikipedia article] [3])
is a great tool used to list, sort, search, and manage processes.
It is similar to `top` ([official website] [4], [sourceforge profile] [5], [wikipedia article] [6]) but with many more features.

One of the more useful features of this program is being able to `tag` processes
and sending all of the tagged processes a signal of your choosing.
It will also ask for a confirmation before the signal is sent.

This way you're less likely to accidentally kill the wrong processes.

[1]: http://hisham.hm/htop/
[2]: https://github.com/hishamhm/htop
[3]: https://en.wikipedia.org/wiki/Htop
[4]: http://www.unixtop.org/
[5]: http://sf.net/projects/procps-ng/
[6]: https://en.wikipedia.org/wiki/Top_(software)
