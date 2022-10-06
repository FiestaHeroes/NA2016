--[[*****																*****]]--
--[[*****							몹 처리 루틴 메인					*****]]--
--[[*****		: 소환되어 제어가 필요없는 몹을 제외한 몹들을 처리		*****]]--
--[[*****																*****]]--
function MobRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["WaveRunner"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["WaveRunner"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		-- 추가 개선 6. 몬스터가 목책에 부딪힐 때, 죽는 애니메이션 처리
		-- cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["WaveRunner"][Handle] = nil
		return ReturnAI["END"]
	end


	BoomMobProcess    ( Var ) -- 자폭몹 처리
	SummonGroupProcess( Var ) -- 소환몹 존재하는경우 처리
	EscortGroupProcess( Var ) -- 호위몹 존재하는경우 처리
	EscortMobProcess  ( Var ) -- 호위몹 이동 처리
	PathTypeProcess   ( Var ) -- 경로가 존재하는경우 처리


	-- 폭탄 타입의 이동 처리를 기존 AI 사용
	local rtn = ReturnAI["END"]

	if Var["BoomTarget"] ~= nil then
		rtn = ReturnAI["CPP"]
	end

	return rtn

end




-- 이동 상태값 flag
MOVESTATE = {}
MOVESTATE["STOP"] = "STOP"
MOVESTATE["MOVE"] = "MOVE"




--[[																				]]--
--[[						BoomType에 따라 폭탄 처리								]]--
--[[																				]]--
function BoomMobProcess( Var )

	if Var == nil then
		return
	end

	if Var["BoomType"] == nil then
		return
	end


	if Var["BoomProgress"] == nil then

		local BoomProgress = {}

		BoomProgress["PlayerCheckTime"] = cCurrentSecond()

		Var["BoomProgress"] = BoomProgress

	end


	local CurSec = cCurrentSecond()

	-- 플레이어 검색 줄이기 위해 1초에 한번 체크
	if Var["BoomProgress"]["PlayerCheckTime"] + BOOMTYPE_CHK_DLY > CurSec then
		return
	end

	Var["BoomProgress"]["PlayerCheckTime"] = CurSec


	-- 타겟이 설정 됐는지 체크
	if Var["BoomTarget"] ~= nil then

		-- 타겟이 사라진 경우 타겟 제거
		if cIsObjectDead( Var["BoomTarget"] ) then

			cAggroReset( Var["Handle"], Var["BoomTarget"] )
			Var["BoomTarget"] = nil

			return

		end


		local dist = cDistanceSquar( Var["Handle"], Var["BoomTarget"] )

		-- 거리가 멀어진 경우 타겟 제거
		if dist > Var["BoomType"]["FollowInterval"] * Var["BoomType"]["FollowInterval"] then

			cAggroReset( Var["Handle"], Var["BoomTarget"] )
			Var["BoomTarget"] = nil

			return

		end

		-- 거리 체크 해서 상태이상 걸어줌
		if dist <= (Var["BoomType"]["ExplosionGap"] * Var["BoomType"]["ExplosionGap"])  then

			if AbstateTypeTable[Var["BoomType"]["AbstateType"]] ~= nil then

				cSetAbstate( Var["BoomTarget"],
								AbstateTypeTable[Var["BoomType"]["AbstateType"]]["Index"],
								1,
								AbstateTypeTable[Var["BoomType"]["AbstateType"]]["KeepTime"],
								Var["Handle"] )

			end

			InstanceField[Var["MapIndex"]]["WaveRunner"][Var["Handle"]] = nil

			-- 추가 개선 6. 몬스터가 목책에 부딪힐 때, 죽는 애니메이션 처리
			cAIScriptSet( Var["Handle"] )
			cNPCVanish( Var["Handle"] )

			-- 이 이후 처리 무시하기 위해 nil로 초기화
			Var = nil

			return

		end

	end


	-- 타겟을 찾음
	local Target = cFindNearPlayer(	Var["Handle"],
									Var["BoomType"]["FollowInterval"],
									FollowTypeTable[Var["BoomType"]["FollowType"]] )

	if Target ~= nil then

		Var["BoomTarget"] = Target

		cAggroSet( Var["Handle"], Var["BoomTarget"], BOOM_AP )

		local speed
		local speedrate

		speed     = Var["MobSettingType"]["Speed"]
		speedrate = ( Var["BoomType"]["FollowSpeedRate"] / 1000 ) +
					( InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"] / 1000 )

		cSetNPCParam( Var["Handle"], "RunSpeed", speed * speedrate )

	end

end


--[[																				]]--
--[[						SummonType에 따라 몹 소환 처리							]]--
--[[																				]]--
function SummonGroupProcess( Var )

	if Var == nil then
		return
	end

	if Var["SummonType"] == nil then
		return
	end


	if Var["SummonProgress"] == nil then

		local SummonProgress = {}

		SummonProgress["LastSummonTime"]  = cCurrentSecond()
		SummonProgress["PlayerCheckTime"] = cCurrentSecond()

		Var["SummonProgress"] = SummonProgress

	end


	local CurSec = cCurrentSecond()

	-- 소환시간 체크
	if Var["SummonProgress"]["LastSummonTime"] + Var["SummonType"]["CoolTime"] > CurSec then
		return
	end

	-- 플레이어 검색 줄이기 위해 1초에 한번 체크
	if Var["SummonProgress"]["PlayerCheckTime"] + SUMMTYPE_CHK_DLY > CurSec then
		return
	end

	Var["SummonProgress"]["PlayerCheckTime"] = CurSec

	-- 주변 플레이어 체크
	if cFindNearPlayer( Var["Handle"], Var["SummonType"]["CheckRange"], FollowTypeTable["All"] ) == nil then
		return
	end



	local CurSummonGroupType = SummonGroupTypeTable[Var["SummonType"]["SummonGroupType"]]

	for i=1, #CurSummonGroupType do

		local CurSummonMobType  = SummonMobTypeTable[CurSummonGroupType[i]["SummonMobType"]]
		local CurMobSettingData = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
		local RegenCoord        = {}
		local Dir               = CurSummonGroupType[i]["Dir"]

		if CurSummonGroupType[i]["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Handle"] )

		end

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["Handle"], Dir, CurSummonGroupType[i]["Dist"] )

		-- 소환몹 리젠 및 셋팅
		local RegenMob = {}
		RegenMob["Handle"]      = cMobRegen_XY( Var["MapIndex"],
													CurMobSettingData["Index"],
													RegenCoord["x"],
													RegenCoord["y"], 0 )
		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]       = Var["MapIndex"]

			RegenMob["MobSettingType"] = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
			RegenMob["BoomType"]       = BoomTypeTable      [CurSummonMobType["BoomType"]      ]



			local DamageRate = (InstanceField[Var["MapIndex"]]["Balance"]["DamageRate"] + InstanceField[Var["MapIndex"]]["FenceBalance"]["DamageRate"]) / 2000
			local HPRate     = (InstanceField[Var["MapIndex"]]["Balance"]["HPRate"]     + InstanceField[Var["MapIndex"]]["FenceBalance"]["HPRate"])     / 2000
			local SpeedRate  = (InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"]  + InstanceField[Var["MapIndex"]]["FenceBalance"]["SpeedRate"])  / 2000

			RegenMob["Damage"]         = CurMobSettingData["Demage"]                   * DamageRate

			cSetNPCParam( RegenMob["Handle"], "MaxHP",    CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "HP",       CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "RunSpeed", CurMobSettingData["Speed"]   * SpeedRate )
			cSetNPCParam( RegenMob["Handle"], "HPRegen",  CurMobSettingData["HPRegen"] )
			cSetNPCParam( RegenMob["Handle"], "AC",       CurMobSettingData["AC"]      )
			cSetNPCParam( RegenMob["Handle"], "MR",       CurMobSettingData["MR"]      )
			cSetNPCParam( RegenMob["Handle"], "MobEXP",   CurMobSettingData["Exp"]     )
			cSetNPCResist( RegenMob["Handle"],            ResistTypeTable[CurSummonMobType["ResistType"]] )
			cSetNPCIsItemDrop( RegenMob["Handle"],        CurMobSettingData["ItemDrop"] )

			-- 리젠시 걸리는 무적 상태이상 풀어줌
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )

			-- 소환된몹 폭탄타입 일 경우 정보 저장
			if RegenMob["BoomType"] ~= nil then

				cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
				cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

				InstanceField[Var["MapIndex"]]["WaveRunner"][RegenMob["Handle"]] = RegenMob

			end

		end

	end

	-- 소환시간 갱신
	Var["SummonProgress"]["LastSummonTime"] = CurSec

