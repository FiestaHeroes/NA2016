-- BH_Albireo --


---------------------------------------------------------------------
-----------------------   Script Data Part   ------------------------
---------------------------------------------------------------------

MemBlock 			= {}
PhaseData			= {}
ReturnAI 			= {}
ReturnAI.END 		= 1    	-- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP 		= 2    	-- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림
SHINEOBJECT  		= 2		-- ShineObject_Player
HPSection			= {}
HPSection.Init		= -1
HPSection.None		= 0
HPSection.First		= 1
HPSection.Second	= 2
HPSection.Third		= 3

-- 1 단계
PhaseData[1]		=
{
	-- 단계 진입 조건
	HPRateMax	= 900,
	HPRateMin	= 750,

	-- 스킬, 상태이상
	Skill 		=
	{
		{ Index = "BH_Albireo_Skill06_W", Type = "Skill",	Target = "Me", 		KeepTime = 0, 		OneShot = true, WaitAfter = 5, Range = 0 	},
		{ Index = "Sta_B_Albi_Fear",	 Type = "AbState",	Target = "Other", 	KeepTime = 20000, 	OneShot = true, WaitAfter = 0, Range = 600 	},
		{ Index = "Sta_B_Albi_Dot",	 	 Type = "AbState",	Target = "Other", 	KeepTime = 20000, 	OneShot	= true, WaitAfter = 0, Range = 600	},
	},

	-- 소환
	Summon		=
	{
		{
			-- MineKN01
			{ Index = "BHArkMine_Kn", X = 2096, Y = 1886, W = 366, H = 281, D = 0, Interval = 20 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 1786, W = 366, H = 281, D = 0, Interval = 20 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 1886, W = 366, H = 281, D = 0, Interval = 20 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 1886, W = 366, H = 281, D = 0, Interval = 20 },

			-- MineKN02
			{ Index = "BHArkMine_Kn", X = 1096, Y = 1886, W = 366, H = 281, D = 0, Interval = 12 },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 1886, W = 366, H = 281, D = 0, Interval = 12 },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 1886, W = 366, H = 281, D = 0, Interval = 12 },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 1886, W = 366, H = 281, D = 0, Interval = 12 },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 1886, W = 366, H = 281, D = 0, Interval = 12 },

			-- MineKN03
			{ Index = "BHArkMine_Kn", X = 1096, Y = 781,  W = 366, H = 549, D = 0, Interval = 16  },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 781,  W = 366, H = 549, D = 0, Interval = 16  },
			{ Index = "BHArkMine_Kn", X = 1096, Y = 781,  W = 366, H = 549, D = 0, Interval = 16  },

			-- MineKN04
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
			{ Index = "BHArkMine_Kn", X = 2096, Y = 781,  W = 366, H = 549, D = 0, Interval = 24 },
		},
	},

	SummonInfo	=
	{
		{ IsAfterPrevSummon = false,  IsTimeOver = false, OverTime = 0, EndHPSection = HPSection.Third },
	},
}

PhaseData[2]		=
{
	-- 단계 진입 조건
	HPRateMax	= 750,
	HPRateMin	= 400,

	-- 스킬, 상태이상
	Skill 		=
	{
		{ Index = "BH_Albireo_Skill06_W", Type = "Skill",	Target = "Me", 	KeepTime = 0, 		OneShot = true, WaitAfter = 5, Range = 0 	},
		{ Index = "Sta_BH_Albi_Reflect",	 Type = "AbState",	Target = "Me", 	KeepTime = 1200000, 	OneShot = true, WaitAfter = 0, Range = 150 	},
	},

	-- 소환
	Summon		=
	{

	},

	SummonInfo	=
	{

	},
}

