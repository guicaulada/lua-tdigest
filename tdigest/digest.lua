local TDigest = require('tdigest.tdigest')
local Digest = TDigest:new()

function Digest:new(config)
  config = config or {}
  local o = TDigest:new(false)
  if config.mode == 'cont' then
    o = TDigest:new(config.delta)
  end
  setmetatable(o, self)
  self.__index = self
  o.config = config
  o.mode = config.mode or 'auto'
  o.digestRatio = config.ratio or 0.9
  o.digestThresh = config.thresh or 1000
  o.nUnique = 0
  return o
end

function Digest:push(x)
  TDigest.push(self, x)
  self:checkContinuous()
end

function Digest:newCentroid(x, n, cumn)
  self.nUnique = self.nUnique + 1
  TDigest.newCentroid(self, x, n, cumn)
end

function Digest:addWeight(nearest, x, n)
  if nearest.n == 1 then
    self.nUnique = self.nUnique - 1
  end
  TDigest.addWeight(self, nearest, x, n)
end

function Digest:checkContinuous()
  if self.mode ~= 'auto' and self:size() < self.digestThresh then
    return false
  end
  if self.nUnique / self:size() > self.digestRatio then
    self.mode = 'cont'
    self.discrete = false
    self.delta = self.config.delta or 0.01
    self:compress()
    return true
  end
  return false
end

return Digest
