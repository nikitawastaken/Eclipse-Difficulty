---@module Sound Name Lookup By Prefix
local M = {}

-- Yes, the prefixes need the _ on the end
-- This table is indexed by prefix as-is

-- Non-filtered cops
-- lXn gets sabotage lines
-- Pure zombie sounds for zXn
-- Tweaks for rXn and mXn
local lXn_sabotage_tbl = {
	"prm",
	"r01",
}
local lXn_tbl = {
	e01 = lXn_sabotage_tbl,
	e02 = lXn_sabotage_tbl,
	e03 = lXn_sabotage_tbl,
	e04 = "g90",
	e05 = "clr",
	e06 = "clr",
	x02a_any_3p = "x01a_any_3p",
	x01a_any_3p = "x02a_any_3p",
	tasered = "burnhurt", -- i'm tased
	lk3a = "lk3b",
	lk3b = "lk3a",
}
local rXn_tbl = {
	a07b = "a07a",
	gr1a = "rdy",
	gr1b = "rdy",
	gr1c = "rdy",
	gr1d = "rdy",
	gr2a = "rdy",
	gr2b = "rdy",
	gr2c = "rdy",
	gr2d = "rdy",
	pos = "rdy",
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
	lk3a = "hlp",
	lk3b = "hlp",
	tasered = "burnhurt", -- i'm tased
	ch3 = "burndeath", -- Ears ouchies
	d02 = "g90", -- Use regular taunt when deploying flashbangs
	rrl = "g90",
	pus = "g90",
	t01 = "rdy",
	i02 = "i01",
	i03 = "g90",
	p02 = "p01",
	p03 = "rdy",
	clr = "mov",
}
local zXn_zombie_sounds_tbl = {
	"g90",
	"mov",
	"rdy",
	"c01",
	"d01",
}
local zXn_tbl = {
	x01a_any_3p = zXn_zombie_sounds_tbl,
	x02a_any_3p = zXn_zombie_sounds_tbl,
	burndeath = zXn_zombie_sounds_tbl,
	burnhurt = zXn_zombie_sounds_tbl,
	a07b = zXn_zombie_sounds_tbl,
	gr1a = zXn_zombie_sounds_tbl,
	gr1b = zXn_zombie_sounds_tbl,
	gr1c = zXn_zombie_sounds_tbl,
	gr1d = zXn_zombie_sounds_tbl,
	gr2a = zXn_zombie_sounds_tbl,
	gr2b = zXn_zombie_sounds_tbl,
	gr2c = zXn_zombie_sounds_tbl,
	gr2d = zXn_zombie_sounds_tbl,
	pos = zXn_zombie_sounds_tbl,
	ch1 = zXn_zombie_sounds_tbl,
	ch2 = zXn_zombie_sounds_tbl,
	ch3 = zXn_zombie_sounds_tbl,
	ch4 = zXn_zombie_sounds_tbl,
	s01x = zXn_zombie_sounds_tbl,
	lk3a = zXn_zombie_sounds_tbl,
	lk3b = zXn_zombie_sounds_tbl,
	tasered = zXn_zombie_sounds_tbl, -- i'm tased
	d02 = zXn_zombie_sounds_tbl,
	rrl = zXn_zombie_sounds_tbl,
	pus = zXn_zombie_sounds_tbl,
	t01 = zXn_zombie_sounds_tbl,
	i02 = zXn_zombie_sounds_tbl,
	i03 = zXn_zombie_sounds_tbl,
	p02 = zXn_zombie_sounds_tbl,
	p03 = zXn_zombie_sounds_tbl,
	clr = zXn_zombie_sounds_tbl,
}
local mXn_tbl = {
	a07b = "a07a",
	gr1a = "rdy",
	gr1b = "rdy",
	gr1c = "rdy",
	gr1d = "rdy",
	gr2a = "rdy",
	gr2b = "rdy",
	gr2c = "rdy",
	gr2d = "rdy",
	pos = "rdy",
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
	lk3a = "hlp",
	lk3b = "hlp",
	tasered = "burnhurt", -- i'm tased
	ch3 = "burndeath", -- Ears ouchies
	d02 = "g90", -- Use regular taunt when deploying flashbangs
	rrl = "g90",
	pus = "g90",
	t01 = "rdy",
	i02 = "i01",
	i03 = "g90",
	p02 = "p01",
	p03 = "rdy",
	clr = "mov",
}
M.l1n_ = {
	e01 = lXn_sabotage_tbl,
	e02 = lXn_sabotage_tbl,
	e03 = lXn_sabotage_tbl,
	e05 = "clr",
	e06 = "clr",
	tasered = "burnhurt", -- i'm tased
	x02a_any_3p = "x01a_any_3p",
	x01a_any_3p = "x02a_any_3p",
}
M.l2n_ = lXn_tbl
M.l3n_ = lXn_tbl
M.l4n_ = {
	e01 = lXn_sabotage_tbl,
	e02 = lXn_sabotage_tbl,
	e03 = lXn_sabotage_tbl,
	e04 = "g90",
	e05 = "clr",
	e06 = "clr",
	tasered = "burnhurt", -- i'm tased
	x02a_any_3p = "x01a_any_3p",
}
M.r1n_ = rXn_tbl
M.r2n_ = rXn_tbl
M.r3n_ = rXn_tbl
M.r4n_ = rXn_tbl
M.z1n_ = zXn_tbl
M.z2n_ = zXn_tbl
M.z3n_ = zXn_tbl
M.z4n_ = zXn_tbl
M.m1n_ = mXn_tbl
M.m2n_ = mXn_tbl
M.m3n_ = mXn_tbl
M.m4n_ = mXn_tbl

