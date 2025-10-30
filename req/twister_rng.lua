---@module twister_rng
---https://en.wikipedia.org/wiki/Mersenne_Twister
local M = {}

M._seed = nil
M.default_seed = 19650218
M.num_states = 624
M.mid_word = 397
M.init19937 = 1812433253
M.word_size = 32
M.separation_point = 31
M.state = {
	state = {},
	state_index = 0,
}

function M:init_state(seed)
	seed = seed or self.default_seed
	self._seed = seed

	self.state.state[0] = seed or self.default_seed
	for i = 1, M.num_states, 1 do
		seed = self.init19937 * (bit.bxor(seed, bit.rshift(seed, self.word_size - 2))) + i
		self.state.state[i] = seed
	end

	self.state.state_index = 0
end

function M:reset_state()
	local seed = self._seed

	self.state.state[0] = seed
	for i = 1, M.num_states, 1 do
		seed = self.init19937 * (bit.bxor(seed, bit.rshift(seed, self.word_size - 2))) + i
		self.state.state[i] = seed
	end

	self.state.state_index = 0
end

local UMASK = bit.lshift(0xffffffff, M.separation_point)
local LMASK = bit.rshift(0xffffffff, M.word_size - M.separation_point)
local coefficient_a = 0x9908b0df
local coefficient_u = 11
local coefficient_s = 7
local coefficient_t = 15
local coefficient_l = 18
local coefficient_b = 0x9d2c5680
local coefficient_c = 0xefc6000
function M:random_uint32()
	local k = self.state.state_index
	local j = k - (self.num_states - 1)
	if j < 0 then
		j = j + self.num_states
	end

	local x = bit.bor(bit.band(self.state.state[k], UMASK), bit.band(self.state.state[j], LMASK))
	local xA = bit.rshift(x, 1)
	if bit.band(x, 0x00000001) then
		xA = bit.bxor(xA, coefficient_a)
	end

	j = k - (self.num_states - self.mid_word)
	if j < 0 then
		j = j + self.num_states
	end

	x = bit.bxor(self.state.state[j], xA)
	k = k + 1
	self.state.state[k] = x

	if k >= self.num_states then
		k = 0
	end
	self.state.state_index = k

	local y = bit.bxor(x, bit.rshift(x, coefficient_u))
	y = bit.bxor(y, bit.band(bit.lshift(y, coefficient_s), coefficient_b))
	y = bit.bxor(y, bit.band(bit.lshift(y, coefficient_t), coefficient_c))
	return bit.bxor(y, bit.rshift(y, coefficient_l))
end

local max_rand = math.pow(2, 32) - 1

---returns a random float in the interval [min, max] or [0, 1]
---@param max number?
---@param min number?
function M:random_uniform_float(max, min)
	max = max or 1
	min = min or 1

	local rand = self:random_uint32() / max_rand
	return rand * (max - min) + min
end

return M
