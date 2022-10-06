-- 대화 함수 Var = 전역변수, Dialog = 대화내용 테이블
-- 리턴값 : 진행중 = 현재 대화 번호, 끝 = nil
--	Dialog =
--	{
--		{ Facecut = "DT_StancherAiri", FileName = "WarN", Index = "Airi_02",      Delay = 5 },
--		...
--	},
function WarN_Dialog( Var, Dialog )
cExecCheck( "WarN_Dialog" )

	if Var == nil or Dialog == nil then
		return nil
	end


	local CurSec = cCurrentSecond()

	if Var["Dialog"] == nil then

		Var["Dialog"]     = Dialog
		Var["DialogStep"] = 1
		Var["DialogTime"] = CurSec

	end


	if Var["DialogStep"] <= #Var["Dialog"] then

		if Var["DialogTime"] + Var["Dialog"][Var["DialogStep"]]["Delay"] > CurSec then
			return Var["DialogStep"]
		end

		cMobDialog( Var["MapIndex"],
					Var["Dialog"][Var["DialogStep"]]["Facecut"],
					Var["Dialog"][Var["DialogStep"]]["FileName"],
					Var["Dialog"][Var["DialogStep"]]["Index"] )

		Var["DialogTime"] = CurSec
		Var["DialogStep"] = Var["DialogStep"] + 1

		return Var["DialogStep"]

	end

	Var["Dialog"]     = nil
	Var["DialogStep"] = nil
	Var["DialogTime"] = nil


	return nil

end


-- 공지 함수
-- 대화 함수랑 동일
--	WarN_Join =
--	{
--		{ FileName = "WarN", Index = "Notice_01",  WaitTime = 0, },
--	},
function WarN_Notice( Var, Notice )
cExecCheck( "WarN_Notice" )

	if Var == nil or Notice == nil then
		return nil
	end


	local CurSec = cCurrentSecond()

	if Var["Notice"] == nil then

		Var["Notice"]     = Notice
		Var["NoticeStep"] = 1
		Var["NoticeTime"] = CurSec

	end

	if Var["NoticeStep"] <= #Var["Notice"] then

		if Var["Noticed"] == nil then

			cNotice( Var["MapIndex"], Var["Notice"][Var["NoticeStep"]]["FileName"], Var["Notice"][Var["NoticeStep"]]["Index"] )
			Var["Noticed"] = 1

		end


		if Var["NoticeTime"] + Var["Notice"][Var["NoticeStep"]]["WaitTime"] > CurSec then
			return Var["NoticeStep"]
		end

		Var["NoticeTime"] = CurSec
		Var["NoticeStep"] = Var["NoticeStep"] + 1
		Var["Noticed"]    = nil

		return Var["NoticeStep"]

	end

	Var["Notice"]     = nil
	Var["NoticeStep"] = nil
	Var["NoticeTime"] = nil
	Var["Noticed"]    = nil


	return nil

end


