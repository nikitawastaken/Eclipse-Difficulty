local Bain_senddozers = {
	dialogue = "Play_ban_s02_b",
	can_not_be_muted = true
}

return {
    elements = {
		Eclipse.mission_elements.gen_dialogue(
            400001,
            "they_sending_dozers",
            Bain_senddozers
        )
    }
}