
function PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, nRunSpeedRate )
	cExecCheck( "PetBaseExecIdleAction" )

	if PetMem == nil
	then
		ErrorLog( "PetBaseExecIdleAction::PetMem is nil" )
		return false
	end

	if type( nStepOffset ) ~= "number"
	then
		ErrorLog( "PetBaseExecIdleAction::nStepOffset is not number" )
		return false
	end

	if type( tStepInfo ) ~= "table"
	then
		ErrorLog( "PetBaseExecIdleAction::tStepInfo is not table" )
		return false
	end

	if type( nRunSpeedRate ) ~= "number"
	then
		ErrorLog( "PetBaseExecIdleAction::nRunSpeedRate is not number" )
		return false
	end

	local nHandle		= PetMem["nHandle"]
	local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
	local tCenterCoord 	= PetMem["PetInfo"]["Coord"]["Center"]
	local tStepHeader 	= PetSystem_tIdleActionData["tHeader"]

	-- 해당 단계가 유효하면 실행
	if PetMem["PetInfo"]["nIdleStep"] - nStepOffset <= #tStepInfo
	then
		local tCurStep = tStepInfo[ PetMem["PetInfo"]["nIdleStep"] - nStepOffset ]

		local nStepType 		= tCurStep[ tStepHeader["nStepType"] ]
		local nNextStepCondType = tCurStep[ tStepHeader["nNextStepCondType"] ]

		-- 각 스텝 타입별 행동 ( 각 단계당 1회만 실행한다 )
		if PetMem["PetInfo"]["bCurIdleStepActionDone"] ~= true
		then
			if nStepType == PISAT_MOVE	-----------------------------------------------------------------------------------------------------------PISAT_MOVE
			then
				local nTargetX = tCurStep[ tStepHeader["nX"] ] + tCenterCoord["x"]
				local nTargetY = tCurStep[ tStepHeader["nY"] ] + tCenterCoord["y"]

				cRunTo( nHandle, nTargetX, nTargetY, nRunSpeedRate )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = nTargetX
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = nTargetY
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_MOVE" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_MOVE" )

			elseif nStepType == PISAT_ROTATION	-----------------------------------------------------------------------------------------------------------PISAT_ROTATION
			then
				local nCurDirect = cGetDirect( nHandle );
				if nCurDirect ~= nil
				then
					local nDirect360 = tCurStep[ tStepHeader["nDir"] ] + nCurDirect

					-- 0~359 맞추기
					if nDirect360 >= 360
					then
						nDirect360 = nDirect360 - 360
					end

					if nDirect360 < 0
					then
						nDirect360 = nDirect360 + 360
					end

					-- 0~179 맞추기
					local nDirect180 = nDirect360 / 2

					cSetObjectDirect( nHandle, nDirect180 )

				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_ROTATION" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_ROTATION" )

			elseif nStepType == PISAT_ATTACK	-----------------------------------------------------------------------------------------------------------PISAT_ATTACK
			then
				-- 애니메이션은 펫 종류마다 다른 것을 사용해야하는 단점이 있어서 이벤트 코드를 직접 사용하기로 함
				if cActByEventCode( nHandle, PetSystem_ActionEventCode["Attack"] ) == nil
				then
					ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Attack" )
				end
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

				CheckLog( "PetBaseExecIdleAction::nStepType == PISAT_ATTACK" )
				DebugLog( "PetBaseExecIdleAction::nStepType == PISAT_ATTACK" )

			elseif nStepType == PISAT_DANCE
			then
				if cActByEventCode( nHandle, PetSystem_ActionEventCode["Dance"] ) == nil
				then
					ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Dance" )
				end
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = true

			else
				-- 잘못된 모드 : 데이터 점검 요청
				ErrorLog( "PetBaseExecIdleAction::Please Check PetBaseActionData : nStepType Column" )
			end
		end

		-- 각 다음 스텝 조건별 행동
		if nNextStepCondType == PNIST_DISTANCE	-----------------------------------------------------------------------------------------------------------PNIST_DISTANCE
		then
			local nDistanceSquare = cDistanceSquar( tPetCoord["x"], tPetCoord["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
			local nDistanceCond = tCurStep[ tStepHeader["nNextStepDistance"] ]
			local nDistanceSquareCond = GetSquare( nDistanceCond )

			-- 조건으로 지정한 거리 안으로 들어오면 다음 스텝으로
			if ( nDistanceSquare <= nDistanceSquareCond )
			then
				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] + 1
				if PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"]
				then
					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] - #tStepInfo
				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = false
			end

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_DISTANCE" )

		elseif nNextStepCondType == PNIST_TIME	-----------------------------------------------------------------------------------------------------------PNIST_TIME
		then
			local nTimeCond = tCurStep[ tStepHeader["dNextStepTime"] ]

			-- 현 스텝 첫 진입시 다음스텝 시간 설정
			if PetMem["PetInfo"]["dNextIdleStepTime"] == PetMem["InitialSec"]
			then
				PetMem["PetInfo"]["dNextIdleStepTime"] = PetMem["CurSec"] + nTimeCond
			end

			-- 시간 되면 다음 스텝으로
			if PetMem["PetInfo"]["dNextIdleStepTime"] < PetMem["CurSec"]
			then
				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] + 1
				if PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"]
				then
					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleStep"] - #tStepInfo
				end

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				PetMem["PetInfo"]["bCurIdleStepActionDone"] = false

				-- 체크 시간 초기화
				PetMem["PetInfo"]["dNextIdleStepTime"] = PetMem["InitialSec"]
			end

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_TIME" )

		elseif nNextStepCondType == PNIST_END -- 스텝 종료-----------------------------------------------------------------------------------------------------------PNIST_END
		then
			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			DebugLog( "PetBaseExecIdleAction::nNextStepCondType == PNIST_END" )

		else
			-- 잘못된 조건 : 데이터 점검 요청
			ErrorLog( "PetBaseExecIdleAction::Please Check PetBaseActionData : nNextStepCondType Column" )
		end

		return true

	else
		ErrorLog( "PetBaseExecIdleAction::PetMem[\"PetInfo\"][\"nIdleStep\"] is too big" )
		return false

	end
