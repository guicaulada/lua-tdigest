-- Examples of Digest, which automatically chooses between
-- a discrete and TDigest representation of a streaming sample.

local Digest = require('tdigest.digest');

-- create a frequency digest for a small sample. automatically store
-- these as discrete samples and report exact percentiles

local N = 10;
local digest = Digest:new();
for i = 0, N, 1 do
  digest:push(i / N * 10 - 5);
end
print(digest:summary());
for p = 0, 1.0, 0.1 do
  print(string.format("p = %.2f, x == %f", p, digest:percentile(p)));
end
for x = -5, 5, 1.0 do
  print(string.format("x = %f, p == %f", x, digest:pRank(x)));
end

-- the digest remains exact for a large number of samples having
-- a small number of distinct values

N = 10000;
digest = Digest:new();
for i = 0, N, 1 do
  digest:push(math.floor(i / N * 10 - 5));
end
print(digest:summary());
for p = 0, 1.0, 0.1 do
  print(string.format("p = %.2f, x == %f", p, digest:percentile(p)));
end
for x = -5, 5, 1.0 do
  print(string.format("x = %f, p == %f", x, digest:pRank(x)));
end

-- the digest automatically shifts to a TDigest approximation for a
-- large number of distinct sample values

N = 10000;
digest = Digest:new();
for i = 0, N, 1 do
  digest:push(i / N * 10 - 5);
end
digest:compress();
print(digest:summary());
for p = 0, 1.0, 0.1 do
  print(string.format("p = %.2f, x ~ %s", p, tostring(digest:percentile(p))));
end
for x = -5, 5, 1.0 do
  print(string.format("x = %f, p ~ %s", x, tostring(digest:pRank(x))));
end

-- force the digest to store all unique samples, regardless of number

N = 10000;
digest = Digest:new({ mode = 'disc' });
for i = 0, N, 1 do
  digest:push(i / N * 10 - 5);
end
print(digest:summary());
for p = 0, 1.0, 0.1 do
  print(string.format("p = %.2f, x == %f", p, digest:percentile(p)));
end
for x = -5, 5, 1.0 do
  print(string.format("x = %f, p == %f", x, digest:pRank(x)));
end