PhaseData[3]		=
{
	-- 단계 진입 조건
	HPRateMax	= 400,
	HPRateMin	= 10,

	-- 스킬, 상태이상
	Skill 		=
	{
		{ Index = "BH_Albireo_Skill06_W", Type = "Skill",	Target = "Me", 	KeepTime = 0, 		OneShot = true, WaitAfter = 5, Range = 0 	},
		{ Index = "Sta_BH_Albi_ACMRUp",	 Type = "AbState",	Target = "Me", 	KeepTime = 600000, 	OneShot = true, WaitAfter = 0, Range = 0 	},
	},

	-- 소환
	Summon		=
	{
		{
			-- MineKN05
			{ Index = "BHArkMine_Kn", X = 1613, Y = 1973, W = 600, H = 600, D = 0, Interval = 22 },
			{ Index = "BHArkMine_Kn", X = 1613, Y = 1973, W = 600, H = 600, D = 0, Interval = 26 },
			{ Index = "BHArkMine_Kn", X = 1613, Y = 1973, W = 600, H = 600, D = 0, Interval = 30 },
			{ Index = "BHArkMine_Kn", X = 1613, Y = 1973, W = 600, H = 600, D = 0, Interval = 34 },
			{ Index = "BHArkMine_Kn", X = 1613, Y = 1973, W = 600, H = 600, D = 0, Interval = 38 },

			-- MineKN06
			{ Index = "BHArkMine_Kn", X = 1600, Y = 796, W = 600, H = 600, D = 0, Interval = 20 },
			{ Index = "BHArkMine_Kn", X = 1600, Y = 796, W = 600, H = 600, D = 0, Interval = 28 },
			{ Index = "BHArkMine_Kn", X = 1600, Y = 796, W = 600, H = 600, D = 0, Interval = 36 },
			{ Index = "BHArkMine_Kn", X = 1600, Y = 796, W = 600, H = 600, D = 0, Interval = 44 },

			-- MineKN07
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 30 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 36 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 42 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 48 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 54 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 60 },
			{ Index = "BHArkMine_Kn", X = 1160, Y = 1463,  W = 600, H = 600, D = 0, Interval = 66 },

			-- MineKN08
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 15 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 21 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 27 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 33 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 39 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 45 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 51 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 57 },
			{ Index = "BHArkMine_Kn", X = 2102, Y = 1487,  W = 600, H = 600, D = 0, Interval = 63 },
		},

		{
			-- MineF01
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 15 },

			-- MineF02
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 15 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 15 },
		},

		{
			-- MineF03
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 20 },

			-- MineF04
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 20 },
		},

		{
			-- MineF05
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 2694, Y = 1468, W = 0, H = 0, D = 10, Interval = 30 },

			-- MineF06
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
			{ Index = "BHArkMine_F", X = 502,  Y = 1464, W = 0, H = 0, D = 10, Interval = 30 },
		},
	},

	SummonInfo	=
	{
		{ IsAfterPrevSummon = false, IsTimeOver = false, OverTime = 0,	 EndHPSection = HPSection.Third },
		{ IsAfterPrevSummon = false, IsTimeOver = true,  OverTime = 180, EndHPSection = HPSection.None 	},
		{ IsAfterPrevSummon = true,  IsTimeOver = true,  OverTime = 300, EndHPSection = HPSection.None 	},
		{ IsAfterPrevSummon = true,	 IsTimeOver = false, OverTime = 0,	 EndHPSection = HPSection.Init 	},
	},
}

-- 보물상자 소환 정보
BH_AlbiBox =
{
	{ Index = "BH_Albireo_Box", ItemDropMobIndex = "BH_Albireo_Box", 	Radius = 250 },
	{ Index = "BH_Albireo_Box", ItemDropMobIndex = "BH_Albireo_Box", 	Radius = 250 },
	{ Index = "BH_Albireo_Box", ItemDropMobIndex = "BH_Albireo_Box", 	Radius = 250 },
	{ Index = "BH_Albireo_Box", ItemDropMobIndex = "BH_Albireo_Box", 	Radius = 250 },
}
AlbiBox_VanishTime = 60 -- Time for Chests to Despawn.
AlbiBox_ChestsSpawns = 5 -- Chest Amount to Spawn.


------------------------------------------------------------------
-----------------------    Albireo Part   ------------------------
------------------------------------------------------------------
function Skill_Wait( Var )
	cExecCheck "Skill_Wait"

	if type(Var) ~= "table" then
		cAssertLog("Skill_Wait ERROR Var not table")
		return false
	end

	local wait = Var.SkillWaitAfter

	if wait == nil then
		cAssertLog("Skill_Wait WARN nil fix")
		Var.SkillWaitAfter = 0
		return false
	end

	if type(wait) ~= "number" then
		cAssertLog("Skill_Wait ERROR type invalid")
		Var.SkillWaitAfter = 0
		return false
	end

	if wait ~= 0 then
		if cCurSec() < wait then
			return true
		else
			Var.SkillWaitAfter = 0
			return false
		end
	end

	return false
end