end



--[[																				]]--
--[[						EscortGroupType에 따라 몹 소환 처리						]]--
--[[																				]]--
function EscortGroupProcess( Var )

	if Var == nil then
		return
	end

	if Var["EscortGroupType"] == nil then
		return
	end



	for i=1, #Var["EscortGroupType"] do

		local CurSummonMobType  = SummonMobTypeTable[Var["EscortGroupType"][i]["SummonMobType"]]
		local CurMobSettingData = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
		local RegenCoord        = {}
		local Dir               = Var["EscortGroupType"][i]["Dir"]

		if Var["EscortGroupType"][i]["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Handle"] )

		end

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["Handle"], Dir, Var["EscortGroupType"][i]["Dist"] )

		-- 호위몹 리젠 및 셋팅
		local RegenMob = {}
		RegenMob["Handle"]      = cMobRegen_XY( Var["MapIndex"],
													CurMobSettingData["Index"],
													RegenCoord["x"],
													RegenCoord["y"], 0 )
		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]    = Var["MapIndex"]

			RegenMob["MobSettingType"] = MobSettingTypeTable[CurSummonMobType["MobSettingType"]]
			RegenMob["BoomType"]       = BoomTypeTable      [CurSummonMobType["BoomType"]      ]
			-- 호위몹 처리 관련정보
			RegenMob["Master"]         = Var["Handle"]
			RegenMob["Rotate"]         = Var["EscortGroupType"][i]["Rotate"]
			RegenMob["Dir"]            = Var["EscortGroupType"][i]["Dir"]
			RegenMob["Dist"]           = Var["EscortGroupType"][i]["Dist"]


			local DamageRate = (InstanceField[Var["MapIndex"]]["Balance"]["DamageRate"] + InstanceField[Var["MapIndex"]]["FenceBalance"]["DamageRate"]) / 2000
			local HPRate     = (InstanceField[Var["MapIndex"]]["Balance"]["HPRate"]     + InstanceField[Var["MapIndex"]]["FenceBalance"]["HPRate"])     / 2000
			local SpeedRate  = (InstanceField[Var["MapIndex"]]["Balance"]["SpeedRate"]  + InstanceField[Var["MapIndex"]]["FenceBalance"]["SpeedRate"])  / 2000

			RegenMob["Damage"]         = CurMobSettingData["Demage"]                   * DamageRate

			cSetNPCParam( RegenMob["Handle"], "MaxHP",    CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "HP",       CurMobSettingData["HP"]      * HPRate )
			cSetNPCParam( RegenMob["Handle"], "RunSpeed", CurMobSettingData["Speed"]   * SpeedRate )
			cSetNPCParam( RegenMob["Handle"], "HPRegen",  CurMobSettingData["HPRegen"] )
			cSetNPCParam( RegenMob["Handle"], "AC",       CurMobSettingData["AC"]      )
			cSetNPCParam( RegenMob["Handle"], "MR",       CurMobSettingData["MR"]      )
			cSetNPCParam( RegenMob["Handle"], "MobEXP",   CurMobSettingData["Exp"]     )
			cSetNPCResist( RegenMob["Handle"],            ResistTypeTable[CurSummonMobType["ResistType"]] )
			cSetNPCIsItemDrop( RegenMob["Handle"],        CurMobSettingData["ItemDrop"] )

			-- 리젠시 걸리는 무적 상태이상 풀어줌
			cResetAbstate( RegenMob["Handle"], ABSTATE_IMT_IDX )


			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "MobRoutine" )

			-- 소환된몹 정보 저장
			InstanceField[Var["MapIndex"]]["WaveRunner"][RegenMob["Handle"]] = RegenMob

		end

	end

	Var["EscortGroupType"] = nil