function InitInstanceDungeon( Var )
cExecCheck( "InitInstanceDungeon" )

	if Var == nil then
		return
	end


	-- 출구 리젠
	local ExitGateList = {}

	local ExitGate = {}

	ExitGate["Handle"] = cMobRegen_XY( Var["MapIndex"], GateData["Index"],
														GateData["RegenCoord"]["x"],
														GateData["RegenCoord"]["y"],
														GateData["RegenCoord"]["dir"] )

	if ExitGate["Handle"] ~= nil then

		ExitGate["Data"] = GateData["LinkTo"]

		cSetAIScript( SCRIPT_MAIN, ExitGate["Handle"] )
		cAIScriptFunc( ExitGate["Handle"], "Entrance", "GateRoutine" )
		cAIScriptFunc( ExitGate["Handle"], "NPCClick", "GateClick"   )

		ExitGateList[ExitGate["Handle"]] = ExitGate
		GateMapIndex[ExitGate["Handle"]] = Var["MapIndex"] -- 맵인덱스 저장

	end

	Var["ExitGateList"] = ExitGateList


	local Guardian = {}

	-- 아이리 리젠
	local RegenAiri = {}
	RegenAiri["Handle"] = cMobRegen_XY( Var["MapIndex"], AiriData["MobIndex"], AiriData["x"], AiriData["y"], AiriData["dir"] )

	if RegenAiri["Handle"] ~= nil then

		RegenAiri["MapIndex"]  = Var["MapIndex"]
		RegenAiri["Data"]      = AiriData

		RegenAiri["State"]     = FM_STATE["Normal"]
		RegenAiri["CheckTime"] = cCurrentSecond()

		cSetAIScript( SCRIPT_MAIN, RegenAiri["Handle"] )
		cAIScriptFunc( RegenAiri["Handle"], "Entrance", "FriendMobRoutine" )

		-- 아이리도 가디언에 같이 포함시켜 처리하고,
		-- 핸들값만 따로 가지고 있음
		Guardian[RegenAiri["Handle"]] = RegenAiri

		Var["Airi"] = RegenAiri["Handle"]

	end


	-- 경비병 리젠
	for index, value in pairs( GuardianDataTable ) do

		local RegenMob = {}

		RegenMob["Handle"] = cMobRegen_XY( Var["MapIndex"], value["MobIndex"], value["x"], value["y"], value["dir"] )

		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]  = Var["MapIndex"]
			RegenMob["Data"]      = value

			RegenMob["State"]     = FM_STATE["Normal"]
			RegenMob["CheckTime"] = cCurrentSecond()

			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "FriendMobRoutine" )

			Guardian[RegenMob["Handle"]] = RegenMob

		end

	end

	Var["Guardian"] = Guardian


	-- 방 정보 설정
	local RoomData = {}
	local RoomNum = 0

	for index, value in pairs( ElementRoom ) do

		local Room = {}

		RoomNum = RoomNum + 1

		Room["Data"] = value
		Room["Door"] = cDoorBuild( Var["MapIndex"],
									ElementMobIndexDataTable[Room["Data"]["ElementMobIndexData"]]["Door"],
									RoomCoordDataTable[Room["Data"]["RoomCoordData"]]["Door"]["x"],
									RoomCoordDataTable[Room["Data"]["RoomCoordData"]]["Door"]["y"],
									RoomCoordDataTable[Room["Data"]["RoomCoordData"]]["Door"]["dir"],
									RoomCoordDataTable[Room["Data"]["RoomCoordData"]]["Door"]["scale"] )

		cDoorAction( Room["Door"], RoomCoordDataTable[Room["Data"]["RoomCoordData"]]["Door"]["Block"], "close" )

		RoomData[RoomNum] = Room

	end

	Var["RoomData"] = RoomData
	Var["RoomNum"]  = RoomNum				-- MaxLev


	-- 기타 진행관련변수 초기화
	Var["CurLev"]         = 0				-- CurLev
	Var["CheckTime"]      = cCurrentSecond()-- 이벤트 딜레이 시간 체크용

	Var["NormalMobList"]  = {}				-- 중심 방에서 리젠한 몹들 리스트
	Var["ElementMobList"] = {}				-- 각 속성방에서 리젠한 몹들 리스트
	Var["OreList"]        = {}              -- 알수없는 광석
	Var["TrapMobList"]    = nil				-- 함정몹 리스트

	Var["RoomOrder"]      = {}				-- 속성방 진행순서 설정
	for i=1, Var["RoomNum"] do
		Var["RoomOrder"][i] = i
	end
	for i=1, Var["RoomNum"] do

		local RndNum1 = cRandomInt( 1, Var["RoomNum"] )
		local RndNum2 = cRandomInt( 1, Var["RoomNum"] )

		Var["RoomOrder"][RndNum1], Var["RoomOrder"][RndNum2] = Var["RoomOrder"][RndNum2], Var["RoomOrder"][RndNum1]

	end


	Var["StepFunc"] = DummyFunc

end