function Init( Var, Handle, MapIndex )
		cExecCheck "Init"

		MemBlock[Handle] = {}

		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.Wait = {}
		Var.Wait.Second = 0
		Var.Wait.NextFunc = nil
		Var.TargetLostSec = 0
		Var.CurrentPhase = 0
		Var.IsInit = {}
		Var.IsUsedSkill = false
		Var.IsUsedSkillAll = false
		Var.CurrentSkill = 1
		Var.SkillWaitAfter = 0

		Var.SummonList = {}

		for i = 1, #PhaseData do
			Var.SummonList[i] = {}

			for j = 1, #(PhaseData[i]["Summon"]) do
				Var.SummonList[i][j] = {}
				Var.SummonList[i][j].IsOver = false
				Var.SummonList[i][j].OverTime = 0

				for k = 1, #(PhaseData[i]["Summon"][j]) do
					Var.SummonList[i][j][k] = {}
					Var.SummonList[i][j][k].IsActive = false
					Var.SummonList[i][j][k].Interval = 0
				end
			end
		end

		Var.MobList = {}
		Var.StepFunc = Albi_HPCheck
end

function BH_Albireo( Handle, MapIndex )
		cExecCheck "BH_Albireo"

		if IsSetScript == false then
			IsSetScript = true
		end

		local Var = MemBlock[Handle]

		if cIsObjectDead(Handle) ~= nil then

			if Var ~= nil then

				local InvisibleHandle = cMobRegen_Obj("InvisibleMan", Handle)
				cAIScriptSet(InvisibleHandle, Handle)

				MemBlock[InvisibleHandle] = {}
				MemBlock[InvisibleHandle].Handle = InvisibleHandle
				MemBlock[InvisibleHandle].MapIndex = MapIndex
				MemBlock[InvisibleHandle].StepFunc = Invisible_Init

				MemBlock[Handle] = nil

				cVanishAll(MapIndex, "BHArkMine_Kn")
				cVanishAll(MapIndex, "BHArkMine_F")

				return MemBlock[InvisibleHandle].StepFunc(MemBlock[InvisibleHandle])
			end

			return ReturnAI.END
		end

		if Var == nil then
			Init(Var, Handle, MapIndex)
			return ReturnAI.CPP
		end

		Var.Handle = Handle
		Var.MapIndex = MapIndex

		if Var.StepFunc ~= nil then
			Var.StepFunc(Var)
		end

		return ReturnAI.CPP
end

function Albi_Init( Var )
		cExecCheck "Albi_Init"

		for i = 1, #PhaseData do
			Var.IsInit[i] = false
		end

		Var.IsUsedSkill = false
		Var.IsUsedSkillAll = false
		Var.CurrentSkill = 1
		Var.SkillWaitAfter = 0
end

-- Albireo HP 구간 체크
function Albi_HPCheck( Var )
		cExecCheck "Albi_HPCheck"

		local hp, maxhp = cObjectHP(Var.Handle)

		if hp == nil or maxhp == nil or hp == 0 then
			Albi_Init(Var)
			Var.CurrentPhase = HPSection.Init

		elseif maxhp * PhaseData[1].HPRateMax < hp * 1000 then
			Albi_Init(Var)
			Var.CurrentPhase = HPSection.None

		elseif maxhp * PhaseData[1].HPRateMin < hp * 1000 and hp * 1000 <= maxhp * PhaseData[1].HPRateMax then
			if Var.IsInit[1] == false then
				Albi_Init(Var)
				Var.IsInit[1] = true
			end
			Var.CurrentPhase = HPSection.First

		elseif maxhp * PhaseData[2].HPRateMin < hp * 1000 and hp * 1000 <= maxhp * PhaseData[2].HPRateMax then
			if Var.IsInit[2] == false then
				Albi_Init(Var)
				Var.IsInit[2] = true
			end
			Var.CurrentPhase = HPSection.Second

		elseif maxhp * PhaseData[3].HPRateMin < hp * 1000 and hp * 1000 <= maxhp * PhaseData[3].HPRateMax then
			if Var.IsInit[3] == false then
				Albi_Init(Var)
				Var.IsInit[3] = true
			end
			Var.CurrentPhase = HPSection.Third
		end

		Var.StepFunc = Albi_Behaviour
		return ReturnAI.CPP
end


