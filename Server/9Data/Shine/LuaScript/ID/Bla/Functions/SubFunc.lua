--------------------------------------------------------------------------------
--                     		Sub Functions		                              --
--------------------------------------------------------------------------------
function DummyFunc( Var )
cExecCheck "DummyFunc"
end






--------------------------------------------------------------------------------
-- RandomRegenMobGroupSetFunc : 18개 영역에 리젠될 몹그룹을 랜덤으로 세팅
--------------------------------------------------------------------------------
function RandomRegenMobGroupSetFunc( Var )
cExecCheck "RandomRegenMobGroupSetFunc"


	if Var == nil
	then
		ErrorLog( "RandomRegenMobGroup::Var == nil" )
		return
	end


	if Var["AreaMobGroup"] == nil
	then
		ErrorLog( "RandomRegenMobGroup::Var[\"AreaMobGroup\"] == nil" )
		return
	end

	local AreaMobGroupList = {}

	for i = 1, #RegenInfo["Mob"]["AreaMobGroup"]
	do
		AreaMobGroupList[i] = RegenInfo["Mob"]["AreaMobGroup"][i]
	end

	local Max		= 18
	local Scope 	= Max

	for i = 1, Max
	do
		local Randomvalue 				= cRandomInt( 1, Scope )
		Var["AreaMobGroup"][i] 			= AreaMobGroupList[Randomvalue]

		AreaMobGroupList[Randomvalue] 	= AreaMobGroupList[Scope]
		AreaMobGroupList[Scope] 		= nil

		Scope = Scope - 1
	end

	DebugLog( "RandomRegenMobGroupSetFunc :: Var[\"AreaMobGroup\"] List is ..." )
	for i = 1, #Var["AreaMobGroup"]
	do
		DebugLog(" : "..Var["AreaMobGroup"][i] )
	end

	return

end






--------------------------------------------------------------------------------
-- KDFargelsSkill01
--------------------------------------------------------------------------------
function KDFargelsSkill01( Var, Handle, Skill, SkillInfo )
cExecCheck( "KDFargelsSkill01" )

	if Var == nil then

		return

	end

	if Handle == nil then

		return

	end

	if Skill == nil then

		return

	end

	if SkillInfo == nil then

		return

	end

	local Range			= SkillInfo["RANGE"]
	local AbstateData	= SkillInfo["ABSTATE"]
	local AbstateList	= Skill["AbstateList"]

	for i = 1, #AbstateList do

		local AbstateIndex	= AbstateData[i]["ABSTATE_INDEX"]
		local KeepTime 		= AbstateData[i]["KEEPTIME"]
		local PrepareTime	= AbstateData[i]["PREPARETIME"]
		local IntervalTime	= AbstateData[i]["INTERVALTIME"]

		local Abstate 		= AbstateList[i]

		if Abstate ~= nil then

			if Abstate["Enable"] == true then

				if Abstate["CheckPrepareTime"] <= Var["CurSec"] then

					if Abstate["CheckIntervalTime"] <= Var["CurSec"] then

						local RestTime = Abstate["CheckKeepTime"] - Var["CurSec"]

						cSetAbstate_Range( Handle, Range * 0.5 , ObjectType["Player"], AbstateIndex, 1, RestTime * 1000 )

						--cDebugLog( "KDFargelsSkill01 :: cSetAbstate_Range : " .. AbstateIndex )

						Abstate["CheckIntervalTime"] = Var["CurSec"] + IntervalTime

					end

				end

				if Abstate["CheckKeepTime"] <= Var["CurSec"] then

					local PlayerList = { cGetPlayerList( Var["MapIndex"] ) }

					for j = 1, #PlayerList do

						if PlayerList[j] ~= nil then

							cResetAbstate( PlayerList[j], AbstateIndex )

						end

					end

					AbstateList[i]["Enable"] = false

				end

			end

		end

	end

end





--------------------------------------------------------------------------------
-- KDFargelsSkill02
--------------------------------------------------------------------------------
function KDFargelsSkill02( Var, Handle, Skill, SkillInfo )
cExecCheck( "KDFargelsSkill02" )

	if Var == nil then

		return

	end

	if Handle == nil then

		return

	end

	if Skill == nil then

		return

	end

	if SkillInfo == nil then

		return

	end

	local Range			= SkillInfo["RANGE"]
	local AbstateData	= SkillInfo["ABSTATE"]
	local AbstateList	= Skill["AbstateList"]

	for i = 1, #AbstateList do

		local AbstateIndex	= AbstateData[i]["ABSTATE_INDEX"]
		local KeepTime 		= AbstateData[i]["KEEPTIME"]
		local PrepareTime	= AbstateData[i]["PREPARETIME"]
		local IntervalTime	= AbstateData[i]["INTERVALTIME"]

		local Abstate 		= AbstateList[i]

		if Abstate ~= nil then

			if Abstate["Enable"] == true then

				if Abstate["CheckPrepareTime"] <= Var["CurSec"] then

					if Abstate["CheckIntervalTime"] <= Var["CurSec"] then

						local RestTime = Abstate["CheckKeepTime"] - Var["CurSec"]

						cSetAbstate( Handle, AbstateIndex, 1, RestTime * 1000 )

						cDebugLog( "KDFargelsSkill01 :: cSetAbstate : " .. AbstateIndex )

						Abstate["CheckIntervalTime"] = Var["CurSec"] + IntervalTime

					end

				end

				if Abstate["CheckKeepTime"] <= Var["CurSec"] then

					cResetAbstate( Handle, AbstateIndex )

					AbstateList[i]["Enable"] = false

				end

			end

		end

	end

