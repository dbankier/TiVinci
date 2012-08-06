TiVinci
=======

A faster alternative to Appcelerator's Paint Module. 

Background
----------

I while back I forked the Appcelerator's paint module and started
adding features, e.g. bezier smoothing, dynamic width, edge blurring,
shapes, etc. It got to a point where the basic implementation was not
fast enough for uses like this: [WiDraw](http://www.youtube.com/watch?v=vWEqFQ6kkN0&feature=plcp).
(They use `drawInRect` - that said, I
haven't followed the module in some time, so things may have improved
since then.) So TiVinci was born which is rewrite of the
module with all the same features added in my fork.


How To
------

Have a look at the `example`.

In a nuthshell the module supports the following.

 * Properites: `strokeColor`, `strokeWidth`, `strokeAlpha`,
`strokeDynamic`, `blurredEdges`

 * `drawMode`: `ERASE`, `CURVE_LINE`, `STRAIGHT_LINE`, `CIRCLE`,
`RECTANGLE` 

 * Methods: `clear()`, `undo()`

 * eventListener: `draw`
