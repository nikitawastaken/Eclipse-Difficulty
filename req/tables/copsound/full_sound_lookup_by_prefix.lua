---@module Full Sound Lookup By Prefix
local M = {}

-- Yes, the prefixes need the _ on the end
-- This table is indexed by prefix as-is

-- proper death sounds for civilains
-- female civ voices have the same death sound since there's only one voiceset for female enemies
-- male
M.cm1_ = {
	x02a_any_3p = "l1n_x01a_any_3p",
}
M.cm2_ = {
	x02a_any_3p = "l2n_x01a_any_3p",
}
M.cm3_ = {
	x02a_any_3p = "l3n_x01a_any_3p",
}
M.cm4_ = {
	x02a_any_3p = "l4n_x01a_any_3p",
}
M.cm5_ = {
	x02a_any_3p = "l1n_x01a_any_3p",
}
M.cm6_ = {
	x02a_any_3p = "l2n_x01a_any_3p",
}
-- female
M.cf1_ = {
	x02a_any_3p = "fl1n_x02a_any_3p",
}
M.cf2_ = {
	x02a_any_3p = "fl1n_x02a_any_3p",
}
M.cf3_ = {
	x02a_any_3p = "fl1n_x02a_any_3p",
}
M.cf4_ = {
	x02a_any_3p = "fl1n_x02a_any_3p",
}
M.cf5_ = {
	x02a_any_3p = "fl1n_x02a_any_3p",
}

-- Non-filtered cops
M.l4n_ = {
	x01a_any_3p = "l1n_x02a_any_3p",
}
-- fix Akan's men not having any pain/death sounds
-- also stelf lines for them
M.r1n_ = {
	x02a_any_3p = "l1n_x01a_any_3p",
	x01a_any_3p = "l1n_x02a_any_3p",
	a05 = "l1n_a06",
	a06 = "l1n_a06",
}
M.r2n_ = {
	x02a_any_3p = "l2n_x01a_any_3p",
	x01a_any_3p = "l2n_x02a_any_3p",
	a05 = "l2n_a06",
	a06 = "l2n_a06",
}
M.r3n_ = {
	x02a_any_3p = "l3n_x01a_any_3p",
	x01a_any_3p = "l3n_x02a_any_3p",
	a05 = "l3n_a06",
	a06 = "l3n_a06",
}
M.r4n_ = {
	x02a_any_3p = "l4n_x01a_any_3p",
	x01a_any_3p = "l1n_x02a_any_3p",
	a05 = "l4n_a06",
	a06 = "l4n_a06",
}

-- stelf idle lines for bexico guards
M.m1n_ = {
	a05 = "l1n_a06",
	a06 = "l1n_a06",
}
M.m2n_ = {
	a05 = "l2n_a06",
	a06 = "l2n_a06",
}
M.m3n_ = {
	a05 = "l3n_a06",
	a06 = "l3n_a06",
}
M.m4n_ = {
	a05 = "l4n_a06",
	a06 = "l4n_a06",
}

-- Female cops
-- These lines are just missing for these voicesets
M.fl1n_ = {
	burnhurt = "cf1_burnhurt",
	burndeath = "cf1_burndeath",
	tasered = "cf1_burnhurt", -- im tased
	ch3 = "cf1_burndeath", -- Ears ouchies
}

-- Filtered cops
-- These lines are just missing for these voicesets
M.l2d_ = {
	x02a_any_3p = "l1d_x02a_any_3p",
}
M.l3d_ = {
	burnhurt = "l1d_burnhurt",
	burndeath = "l1d_burndeath",
}

-- Bulldozers
local bdz_tbl = {
	burndeath = "l1d_burndeath",
	burnhurt = "l1d_burnhurt",
	x02a_any_3p = "bdz_x02a_any_3p",
	x01a_any_3p = "bdz_x01a_any_3p",
}
M.bdz_ = bdz_tbl
M.rbdz_ = bdz_tbl
M.mbdz_ = bdz_tbl

-- Cloakers
local clk_tbl = {
	g90 = "clk_c01x_plu", -- Cloakers whistle in place of contact/taunt lines
	c01 = "clk_c01x_plu",
}
M.clk_ = {
	x01a_any_3p = "l2d_x01a_any_3p", -- Radio filtered hurt sound, lacks his own
	x02a_any_3p = "clk_x02a_any_3p",
	g90 = "clk_c01x_plu",
	c01 = "clk_c01x_plu",
}
M.rclk_ = clk_tbl
M.mclk_ = clk_tbl

-- Gangsters
local gangsters_1_tbl = {
	burnhurt = "l1n_burnhurt",
	burndeath = "l1n_burndeath",
	tasered = "l1n_burnhurt", -- i'm tased
	ch3 = "l1n_burndeath", -- Ears ouchies
	a05 = "l3n_a06",
	a06 = "l3n_a06",
}
M.ict1_ = gangsters_1_tbl
M.bik1_ = gangsters_1_tbl
M.lt1_ = gangsters_1_tbl
M.rt1_ = gangsters_1_tbl