function ElementClearEvent( Var )
cExecCheck( "ElementClearEvent" )

	if Var == nil then
		return
	end



	-- 속성몹이 남아있는지 체크
	for index, value in pairs( Var["ElementMobList"] ) do
		return
	end


	if Var["CTEStep"] == nil then

		Var["CTEStep"] = 1


		-- 함정몹 클리어
		Var["TrapMobList"] = nil


		-- 레벨 증가 시키기 전에 알수없는 광석 리젠.
		if Var["CurLev"] > 0 and Var["CurLev"] <= Var["RoomNum"] then

			local CenterCoord = RoomCoordDataTable[Var["RoomData"][Var["RoomOrder"][Var["CurLev"]]]["Data"]["RoomCoordData"]]["CenterCoord"]

			local Ore = {}

			Ore["Handle"] = cMobRegen_XY( Var["MapIndex"], SpecialIndex["Ore"], CenterCoord["x"], CenterCoord["y"], CenterCoord["dir"] )

			if Ore["Handle"] ~= nil then

				Ore["RoomNum"]   = Var["RoomOrder"][Var["CurLev"]]
				Ore["CheckTime"] = cCurrentSecond()

				cSetAIScript( SCRIPT_MAIN, Ore["Handle"] )
				cAIScriptFunc( Ore["Handle"], "Entrance", "OreRoutine" )

				Var["OreList"][Ore["Handle"]] = Ore

			end

		end

		-- 레벨 증가
		Var["CurLev"] = Var["CurLev"] + 1

	end


	-- 최초
	if Var["CurLev"] == 1 then

		if Var["CTEStep"] == 1 then

			if WarN_Dialog( Var, DialogInfo["WarN_Join"] ) ~= nil then
				return
			end

			Var["CTEStep"] = Var["CTEStep"] + 1

			return

		end

		if Var["CTEStep"] == 2 then

			if WarN_Notice( Var, NoticeInfo["WarN_Join"] ) ~= nil then
				return
			end

			Var["CTEStep"] = Var["CTEStep"] + 1

			return

		end

	elseif Var["CurLev"] < Var["RoomNum"] then

		if Var["CTEStep"] == 1 then

			if WarN_Dialog( Var, DialogInfo["Airi_Event"] ) ~= nil then
				return
			end

			Var["CTEStep"] = Var["CTEStep"] + 1

			return

		end

	elseif Var["CurLev"] == Var["RoomNum"] then

		-- 보스처치후 10초 --
		local CurSec = cCurrentSecond()

		if Var["CTEWait"] == nil then
			Var["CTEWait"] = CurSec
		end

		if Var["CTEWait"] + WAIT_BOSSROOM > CurSec then
			return
		end
		-- -- -- -- -- -- --


		if Var["CTEStep"] == 1 then

			if WarN_Dialog( Var, DialogInfo["Airi_Boss"] ) ~= nil then
				return
			end

			Var["CTEStep"] = Var["CTEStep"] + 1

			return

		end

		if Var["CTEStep"] == 2 then

			if WarN_Notice( Var, NoticeInfo["Airi_Boss"] ) ~= nil then
				return
			end

			Var["CTEStep"] = Var["CTEStep"] + 1

			return

		end

	end


	Var["CTEWait"]  = nil
	Var["CTEStep"]  = nil

	Var["StepFunc"] = CenterSetting

end