end



--[[																				]]--
--[[						EscortGroupProcess에서 소환된 몹 처리					]]--
--[[																				]]--
function EscortMobProcess( Var )

	if Var == nil then
		return
	end

	if Var["Master"] == nil then
		return
	end

	-- 폭탄 타입인경우 타겟이 설정되면 이동처리 무시
	if Var["BoomType"] ~= nil then
		if Var["BoomTarget"] ~= nil then
			return
		end
	end


	-- 마스터가 죽었을 경우 처리
	if cIsObjectDead( Var["Master"] ) then

		if Var["BoomType"] ~= nil then

			local ply = cFindNearPlayer( Var["Handle"], Var["BoomType"]["ExplosionGap"], FollowTypeTable["All"] )

			if ply ~= nil then

				local AbstateTypeData = AbstateTypeTable[Var["BoomType"]["AbstateType"]]

				cSetAbstate( ply, AbstateTypeData["Index"], 1, AbstateTypeData["KeepTime"], Var["Handle"] )

			end

		end

		InstanceField[Var["MapIndex"]]["WaveRunner"][Var["Handle"]] = nil

		-- 추가 개선 6. 몬스터가 목책에 부딪힐 때, 죽는 애니메이션 처리
		cAIScriptSet( Var["Handle"] )
		cNPCVanish( Var["Handle"] )


		return

	end


	if Var["EscortProgress"] == nil then

		local EscortProgress = {}

		EscortProgress["CurGoalX"]      = ESCORT_H_G_INIT
		EscortProgress["CurGoalY"]      = ESCORT_H_G_INIT
		EscortProgress["LastCheckTime"] = cCurrentSecond()
		EscortProgress["CurMoveState"]  = MOVESTATE["STOP"]

		Var["EscortProgress"] = EscortProgress

	end



	if Var["EscortProgress"]["CurMoveState"] == MOVESTATE["STOP"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- 움직일 수 없는 상태
			return
		end

		Var["EscortProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	else

		if cWillMovement( Var["Handle"] ) == nil then	-- 움직일 수 없는 상태

			Var["EscortProgress"]["CurGoalX"]     = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurGoalX"]     = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurMoveState"] = MOVESTATE["STOP"]

			return

		end

	end



	local CurSec = cCurrentSecond()

	if Var["EscortProgress"]["LastCheckTime"] + ESCOTYPE_CHK_DLY <= CurSec then

		Var["EscortProgress"]["LastCheckTime"] = CurSec


		local CurAroundCoord = {}
		local CurMasterCoord = {}
		local CurMasterGoal  = {}

		local CalcTempCoord  = {}
		local CalcTempDist   = 0

		local Dir            = Var["Dir"]

		if Var["Rotate"] == true then

			Dir = Dir + cGetDirect( Var["Master"] )

		end



		CurAroundCoord["x"], CurAroundCoord["y"] = cGetAroundCoord( Var["Master"], Dir, Var["Dist"] )


		-- 현재 몹이 이동하고 있어야할 좌표와 많이 차이 날 경우 처리
		CalcTempCoord["x"], CalcTempCoord["y"] = cObjectLocate( Var["Handle"] )

		CalcTempDist = cDistanceSquar( CalcTempCoord["x"], CalcTempCoord["y"], CurAroundCoord["x"], CurAroundCoord["y"] )


		if CalcTempDist >= ESCORT_H_GAP then

			cRunTo( Var["Handle"], CurAroundCoord["x"], CurAroundCoord["y"], ESCORT_H_S_RATE )

			Var["EscortProgress"]["CurGoalX"] = ESCORT_H_G_INIT
			Var["EscortProgress"]["CurGoalY"] = ESCORT_H_G_INIT

			return

		end



		CurMasterCoord["x"], CurMasterCoord["y"] = cObjectLocate( Var["Master"] )
		 CurMasterGoal["x"],  CurMasterGoal["y"] = cMove2Where( Var["Master"] )


		-- 일반적인 경우 이동 처리
		CalcTempCoord["x"] = CurMasterGoal["x"] - CurMasterCoord["x"]
		CalcTempCoord["y"] = CurMasterGoal["y"] - CurMasterCoord["y"]

		CalcTempCoord["x"] = CalcTempCoord["x"] + CurAroundCoord["x"]
		CalcTempCoord["y"] = CalcTempCoord["y"] + CurAroundCoord["y"]

		CalcTempDist = cDistanceSquar( CalcTempCoord["x"], CalcTempCoord["y"], Var["EscortProgress"]["CurGoalX"], Var["EscortProgress"]["CurGoalY"] )

		if CalcTempDist >= ESCORT_M_GAP then

			Var["EscortProgress"]["CurGoalX"] = CalcTempCoord["x"]
			Var["EscortProgress"]["CurGoalY"] = CalcTempCoord["y"]

			cRunTo( Var["Handle"], CalcTempCoord["x"], CalcTempCoord["y"], 1000 )

		end

	end

end



--[[																				]]--
--[[							PathType에 따라 몹 이동 처리						]]--
--[[																				]]--
function PathTypeProcess( Var )

	if Var == nil then
		return
	end

	if Var["PathType"] == nil then
		return
	end

	-- 폭탄 타입인경우 타겟이 설정되면 이동처리 무시
	if Var["BoomType"] ~= nil then
		if Var["BoomTarget"] ~= nil then
			return
		end
	end


	if Var["PathProgress"] == nil then

		local PathProgress = {}

		PathProgress["GoalCheckTime"] = cCurrentSecond()
		PathProgress["CurPathStep"]   = 1
		PathProgress["CurMoveState"]  = MOVESTATE["STOP"]


		Var["PathProgress"] = PathProgress

	end



	if Var["PathProgress"]["CurPathStep"] > #Var["PathType"] then

		-- 목적지까지 완주한경우 정보 클리어 시킨다
		Var["PathType"]		= nil
		Var["PathProgress"]	= nil

		return

	end



	if Var["PathProgress"]["CurMoveState"] == MOVESTATE["STOP"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- 움직일 수 없는 상태
			return
		end

		-- 이동속도 천분률은 필요하면 변경
		cRunTo( Var["Handle"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"],
				1000 )
		Var["PathProgress"]["CurMoveState"] = MOVESTATE["MOVE"]

	end


	if Var["PathProgress"]["CurMoveState"] == MOVESTATE["MOVE"] then

		if cWillMovement( Var["Handle"] ) == nil then	-- 움직일 수 없는 상태

			Var["PathProgress"]["CurMoveState"] = MOVESTATE["STOP"]

			return

		end

	end


	-- 목표점 체크 제한
	local CurSec = cCurrentSecond()

	if Var["PathProgress"]["GoalCheckTime"] + PATHTYPE_CHK_DLY > CurSec then
		return
	end

	Var["PathProgress"]["GoalCheckTime"] = CurSec



	-- 목표점 체크
	local curr = {}
	local goal = {}

	curr["x"], curr["y"] = cObjectLocate( Var["Handle"] )
	goal["x"]            = Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"]
			   goal["y"] = Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"]



	local dx = goal["x"] - curr["x"]
	local dy = goal["y"] - curr["y"]
	local distsquar = dx * dx + dy * dy

	if distsquar < PATHTYPE_GAP then

		Var["PathProgress"]["CurPathStep"]	= Var["PathProgress"]["CurPathStep"] + 1
		Var["PathProgress"]["CurMoveState"]	= MOVESTATE["STOP"]

		return

	end


	-- 몹이 이동 멈추는 현상 때문에 목적지 체크
	curr["x"], curr["y"] = cMove2Where( Var["Handle"] )

	if curr["x"] ~= goal["x"] and curr["y"] ~= goal["y"] then

		cRunTo( Var["Handle"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["x"],
				Var["PathType"][Var["PathProgress"]["CurPathStep"]]["y"],
				1000 )

	end


	return

end



--[[*****																*****]]--
--[[*****						게이트 처리 루틴 메인					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
GateMapIndex = {} -- 엔피씨클릭시에 맵인덱스를 받지 않아 리젠시에 맵인덱스를 저장

function GateRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["GateList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["GateList"][Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["GateList"][Handle] = nil
		GateMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if GateMapIndex[Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		InstanceField[MapIndex]["GateList"][Handle] = nil
		return ReturnAI["END"]
	end

	return ReturnAI["END"]

end



function GateFunc( NPCHandle, PlyHandle, RegistNumber )

	local MapIndex = GateMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["GateList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["GateList"][NPCHandle]

	if Var == nil then
		return
	end


	cLinkTo( PlyHandle, MapIndex, Var["GateData"]["GoalX"], Var["GateData"]["GoalY"] )

end



--[[*****																*****]]--
--[[*****					방어오브젝트 처리 루틴 메인					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
DefObjMapIndex = {} -- 엔피씨클릭시에 맵인덱스를 받지 않아 리젠시에 맵인덱스를 저장

function DefObjRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end


	local Var = InstanceField[MapIndex]["DefObjList"][Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["DefObjList"][Handle] = nil
		DefObjMapIndex[Handle] = nil
		return ReturnAI["END"]
	end

	if DefObjMapIndex[Handle] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		InstanceField[MapIndex]["DefObjList"][Handle] = nil
		return ReturnAI["END"]
	end


	DefObjDamage( Var )


	return ReturnAI["END"]

end



function DefObjDamage( Var )

	if Var == nil then
		return
	end

	local MapIndex = DefObjMapIndex[Var["Handle"]]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex]["WaveRunner"] == nil then
		return
	end

	-- hp 체크
	if Var["CurHP"] <= 0 then
		return
	end


	-- 체크 딜레이
	local CurSec = cCurrentSecond()

	if Var["LastCheckTime"] + DEF_TYPE_CHK_DLY > CurSec then
		return
	end

	Var["LastCheckTime"] = CurSec


	local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["DamageRange"], ObjectType["Mob"] ) }
	local tmpHP   = Var["CurHP"]

	for index, value in pairs( ObjList ) do

		local obj = InstanceField[MapIndex]["WaveRunner"][value]

		if obj ~= nil then

			Var["CurHP"] = Var["CurHP"] - obj["Damage"]

			-- 웨이브몹 제거
			InstanceField[MapIndex]["WaveRunner"][value] = nil
			cAIScriptSet( value )
			-- 추가 개선 6. 몬스터가 목책에 부딪힐 때, 죽는 애니메이션 처리
			--cNPCVanish( value )
			local CurHP, MaxHP = cObjectHP( value )
			cDamaged( value, CurHP, Var["Handle"] )

			if Var["CurHP"] <= 0 then
				break
			end

		end

	end


	-- hp 변화가 있는지 체크
	if tmpHP == Var["CurHP"] then
		return
	end



	if Var["CurHP"] <= 0 then

		cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Dst"], Var["MMGroup"] ) -- 목책이 파괴됨

		-- 체력이 모두 소모된 파괴 상태

		-- 현재 상태와 다르면 아이콘 바꿔줌
		if Var["CurMM"] ~= MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Destruct"] then

			Var["CurMM"] = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Destruct"]

			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
			mmData["x"]         = Var["Data"]["x"]
			mmData["y"]         = Var["Data"]["y"]
			mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
			mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

			cMapMark( MapIndex, MapMarkTable )

		end


		-- 파괴된경우 쿨타임 셋
		Var["DestroyTime"] = CurSec

		-- 밸런스값 조정
		local FenceBalance = InstanceField[MapIndex]["FenceBalance"]

		if FenceBalance ~= nil then

			local BalanceData = DefBalanceTypeTable[Var["Data"]["DefBalanceType"]]

			if BalanceData ~= nil then

				FenceBalance["DamageRate"] = FenceBalance["DamageRate"] + BalanceData["DamageRate"]
				FenceBalance["SpeedRate"]  = FenceBalance["SpeedRate"]  + BalanceData["SpeedRate"]
				FenceBalance["HPRate"]     = FenceBalance["HPRate"]     + BalanceData["HPRate"]

			end

		end

	else

		-- 데미지 입은 상태
		cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Atk"], Var["MMGroup"] ) -- 목책이 공격받고 있음

		-- 현재 상태와 다르면 아이콘 바꿔줌
		if Var["CurMM"] ~= MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Damage"] then

			Var["CurMM"] = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Damage"]

			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
			mmData["x"]         = Var["Data"]["x"]
			mmData["y"]         = Var["Data"]["y"]
			mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
			mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

			MapMarkTable[mmData["Group"]] = mmData

			cMapMark( MapIndex, MapMarkTable )

		end

	end


	local CurHPRate  = (Var["CurHP"] * 1000) / Var["Data"]["HP"]
	local CurAniData = AniStateTypeTable[Var["Data"]["AniStateType"]]

	for i=1, #CurAniData do

		if CurHPRate <= CurAniData[i]["HPRate"] then

			-- 애니매이션 변화가 있으면 바꿔줌
			if Var["CurAni"] ~= i then

				Var["CurAni"] = i
				cAnimate( Var["Handle"], "start", CurAniData[i]["AniIndex"] )

			end

			break

		end

	end

end



function DefObjClick( NPCHandle, PlyHandle, PlyRegNum )

	local MapIndex = DefObjMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["DefObjList"][NPCHandle]

	if Var == nil then
		return
	end

	if Var["CurHP"] > 0 then
		return
	end

	if Var["DestroyTime"] + Var["Data"]["RepairDlyTime"] > cCurrentSecond() then
		return
	end

	cCastingBar( PlyHandle, NPCHandle, (Var["Data"]["RepairTime"] * 1000), CHAR_CASTING )

end



function DefObjCasting( NPCHandle, PlyHandle, PlyRegNum, Menu )

	local MapIndex = DefObjMapIndex[NPCHandle]

	if MapIndex == nil then
		return
	end

	if InstanceField[MapIndex] == nil then
		return
	end

	if InstanceField[MapIndex]["DefObjList"] == nil then
		return
	end


	local Var = InstanceField[MapIndex]["DefObjList"][NPCHandle]

	if Var == nil then
		return
	end

	if Var["CurHP"] > 0 then
		return
	end


	-- 밸런스값 조정
	local FenceBalance = InstanceField[MapIndex]["FenceBalance"]

	if FenceBalance ~= nil then

		local BalanceData = DefBalanceTypeTable[Var["Data"]["DefBalanceType"]]

		if BalanceData ~= nil then

			FenceBalance["DamageRate"] = FenceBalance["DamageRate"] - BalanceData["DamageRate"]
			FenceBalance["SpeedRate"]  = FenceBalance["SpeedRate"]  - BalanceData["SpeedRate"]
			FenceBalance["HPRate"]     = FenceBalance["HPRate"]     - BalanceData["HPRate"]

		end

	end


	Var["CurHP"]  = Var["Data"]["HP"]
	Var["CurAni"] = #AniStateTypeTable[Var["Data"]["AniStateType"]]
	Var["CurMM"]  = MMGroupTypeTable[Var["Data"]["MMGroupType"]]["Normal"]


	local MapMarkTable = {}
	local mmData = {}

	mmData["Group"]     = MM_G_FENCE + Var["MMGroup"]
	mmData["x"]         = Var["Data"]["x"]
	mmData["y"]         = Var["Data"]["y"]
	mmData["KeepTime"]  = MapMarkTypeTable[Var["CurMM"]]["KeepTime"]
	mmData["IconIndex"] = MapMarkTypeTable[Var["CurMM"]]["IconIndex"]

	MapMarkTable[mmData["Group"]] = mmData


	cMapMark( MapIndex, MapMarkTable )

	cScriptMessage( MapIndex, AnnounceInfo["KDMine_Fence_Rep"], Var["MMGroup"] ) -- 목책이 수리됨

	cAnimate( NPCHandle, "start", AniStateTypeTable[Var["Data"]["AniStateType"]][Var["CurAni"]]["AniIndex"] )

end




--[[*****																*****]]--
--[[*****					메인오브젝트 처리 루틴 메인					*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
function MainObjRoutine( Handle, MapIndex )

	if InstanceField[MapIndex] == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	local Var = InstanceField[MapIndex]["MainObj"]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		InstanceField[MapIndex]["MainObj"] = nil
		return ReturnAI["END"]
	end

	MainObjDamage( Var )

end



function MainObjDamage( Var )

	if Var == nil then
		return
	end


	-- 체크 딜레이
	local CurSec = cCurrentSecond()

	if Var["LastCheckTime"] + DEF_TYPE_CHK_DLY > CurSec then
		return
	end

	Var["LastCheckTime"] = CurSec


	local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["DamageRange"], ObjectType["Mob"] ) }
	local tmpHP   = Var["CurHP"]

	for index, value in pairs( ObjList ) do

		local obj = InstanceField[Var["MapIndex"]]["WaveRunner"][value]

		if obj ~= nil then

			Var["CurHP"] = Var["CurHP"] - obj["Damage"]

			-- 웨이브몹 제거
			InstanceField[Var["MapIndex"]]["WaveRunner"][value] = nil
			cAIScriptSet( value )
			cNPCVanish( value )

			if Var["CurHP"] <= 0 then
				break
			end

		end

	end


	-- hp 변화가 있는지 체크
	if tmpHP == Var["CurHP"] then
		return
	end


	-- 추가 개선 1. 최종 오브젝트인 탈출구를 몬스터가 부딪힐 때,
	local TotalDmg = (MainDefenceObject["HP"] - Var["CurHP"])


	if Var["CurHP"] <= 0 then

		-- 파괴 상태
		-- 추가 개선 1. 최종 오브젝트인 탈출구를 몬스터가 부딪힐 때,
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Dst"], TotalDmg )
--		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Dst"] )

	else

		-- 데미지 입은 상태
		-- 추가 개선 1. 최종 오브젝트인 탈출구를 몬스터가 부딪힐 때,
		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Esc"], TotalDmg )
--		cScriptMessage( Var["MapIndex"], AnnounceInfo["KDMine_Gate_Esc"] )



	end

end




--[[*****																*****]]--
--[[*****						지뢰 처리 루틴 메인						*****]]--
--[[*****		:														*****]]--
--[[*****																*****]]--
MineMemory = {}		-- 개별 메모리로 처리
function MineRoutine( Handle, MapIndex )

	local Var = MineMemory[Handle]

	if Var == nil then
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) then
		cAIScriptSet( Handle )
		MineMemory[Handle] = nil
		return ReturnAI["END"]
	end


	if InstanceField[MapIndex] == nil then
		MineMemory[Handle] = nil
		return ReturnAI["END"]
	end



	local CurSec = cCurrentSecond()


	if Var["BoomFlag"] ~= nil then

		if Var["RegenTime"] + Var["Data"]["HitTime"] < CurSec then

			if InstanceField[MapIndex]["WaveRunner"] ~= nil then

				local ObjList = { cNearObjectList( Var["Handle"], Var["Data"]["Range"], ObjectType["Mob"] ) }

				for index, value in pairs( ObjList ) do

					local obj = InstanceField[MapIndex]["WaveRunner"][value]

					if obj ~= nil and cIsObjectDead( value ) == nil then

						cDamaged( value, Var["Data"]["Damage"], Var["Handle"] )

						local Abstate = AbstateTypeTable[Var["Data"]["AbstateType"]]

						if Abstate ~= nil then

							cSetAbstate( value, Abstate["Index"], 1, Abstate["KeepTime"], Var["Handle"] )

						end

					end

				end

			end

			Var["BoomFlag"] = nil

		end

	end


	if Var["RegenTime"] + Var["Data"]["LifeTime"] < CurSec then

		MineMemory[Handle] = nil

	end

	return ReturnAI["END"]

end
