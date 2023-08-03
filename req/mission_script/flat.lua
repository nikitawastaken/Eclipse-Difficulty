return {
	-- Disable roof/stairs reinforcement
	[102501] = {
		values = {
			enabled = false
		}
	},
	[103181] = {
		values = {
			enabled = false
		}
	},
	-- reenable far sniper
    [101521] = {
		values = {
			enabled = true
		}
	},
    [101599] = {
		values = {
			enabled = true
		}
	},
	-- reenable alleyway drop
    [102261] = {
        values = {
            on_executed = {
                {delay = 0, id = 101591},
                {delay = 0, id = 101573},
                {delay = 0, id = 100350}
            }
        }
    },
    -- add point of no return
    [101016] = {
    ponr = 180
    }
}