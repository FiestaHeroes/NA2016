--------------------------------------------------------------------------------
--                           Seiren Castle Stuff Data                         --
--------------------------------------------------------------------------------

-- 게이트 정보

--[[
	※ 참고
	TwinGate 있는 도어는
	오픈할때, TwinGate에 해당하는 도어도 같이 열어준다.
--]]

DoorInfo =
{
	Door1_1 =
	{
		Block 		= "DoorBlock01",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		TwinGate 	= "Door1_2",
		FuncName 	= "Door1",
	},
	Door1_2 =
	{
		Block 		= "DoorBlock01_1",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		TwinGate 	= "Door1_1",
		FuncName 	= "Door1",
	},

	Door2 =
	{
		Block 		= "DoorBlock02",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		FuncName 	= "Door2",
	},

	Door3 =
	{
		Block 		= "DoorBlock03",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		FuncName 	= "Door3",
	},

	Door4_1 =
	{
		Block 		= "DoorBlock04",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		TwinGate 	= "Door4_2",
		FuncName 	= "Door4",
	},

	Door4_2 =
	{
		Block 		= "DoorBlock04_1",
		NeedItem 	= "SilverKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		TwinGate 	= "Door4_1",
		FuncName 	= "Door4",
	},

	DoorBoss =
	{
		Block 		= "DoorBlock05",
		NeedItem 	= "GoldKey",
		CastingTime = 2,
		CastingAni 	= "ActionProduct",
		FuncName 	= "DoorBoss",
	},
}
