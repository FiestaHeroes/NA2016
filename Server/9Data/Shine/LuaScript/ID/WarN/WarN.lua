require( "common" )
require( "ID/WarN/WarNData" )
require( "ID/WarN/WarNFunc" )
require( "ID/WarN/WarNRoutine" )


function Main( Field )
cExecCheck( "Main" )

	local Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var["MapIndex"]	= Field

		Var["StepControl"] = StepControl
		Var["StepFunc"]    = DummyFunc

		cSetFieldScript( Var["MapIndex"], SCRIPT_MAIN )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

	end


	Var["StepControl"]( Var )
	Var["StepFunc"]( Var )

end


function DummyFunc( Var )
cExecCheck( "DummyFunc" )
end


function StepControl( Var )
cExecCheck( "StepControl" )

	if Var == nil then
		return
	end


	MapMarking( Var ) -- 맵마킹 처리


	local CurSec = cCurrentSecond()


	-- 초기화, 기본 몹 도어 리젠
	if Var["Step"] == nil then

		Var["Step"]     = 1
		Var["StepFunc"] = InitInstanceDungeon	-- 초기화 내용은 이 함수에서 확인

		return

	end


	-- 아이리 구출부터 시작.
	-- ElementClearEvent -> CenterSetting -> NormalClearEvent -> ElementSetting
	-- 함수 반복
	if Var["Step"] == 1 then

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = ElementClearEvent

		return

	end


	-- 보스 클리어 체크
	-- 아이리와 가디언 보스방에서 리젠해서 이동 처리
	if Var["Step"] == 2 then

		local OreNum = 0

		-- 광석 갯수로 클리어 여부 판단
		for index, value in pairs( Var["OreList"] ) do

			OreNum = OreNum + 1

		end

		if OreNum < Var["RoomNum"] then

			return

		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = ClearDungeon

		return

	end


	-- 아이리와 광석 거리 체크
	if Var["Step"] == 3 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end


		local CurDistSqr = cDistanceSquar( Var["Airi"], Var["BossOre"] )
		local ChkDist    = WARN_END_EVENT["Flw_Gap"] + WARN_END_EVENT["EventDist"]

		if CurDistSqr < ChkDist * ChkDist then

			Var["Step"]     = Var["Step"] + 1
			Var["StepFunc"] = DummyFunc

		end

		return

	end


	-- 대화 1차
	if Var["Step"] == 4 then

		if WarN_Dialog( Var, DialogInfo["WarN_Clear_1"] ) ~= nil then
			return
		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- 아이리 광석 가까이 한번 더 이동
	if Var["Step"] == 5 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end

		cFollow( Var["Airi"], Var["BossOre"], WARN_END_EVENT["Flw_Airi"], WARN_END_EVENT["Flw_Airi"] + WARN_END_EVENT["Flw_Gap"] )

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- 아이리와 광석 거리 체크
	if Var["Step"] == 6 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end


		local CurDistSqr = cDistanceSquar( Var["Airi"], Var["BossOre"] )
		local ChkDist    = WARN_END_EVENT["Flw_Airi"] + WARN_END_EVENT["EventDist"]

		if CurDistSqr < ChkDist * ChkDist then

			Var["Step"]     = Var["Step"] + 1
			Var["StepFunc"] = DummyFunc

		end

		return

	end


	-- 아이리 조사 애니매이션
	if Var["Step"] == 7 then

		if Var["Airi"] == nil then
			Var["Step"] = 99
			return
		end

		-- 아이리 이동이 아직 덜끝나서 애니매이션이 다시 바뀔 가능성을 생각해서 여유시간동안 대기
		if Var["StepWait"] == nil then

			Var["StepWait"] = CurSec

		end

		if Var["StepWait"] + WARN_END_EVENT["WaitAiriMove"] > CurSec then

			return

		end


		cAnimate( Var["Airi"], "start", AiriData["ResearchAniIndex"] )


		Var["StepWait"] = nil
		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	-- 대화 2차
	if Var["Step"] == 8 then

		if WarN_Dialog( Var, DialogInfo["WarN_Clear_2"] ) ~= nil then
			return
		end


		-- 출구 게이트 리젠
		if Var["BossOre"] == nil then
			Var["Step"] = 99
			return
		end

		if Var["OreList"][Var["BossOre"]] == nil then
			Var["Step"] = 99
			return
		end


		local CurRoomNum  = Var["RoomOrder"][#Var["RoomOrder"]]
		local CenterCoord = RoomCoordDataTable[Var["RoomData"][CurRoomNum]["Data"]["RoomCoordData"]]["CenterCoord"]
		local RegenCoord  = {}

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( Var["BossOre"], CenterCoord["dir"], WARN_END_EVENT["GateDist"] )


		local ExitGate = {}

		ExitGate["Handle"] = cMobRegen_XY( Var["MapIndex"], GateData["Index"],
															RegenCoord["x"],
															RegenCoord["y"],
															CenterCoord["dir"] )

		if ExitGate["Handle"] ~= nil then

			ExitGate["Data"] = GateData["LinkTo"]

			cSetAIScript( SCRIPT_MAIN, ExitGate["Handle"] )
			cAIScriptFunc( ExitGate["Handle"], "Entrance", "GateRoutine" )
			cAIScriptFunc( ExitGate["Handle"], "NPCClick", "GateClick"   )

			Var["ExitGateList"][ExitGate["Handle"]] = ExitGate
			GateMapIndex[ExitGate["Handle"]]        = Var["MapIndex"] -- 맵인덱스 저장

		end


		Var["Step"]     = 99
		Var["StepFunc"] = DummyFunc

		return

	end


	if 	Var["Step"] == 99 then

		if WarN_Notice( Var, NoticeInfo["KQReturn"] ) ~= nil then
			return
		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

	end


	if Var["Step"] == 100 then

		cLinkToAll( Var["MapIndex"], GateData["LinkTo"]["Field"], GateData["LinkTo"]["x"], GateData["LinkTo"]["y"] )

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end

end
