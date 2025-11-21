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
	lk3a = "lk3b",
	lk3b = "lk3a",
}
local rXn_tbl = {
    a07b = "a07a",
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
    ch3 = "burndeath", -- Ears ouchies
	d02 = "g90", -- Use regular taunt when deploying flashbangs
	i02 = "i01",
	i03 = "g90",
    p02 = "p01",
    p03 = "rdy",
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
	ch1 = zXn_zombie_sounds_tbl,
	ch2 = zXn_zombie_sounds_tbl,
	ch3 = zXn_zombie_sounds_tbl,
	ch4 = zXn_zombie_sounds_tbl,
	d02 = zXn_zombie_sounds_tbl,
	i02 = zXn_zombie_sounds_tbl,
	i03 = zXn_zombie_sounds_tbl,
    p02 = zXn_zombie_sounds_tbl,
	p03 = zXn_zombie_sounds_tbl,
}
local mXn_tbl = {
    a07b = "a07a",
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
    ch3 = "burndeath", -- Ears ouchies
	d02 = "g90", -- Use regular taunt when deploying flashbangs
	i02 = "i01",
	i03 = "g90",
    p02 = "p01",
    p03 = "rdy",
}
M.l1n_ = {
	e01 = lXn_sabotage_tbl,
	e02 = lXn_sabotage_tbl,
	e03 = lXn_sabotage_tbl,
	amm = "lk3b", -- l1n doesn't have medic/ammo bag spot lines for some reason
	med = "lk3b",
	e05 = "clr",
	e06 = "clr",
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
	i03 = "g90",
}
M.lt2_ = gangsters_tbl
M.ict1_ = gangsters_tbl
M.ict2_ = gangsters_tbl
M.bik1_ = gangsters_tbl
M.bik2_ = gangsters_tbl
M.rt1_ = gangsters_tbl
M.rt2_ = gangsters_tbl

-- Tasers
local tsr_tbl = {
	ch3 = "burndeath", -- Ears ouchies
}
M.tsr_ = tsr_tbl
M.rtsr_ = tsr_tbl
M.mtsr_ = tsr_tbl

-- Medics
local mdc_tbl = {
	ch3 = "burndeath", -- Ears ouchies
}
M.mdc_ = mdc_tbl
M.rmdc_ = mdc_tbl
M.mmdc_ = mdc_tbl

return M