end



function PetBaseIdleAction( PetMem, tPetIdleActRecord )
	cExecCheck( "PetBaseIdleAction" )

	if PetMem == nil
	then
		DebugLog( "PetBaseIdleAction::PetMem is nil" )
		return false
	end

	local nHandle 			= PetMem["PetInfo"]["nHandle"]
	local nMasterHandle		= PetMem["MasterInfo"]["nHandle"]
	local tPetCoord 		= PetMem["PetInfo"]["Coord"]["Cur"]
	local tMasterCoord 		= PetMem["MasterInfo"]["Coord"]["Cur"]
	local tMasterLastCoord 	= PetMem["MasterInfo"]["Coord"]["Last"]

	if tPetIdleActRecord == nil
	then
		ErrorLog( "PetBaseIdleAction::tPetIdleActRecord == nil" )
		return false
	end


	-- 액션 종류 가져오기
	local sAIType = tPetIdleActRecord[ 1 ]

	if sAIType == "none"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_NONE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_NONE:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "follow"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_FOLLOW
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "revolution"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_REVOLUTION
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "dance"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_DANCE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "attack"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ATTACK
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "roaming"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROAMING
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "rotation"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROTATION
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "talk"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_TALK
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:Selected - nHandle( "..nHandle.." )" )
	elseif sAIType == "die"
	then
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_DIE
		DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:Selected - nHandle( "..nHandle.." )" )
	else
		PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_INVALID
		ErrorLog( "PetBaseIdleAction::sAIType is invalid" )
		return false
	end

	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
