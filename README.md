TDigest
============

Lua implementation of Dunning's T-Digest for streaming quantile approximation.

The T-Digest is a data structure and algorithm for constructing an
approximate distribution for a collection of real numbers presented as a
stream. The algorithm makes no guarantees, but behaves well enough in
practice that implementations have been included in Apache Mahout and
ElasticSearch for computing summaries and approximate order
statistics over a stream.

For an overview of T-Digest's behavior, see Davidson-Pilon's
[blog post](http://dataorigami.net/blogs/napkin-folding/19055451-percentile-and-quantile-estimation-of-big-data-the-t-digest) regarding a python implementation. For more details,
there are the [tdigest paper](https://github.com/tdunning/t-digest/blob/master/docs/t-digest-paper/histo.pdf) and [reference implementation](https://github.com/tdunning/t-digest) (Java).
This Lua implementation is based on a reading of the paper,
with some boundary and performance tweaks.

This is an adaptation of the JavaScript version created by [Will Welch](https://github.com/welch/tdigest).

Quickstart
------------

```
luarocks install tdigest
```

```lua
local TDigest = require('tdigest').TDigest;
local x={}
local N = 100000;
for i = 0, N, 1 do
  table.insert(x, math.random() * 10 - 5);
end
td = TDigest:new();
td:push(x);
td:compress();
print(td.summary());
print("median ~ " .. td:percentile(0.5));
```

See also [examples/tdigest.lua](./examples/tdigest.lua) in this package.

Dependencies
-------------
`bintrees`: [https://luarocks.org/modules/guicaulada/bintrees](https://luarocks.org/modules/guicaulada/bintrees)