function CenterSetting( Var )
cExecCheck( "CenterSetting" )

	if Var == nil then
		return
	end


	-- 마지막 레벨을 초과한 경우(보스를 잡은것)
	if Var["CurLev"] > Var["RoomNum"] then

		Var["StepFunc"] = DummyFunc
		return;

	-- 마지막 레벨인경우
	elseif Var["CurLev"] == Var["RoomNum"] then

		-- 경비병 부상상태로 바꾸기 위해 데미지 줌
		for index, value in pairs( Var["Guardian"] ) do

			local CurHP, MaxHP = cObjectHP( index )

			cDamaged( index, CurHP-1 )
			value["State"] = FM_STATE["Normal"]

		end

	-- 마지막 레벨 미만인 경우
	elseif Var["CurLev"] < Var["RoomNum"] then

		-- 경비병 보통상태로 바꾸기 위해 힐 줌
		for index, value in pairs( Var["Guardian"] ) do

			local CurHP, MaxHP = cObjectHP( index )

			cHeal( index, MaxHP )
			value["State"] = FM_STATE["Injury"]

		end

		-- 몹 리젠 하기위해 데이터 체크
		-- 레벨이 RegenGroupDataTable의 갯수이상이면 마지막 데이터로 리젠
		local CurLev = Var["CurLev"]

		if CurLev > #RegenGroupDataTable then

			CurLev = #RegenGroupDataTable

		end

		local CurRegenNormal = NormalRegenTypeTable[RegenGroupDataTable[CurLev]["NormalRegenType"]]
		local CurRegenElite  = EliteRegenTypeTable [RegenGroupDataTable[CurLev]["EliteRegenType"] ]


		local NormalMobList = {}

		-- 노멀몹 리젠
		for i=1, #CurRegenNormal do

			for j=1, CurRegenNormal[i]["Num"] do

				local NormalMob = {}

				NormalMob["Handle"] = cMobRegen_Circle( Var["MapIndex"],
														CurRegenNormal[i]["MobIndex"],
														CurRegenNormal[i]["x"],
														CurRegenNormal[i]["y"],
														CurRegenNormal[i]["Range"] )

				if NormalMob["Handle"] ~= nil then

					cSetAIScript( SCRIPT_MAIN, NormalMob["Handle"] )
					cAIScriptFunc( NormalMob["Handle"], "Entrance", "NormalMobRoutine" )

					NormalMobList[NormalMob["Handle"]] = NormalMob

				end

			end

		end

		-- 엘리트몹 리젠
		local EliteElement = {}
		for i=1, #ElementRoom do

			EliteElement[i] = i

		end

		for i=1, #ElementRoom do

			local RndNum1 = cRandomInt( 1, #ElementRoom )
			local RndNum2 = cRandomInt( 1, #ElementRoom )

			EliteElement[RndNum1], EliteElement[RndNum2] = EliteElement[RndNum2], EliteElement[RndNum1]

		end


		local CurElement = 1
		for i=1, #CurRegenElite do

			if CurElement > #ElementRoom then
				CurElement = 1
			end

			local EliteMob = {}

			EliteMob["Handle"] = cMobRegen_XY( Var["MapIndex"],
												ElementMobIndexDataTable[ElementRoom[EliteElement[CurElement]]["ElementMobIndexData"]]["Elite"],
												CurRegenElite[i]["x"],
												CurRegenElite[i]["y"],
												CurRegenElite[i]["dir"] )

			if EliteMob["Handle"] ~= nil then

				cSetAIScript( SCRIPT_MAIN, EliteMob["Handle"] )
				cAIScriptFunc( EliteMob["Handle"], "Entrance", "NormalMobRoutine" )

				NormalMobList[EliteMob["Handle"]] = EliteMob

			end

			CurElement = CurElement + 1

		end


		-- 만들어진 몹 리스트 저장
		Var["NormalMobList"] = NormalMobList

	end


	Var["StepFunc"] = NormalClearEvent

	return

end


function NormalClearEvent( Var )
cExecCheck( "NormalClearEvent" )

	if Var == nil then
		return
	end


	-- 노멀몹 남아있는지 체크
	for index, value in pairs( Var["NormalMobList"] ) do
		return
	end


	if Var["ETCStep"] == nil then

		Var["ETCStep"] = 1

	end


	-- 마지막 보스방이 아닌경우 다이얼로그와 공지
	if Var["CurLev"] < Var["RoomNum"] then

		-- 아이리 구출 성공
		if Var["Airi"] ~= nil and Var["Guardian"] ~= nil and Var["Guardian"][Var["Airi"]]["State"] ~= FM_STATE["Injury"] then

			if Var["ETCStep"] == 1 then

				if WarN_Notice( Var, NoticeInfo["Airi_Success"] ) ~= nil then
					return
				end

				Var["ETCStep"] = Var["ETCStep"] + 1

				return

			end

			if Var["ETCStep"] == 2 then

				if WarN_Dialog( Var, DialogInfo["Airi_Success"] ) ~= nil then
					return
				end

				Var["ETCStep"] = Var["ETCStep"] + 1

				return

			end

		-- 아이리 구출 실패
		else

			if Var["ETCStep"] == 1 then

				if WarN_Notice( Var, NoticeInfo["Airi_Fail"] ) ~= nil then
					return
				end

				Var["ETCStep"] = Var["ETCStep"] + 1

				return

			end

			if Var["ETCStep"] == 2 then

				if WarN_Dialog( Var, DialogInfo["Airi_Fail"] ) ~= nil then
					return
				end

				Var["ETCStep"] = Var["ETCStep"] + 1

				return

			end

		end

		-- 공통
		if Var["ETCStep"] == 3 then

			if WarN_Dialog( Var, DialogInfo["Airi_End"] ) ~= nil then
				return
			end

			Var["ETCStep"] = Var["ETCStep"] + 1

			return

		end

		if Var["ETCStep"] == 4 then

			if WarN_Notice( Var, NoticeInfo["Airi_End"] ) ~= nil then
				return
			end

			Var["ETCStep"] = Var["ETCStep"] + 1

			return

		end

	end


	Var["ETCStep"]  = nil


-------------------------------------------------------------------
--	카메라 이동

	local PlayerList = { cGetPlayerList( Var["MapIndex"] ) }

	for i=1, #PlayerList do
		cSetAbstate( PlayerList[i], CAMERAMOVE["StaStun"], 1, CAMERAMOVE["StaTime"] )
	end

	local CurRoomData = Var["RoomData"][Var["RoomOrder"][Var["CurLev"]]]
	local DoorLoc = RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["Door"]

	-- 서버와 클라 방향 맞춰줌
	local tmpdir = (DoorLoc["dir"] + 180) * (-1)

	tmpdir = tmpdir % 360

	cCameraMove( Var["MapIndex"], DoorLoc["x"], DoorLoc["y"], tmpdir, CAMERAMOVE["AngleY"], CAMERAMOVE["Dist"], 1 )
	Var["CameraMoveTime"] = cCurrentSecond()
-------------------------------------------------------------------

	Var["StepFunc"] = ElementSetting

end


function ElementSetting( Var )
cExecCheck( "ElementSetting" )

	if Var == nil then
		return
	end


	if Var["ES_Step"] == nil then

		local CurRoomData = Var["RoomData"][Var["RoomOrder"][Var["CurLev"]]]


		if Var["CurLev"] > Var["RoomNum"] then

			Var["StepFunc"] = CenterRoomEvent
			return;

		elseif Var["CurLev"] == Var["RoomNum"] then

			-- 도어 오픈
			cDoorAction( CurRoomData["Door"], RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["Door"]["Block"], "open" )

			-- 보스몹 리젠
			local ElementMobList = {}

			local ElementBossMob = {}

			ElementBossMob["Handle"] =
								cMobRegen_XY( Var["MapIndex"],
											ElementMobIndexDataTable[CurRoomData["Data"]["ElementMobIndexData"]]["Boss"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["x"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["y"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["dir"] )


			if ElementBossMob["Handle"] ~= nil then

				ElementBossMob["CheckTime"]       = cCurrentSecond()
				ElementBossMob["Grade"]           = E_MOB_GRADE["Boss"]
					ElementBossMob["SummonIndex"] = ElementMobIndexDataTable[CurRoomData["Data"]["ElementMobIndexData"]]["Elite"]
					ElementBossMob["SummonStep"]  = #BossSummonElite

				cSetAIScript( SCRIPT_MAIN, ElementBossMob["Handle"] )
				cAIScriptFunc( ElementBossMob["Handle"], "Entrance", "ElementMobRoutine" )

				ElementMobList[ElementBossMob["Handle"]] = ElementBossMob

			end

			Var["ElementMobList"] = ElementMobList


		elseif Var["CurLev"] < Var["RoomNum"] then

			-- 도어 오픈
			cDoorAction( CurRoomData["Door"], RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["Door"]["Block"], "open" )

			-- 치프몹 리젠
			local ElementMobList = {}

			local ElementChiefMob = {}

			ElementChiefMob["Handle"] =
								cMobRegen_XY( Var["MapIndex"],
											ElementMobIndexDataTable[CurRoomData["Data"]["ElementMobIndexData"]]["Chief"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["x"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["y"],
											RoomCoordDataTable[CurRoomData["Data"]["RoomCoordData"]]["CenterCoord"]["dir"] )


			if ElementChiefMob["Handle"] ~= nil then

				ElementChiefMob["CheckTime"] 		= cCurrentSecond()
				ElementChiefMob["Grade"]    		= E_MOB_GRADE["Chief"]
					ElementChiefMob["SummonIndex"]	= ElementMobIndexDataTable[CurRoomData["Data"]["ElementMobIndexData"]]["Elite"]
					ElementChiefMob["SummonStep"]	= #BossSummonElite


				cSetAIScript( SCRIPT_MAIN, ElementChiefMob["Handle"] )
				cAIScriptFunc( ElementChiefMob["Handle"], "Entrance", "ElementMobRoutine" )

				ElementMobList[ElementChiefMob["Handle"]] = ElementChiefMob

			end

			Var["ElementMobList"] = ElementMobList

		end



		-- 함정몹 리젠
		local CurPatrolData = TrapPatrolDataTable     [CurRoomData["Data"]["TrapPatrolData"]     ]
		local CurTrapIndex  = ElementMobIndexDataTable[CurRoomData["Data"]["ElementMobIndexData"]]["Trap"]
		local CurTrapData   = TrapDataTable [CurTrapIndex]

		local TrapMobList   = {}

		for i=1, #CurPatrolData do

			local TrapMob = {}

			TrapMob["Handle"] = cMobRegen_XY( Var["MapIndex"], CurTrapIndex, CurPatrolData[i][1]["x"], CurPatrolData[i][1]["y"], 0 )

			if TrapMob["Handle"] ~= nil then

				TrapMob["Data"]       = CurTrapData
				TrapMob["PatrolPath"] = CurPatrolData[i]

				TrapMob["CurGoal"]    = 1
				TrapMob["CheckTime"]  = cCurrentSecond()	-- 주변 플레이어 체크, 이동 처리 체크
				TrapMob["DelayTime"]  = cCurrentSecond()	-- 스킬 딜레이

				local Speed

				if Var["CurLev"] < Var["RoomNum"] then
					Speed = 99 + (cRandomInt( 1, 2 ) * cRandomInt( 1, 100 ))	-- 100 ~ 300
				else
					Speed = 99 + (cRandomInt( 1, 4 ) * cRandomInt( 1, 100 ))	-- 100 ~ 400
				end

				cSetNPCParam( TrapMob["Handle"], "RunSpeed", Speed )

				cSetAIScript( SCRIPT_MAIN, TrapMob["Handle"] )
				cAIScriptFunc( TrapMob["Handle"], "Entrance", "TrapMobRoutine" )

				TrapMobList[TrapMob["Handle"]] = TrapMob

				cRunTo( TrapMob["Handle"], TrapMob["PatrolPath"][TrapMob["CurGoal"]]["x"], TrapMob["PatrolPath"][TrapMob["CurGoal"]]["y"] )

			end

		end

		Var["TrapMobList"] = TrapMobList



		-- 아이리가 부상 상태가 아니면 플레이어들에게 이로운 상태이상을 걸어줌
		if Var["Airi"] ~= nil and Var["Guardian"] ~= nil then

			if Var["Guardian"][Var["Airi"]]["State"] ~= FM_STATE["Injury"] then

				local Player = { cGetPlayerList( Var["MapIndex"] ) }

				for i=1, #Player do

					cSetAbstate( Player[i], AIRI_BLESSING["Index"], 1, AIRI_BLESSING["KeepTime"] )

				end

			end

		end

		-- 보스방 전에는 무조건 버프 걸어줌
		if Var["CurLev"] == Var["RoomNum"] then

			local Player = { cGetPlayerList( Var["MapIndex"] ) }

			for i=1, #Player do

				cSetAbstate( Player[i], AIRI_BLESSING["Index"], 1, AIRI_BLESSING["KeepTime"] )

			end

		end

		Var["ES_Step"] = 1

	end


	if Var["ES_Step"] == 1 then

		local CurSec = cCurrentSecond()

		if Var["CameraMoveTime"] + CAMERAMOVE["MoveKeep"] > CurSec then
			return
		end

		local PlayerList = { cGetPlayerList( Var["MapIndex"] ) }

		for i=1, #PlayerList do
			cResetAbstate( PlayerList[i], CAMERAMOVE["StaStun"] )
		end

		Var["CameraMoveTime"] = nil
		Var["ES_Step"]        = nil

		cCameraMove( Var["MapIndex"], 0, 0, 0, 0, 0, 0 )

	end


	Var["StepFunc"] = ElementClearEvent

	return

end


function ClearDungeon( Var )
cExecCheck( "ClearDungeon" )

	if Var == nil then
		return
	end


	local CurRoomNum  = Var["RoomOrder"][#Var["RoomOrder"]]
	local CenterCoord = RoomCoordDataTable[Var["RoomData"][CurRoomNum]["Data"]["RoomCoordData"]]["CenterCoord"]
	local CurRoomOre  = nil


	-- 보스방 광석핸들을 찾음
	for index, value in pairs( Var["OreList"] ) do

		if value["RoomNum"] == CurRoomNum then

			CurRoomOre = index

			break

		end

	end

	Var["BossOre"] = CurRoomOre

	if Var["BossOre"] == nil then

		Var["StepFunc"] = DummyFunc

		return

	end


	local RegenCoord = {}

	RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( CurRoomOre, CenterCoord["dir"] + WARN_END_EVENT["Plus_Dir"], WARN_END_EVENT["Dist"] )


	local Guardian = {}

	-- 아이리 리젠
	local RegenAiri = {}
	RegenAiri["Handle"] = cMobRegen_XY( Var["MapIndex"], AiriData["MobIndex"], RegenCoord["x"], RegenCoord["y"], CenterCoord["dir"] )

	if RegenAiri["Handle"] ~= nil then

		RegenAiri["MapIndex"]  = Var["MapIndex"]
		RegenAiri["Data"]      = AiriData

		RegenAiri["State"]     = FM_STATE["Stop"]
		RegenAiri["CheckTime"] = cCurrentSecond()

		cSetAIScript( SCRIPT_MAIN, RegenAiri["Handle"] )
		cAIScriptFunc( RegenAiri["Handle"], "Entrance", "FriendMobRoutine" )

		-- 아이리도 가디언에 같이 포함시켜 처리하고,
		-- 핸들값만 따로 가지고 있음
		Guardian[RegenAiri["Handle"]] = RegenAiri

		Var["Airi"] = RegenAiri["Handle"]


		cFollow( Var["Airi"], CurRoomOre, WARN_END_EVENT["Flw_Gap"], WARN_END_EVENT["Dist"] + WARN_END_EVENT["Flw_Gap"] )

	end


	-- 경비병 리젠
	local Count = 0
	local Modul = 0

	for index, value in pairs( GuardianDataTable ) do

		Count = Count + 1
		Modul = Count % 2

		local Dir = ( (CenterCoord["dir"] + WARN_END_EVENT["Plus_Dir"]) + ( ((-1)^Count) * WARN_END_EVENT["Interval"] *( Count + Modul ) ) )

		RegenCoord["x"], RegenCoord["y"] = cGetAroundCoord( CurRoomOre, Dir, WARN_END_EVENT["Dist"] )

		local RegenMob = {}

		RegenMob["Handle"] = cMobRegen_XY( Var["MapIndex"], value["MobIndex"], RegenCoord["x"], RegenCoord["y"], CenterCoord["dir"] )

		if RegenMob["Handle"] ~= nil then

			RegenMob["MapIndex"]  = Var["MapIndex"]
			RegenMob["Data"]      = value

			RegenMob["State"]     = FM_STATE["Stop"]
			RegenMob["CheckTime"] = cCurrentSecond()

			cSetAIScript( SCRIPT_MAIN, RegenMob["Handle"] )
			cAIScriptFunc( RegenMob["Handle"], "Entrance", "FriendMobRoutine" )

			Guardian[RegenMob["Handle"]] = RegenMob

			cFollow( RegenMob["Handle"], CurRoomOre, WARN_END_EVENT["Flw_Gap"], WARN_END_EVENT["Dist"] + WARN_END_EVENT["Flw_Gap"] )

		end

	end

	Var["Guardian"] = Guardian -- 덮어쓰면 기존 애들 지워짐


	Var["StepFunc"] = DummyFunc

end


function MapMarking( Var )

	if Var == nil then
		return
	end

	if Var["MapIndex"] == nil then
		return
	end


	if Var["MapMarkTime"] == nil then

		Var["MapMarkTime"]   = cCurrentSecond()

	end


	local CurSec = cCurrentSecond()

	if Var["MapMarkTime"] + MAP_MARK_CHK_DLY > CurSec then	-- 맵 마킹 갱신 시간 체크
		return
	end

	Var["MapMarkTime"] = CurSec


	-- 맵마킹 요청할 데이터 테이블 만들어줌
	--{ { Group = 1, x = 100, y = 100, KeepTime = 1000, IconIndex = "chief" }, ... }
	local MapMarkTable = {}

	-- 가디언 위치
	local Num = 0
	for index, value in pairs( Var["Guardian"] ) do

		local mmData = {}
		local Coord  = {}

		Coord["x"], Coord["y"] = cObjectLocate( index )

		mmData["Group"]     = MAPMARK_GROUP["Guardian"] + Num
		mmData["x"]         = Coord["x"]
		mmData["y"]         = Coord["y"]
		mmData["KeepTime"]  = MAPMARK_TIME["Guardian"]
		mmData["IconIndex"] = MAPMARK_ICON["Guardian"]

		MapMarkTable[mmData["Group"]] = mmData

		Num = Num + 1

	end

	Num = 0
	for index, value in pairs( Var["OreList"] ) do

		local mmData = {}
		local Coord  = {}

		Coord["x"], Coord["y"] = cObjectLocate( index )

		mmData["Group"]     = MAPMARK_GROUP["Ore"] + Num
		mmData["x"]         = Coord["x"]
		mmData["y"]         = Coord["y"]
		mmData["KeepTime"]  = MAPMARK_TIME["Ore"]
		mmData["IconIndex"] = MAPMARK_ICON["Ore"]

		MapMarkTable[mmData["Group"]] = mmData

		Num = Num + 1

	end


	for index, value in pairs( Var["ElementMobList"] ) do

		if Var["CurLev"] > 0 and Var["CurLev"] <= Var["RoomNum"] then

			local mmData = {}
			local Coord  = {}

			Coord["x"], Coord["y"] = cObjectLocate( Var["RoomData"][Var["RoomOrder"][Var["CurLev"]]]["Door"] )

			mmData["Group"]     = MAPMARK_GROUP["Door"]
			mmData["x"]         = Coord["x"]
			mmData["y"]         = Coord["y"]
			mmData["KeepTime"]  = MAPMARK_TIME["Door"]
			mmData["IconIndex"] = MAPMARK_ICON["Door"]

			MapMarkTable[mmData["Group"]] = mmData

		end

		break

	end



	cMapMark( Var["MapIndex"], MapMarkTable )

end


function PlayerMapLogin( Field, Player )

	local Var = InstanceField[Field]

	if Var == nil then
		return
	end

	-- 게이트 위치 표시 위해 맵마킹 보내줌
	local MapMarkTable = {}


	for i=1, #ElementRoom do

		local DoorLoc = RoomCoordDataTable[ElementRoom[i]["RoomCoordData"]]["Door"]
		local mmData = {}

		mmData["Group"]     = MAPMARK_GROUP["Door_C"] + i
		mmData["x"]         = DoorLoc["x"]
		mmData["y"]         = DoorLoc["y"]
		mmData["KeepTime"]  = MAPMARK_TIME["Door_C"]
		mmData["IconIndex"] = MAPMARK_ICON["Door_C"]

		MapMarkTable[mmData["Group"]] = mmData

	end


	cMapMark( Field, MapMarkTable )

end

