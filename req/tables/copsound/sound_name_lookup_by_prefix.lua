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
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
	d02 = "g90", -- Use regular taunt when deploying flashbangs
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
	ch1 = zXn_zombie_sounds_tbl,
	ch2 = zXn_zombie_sounds_tbl,
	ch3 = zXn_zombie_sounds_tbl,
	ch4 = zXn_zombie_sounds_tbl,
}
local mXn_tbl = {
	ch1 = "hlp", -- Use suppressed lines for sentries, saws, intimidation, trip mines blowing up
	ch2 = "hlp",
	ch4 = "hlp",
	s01x = "hlp",
	d02 = "g90", -- Use regular taunt when deploying flashbangs
}
M.l1n_ = {
	e01 = lXn_sabotage_tbl,
	e02 = lXn_sabotage_tbl,
	e03 = lXn_sabotage_tbl,
	e04 = "g90",
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
	a05 = "clr",
	a06 = "clr",
}
M.l1d_ = {
	a05 = "clr",
	a06 = "clr",
	e05 = "clr",
	e06 = "clr",
}
M.l2d_ = lXd_tbl
M.l3d_ = lXd_tbl
M.l4d_ = lXd_tbl
M.l5d_ = {
	c01 = "g90",
	att = "g90",
	rrl = "pus",
	t01 = "prm",
	h01 = "h10",
	a05 = "clr",
	a06 = "clr",
	e05 = "clr",
	e06 = "clr",
}

-- Gangsters
M.lt1_ = {
	g90 = "c01",
}

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