function Albi_Behaviour( Var )
		cExecCheck "Albi_Behaviour"

		Var.StepFunc = Albi_HPCheck

		local Handle 	= Var.Handle
		local MapIndex 	= Var.MapIndex

		-- 타겟 잃어버린 시간 검사
		local TargetHandle = cTargetHandle( Var.Handle )

		if TargetHandle ~= nil and cObjectType( TargetHandle ) == SHINEOBJECT then
			Var.TargetLostSec = cCurSec()
		elseif Var.TargetLostSec + 10 < cCurSec() then

			cResetAbstate( Var.Handle, "Sta_BH_Albi_Reflect" )
			cResetAbstate( Var.Handle, "Sta_BH_Albi_ACMRUp" )

			for i = 1, #(Var.MobList) do
				cNPCVanish( Var.MobList[i] )
			end

			MemBlock = {}
			WaitBoom = {}

			Init( Var, Handle, MapIndex )
		end


		-- 벗어난 단계 검사
		if Var.CurrentPhase < 1 or #PhaseData < Var.CurrentPhase then
			return ReturnAI.CPP
		end


		local Skill = PhaseData[Var.CurrentPhase]["Skill"]

		-- 알비레오 스킬 사용
		if Skill ~= nil then
			if Skill_Wait( Var ) == false and Var.IsUsedSkillAll == false then
				-- 스킬이면
				if Skill[Var.CurrentSkill]["Type"] == "Skill" then

					if TargetHandle ~= nil then
						cSkillBlast( Var.Handle, Var.Handle, Skill[Var.CurrentSkill]["Index"] )
					end

				elseif Skill[Var.CurrentSkill]["Type"] == "AbState" then

					local Range 	= Skill[Var.CurrentSkill]["Range"]
					local Index 	= Skill[Var.CurrentSkill]["Index"]
					local KeepTime	= Skill[Var.CurrentSkill]["KeepTime"]
					local Strength 	= 1

					if Skill[Var.CurrentSkill]["Target"] == "Other" then

						if TargetHandle ~= nil then
							cSetAbstate_Range( Var.Handle, Range, SHINEOBJECT, Index, Strength, KeepTime )
						end

					elseif Skill[Var.CurrentSkill]["Target"] == "Me" then

						if TargetHandle ~= nil then
							cSetAbstate( Var.Handle, Index, Strength, KeepTime )
						end
					end
				end

				Var.SkillWaitAfter = cCurSec() + Skill[Var.CurrentSkill]["WaitAfter"]

				Var.CurrentSkill = Var.CurrentSkill + 1

				if #Skill < Var.CurrentSkill then
					Var.IsUsedSkillAll = true
				end
			end
		end


		-- 아크 마인 소환
		local Summon 		= PhaseData[Var.CurrentPhase]["Summon"]
		local SummonInfo 	= PhaseData[Var.CurrentPhase]["SummonInfo"]

		for i = 1, #Var.SummonList do
			for j = 1, #(Var.SummonList[i]) do
				for k = 1, #(Var.SummonList[i][j]) do

					if Var.SummonList[i][j][k].IsActive == false then

						if i == Var.CurrentPhase then

							if SummonInfo[j] ~= nil and SummonInfo[j].IsAfterPrevSummon == true then

								if Var.SummonList[i][j - 1] and Var.SummonList[i][j - 1].IsOver == true then
									Var.SummonList[i][j][k].IsActive = true
									Var.SummonList[i][j].OverTime = cCurSec() + SummonInfo[j].OverTime
								end
							else
								Var.SummonList[i][j][k].IsActive = true
								Var.SummonList[i][j].OverTime = cCurSec() + (SummonInfo[j] and SummonInfo[j].OverTime or 0)
							end
						end

					elseif Var.SummonList[i][j][k].IsActive == true then

						if Var.SummonList[i][j][k].Interval < cCurSec() then

							local s = Summon and Summon[j] and Summon[j][k]
							if not s then
								return ReturnAI.CPP
							end

							local Index = s.Index
							local X = s.X
							local Y = s.Y
							local W = s.W
							local H = s.H
							local D = s.D
							local handle = cMobRegen_Rectangle( Var.MapIndex, Index, X, Y, W, H, D )

							
							if handle ~= nil then
								cAIScriptSet(handle, Var.Handle)
								cAIScriptFunc(handle, "MobAttack", "ArkMine_MobAttack")
							end

							Var.MobList[#(Var.MobList) + 1] = handle
							Var.SummonList[i][j][k].Interval = cCurSec() + Summon[j][k].Interval
						end


						local info = SummonInfo[j]
						if info ~= nil then

							if info.IsTimeOver == true then

								if Var.SummonList[i][j].OverTime <= cCurSec() then
									Var.SummonList[i][j][k].IsActive = false
									Var.SummonList[i][j].IsOver = true

									for n = 1, #(Var.SummonList[i][j]) do
										if Var.SummonList[i][j][n].IsActive == true then
											Var.SummonList[i][j].IsOver = false
										end
									end
								end

							elseif info.EndHPSection == Var.CurrentPhase then

								Var.SummonList[i][j][k].IsActive = false
								Var.SummonList[i][j].IsOver = true

								for n = 1, #(Var.SummonList[i][j]) do
									if Var.SummonList[i][j][n].IsActive == true then
										Var.SummonList[i][j].IsOver = false
									end
								end
							end
						end
					end
				end

				if 0 < (j - 1) then
					if Var.SummonList[i][j - 1].IsOver == true then
						Var.SummonList[i][j - 1].IsOver = false
					end
				end
			end
		end
	return ReturnAI.CPP
end


--------------------------------------------------------------------
-----------------------   ArkMine  Part   --------------------------
--------------------------------------------------------------------
ExplosionTime 	= 5
WaitBoom		= {}

function BHArkMine_Kn( Handle, MapIndex )
cExecCheck "BHArkMine_Kn"

	local Var = WaitBoom[Handle]

	if Var == nil then

		--cDebugLog( "BHArkMine_Kn Init")
		WaitBoom[Handle] 	= {}
		Var 				= WaitBoom[Handle]
		Var.Second			= cCurSec() + ExplosionTime

	end

	-- Mine이 Second 후 자폭

	if Var.Second ~= 0 then

		if Var.Second <= cCurSec() then

			--cDebugLog( "ATTACK~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			--cSkillBlast( Handle,  Handle, "BHArkMine_Kn_Skill01_W" )
			--cNPCSkillUse( Handle,  Handle, "BHArkMine_Kn_Skill01_W" )
			--cNPCVanish( Handle )
			--Var.Second = 0
			--ArkMine_MobAttack( Var.
		end

	end

	return ReturnAI.CPP
end


function BHArkMine_F( Handle, MapIndex )
cExecCheck "BHArkMine_F"
	return ReturnAI.CPP
end


function ArkMine_MobAttack( MapIndex, AtkHandle )
cExecCheck "BHArkMine_MobAttack"

	--local MobID = cGetMobID( AtkHandle )
	--if MobID == nil then
	--	return
	--end
	--for i = 1, #Var.MineIDList do
	--	if MobID ~= nil then
	--		if MobID == Var.MineIDList[i] then
	--		end
	--	end
	--end

	cNPCVanish( AtkHandle )
	--cSetObjectHP( 0 ) -- 자살

end


--------------------------------------------------------------------
-------------------------   Reward Part   --------------------------
--------------------------------------------------------------------
-- 보물상자 제어용 오브젝트
function Common_RemoveTreasure( MapIndex )
cExecCheck "Common_RemoveTreasure"

	for i = 1, #BH_AlbiBox
	do
		cVanishAll( MapIndex, BH_AlbiBox[i].ItemDropMobIndex )
		--cDebugLog( "remove" )
	end
end


function Invisible_Init(Var)
cExecCheck "Invisible_Init"
    cDebugLog "Invisible_Init"

	local x, y = cObjectLocate( Var.Handle )
	
    math.randomseed(os.time())
    local mobtable = {}
	for i = 1, AlbiBox_ChestsSpawns do
		local box = BH_AlbiBox[((i - 1) % #BH_AlbiBox) + 1]
		mobtable[i] = cMobRegen_Circle(
			Var["MapIndex"],
			box["Index"],
			x,
			y,
			box["Radius"]
		)
	end

    local randomnumbers = {}
    for i = 1, #BH_AlbiBox do
        local num = math.random(1, #mobtable)
        if randomnumbers[num] == nil then
            randomnumbers[num] = true
            cSetItemDropMobID( mobtable[num], BH_AlbiBox[i]["ItemDropMobIndex"] )
        else
            i = i - 1
        end
    end

    Var.Wait = {}
    Var.Wait.Second = cCurSec() + AlbiBox_VanishTime
    Var.StepFunc = Invisible_AllVanish
end


function InvisibleMan( Handle, MapIndex )
cExecCheck "InvisibleMan"

	local Var = MemBlock[Handle]
	if Var == nil then
		--cDebugLog("InvisibleMan Handle Error : " .. Handle)
		return
	end

	if Var.StepFunc ~= nil then
		Var.StepFunc( Var )
	end

	return ReturnAI.END
end


function Invisible_AllVanish( Var )
cExecCheck "Invisible_AllVanish"

	if cCurSec() > Var.Wait.Second then

		--cRegenGroupActiv( Var.MapIndex, "UniWpLv125", 0 )	-- 상자가 나오지 않도록(세번째 인수를 생략하거나 1이면 activ)

		cRegenGroupActiv("BH_Albireo", "BH_AlbiBox", 0) -- 상자가 나오지 않도록(세번째 인수를 생략하거나 1이면 activ)
		Common_RemoveTreasure(Var.MapIndex)
		cNPCVanish(Var.Handle)

		Var.StepFunc = nil
	end
end