local gangsters_2_tbl = {
	burnhurt = "l2n_burnhurt",
	burndeath = "l2n_burndeath", -- Ears ouchies
	tasered = "l2n_burnhurt", -- i'm tased
	ch3 = "l2n_burndeath",
	a05 = "l4n_a06",
	a06 = "l4n_a06",
}
M.ict2_ = gangsters_2_tbl
M.bik2_ = gangsters_2_tbl
M.lt2_ = gangsters_2_tbl
M.rt2_ = gangsters_2_tbl

-- l5n voiceset restoration below, credit goes to SonicSoapyBoi for figuring out the line IDs
local l5n_contact_tbl = {
	"Play_l5n_i01_con",
	"Play_l5n_g90",
}
local l5n_alert_tbl = {
	"Play_l5n_lk3_con",
	"l5n_a08",
}
local l5n_police_calls_tbl = {
	"l5n_a09",
	"l5n_a23",
}
local l5n_sabotage_tbl = {
	"Play_l5n_prm_con",
	"Play_l5n_r01_con",
}
M.l5n_ = {
	c01 = l5n_contact_tbl, -- Use i01 and g90 as contact, l5n lacks them
	att = l5n_contact_tbl,

	a07a = l5n_alert_tbl,
	a07b = l5n_alert_tbl,

	a10 = l5n_police_calls_tbl,
	a11 = l5n_police_calls_tbl,
	a12 = l5n_police_calls_tbl,

	e01 = l5n_sabotage_tbl,
	e02 = l5n_sabotage_tbl,
	e03 = l5n_sabotage_tbl,

	rdy = "Play_l5n_rdy",

	h01 = "Play_l5n_c01a", -- Contact line is actually a rescue line

	cn1 = "Play_l5n_cn1_con",

	civ = "Play_l5n_civ_con",

	cr1 = "Play_l5n_cr1_con",

	clr = "Play_l5n_clr_con",
	e05 = "Play_l5n_clr_con",
	e06 = "Play_l5n_clr_con",

	g90 = "Play_l5n_g90",
	e04 = "Play_l5n_g90",

	d01 = "Play_l5n_d01_con",
	d02 = "Play_l5n_d02_con",

	ch1 = "Play_l5n_ch1_con",
	ch2 = "Play_l5n_ch2_con",
	ch3 = "Play_l5n_ch3_con",
	ch4 = "Play_l5n_ch4_con",

	gr1a = "Play_l5n_gr1a_con",
	gr1b = "Play_l5n_gr1b_con",
	gr1c = "Play_l5n_gr1c_con",
	gr1d = "Play_l5n_gr1d_con",

	gr2a = "Play_l5n_gr2a_con",
	gr2b = "Play_l5n_gr2b_con",
	gr2c = "Play_l5n_gr2c_con",
	gr2d = "Play_l5n_gr2d_con",

	med = "Play_l5n_med_con",

	m01 = "Play_l5n_m01_any",

	mov = "Play_l5n_mov_ass",

	p01 = "Play_l5n_p01_ass",
	p02 = "Play_l5n_p02_ass",
	p03 = "Play_l5n_p03_ass",

	pos = "Play_l5n_pos_con",

	prm = "Play_l5n_prm_con",
	t01 = "Play_l5n_prm_con",

	pus = "Play_l5n_pus_con",
	rrl = "Play_l5n_pus_con",

	r01 = "Play_l5n_r01_con",

	s01x = "Play_l5n_s01x_con",

	i01 = "Play_l5n_i01_con",
	i02 = "Play_l5n_i02_con",
	i03 = "Play_l5n_i03_con__________________MISSING_i03c",

	l01 = "Play_l5n_l01_con__________________MISSING_l01b",

	lk3a = "Play_l5n_lk3_ass",
	lk3b = "Play_l5n_lk3_con",

	hlp = "Play_l5n_hlp_con",

	x02a_any_3p = "l1n_x01a_any_3p",
	x01a_any_3p = "l1n_x02a_any_3p",
	tasered = "l1n_burnhurt", -- i'm tased
}
-- Test fix for l5n on clientside
-- for _, replacement in pairs(M.l5n_) do
-- 	if type(replacement) == "table" then
-- 		for _, v in pairs(replacement) do
-- 			if v:begins("Play_") then
-- 				M.l5n_[SoundDevice:string_to_id(v)] = replacement
-- 			end
-- 		end
-- 	elseif replacement:begins("Play_") then
-- 		M.l5n_[SoundDevice:string_to_id(replacement)] = replacement
-- 	end
-- end

return M