--	PetMem["PetInfo"]["PetMode"]["nIdleActionMode"] = PIAM_ROAMING
--	DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:Forced - nHandle( "..nHandle.." )" )
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------


	local nIdleActionMode 		= PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]

	local sScriptMessageIndex 	= tPetIdleActRecord[ 2 ]
	local sHairEffect 			= tPetIdleActRecord[ 3 ]
	local sSoundFile 			= tPetIdleActRecord[ 4 ]

	if sScriptMessageIndex == nil
	then
		ErrorLog( "PetBaseIdleAction::sScriptMessageIndex is invalid" )
		return false
	end

	if sHairEffect == nil
	then
		ErrorLog( "PetBaseIdleAction::sHairEffect is invalid" )
		return false
	end

	if sSoundFile == nil
	then
		ErrorLog( "PetBaseIdleAction::sSoundFile is invalid" )
		return false
	end

	-- 패턴별 행동
	if nIdleActionMode == PIAM_NONE	-----------------------------------------------------------------------------------------------------------PIAM_NONE
	then
		-- 없음
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 1

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

	elseif nIdleActionMode == PIAM_FOLLOW	-----------------------------------------------------------------------------------------------------------PIAM_FOLLOW
	then
		-- 5초동안 동작, 주인과의 거리 500제한
		-- 펫 따라감 : 200이내 펫 선택, 30거리까지 계속 접근, 80 이상 이동시작(임의로 정함)

		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3

			-- 주변 펫 탐색
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleFollowingPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- 주변 펫 따라다니기 액션을 할 경우 주위 펫에게 영향 줌
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- 각 펫에다가 마인드 변화 명령 루아 고고고고고고고고
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "follow" );
					end
				end
			end

			-- 선택된 펫 위치 탐색
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end


		-- 해당 펫이 유효하면 실행
		if PetMem["TargetInfo"]["nHandle"] >= 0
		then
			-- RubyFruit 2013.11.23 임시 로그
			DebugLog( "PetBaseIdleAction::PIAM_FOLLOW::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )

			local nDistanceSquarePet	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
			local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )
			----------------------------------------------------------------------
			---------- //거리별 Pattern Decision ---------------------------------
			if nDistanceSquarePet < PS_nDS_IdleFollowingPetStop
			then
				-- 아무것도 안함
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:STOP - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif nDistanceSquareMaster < PS_nDS_IdleFollowingPetStayMax
			then
				-- 펫 따라감
				--cRunTo( nHandle, PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nSpeedRateFollowingMil )
				cFollow( nHandle, PetMem["TargetInfo"]["nHandle"], PetFollowGap, PetFollowStop  )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:START - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 2

			else
				-- 취소 조건 : 거리
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by Distance - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end
			---------- 거리별 Pattern Decision// ---------------------------------
			----------------------------------------------------------------------

			-- 시간제한 체크
			if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleFollow <= PetMem["CurSec"]
			then
				-- 취소 조건 : 시간
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by Time - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end

		else
			-- 펫이 무효 - 행동 취소
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_FOLLOW:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end

	elseif nIdleActionMode == PIAM_REVOLUTION	-----------------------------------------------------------------------------------------------------------PIAM_REVOLUTION
	then
		-- 10초동안 동작, 주인 멈춰있을때만 동작, 상대 펫 주인 멈춰있을때만 동작
		-- 200이내 펫 선택, 30거리까지 접근, 펫 주위를 빙빙 돔 30 반지름으로
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3 + #PetSystem_tIdleActionData["tData"]["tRevolution"]

			-- 주변 펫 탐색
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleRevolutionPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- 주변 펫 공전 액션을 할 경우 주위 펫에게 영향 줌
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- 각 펫에다가 마인드 변화 명령 루아 고고고고고고고고
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "revolution" );
					end
				end
			end

			-- 선택된 펫 위치 탐색
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			-- 공전 중심 좌표 셋팅
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

			local nTargetPetMasterHandle = cGetMaster( PetMem["TargetInfo"]["nHandle"] )
			if nTargetPetMasterHandle == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["nHandle"] = nTargetPetMasterHandle

			local nTargetMasterX, nTargetMasterY = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if nTargetMasterX == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]		= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]		= nTargetMasterY
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["x"]	= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["y"]	= nTargetMasterY


			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- 해당 펫과 해당 펫 마스터가 유효하면 실행
		if PetMem["TargetInfo"]["nHandle"] >= 0 and PetMem["TargetMasterInfo"]["nHandle"] >= 0
		then

			-- RubyFruit 2013.11.23 임시 로그
			DebugLog( "PetBaseIdleAction::PIAM_REVOLUTION::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- 단계별 실행
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then
				-- 첫 스텝
				-- 처음에만 펫으로 향함
				local nDistanceSquare 	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				----------------------------------------------------------------------
				---------- //거리별 Pattern Decision ---------------------------------
				if nDistanceSquare > PS_nDS_IdleRevolutionPetStart
				then
					-- 펫 따라감
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nDistanceIdleRevolutionPetStop )
					cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:START Follow - nHandle( "..nHandle.." )" )
				end
				---------- 거리별 Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then
				-- 두번째 스텝
				local nDistanceSquare = cDistanceSquar( PetMem["PetInfo"]["Coord"]["Cur"]["x"], PetMem["PetInfo"]["Coord"]["Cur"]["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
				----------------------------------------------------------------------
				---------- //거리별 Pattern Decision ---------------------------------
				if nDistanceSquare <= PS_nDS_IdleRevolutionPetStop
				then

					PetMem["PetInfo"]["nIdleStep"] = 3

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:STOP Follow - nHandle( "..nHandle.." )" )
				end
				---------- 거리별 Pattern Decision// ---------------------------------
				----------------------------------------------------------------------



			elseif PetMem["PetInfo"]["nIdleStep"] > 2 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
			then
				-- 공전스텝 3 ~ 10
				local nStepOffset 	= 2
				local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tRevolution"]

				if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
				then
					ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
				end
				cExecCheck( "PetBaseIdleAction" )
			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
				-- 끝이므로 아무것도 안하고 뒤로 넘김
			end
			-- 단계별 실행 구간 종료
			----------------------------------------------------------------------



			-- 시간제한 체크
			if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRevolution <= PetMem["CurSec"]
			then
				-- 취소 조건 : 시간
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Time - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
			end

			-- 마스터 움직임 체크
			if IsPetMasterMoved( PetMem ) == true
			then
				-- 취소 조건 : 마스터 이동
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end
			cExecCheck( "PetBaseIdleAction" )

			-- 상대방 펫 마스터 움직임 체크
			local tTargetPetMasterLastCoord	= PetMem["TargetMasterInfo"]["Coord"]["Last"]
			local tTargetPetMasterCurCoord	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]

			tTargetPetMasterLastCoord["x"]	= tTargetPetMasterCurCoord["x"]
			tTargetPetMasterLastCoord["y"]	= tTargetPetMasterCurCoord["y"]

			tTargetPetMasterCurCoord["x"], tTargetPetMasterCurCoord["y"] = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if tTargetPetMasterCurCoord["x"] == nil
			then
				-- 취소 조건 : 상대 펫 마스터 어디니
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Cannot Find Target Pet Master - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

			if tTargetPetMasterLastCoord["x"] ~= tTargetPetMasterCurCoord["x"] or tTargetPetMasterLastCoord["y"] ~= tTargetPetMasterCurCoord["y"]
			then
				-- 취소 조건 : 상대 펫 마스터 이동
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by Target Pet Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

		else
			-- 펫이 무효 - 행동 취소
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_REVOLUTION:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_DANCE	-----------------------------------------------------------------------------------------------------------PIAM_DANCE
	then
		-- 10초동안 동작, 주인 멈춰있을때만 동작
		-- 제자리 좌둘 우둘 공격 : 왼쪽 보기, 공격, 공격, 오른쪽보기, 공격, 공격
		-- 제자리 3번돌기 : 반바퀴를 1초에 도는 속도로.. 0도 15도 30도 45도 60도 75도 90도 105도 120도 135도 150도 165도 0도... 반복
		-- 별표그리기 : 거리 100 이내 별???????? 좌표 5개 찍고 근처 30 이내 갈때마다 이동 위치 전환
		-- 제자리돌며 원그리기 팽이가 빙글빙글 : 반경 50 이내 원을 자전 1초에 한바퀴 공전 1초에 20% 돌기
		-- 원그리기 그냥 원모양으로 이동 : 공전 1초에 33.3% 돌기


		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["nCurDanceNo"] = cRandomInt( 1, #PetSystem_tIdleActionData["tData"]["ttDance"] )
			DebugLog( "PetBaseIdleAction::PIAM_DANCE::nCurDanceNo = "..PetMem["PetInfo"]["nCurDanceNo"].." has been selected" )
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2 + #PetSystem_tIdleActionData["tData"]["ttDance"][ PetMem["PetInfo"]["nCurDanceNo"] ]
			PetMem["PetInfo"]["Time"]["DanceStartTime"] = PetMem["CurSec"]

			-- 댄스 중심 좌표 셋팅
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 임시 로그
		DebugLog( "PetBaseIdleAction::PIAM_DANCE::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- 단계별 실행
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- 첫 스텝

			PetMem["PetInfo"]["nIdleStep"] = 2
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:START Dance - nHandle( "..nHandle.." )" )

		elseif PetMem["PetInfo"]["nIdleStep"] > 1 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
		then
			-- 댄스스텝 : 2 ~

			local nStepOffset 	= 1
			local tStepInfo 	= PetSystem_tIdleActionData["tData"]["ttDance"][ PetMem["PetInfo"]["nCurDanceNo"] ]

			if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
			then
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
			end
			cExecCheck( "PetBaseIdleAction" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
			-- 끝이므로 아무것도 안하고 뒤로 넘김
		end
		-- 단계별 실행 구간 종료
		----------------------------------------------------------------------

		-- 시간제한 체크
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleDance <= PetMem["CurSec"]
		then
			-- 취소 조건 : 시간
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			-- 제한시간까지 춤 췄을 경우 주위 펫에게 영향 줌
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleMindChangePetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- 각 펫에다가 마인드 변화 명령 루아 고고고고고고고고
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "dance" );
					end

				end
			end

		end

		-- 마스터 움직임 체크
		if IsPetMasterMoved( PetMem ) == true
		then
			-- 취소 조건 : 마스터 이동
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DANCE:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_ATTACK	-----------------------------------------------------------------------------------------------------------PIAM_ATTACK
	then
		-- 1루틴만 동작, 주인 멈춰있을때만 동작, 상대 펫 주인 멈춰있을때만 동작
		-- 주변 펫 공격 : 200거리 이내 펫 선택, 방향전환, 공격, 공격, 공격
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3 + #PetSystem_tIdleActionData["tData"]["tAttack"]


			-- 주변 펫 탐색
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleAttackPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- 주변 펫 공격 액션을 할 경우 주위 펫에게 영향 줌
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- 각 펫에다가 마인드 변화 명령 루아 고고고고고고고고
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "attack" );
					end
				end
			end

			-- 선택된 펫 위치 탐색
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			-- 어택 중심 좌표 셋팅
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = tTargetPetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = tTargetPetCoord["y"]

			local nTargetPetMasterHandle = cGetMaster( PetMem["TargetInfo"]["nHandle"] )
			if nTargetPetMasterHandle == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["nHandle"] = nTargetPetMasterHandle

			local nTargetMasterX, nTargetMasterY = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if nTargetMasterX == nil
			then
				nTargetPetMasterHandle = -1
			end

			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["x"]		= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Cur"]["y"]		= nTargetMasterY
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["x"]	= nTargetMasterX
			PetMem["TargetMasterInfo"]["Coord"]["Last"]["y"]	= nTargetMasterY

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- 해당 펫과 해당 펫의 마스터가 유효하면 실행
		if PetMem["TargetInfo"]["nHandle"] >= 0 and PetMem["TargetMasterInfo"]["nHandle"] >= 0
		then
			-- RubyFruit 2013.11.23 임시 로그
			DebugLog( "PetBaseIdleAction::PIAM_ATTACK::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- 단계별 실행
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then

				local nDir4 = cRandomInt( 1, 90 )
				local nGoalX, nGoalY = cGetAroundCoord( PetMem["TargetInfo"]["nHandle"], nDir4*4, PetFollowGap )

				cRunTo( nHandle, nGoalX, nGoalY, PetSystem_nSpeedRateFollowingMil )

				PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then

				local nDistanceSquarePet	= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )

				if nDistanceSquarePet < PS_nDS_IdleFollowingPetStop
				then

					-- 다른 펫 쪽으로 방향 전환
					local tTargetCoord = PetMem["TargetInfo"]["Coord"]["Cur"]
					cSetObjectDirect( nHandle, tTargetCoord["x"], tTargetCoord["y"] )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]

					PetMem["PetInfo"]["nIdleStep"] = 3

				elseif nDistanceSquareMaster < PS_nDS_IdleFollowingPetStayMax
				then

					PetMem["PetInfo"]["Coord"]["Next"]["x"] = PetMem["TargetInfo"]["Coord"]["Cur"]["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = PetMem["TargetInfo"]["Coord"]["Cur"]["y"]

				else

					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

				end

			elseif PetMem["PetInfo"]["nIdleStep"] > 2 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
			then
				-- 공격스텝 3 ~ 5
				local nStepOffset 	= 2
				local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tAttack"]

				if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, 0 ) ~= true
				then
					ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
				end
				cExecCheck( "PetBaseIdleAction" )

			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
				-- 끝이므로 아무것도 안하고 뒤로 넘김
			end
			-- 단계별 실행 구간 종료
			----------------------------------------------------------------------

			----------------------------------------------------------------------
			-- 마스터 움직임 체크
			if IsPetMasterMoved( PetMem ) == true
			then
				-- 취소 조건 : 마스터 이동
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end
			cExecCheck( "PetBaseIdleAction" )

			-- 상대방 펫 마스터 움직임 체크
			local tTargetPetMasterLastCoord	= PetMem["TargetMasterInfo"]["Coord"]["Last"]
			local tTargetPetMasterCurCoord	= PetMem["TargetMasterInfo"]["Coord"]["Cur"]

			tTargetPetMasterLastCoord["x"]	= tTargetPetMasterCurCoord["x"]
			tTargetPetMasterLastCoord["y"]	= tTargetPetMasterCurCoord["y"]

			tTargetPetMasterCurCoord["x"], tTargetPetMasterCurCoord["y"] = cObjectLocate( PetMem["TargetMasterInfo"]["nHandle"] )
			if tTargetPetMasterCurCoord["x"] == nil
			then
				-- 취소 조건 : 상대 펫 마스터 어디?
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Cannot Find Target Pet Master - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

			if tTargetPetMasterLastCoord["x"] ~= tTargetPetMasterCurCoord["x"] or tTargetPetMasterLastCoord["y"] ~= tTargetPetMasterCurCoord["y"]
			then
				-- 취소 조건 : 상대 펫 마스터 이동
				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by Target Pet Master Move - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			end

		else
			-- 펫이 무효 - 행동 취소
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ATTACK:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_ROAMING	-----------------------------------------------------------------------------------------------------------PIAM_ROAMING
	then
		-- 그냥 처리
		-- 20초동안 동작, 주인 멈춰있을때만 동작
		-- 그냥 막 움직여 ㅋㅋㅋㅋㅋㅋㅋㅋㅋ
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end


		-- RubyFruit 2013.11.23 임시 로그
		DebugLog( "PetBaseIdleAction::PIAM_ROAMING::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- 단계별 실행
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- 첫 스텝

			-- 아무데나 찍고 이동
			local tTargetCoord = {}

			tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tPetCoord["x"], tPetCoord["y"], PetSystem_nDistanceIdleRoamingMax )

			if tTargetCoord["x"] ~= nil
			then
				cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:START Roaming - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 1
			end

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
			-- 끝이므로 아무것도 안하고 뒤로 넘김
		end
		-- 단계별 실행 구간 종료
		----------------------------------------------------------------------


		-- 시간제한 체크
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRoaming <= PetMem["CurSec"]
		then
			-- 취소 조건 : 시간
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

		-- 마스터 움직임 체크
		if IsPetMasterMoved( PetMem ) == true
		then
			-- 취소 조건 : 마스터 이동
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROAMING:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_ROTATION	-----------------------------------------------------------------------------------------------------------PIAM_ROTATION
	then
		-- 10초동안 동작, 주인 멈춰있을때만 동작
		-- 자전 : 20%를 1초에 도는 속도로.. 0도, 10도, 20도, 30도, 40도, ... , 350도, 0도... 반복
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 2 + #PetSystem_tIdleActionData["tData"]["tRotation"]

			-- 회전 중심 좌표 셋팅
			PetMem["PetInfo"]["Coord"]["Center"]["x"] = PetMem["PetInfo"]["Coord"]["Cur"]["x"]
			PetMem["PetInfo"]["Coord"]["Center"]["y"] = PetMem["PetInfo"]["Coord"]["Cur"]["y"]

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 임시 로그
		DebugLog( "PetBaseIdleAction::PIAM_ROTATION::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- 단계별 실행
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- 첫 스텝
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:START Pattern- nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = 2

		elseif PetMem["PetInfo"]["nIdleStep"] > 1 and PetMem["PetInfo"]["nIdleStep"] < PetMem["PetInfo"]["nIdleEndStep"]
		then
			-- 자전스텝 2 ~ 41
			local nStepOffset 	= 1
			local tStepInfo 	= PetSystem_tIdleActionData["tData"]["tRotation"]

			if PetBaseExecIdleAction( PetMem, nStepOffset, tStepInfo, PetSystem_nSpeedRateFollowingMil ) ~= true
			then
				ErrorLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:PetBaseExecIdleAction Failed - nHandle( "..nHandle.." )" )
			end
			cExecCheck( "PetBaseIdleAction" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
			-- 끝이므로 아무것도 안하고 뒤로 넘김
		end
		-- 단계별 실행 구간 종료
		----------------------------------------------------------------------

		-- 시간제한 체크
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleRotation <= PetMem["CurSec"]
		then
			-- 취소 조건 : 시간
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

		-- 마스터 움직임 체크
		if IsPetMasterMoved( PetMem ) == true
		then
			-- 취소 조건 : 마스터 이동
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_ROTATION:CANCEL by Master Move - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

		end
		cExecCheck( "PetBaseIdleAction" )

	elseif nIdleActionMode == PIAM_TALK	-----------------------------------------------------------------------------------------------------------PIAM_TALK
	then
		-- 그냥 처리
		-- 1회 : 말하는 스텝이 정해져 있음 하고나서 초기화
		-- 주변 펫 에게 다가가서 말하기 : 200거리 이내 펫 선택, 펫에게 30거리까지 접근, 방향전환 투 펫, 말하기 주인과 300이상벌어지면 끝
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 5

			-- 주변 펫 탐색
			local nTargetPetHandle = -1
			local tHandleList = { cNearObjectList( nHandle, PetSystem_nDistanceIdleTalkPetSelectMax, ObjectType["Pet"] ) }
			if #tHandleList > 0
			then
				nTargetPetHandle = tHandleList[ cRandomInt( 1, #tHandleList ) ]

				-- 주변 펫 에게 말하는 액션을 할 경우 주위 펫에게 영향 줌
				for i, nCurPetHandle in pairs( tHandleList )
				do
					-- 각 펫에다가 마인드 변화 명령 루아 고고고고고고고고
					if nCurPetHandle ~= nHandle
					then
						cPet_ChangeMind( nCurPetHandle, "talk" );
					end
				end
			end

			-- 선택된 펫 위치 탐색
			local tTargetPetCoord = {}
			tTargetPetCoord["x"], tTargetPetCoord["y"] = cObjectLocate( nTargetPetHandle )
			if tTargetPetCoord["x"] == nil
			then
				nTargetPetHandle = -1
			end

			PetMem["TargetInfo"]["nHandle"] = nTargetPetHandle
			PetMem["TargetInfo"]["Coord"]["Cur"]["x"] = tTargetPetCoord["x"]
			PetMem["TargetInfo"]["Coord"]["Cur"]["y"] = tTargetPetCoord["y"]

			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- 해당 펫이 유효하면 실행
		if PetMem["TargetInfo"]["nHandle"] >= 0
		then

			-- RubyFruit 2013.11.23 임시 로그
			DebugLog( "PetBaseIdleAction::PIAM_TALK::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
			----------------------------------------------------------------------
			-- 단계별 실행
			if PetMem["PetInfo"]["nIdleStep"] == 1
			then
				-- 첫 스텝
				-- 처음에만 펫으로 향함
				local nDistanceSquare 		= cDistanceSquar( nHandle, PetMem["TargetInfo"]["nHandle"] )
				----------------------------------------------------------------------
				---------- //거리별 Pattern Decision ---------------------------------
				if nDistanceSquare > PS_nDS_IdleTalkPetStart
				then
					-- 펫 따라감
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( PetMem["TargetInfo"]["Coord"]["Cur"]["x"], PetMem["TargetInfo"]["Coord"]["Cur"]["y"], PetSystem_nDistanceIdleRevolutionPetStop )
					cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START Follow - nHandle( "..nHandle.." )" )
				end
				---------- 거리별 Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

				PetMem["PetInfo"]["nIdleStep"] = 2

			elseif PetMem["PetInfo"]["nIdleStep"] == 2
			then
				-- 두번째 스텝 : 마스터와의 거리를 체크하며 다른펫에게 다가감
				local nDistanceSquare 		= cDistanceSquar( PetMem["PetInfo"]["Coord"]["Cur"]["x"], PetMem["PetInfo"]["Coord"]["Cur"]["y"], PetMem["PetInfo"]["Coord"]["Next"]["x"], PetMem["PetInfo"]["Coord"]["Next"]["y"] )
				local nDistanceSquareMaster	= cDistanceSquar( nHandle, nMasterHandle )
				----------------------------------------------------------------------
				---------- //거리별 Pattern Decision ---------------------------------
				if nDistanceSquare <= PS_nDS_IdleTalkPetStop
				then

					PetMem["PetInfo"]["nIdleStep"] = 3

					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:STOP Follow - nHandle( "..nHandle.." )" )
				elseif nDistanceSquareMaster > PS_nDS_IdleTalkPetStayMax
				then
					-- 취소 조건 : 마스터와의 거리
					DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:CANCEL by Distance from Master - nHandle( "..nHandle.." )" )

					PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
				end
				---------- 거리별 Pattern Decision// ---------------------------------
				----------------------------------------------------------------------

			elseif PetMem["PetInfo"]["nIdleStep"] == 3
			then
				-- 대상 펫 쪽으로 방향 전환
				local tTargetCoord = PetMem["TargetInfo"]["Coord"]["Cur"]
				cSetObjectDirect( nHandle, tTargetCoord["x"], tTargetCoord["y"] )
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START See - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = 4

			elseif PetMem["PetInfo"]["nIdleStep"] == 4
			then
				-- 말하기

				PetBaseScriptMessage( nHandle, sScriptMessageIndex )
				cExecCheck( "PetBaseIdleAction" )

				DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:START Talk - nHandle( "..nHandle.." )" )

				PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
				-- 끝이므로 아무것도 안하고 뒤로 넘김
			end
			-- 단계별 실행 구간 종료
			----------------------------------------------------------------------

		else
			-- 펫이 무효 - 행동 취소
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_TALK:CANCEL by No Target Pet - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]
		end

	elseif nIdleActionMode == PIAM_DIE	-----------------------------------------------------------------------------------------------------------PIAM_DIE
	then
		-- 그냥 처리
		-- 10초간 죽은척
		if 	PetMem["PetInfo"]["Time"]["EnterIdleAction"] == PetMem["InitialSec"]
		then
			-- 진입셋팅
			PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["CurSec"]
			PetMem["PetInfo"]["nIdleStep"] = 1
			PetMem["PetInfo"]["nIdleEndStep"] = 3

			PetBaseScriptMessage( nHandle, sScriptMessageIndex )
			PetBaseObjectEffect( nHandle, sHairEffect )
			PetBaseObjectSound( nHandle, sSoundFile )

			cExecCheck( "PetBaseIdleAction" )

		end

		-- RubyFruit 2013.11.23 임시 로그
		DebugLog( "PetBaseIdleAction::PIAM_DIE::nIdleStep = "..PetMem["PetInfo"]["nIdleStep"] )
		----------------------------------------------------------------------
		-- 단계별 실행
		if PetMem["PetInfo"]["nIdleStep"] == 1
		then
			-- 첫 스텝
			-- 애니메이션은 펫 종류마다 다른 것을 사용해야하는 단점이 있어서 이벤트 코드를 직접 사용하기로 함
			if cActByEventCode( nHandle, PetSystem_ActionEventCode["Die"] ) == nil
			then
				ErrorLog( "cActByEventCode failed ["..nHandle.."]'s Die" )
			end

			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:START Die animation - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = 2

		elseif PetMem["PetInfo"]["nIdleStep"] == 2
		then

			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:Not Do Anithing - nHandle( "..nHandle.." )" )

		else	-- PetMem["PetInfo"]["nIdleStep"] == PetMem["PetInfo"]["nIdleEndStep"] 의 경우
			-- 끝이므로 아무것도 안하고 뒤로 넘김
		end
		-- 단계별 실행 구간 종료
		----------------------------------------------------------------------

		-- 시간제한 체크
		if PetMem["PetInfo"]["Time"]["EnterIdleAction"] + PetSystem_nSecStayAtIdleDie <= PetMem["CurSec"]
		then
			-- 취소 조건 : 시간
			DebugLog( "PetBaseIdleAction::PET_IDLE_ACTION_MODE-PIAM_DIE:CANCEL by Time - nHandle( "..nHandle.." )" )

			PetMem["PetInfo"]["nIdleStep"] = PetMem["PetInfo"]["nIdleEndStep"]

			-- 죽어있는 모습으로 계속 있는 문제 때문에 Idle로 변경
			cActByEventCode( nHandle, PetSystem_ActionEventCode["Idle"] )
		end

	else
		-- logic error
		ErrorLog( "PetBaseIdleAction::nIdleActionMode is invalid - logic error" )
		return false
	end


	-- 마지막 스텝 처리 이후 초기화 : 마지막으로 Idle 행동을 했다고 하는 시간 갱신을 이때 한번 더 한다.(다른 곳에서 하는 것과는 관계 없이 한번 더 해주는 셈)
	if PetMem["PetInfo"]["nIdleStep"] >= PetMem["PetInfo"]["nIdleEndStep"]
	then
		if PetBaseInitIdleAction( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

		if PetBaseInitTarget( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

		if PetBaseInitTargetMaster( PetMem ) ~= true
		then
			return false
		end
		cExecCheck( "PetBaseIdleAction" )

--		PetMem["PetInfo"]["PetMode"]["nMasterMode"] = PMM_NONE
		PetMem["PetInfo"]["PetMode"]["nActionMode"] = PAM_NONE
		PetMem["PetInfo"]["Time"]["LastActIdleMode"] = PetMem["CurSec"]
		local nWaitIdleActSec = cRandomInt( PetSystem_nSecMinWaitActAtIdle, PetSystem_nSecMaxWaitActAtIdle )
		PetMem["PetInfo"]["Time"]["ExecIdleActMode"]	= PetMem["CurSec"] + nWaitIdleActSec

		return true
	end

	--PetMem["PetInfo"]["PetMode"]["nIdleActionMode"]

end
