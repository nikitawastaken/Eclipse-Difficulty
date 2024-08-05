return {
	--Don't trigger the spawngroup if the tarp has been cut (should prevent cops from spawning early)
--yes, this makes the cops spawn early 
	[101288] = {
		values = {
			enabled = false
		}
	}
}