end


--------------------------------------------------------------------------------
-- KDFargelsSkill03
--------------------------------------------------------------------------------
function KDFargelsSkill03( Var, Handle, Skill, SkillInfo )
cExecCheck( "KDFargelsSkill03" )

	if Var == nil then

		return

	end

	if Handle == nil then

		return

	end

	if Skill == nil then

		return

	end

	if SkillInfo == nil then

		return

	end

	local SummonList	= Skill["Summon"]
	local SummonData	= SkillInfo["SUMMON_MOBDATA"]

	if SummonList["Enable"] == true then

		if SummonList["CheckTime"] <= Var["CurSec"] then

			for i = 1, #SummonData do

				local MobIdx  	= SummonData[i]["Index"]
				local RegenX	= SummonData[i]["x"]
				local RegenY	= SummonData[i]["y"]
				local Radius	= SummonData[i]["radius"]

				if cMobRegen_Circle( Var["MapIndex"], MobIdx, RegenX, RegenY, Radius ) == nil then
					--ErrorLog( "KDFargelsSkill03 :: MobRegen Fail. MobIdx = " .. MobIdx .. ",  i = " ..i )
				end

				DebugLog( "KDFargelsSkill03 :: MobRegen" .. i )

			end

			SummonList["Enable"] = false

		end

	end

end



--------------------------------------------------------------------------------
-- RootManagerFunc
--------------------------------------------------------------------------------
function RootManagerFunc( Var, RootName )
cExecCheck "RootManagerFunc"


	if Var == nil
	then
		ErrorLog( "RootManagerFunc:: Var == nil" )
		return
	end


	if Var["RootManager"] == nil
	then
		return
	end


	if Var["RootManager"]["DelayTime"][RootName] > Var["CurSec"]
	then
		return
	else
		Var["RootManager"]["DelayTime"][RootName] = Var["RootManager"]["DelayTime"][RootName] + DelayTime["RootManagerFuncTick"]
	end


	if RootName == nil
	then
		ErrorLog( "RootManagerFunc:: RootName == nil" )
		return
	end


	if RootInfo[RootName] == nil
	then
		ErrorLog( "RootManagerFunc:: Invalid RootName" )
		return
	end


	local CurStep 				= Var["RootManager"][RootName]


	if CurStep == 5
	then
		return
	end


	if CurStep <= 4
	then

		local CurCheckArea			= RootInfo[RootName][CurStep]["AreaName"]
		local CurOpenDoorName		= RootInfo[RootName][CurStep]["OpenDoor"]
		local CurOpenDoorHandle		= Var["Door"][CurOpenDoorName]

		if CurOpenDoorHandle == nil
		then
			ErrorLog( "RootManagerFunc:: Var[\"Door\"][CurOpenDoorName] == nil" )
			return
		end

		local CurOpenDoorInfo			= Var["Door"][CurOpenDoorHandle]["Info"]
		if CurOpenDoorInfo == nil
		then
			ErrorLog( "RootManagerFunc:: Var[\"Door\"][CurOpenDoorHandle][\"Info\"] == nil" )
			return
		end

		local CurRegenMobGroupInfo		= DoorMobRegenInfo[CurOpenDoorName]


		local bIsMobInArea 				= cIsMobTypeInArea( Var["MapIndex"], CurCheckArea, ObjectType["Mob"] )

		if bIsMobInArea == 1
		then
			return
		end

		DebugLog( "RootManagerFunc:: Root : "..RootName..", clear Area : ".. CurCheckArea )

		if cDoorAction( CurOpenDoorHandle, CurOpenDoorInfo["Block"], "open" ) == nil
		then
			ErrorLog( "RootManagerFunc:: Root : "..RootName..", Door Open Fail" ..CurOpenDoorName )
			--return
		end

		for i = 1, #CurRegenMobGroupInfo
		do
			local CurMobGroupNum 	= CurRegenMobGroupInfo[i]["MobGroupNum"]
			local CurMobGroupIdx 	= Var["AreaMobGroup"][CurMobGroupNum]
			local CurMobGroupX		= CurRegenMobGroupInfo[i]["x"]
			local CurMobGroupY		= CurRegenMobGroupInfo[i]["y"]

			--[[
			DebugLog( "   몹 리젠 : "..CurMobGroupNum )
			DebugLog( "CurMobGroupNum ".. CurMobGroupNum )
			DebugLog( "CurMobGroupIdx ".. CurMobGroupIdx )
			DebugLog( "CurMobGroupX ".. CurMobGroupX )
			DebugLog( "CurMobGroupY ".. CurMobGroupY )
			--]]

			if cGroupRegenInstance_XY( Var["MapIndex"], CurMobGroupIdx, CurMobGroupX, CurMobGroupY ) == nil
			then
				ErrorLog( "RootManagerFunc:: Root : "..RootName..", MobGroup Regen Fail"..MobGroupIdx )
			end

		end

		Var["RootManager"][RootName] 		= Var["RootManager"][RootName] + 1
		DebugLog( "RootManagerFunc :: Root : "..RootName.."다음 단계로 이동 .. ".. Var["RootManager"][RootName] )

	end

	return

