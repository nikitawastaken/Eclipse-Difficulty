local Bain_sendcloakers = {
	dialogue = "Play_ban_s04",
	can_not_be_muted = true
}

return {
    elements = {
		StreamHeist:gen_dialogue(
            400001,
            "they_sending_cloakers",
            Bain_sendcloakers
        )
    }
}