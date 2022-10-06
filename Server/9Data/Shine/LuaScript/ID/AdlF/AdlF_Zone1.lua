--[[																	]]--
--[[						불타는 아델리아 							]]--
--[[							1지역									]]--
--[[																	]]--

function Zone1_Setting( Var )
cExecCheck "Zone1_Setting"

	if Var == nil then
		return
	end


	-- 어둠의돌 소환
	Var.Zone_1_Darkstone_1 = cMobRegen_XY( Var.MapIndex, RegenInfo.DStone1.Index,
															RegenInfo.DStone1.x,
															RegenInfo.DStone1.y,
															RegenInfo.DStone1.dir )

	-- 공격 당할시 회전 하는 문제 때문에 다시 추가
	cSetAIScript( "ID/AdlF/AdlF", Var.Zone_1_Darkstone_1 )

	-- 루시에 소환
	-- 루시에 HP 50% 상태로 리젠 하는 내용 제거
	Var.LoussierHandle = cMobRegen_XY( Var.MapIndex, RegenInfo.Loussier.Index, RegenInfo.Loussier.x, RegenInfo.Loussier.y, RegenInfo.Loussier.dir )
	Var.Loussier_Stop  = 1	-- 루시에 멈춤 상태

	-- 마렌느, 경비병2명 소환
	Var.Marlene        = cMobRegen_XY( Var.MapIndex, RegenInfo.Marlene.Index,  RegenInfo.Marlene.x,  RegenInfo.Marlene.y,  RegenInfo.Marlene.dir  )
	Var.Guard1         = cMobRegen_XY( Var.MapIndex, RegenInfo.Guard1.Index,   RegenInfo.Guard1.x,   RegenInfo.Guard1.y,   RegenInfo.Guard1.dir   )
	Var.Guard2         = cMobRegen_XY( Var.MapIndex, RegenInfo.Guard2.Index,   RegenInfo.Guard2.x,   RegenInfo.Guard1.y,   RegenInfo.Guard2.dir   )

	if Var.LoussierHandle == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY Loussier" )
		return
	end
	if Var.Marlene == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY Marlene" )
		return
	end
	if Var.Guard1 == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY Guard1" )
		return
	end
	if Var.Guard2 == nil then
		cDebugLog( "Default_Setting : Fail cMobRegen_XY Guard2" )
		return
	end


	-- 루시에 스크립트 셋팅
	if cSetAIScript( "ID/AdlF/AdlF", Var.LoussierHandle ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript Loussier" )
		return
	end


	-- 마렌느, 경비병 스크립트 셋팅
	if cSetAIScript( "ID/AdlF/AdlF", Var.Marlene ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript Marlene" )
		return
	end
	if cSetAIScript( "ID/AdlF/AdlF", Var.Guard1 ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript Guard1" )
		return
	end
	if cSetAIScript( "ID/AdlF/AdlF", Var.Guard2 ) == nil then
		cDebugLog( "Default_Setting : Fail cSetAIScript Guard2" )
		return
	end

	-- 그룹 몹 리젠
	for i=1, #RegenInfo.Zone1_Regen_Group do

		cGroupRegenInstance( Var.MapIndex, RegenInfo.Zone1_Regen_Group[i] )

	end

	-- 정찰자 소환, 상태이상 셋팅
	for i=1, #RegenInfo.Zone1_Regen_Franger do

		local franger = cMobRegen_XY( Var.MapIndex,
									RegenInfo.Zone1_Regen_Franger[i].Index,
									RegenInfo.Zone1_Regen_Franger[i].x,
									RegenInfo.Zone1_Regen_Franger[i].y,
									RegenInfo.Zone1_Regen_Franger[i].dir )

		cSetAbstate( franger, "StaHideWC", 1, 20000000 )

	end


	Var.StepFunc = Zone1_LoussierRescueEvent

	return
end


-- 루시에 구출 이벤트 처리
function Zone1_LoussierRescueEvent( Var )
cExecCheck "Zone1_LoussierRescueEvent"

	if Var == nil then
		return
	end

	local CurSec = cCurrentSecond()

	-- 이벤트 시작 체크
	if Var.Zone1_EventStep == nil then

		-- 지역안에 오브젝트 첫번째가 있는지만 체크
		local Object = cGetAreaObjectList( Var.MapIndex, AreaIndex.Zone1_1, ObjectType.Player )

		if Object == nil then
			return
		end

		Var.Dialog				= nil
		Var.DialogStep			= nil

		Var.Zone1_EventStep		= 1
		Var.Zone1_EventPlayTime = CurSec

		return
	end


	--  1_1, 1_2
	-- 플레이어 행동을 막기위해 상태이상을 걸고, 루시에 쪽으로 카메라 이동
	if Var.Zone1_EventStep == 1 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		local PlayerList	= { cGetPlayerList( Var.MapIndex ) }
		for i=1, #PlayerList do
			if cSetAbstate( PlayerList[i], STUN, 1, 200000 ) == nil then
				cDebugLog( "Zone1_LoussierRescueEvent : cSetAbstate" )
			end
		end

		cCameraMove( Var.MapIndex,
						CameraMoveInfo[1].x,
						CameraMoveInfo[1].y,
						CameraMoveInfo[1].AngleXZ,
						CameraMoveInfo[1].AngleY,
						CameraMoveInfo[1].Dist,		1 )


		Var.Zone1_EventStep		= 2
		Var.Zone1_EventPlayTime	= CurSec + 2

		return
	end


	-- 1_3
	-- 마렌느, 경비병쪽으로 카메라 이동
	if Var.Zone1_EventStep == 2 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		local PlayerList	= { cGetPlayerList( Var.MapIndex ) }
		for i=1, #PlayerList do
			if cSetAbstate( PlayerList[i], STUN, 1, 200000 ) == nil then
				cDebugLog( "Zone1_LoussierRescueEvent : cSetAbstate" )
			end
		end

		cCameraMove( Var.MapIndex,
				CameraMoveInfo[2].x,
				CameraMoveInfo[2].y,
				CameraMoveInfo[2].AngleXZ,
				CameraMoveInfo[2].AngleY,
				CameraMoveInfo[2].Dist,		1 )



		Var.Zone1_EventStep		= 3
		Var.Zone1_EventPlayTime	= CurSec + 2

		return
	end


	-- 1_4
	-- NPC 대화
	if Var.Zone1_EventStep == 3 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		if Var.Dialog == nil then
			Var.Dialog		= DialogInfo.Loussier_Rescue_Event
			Var.DialogStep	= 1

		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone1_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog				= nil
		Var.DialogStep			= nil

		Var.Zone1_EventStep		= 4
		Var.Zone1_EventPlayTime	= CurSec

		return
	end


	-- 1_5
	-- 카메라 루시에 위치로 이동
	if Var.Zone1_EventStep == 4 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		local PlayerList	= { cGetPlayerList( Var.MapIndex ) }
		for i=1, #PlayerList do
			if cSetAbstate( PlayerList[i], STUN, 1, 200000 ) == nil then
				cDebugLog( "Zone1_LoussierRescueEvent : cSetAbstate" )
			end
		end

		cCameraMove( Var.MapIndex,
				CameraMoveInfo[3].x,
				CameraMoveInfo[3].y,
				CameraMoveInfo[3].AngleXZ,
				CameraMoveInfo[3].AngleY,
				CameraMoveInfo[3].Dist,		1 )


		Var.Zone1_EventStep		= 5
		Var.Zone1_EventPlayTime	= CurSec + 1

		return
	end


	-- 1_6, ( 1_7 )
	-- 몹 소환
	if Var.Zone1_EventStep == 5 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end


		Var.Zone1_Event_Mob = {}

		for i=1, #RegenInfo.Zone1_Event do
			Var.Zone1_Event_Mob[i] = cMobRegen_XY( Var.MapIndex, RegenInfo.Zone1_Event[i].Index,
																	RegenInfo.Zone1_Event[i].x,
																	RegenInfo.Zone1_Event[i].y,
																	RegenInfo.Zone1_Event[i].dir )
		end

		Var.Zone1_EventStep		= 6
		Var.Zone1_EventPlayTime	= CurSec + 2

		return
	end


	-- 1_8
	-- 카메라 원위치로 하기전 상태이상 제거
	if Var.Zone1_EventStep == 6 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		local PlayerList	= { cGetPlayerList( Var.MapIndex ) }
		for i=1, #PlayerList do
			if cResetAbstate( PlayerList[i], STUN ) == nil then
				cDebugLog( "Zone1_LoussierRescueEvent : Fail cResetAbstate" )
			end
		end

		Var.Zone1_EventStep		= 7
		Var.Zone1_EventPlayTime	= CurSec

		return
	end


	-- 1_8
	-- 카메라 원위치
	if Var.Zone1_EventStep == 7 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end


		cCameraMove( Var.MapIndex, 0, 0, 0, 0, 0, 0 )


		Var.Zone1_EventStep		= 8
		Var.Zone1_EventPlayTime	= CurSec + 1

		return
	end


	-- 1_9
	-- 경비병, 마렌느 루시에쪽으로 이동
	if Var.Zone1_EventStep == 8 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		cNPCVanish( Var.Marlene )
		cNPCVanish( Var.Guard1 )
		cNPCVanish( Var.Guard2 )

		Var.Marlene	= cMobRegen_Obj( RegenInfo.Marlene.Index, Var.LoussierHandle )
		Var.Guard1	= cMobRegen_Obj( RegenInfo.Guard1.Index,  Var.LoussierHandle )
		Var.Guard2	= cMobRegen_Obj( RegenInfo.Guard2.Index,  Var.LoussierHandle )


		-- 마렌느 및 경비병 루시에 죽을때, 마렌느 죽을때 처리등의 문제로 수정
		cSetAIScript( "ID/AdlF/AdlF", Var.Marlene )
		cSetAIScript( "ID/AdlF/AdlF", Var.Guard1  )
		cSetAIScript( "ID/AdlF/AdlF", Var.Guard2  )


		Var.Loussier_Stop  = nil -- 루시에 멈춤 상태 해제

		Var.Zone1_EventStep		= 9
		Var.Zone1_EventPlayTime	= CurSec

		return
	end


	-- 1_10
	-- 공지 출력
	if Var.Zone1_EventStep == 9 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end


		-- 마렌느 및 경비병 루시에 죽을때, 마렌느 죽을때 처리등의 문제로 수정
		if GuardMemBlock[Var.Marlene] ~= nil then
			GuardMemBlock[Var.Marlene].StepFunc = GuarderActivity
		end
		if GuardMemBlock[Var.Guard1] ~= nil then
			GuardMemBlock[Var.Guard1].StepFunc = GuarderActivity
		end
		if GuardMemBlock[Var.Guard2] ~= nil then
			GuardMemBlock[Var.Guard2].StepFunc = GuarderActivity
		end

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_01_001 )

		Var.Zone1_EventStep		= 10
		Var.Zone1_EventPlayTime	= CurSec

		return
	end



	Var.Zone1_EventStep		= nil
	Var.Zone1_EventPlayTime	= nil

	Var.StepFunc			= Zone1_LoussierRescueEnd

	return
end


-- 루시에 구출 이벤트 종료
function Zone1_LoussierRescueEnd( Var )
cExecCheck "Zone1_LoussierRescueEnd"

	if Var == nil then
		return
	end


	local CurSec = cCurrentSecond()

	-- 1_11, 1_12
	-- 구출이벤트 종료 조건 체크
	if Var.Zone1_EventStep == nil then

		-- 루시에가 죽었을 경우, ( stepcontrol 에서 매루틴 루시에 체크 )
		if Var.LoussierHandle == nil then

			Var.Dialog				= DialogInfo.Loussier_Rescue_Fail
			Var.DialogStep			= 1

			Var.Zone1_EventStep		= 1
			Var.Zone1_EventPlayTime = CurSec + 2

			return
		end

		local chkEventMob = 0
		-- 몹 전부 죽었는지 체크
		for index, value in pairs( Var.Zone1_Event_Mob ) do
			if value ~= nil then
				if cIsObjectDead( value ) ~= nil then
					Var.Zone1_Event_Mob[index] = nil
				end

				chkEventMob = 1
			end
		end


		if chkEventMob == 1 then
			return
		end

		-- 몹이 다 죽었을 경우
		Var.Zone1_Event_Mob		= nil

		Var.Dialog				= DialogInfo.Loussier_Rescue_Succ
		Var.DialogStep			= 1

		Var.Zone1_EventStep		= 1
		Var.Zone1_EventPlayTime = CurSec + 2

		return
	end


	if Var.Zone1_EventStep == 1 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		-- 마렌느 및 경비병 루시에 죽을때, 마렌느 죽을때 처리등의 문제로 수정
		if GuardMemBlock[Var.Marlene] ~= nil then
			GuardMemBlock[Var.Marlene].StepFunc = GuarderStop
		end
		if GuardMemBlock[Var.Guard1] ~= nil then
			GuardMemBlock[Var.Guard1].StepFunc = GuarderStop
		end
		if GuardMemBlock[Var.Guard2] ~= nil then
			GuardMemBlock[Var.Guard2].StepFunc = GuarderStop
		end


		cFollow( Var.Marlene, Var.LoussierHandle, 100, 1000 )
		cFollow( Var.Guard1,  Var.LoussierHandle, 100, 1000 )
		cFollow( Var.Guard2,  Var.LoussierHandle, 100, 1000 )


		Var.Zone1_EventStep		= 2
		Var.Zone1_EventPlayTime = CurSec

		return
	end



	-- 1_13_S, 1_14_S, 1_13_F
	-- 해당 대화 출력
	if Var.Zone1_EventStep == 2 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		if Var.DialogStep <= #Var.Dialog then

			cMobDialog( Var.MapIndex,
						Var.Dialog[Var.DialogStep].Portrait,
						Var.Dialog[Var.DialogStep].FileName,
						Var.Dialog[Var.DialogStep].Index )

			Var.Zone1_EventPlayTime	= CurSec + Var.Dialog[Var.DialogStep].Delay

			Var.DialogStep = Var.DialogStep + 1

			return
		end


		Var.Dialog				= nil
		Var.DialogStep			= nil

		Var.Zone1_EventStep		= 3
		Var.Zone1_EventPlayTime	= CurSec + 4

		return
	end


	-- 1_14_F
	-- 공지 출력
	if Var.Zone1_EventStep == 3 then

		if Var.Zone1_EventPlayTime > CurSec then
			return
		end

		cScriptMessage( Var.MapIndex, AnnounceInfo.AdlF_Mission_01_002 )

		Var.Zone1_EventStep		= 4
		Var.Zone1_EventPlayTime	= CurSec

		return
	end


	Var.Zone1_EventStep		= nil
	Var.Zone1_EventPlayTime	= nil

	Var.StepFunc			= Dummy

	return
end




