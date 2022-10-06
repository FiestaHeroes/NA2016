--------------------------------------------------------------------------------
--                       		Routine		                                  --
--------------------------------------------------------------------------------
function DummyRoutineFunc( )
cExecCheck "DummyRoutineFunc"
end






--------------------------------------------------------------------------------
-- PlayerMapLogin : 원본
--------------------------------------------------------------------------------
function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	-- 첫 플레이어의 맵 로그인 체크
	Var["bPlayerMapLogin"] = true

end






--------------------------------------------------------------------------------
-- Routine_Blakan : 블라칸 루틴 함수
--------------------------------------------------------------------------------
function Routine_Blakan( Handle, MapIndex )
cExecCheck "Routine_Blakan"

	if Handle == nil
	then
		ErrorLog( "Routine_Blakan::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "Routine_Blakan::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Routine_Blakan::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["Routine_Blakan"] == nil
	then
		Var["Routine_Blakan"] = {}
	end


	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"]["Routine_Blakan"] <= cCurrentSecond()
	then
		Var["RoutineTime"]["Routine_Blakan"] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 죽었는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		--EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	-- 봉인석 다 부셨을 경우
	if Var["Enemy"]["Seal"]["SealNum"] == 0
	then
		return ReturnAI["END"]
	end


	local Blakan_CurHP, BlakanMaxHP 	= cObjectHP( Handle )
	local CurHPRate						= Blakan_CurHP/BlakanMaxHP * 100
	local Blakan_HP50Info 				= Blakan_Data_Info["HP50"]


	-- 첫 HP 50% 이하시, 테이블 생성 및 소환시간 설정
	if CurHPRate < 50
	then

		if Var["Routine_Blakan"]["SummonTonado"] == nil
		then
			Var["Routine_Blakan"]["SummonTonado"] 				= {}
			Var["Routine_Blakan"]["SummonTonado"]["SummonTime"]	= Var["CurSec"]
		end

		-- 지속적으로 소환시간 체크
		if Var["Routine_Blakan"]["SummonTonado"]["SummonTime"] ~= nil
		then

			if Var["Routine_Blakan"]["SummonTonado"]["SummonTime"] > Var["CurSec"]
			then
				return
			else
				Var["Routine_Blakan"]["SummonTonado"]["SummonTime"] = Var["Routine_Blakan"]["SummonTonado"]["SummonTime"] + Blakan_HP50Info["SummonTick"]
				DebugLog( "Routine_Blakan :: SummonTonado" )

				for i = 1, #Blakan_HP50Info["Mob"]
				do
					local CurMobIdx 		= Blakan_HP50Info["Mob"][i]["Index"]
					local CurMobRegenX 		= Blakan_HP50Info["Mob"][i]["x"]
					local CurMobRegenY 		= Blakan_HP50Info["Mob"][i]["y"]

					local CurTornadoHandle = cMobRegen_XY( Var["MapIndex"], CurMobIdx, CurMobRegenX, CurMobRegenY )
					if CurTornadoHandle == nil
					then
						ErrorLog( "Routine_Blakan :: Tornado Regen Fail.." )
					end
				end
			end

		end

	end

	return ReturnAI["CPP"]
end






--------------------------------------------------------------------------------
-- Routine_Fagels : 파겔스 루틴 함수
--------------------------------------------------------------------------------
function Routine_Fagels( Handle, MapIndex )
cExecCheck "Routine_Fagels"

	if Handle == nil
	then
		ErrorLog( "Routine_Fagels::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "Routine_Fagels::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Routine_Fagels::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	if Var["Enemy"]["Fagels"] == nil
	then
		ErrorLog( "Routine_Fagels::Var[\"Enemy\"][\"Fagels\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]


	end

	if Var["Enemy"]["Fagels"]["Handle"] == nil
	then
		ErrorLog( "Routine_Fagels::Var[\"Enemy\"][\"Fagels\"][\"Handle\"] == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end



	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"]["Routine_Fagels"] <= cCurrentSecond()
	then
		Var["RoutineTime"]["Routine_Fagels"] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end


	-- 죽었는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		--EnemyBufferClear( Var, Handle )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	local HP, MaxHP = cObjectHP( Handle )

	if MaxHP == 0 then

		return ReturnAI["END"]

	end

	local HPRate = HP / MaxHP * 100


	local Fargels = Var["Enemy"]["Fagels"]

	-- Fargels Skill
	for i = 1, #FARGELS_SKILL do

		local SkillIndex 	= FARGELS_SKILL[i]["SKILL_INDEX"]
		local MinHPRate 	= FARGELS_SKILL[i]["MINHPRATE"]
		local MaxHPRate		= FARGELS_SKILL[i]["MAXHPRATE"]
		local Delay			= FARGELS_SKILL[i]["DELAY"]
		local Range			= FARGELS_SKILL[i]["RANGE"]
		local AbstateData	= FARGELS_SKILL[i]["ABSTATE"]
		local Func			= FARGELS_SKILL[i]["FUNC"]

		-- skill
		if MinHPRate < HPRate and HPRate <= MaxHPRate then

			if Fargels["SkillList"][i]["CheckTime"] <= Var["CurSec"]
			then

				local ClassList 	= { 1, 6, 11, 16, 21, 26 }
				local PlayerHandle 	= cFindNearPlayer( Handle, Range, ClassList )

				if PlayerHandle ~= nil and SkillIndex ~= nil then

					cSkillBlast( Handle, PlayerHandle, SkillIndex )

				end

				-- abstate
				local AbstateList = Fargels["SkillList"][i]["AbstateList"]

				for j = 1, #AbstateList do

					local KeepTime		= AbstateData[j]["KEEPTIME"]
					local PrepareTime	= AbstateData[j]["PREPARETIME"]

					AbstateList[j]["CheckKeepTime"]		= Var["CurSec"] + KeepTime
					AbstateList[j]["CheckPrepareTime"]	= Var["CurSec"] + PrepareTime
					AbstateList[j]["Enable"]			= true

				end

				-- Summon
				local SummonList 		= Fargels["SkillList"][i]["Summon"]

				if SummonList ~= nil
				then
					SummonList["CheckTime"]	= Var["CurSec"]
					SummonList["Enable"]	= true
				end

				if SkillIndex ~= nil
				then
					cDebugLog( "cSkillBlast : " .. SkillIndex )
				end


				Fargels["SkillList"][i]["CheckTime"] = Var["CurSec"] + Delay

			end

		end

		if Func ~= nil then

			Func( Var, Handle, Fargels["SkillList"][i], FARGELS_SKILL[i] )

		end

	end

	return ReturnAI["CPP"]

end






--------------------------------------------------------------------------------
-- Routine_Seal : 봉인석에 붙을 루틴
--------------------------------------------------------------------------------
function Routine_Seal( Handle, MapIndex )
cExecCheck "Routine_Seal"

	if Handle == nil
	then
		ErrorLog( "Routine_Seal::Handle == nil" )
		return ReturnAI["END"]
	end

	if MapIndex == nil
	then
		ErrorLog( "Routine_Seal::MapIndex == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		ErrorLog( "Routine_Seal::Var == nil" )
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if Var["RoutineTime"]["Routine_Seal"][Handle] == nil
	then
		ErrorLog( "Var[\"RoutineTime\"][\"Routine_Seal\"][Handle] == nil" .. Handle)
		return ReturnAI["END"]
	end

	-- 0.2초마다 체크하는 루틴
	if Var["RoutineTime"]["Routine_Seal"][Handle] <= cCurrentSecond()
	then
		Var["RoutineTime"]["Routine_Seal"][Handle] = cCurrentSecond() + 0.2
	else
		return ReturnAI["CPP"]
	end

	if cIsObjectDead( Var["Enemy"]["Blakan"] ) ~= nil
	then
		DebugLog( "Routine_Seal :: 블라칸 죽어서 봉인석 루틴 제거" )

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end


	if cIsObjectDead( Handle ) ~= nil
	then

		local AtkUp_Idx			= AbStateInfo["BlakanAtkUp"]["Index"]
		local AtkUp_Strength	= AbStateInfo["BlakanAtkUp"]["Strength"]
		local AtkUp_KeepTime	= AbStateInfo["BlakanAtkUp"]["KeepTime"]


		if cSetAbstate( Var["Enemy"]["Blakan"], AtkUp_Idx, AtkUp_Strength, AtkUp_KeepTime, Handle ) == nil
		then
			ErrorLog("Routine_Seal :: Fail Set Abstate To Blakan")
		end

		cScriptMessage( Var["MapIndex"], ChatInfo["Seal_Broken"][1] )
		Var["Enemy"]["Seal"]["SealNum"] = Var["Enemy"]["Seal"]["SealNum"] - 1

		cAIScriptSet( Handle )
		cNPCVanish( Handle )

		return ReturnAI["END"]
	end

	return ReturnAI["CPP"]

end






--------------------------------------------------------------------------------
-- Click_ExitGate
--------------------------------------------------------------------------------
function Click_ExitGate( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "ExitGateClick"

	DebugLog( "ExitGateClick::Start" )

	if NPCHandle == nil
	then
		ErrorLog( "ExitGateClick::NPCHandle == nil" )
		return
	end

	if PlyHandle == nil
	then
		ErrorLog( "ExitGateClick::PlyHandle == nil" )
		return
	end


	cLinkTo( PlyHandle, LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["x"], LinkInfo["ReturnMap"]["y"] )

	DebugLog( "ExitGateClick::End" )
end
