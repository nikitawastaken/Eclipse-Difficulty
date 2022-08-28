function DramaTweakData:init()
	self:_create_table_structure()

	self.drama_actions = {criminal_hurt = 0.2, criminal_dead = 0.2, criminal_disabled = 0.1}
	self.drama_balance_mul = {1.3, 1, 0.75, 0.5}
	self.decay_period = 30
	self.max_dis = 6000
	self.max_dis_mul = 0.5
	self.low = 0.1
	self.peak = 1
	self.assault_fade_end = 0.15
end
