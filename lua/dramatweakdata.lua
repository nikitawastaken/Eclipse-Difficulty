-- Make drama inefficient so that it has barely (if any) impact on fades
function DramaTweakData:init()
	self:_create_table_structure()

	self.drama_actions = {
		criminal_hurt = 0.075,
		criminal_dead = 0.15,
		criminal_disabled = 0.1
	}
	self.decay_period = 30
	self.max_dis = 6000
	self.max_dis_mul = 0.5
	self.low = 0.1
	self.peak = 0.95
	self.assault_fade_end = 0.5
end