-- Filtered cops
-- l5d is very brokey, the others just need something for stealth lines
local lXd_tbl = {
	amm = "e04",
	med = "e04",
	a05 = "clr",
	a06 = "clr",
	tasered = "burnhurt", -- i'm tased
}
local l5d_contact_tbl = {
	"i01",
	"g90",
}
M.l1d_ = {
	amm = "e04",
	med = "e04",
	a05 = "clr",
	a06 = "clr",
	e05 = "clr",
	e06 = "clr",
	tasered = "burnhurt", -- i'm tased
	i02 = "i01", -- l1d doesn't have i02 lines for some reason (use i01 instead)
}
M.l2d_ = lXd_tbl
M.l3d_ = lXd_tbl
M.l4d_ = lXd_tbl
M.l5d_ = {
	amm = "e04",
	med = "e04",
	c01 = l5d_contact_tbl,
	att = l5d_contact_tbl,
	rrl = "pus",
	t01 = "prm",
	h01 = "h10",
	a05 = "clr",
	a06 = "clr",
	tasered = "burnhurt", -- i'm tased
}

-- Gangsters
local gangsters_tbl = {
	i01 = "aes",
	i02 = "c01",
	i03 = "g90",
}
M.lt1_ = {
	g90 = "c01",
	i01 = "aes",
	i02 = "c01",
	--i03 = "g90",
}
M.lt2_ = gangsters_tbl
M.ict1_ = gangsters_tbl
M.ict2_ = gangsters_tbl
M.bik1_ = gangsters_tbl
M.bik2_ = gangsters_tbl
M.rt1_ = gangsters_tbl
M.rt2_ = gangsters_tbl

-- Bulldozers
local bdz_tbl = {
	d01 = "g90",
	d02 = "g90",
	heal = "g90", -- use taunt lines when healing (American Medicdozers already do so anyway)
}
M.bdz_ = {
	d01 = "g90",
	d02 = "g90",
}
M.rbdz_ = bdz_tbl
M.mbdz_ = bdz_tbl

-- Tasers
local tsr_tbl = {
	ch3 = "burndeath", -- Ears ouchies
	d01 = "g90",
	d02 = "g90",
}
M.tsr_ = tsr_tbl
M.rtsr_ = tsr_tbl
M.mtsr_ = tsr_tbl

-- Cloakers
local clk_tbl = {
	tasered = "burnhurt", -- i'm tased
}
M.clk_ = clk_tbl
M.rclk_ = clk_tbl
M.mclk_ = clk_tbl

-- Medics
local mdc_tbl = {
	ch3 = "burndeath", -- Ears ouchies
	tasered = "burnhurt", -- i'm tased
	e05 = "g90",
	e06 = "g90",
}
M.mdc_ = mdc_tbl
M.rmdc_ = mdc_tbl
M.mmdc_ = mdc_tbl

return M