end






--------------------------------------------------------------------------------
-- TeleportFunc
--------------------------------------------------------------------------------
function TeleportFunc( Var )
cExecCheck "TeleportFunc"

	if Var == nil
	then
		ErrorLog( "RootManagerFunc:: Var == nil" )
		return
	end

	if Var["TimeList"] == nil
	then
		return
	end

	if Var["TimeList"]["FaceCutArea"] == nil
	then
		return
	end


	if Var["TimeList"]["FaceCutArea"]["PlayerEntrance"] == nil
	then
		return
	end


	if Var["TimeList"]["FaceCutArea"]["PlayerEntrance"] > Var["CurSec"]
	then
		return
	else
		Var["TimeList"]["FaceCutArea"]["PlayerEntrance"]	= Var["TimeList"]["FaceCutArea"]["PlayerEntrance"] + DelayTime["TeleportFuncTick"]
	end


	local TeleportInfo = AreaInfo["Zone5_Teleport"]

	for i = 1, #TeleportInfo
	do
		local CurAreaName 		= TeleportInfo[i]["AreaName"]
		local CurLinkX			= TeleportInfo[i]["LinkX"]
		local CurLinkY			= TeleportInfo[i]["LinkY"]

		local CurPlayerList 	= { cGetAreaObjectList( Var["MapIndex"], CurAreaName, ObjectType["Player"] ) }

		if CurPlayerList ~= nil
		then

			if #CurPlayerList >= 1
			then


				for i = 1, #CurPlayerList
				do
					DebugLog( "TeleportFunc :: 캐릭터 이동 : " ..CurPlayerList[i] )
					if cLinkTo( CurPlayerList[i], Var["MapIndex"], CurLinkX, CurLinkY ) == nil
					then
						ErrorLog( "TeleportFunc :: Link Fail.."..CurPlayerList[i] )
					end
				end


				-- 링크하는 첫 유저일 경우,
				if Var["TimeList"]["TeleportArea"] == nil
				then

					Var["TimeList"]["TeleportArea"] = {}

					Var["TimeList"]["TeleportArea"]["PlayerEntrance"]	= Var["CurSec"]
					Var["TimeList"]["TeleportArea"]["Dialog_Blakan"]	= Var["CurSec"] + Blakan_Data_Info["WaitBlakanDialog"]
					Var["TimeList"]["TeleportArea"]["Dialog_Fagels"]	= Var["CurSec"] + Blakan_Data_Info["WaitFagelsDialog"]
					Var["TimeList"]["TeleportArea"]["SummonStart"]		= Var["CurSec"] + Blakan_Data_Info["WaitFirstSummon"]


					DebugLog( "TeleportFunc :: 첫 유저 진입시간 : "		..Var["TimeList"]["TeleportArea"]["PlayerEntrance"] )
					DebugLog( "TeleportFunc :: 블라칸 대사할 시간 : "	..Var["TimeList"]["TeleportArea"]["Dialog_Blakan"] )
					DebugLog( "TeleportFunc :: 파겔스 대사할 시간 : "	..Var["TimeList"]["TeleportArea"]["Dialog_Fagels"] )
					DebugLog( "TeleportFunc :: 몹소환시작시간 : "		..Var["TimeList"]["TeleportArea"]["SummonStart"] )

				end

			end

		end
	end

	return

end






--------------------------------------------------------------------------------
-- DebugLog
--------------------------------------------------------------------------------
function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	--cAssertLog( "Debug - "..String )

end

--------------------------------------------------------------------------------
-- ErrorLog
--------------------------------------------------------------------------------
function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end

