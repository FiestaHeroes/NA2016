--------------------------------------------------------------------------------
--                           Stuff Data                                       --
--------------------------------------------------------------------------------

-- 게이트 오픈시 리젠될 몹 정보와 좌표
DoorMobRegenInfo =
{
	-- 처음 인던 입장시 리젠할 몹그룹
	start =
	{
		{ MobGroupNum = 1, x = 1348, y = 8497 }, 	-- A영역
		{ MobGroupNum = 2, x = 3403, y = 10558 }, 	-- B영역
	},

	-- RootA
	-- a도어 오픈시 리젠될 몹그룹과 좌표
	a =
	{
		{ MobGroupNum = 3, x = 1336, y = 6449 }, -- D영역
		{ MobGroupNum = 4, x = 1336, y = 4383 }, -- E영역

	},

	e =
	{
		{ MobGroupNum = 5, x = 1336, y = 2355 }, -- F영역
		{ MobGroupNum = 6, x = 3398, y = 4402 }, -- I영역
		{ MobGroupNum = 7, x = 3398, y = 2348 }, -- H영역
	},

	h =
	{
		{ MobGroupNum = 8, 	x = 4550, y = 4401 }, -- L영역
		{ MobGroupNum = 9, 	x = 5450, y = 2347 }, -- M영역
		{ MobGroupNum = 10, x = 7502, y = 2347 }, -- N영역

	},

	n =
	{
		-- 보스 몹 소환
	},


	-- RootB
	b =
	{
		{ MobGroupNum = 11, x = 3401, y = 8507 }, 	-- C영역
		{ MobGroupNum = 12, x = 3403, y = 6453 }, 	-- G영역

	},

	g =
	{
		{ MobGroupNum = 13, x = 5459, y = 8513 }, 	-- K영역
		{ MobGroupNum = 14, x = 5444, y = 6453 }, 	-- J영역
		{ MobGroupNum = 15, x = 5443, y = 10563 }, 	-- O영역
	},

	o =
	{
		{ MobGroupNum = 16, x = 7500, 	y = 10571 }, -- P영역
		{ MobGroupNum = 17, x = 9560, 	y = 10559 }, -- Q영역
		{ MobGroupNum = 18, x = 11625, 	y = 10564 }, -- R영역
	},

	r =
	{
		-- 보스 몹 소환
	},
}



-- A 영역 몹 모두 잡으면 a 도어 오픈
RootInfo =
{
	RootA =
	{
		{ AreaName = "A", OpenDoor = "a" },
		{ AreaName = "E", OpenDoor = "e" },
		{ AreaName = "H", OpenDoor = "h" },
		{ AreaName = "N", OpenDoor = "n" },
	},

	RootB =
	{
		{ AreaName = "B", OpenDoor = "b" },
		{ AreaName = "G", OpenDoor = "g" },
		{ AreaName = "O", OpenDoor = "o" },
		{ AreaName = "R", OpenDoor = "r" },
	},
}





