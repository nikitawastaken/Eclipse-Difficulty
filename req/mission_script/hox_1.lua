return {
    -- add point of no return and disable endless assault
    [100580] = {
    ponr = 1000
    },
    [100799] = {
        values = {
            on_executed = {
                {delay = 0, id = 100129}
            }
        }
    },
    [102351] = {
        values = {
			enabled = false
        }
    },
    [100824] = {
		values = {
			enabled = false
		}
	}
}