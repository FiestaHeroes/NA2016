
function PetBaseRoutine( PetMem )
	cExecCheck( "PetBaseRoutine" )

	if PetMem == nil
	then
		DebugLog( "PetBaseRoutine::PetMem is nil" )
		return ReturnAI["END"]
	end

	local nHandle = PetMem["PetInfo"]["nHandle"]

	-- 펫 사망시
	if cIsObjectDead( nHandle ) == 1
	then
		-- AI 스크립트 해제
		cAIScriptSet( nHandle )

		-- 메모리 해제
		gPetAIMemory["PetBase"][ nHandle ] = nil

		DebugLog( "PetBaseRoutine::Pet Has Died - nHandle( "..nHandle.." )" )
		return ReturnAI["END"]
	end

--	펫 대기모드
-- 	주인 있는지 체크( 맵링크 때문에 )
--	주인 죽었는지 체크 ( 사망 체크 )
--	주인이 부른 상태인지 체크 ( 존에 셋팅된 주인이 불렀다 체크 )
--	주인과의 거리 체크( 멀어지면 따라가라 )
--	펫 성향 저장시간 체크
--	펫 대기 시작 시간 체크
	local nMasterHandle = PetMem["MasterInfo"]["nHandle"]

	if cIsObjectDead( nMasterHandle ) == 1
	then
		-- 여긴 객체가 없거나 시체상태일때만 들어오는 곳.. 아직은 의미 없음
	end

	local sMasterMode = cGetObjectMode( nMasterHandle );
	if sMasterMode == nil
	then
		-- 마스터 모드 못찾음 : 문제 있으므로 솬해제해쁘려 없거나 뭐 그런거니까
		cAIScriptSet( nHandle )
		gPetAIMemory["PetBase"][ nHandle ] = nil

		DebugLog( "PetBaseRoutine::cGetObjectMode Fail - nHandle( "..nHandle.." )" )
		return ReturnAI["END"]
	end

DebugLog( "PetBaseRoutine:: Point 1 - 현재 마스터 상태에 따라서.." )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------ 마스터의 상태에 따라 내부 변수및 행동 변화 설정 : 상태진입처리, 특정상태에서의 상태진입처리
	local tMode = PetMem["PetInfo"]["PetMode"]	-- 모드 접근을 편하게 하기 위해

	-- 죽었다 살아나면 우선순위가 낮은 AI를 위해 AI 초기화
	if tMode["nMasterMode"] == PMM_DIE and sMasterMode ~= "corpse"
	then
		local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
		PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
		PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
		tMode["nMasterMode"] = PMM_NONE
		tMode["nActionMode"] = PAM_NONE
	end

	-- 아이들 액션이 아닐땐 이 값 항상 초기화 해주기
	if tMode["nMasterMode"] ~= PMM_IDLE or tMode["nActionMode"] ~= PAM_IDLE_ACT
	then
		PetMem["PetInfo"]["Time"]["EnterIdleAction"] = PetMem["InitialSec"]
	end


	if sMasterMode == "linking"
	then
		tMode["nMasterMode"] = PMM_LINK
		DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_LINK - nHandle( "..nHandle.." )" )
	elseif sMasterMode == "corpse"
	then
		if tMode["nMasterMode"] < PMM_DIE	-- 우선순위체크
		then
			-- Die 진입 셋팅
			local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
			-- 제자리로 이동한것처럼 표시
			PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
			tMode["nActionMode"] = PAM_NONE

			-- PupCaseDesc 에서 펫 종류까지 고려해서 레코드 가져와서 PAI 타입을 확인 후 Valid 일 때 스크립트 메세지와 헤어이펙트, 사운드를 발생시킨다.
			local tPetDieActRecord = { cPet_GetActionRecord( nHandle, "die" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

			if tPetDieActRecord ~= nil
			then
				if tPetDieActRecord[ 1 ] == "script"
				then
					if tPetDieActRecord[ 2 ] ~= "-"
					then
						PetBaseScriptMessage( nHandle, tPetDieActRecord[ 2 ] )
					end

					if tPetDieActRecord[ 3 ] ~= "-"
					then
						PetBaseObjectEffect( nHandle, tPetDieActRecord[ 3 ] )
					end

					if tPetDieActRecord[ 4 ] ~= "-"
					then
						PetBaseObjectSound( nHandle, tPetDieActRecord[ 4 ] )
					end

					cExecCheck( "PetBaseRoutine" )

				else
					ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
				end

			else
				ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
			end



			CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_DIE - nHandle( "..nHandle.." )" )
		end

		tMode["nMasterMode"] = PMM_DIE
		DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_DIE - nHandle( "..nHandle.." )" )

	elseif sMasterMode == "normal" or sMasterMode == "fight" or sMasterMode == "riding" or sMasterMode == "house" or sMasterMode == "booth"
	then
		-- 주인이 불렀는지 체크
		if cPet_IsMasterCalling( nHandle ) == true
		then
			-- 주인이 부름
			if tMode["nMasterMode"] <= PMM_CALL	-- 우선순위체크
			then
				-- Call 진입 셋팅

				-- PupCaseDesc 에서 펫 종류까지 고려해서 레코드 가져와서 PAI 타입을 확인 후 Valid 일 때 스크립트 메세지와 헤어이펙트, 사운드를 발생시킨다.
				local tPetCallActRecord = { cPet_GetActionRecord( nHandle, "call" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

				if tPetCallActRecord ~= nil
				then
					if tPetCallActRecord[ 1 ] == "script"
					then
						if tPetCallActRecord[ 2 ] ~= "-"
						then
							PetBaseScriptMessage( nHandle, tPetCallActRecord[ 2 ] )
						end

						if tPetCallActRecord[ 3 ] ~= "-"
						then
							PetBaseObjectEffect( nHandle, tPetCallActRecord[ 3 ] )
						end

						if tPetCallActRecord[ 4 ] ~= "-"
						then
							PetBaseObjectSound( nHandle, tPetCallActRecord[ 4 ] )
						end

						cExecCheck( "PetBaseRoutine" )

					else
						ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
					end

				else
					ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
				end


				-- 일단 하던것 멈추기 : 상황봐서 뺄지말지 결정하기
				local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
-- 제자리 이동 요청시, 멈춘다기보다 클라와 싱크 맞춰서 약간 공간이동한것처럼되기 때문에 그냥 몹표지점 메모리만 표시.
--				cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
				-- 제자리로 이동한것처럼 표시
				PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
				PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				tMode["nActionMode"] = PAM_NONE
				CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_CALL - nHandle( "..nHandle.." )" )
			end

			tMode["nMasterMode"] = PMM_CALL
			DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_CALL - nHandle( "..nHandle.." )" )

		else
			-- 주인이 부르지 않음
			if tMode["nActionMode"] <= PAM_FAR_MISSED	-- 더 상위 우선순위에 의해 행동하는것이 아닐때만 처리하기.
			then

				if tMode["nActionMode"] <= PAM_FAR_MISSED	-- 더 상위 우선순위에 의해 행동하는것이 아닐때만 처리하기.
				then
					local nDistanceSquare = cDistanceSquar( nHandle, nMasterHandle )

					----------------------------------------------------------------------
					---------- //거리별 Pattern Decision ---------------------------------
					if nDistanceSquare < PS_nDS_AwayStart
					then
						if tMode["nMasterMode"] == PMM_AWAY
						then
							-- 충분히 가까워졌으니 멈춘것 처럼
							local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--							cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
							PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
							PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
						end

						if tMode["nMasterMode"] ~= PMM_IDLE
						then
							local nWaitIdleActSec = cRandomInt( PetSystem_nSecMinWaitActAtIdle, PetSystem_nSecMaxWaitActAtIdle )

							-- Idle 진입 셋팅
							PetMem["PetInfo"]["Time"]["ExecSaveTendency"]	= PetMem["CurSec"] + PetSystem_nSecWaitSaveTendencyAtIdle
							PetMem["PetInfo"]["Time"]["ExecIdleActMode"]	= PetMem["CurSec"] + nWaitIdleActSec
							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_IDLE - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_IDLE
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_IDLE - nHandle( "..nHandle.." )" )

					elseif nDistanceSquare < PS_nDS_FarStart
					then
						if tMode["nMasterMode"] ~= PMM_AWAY
						then
							-- Away 진입 셋팅

							-- PupCaseDesc 에서 펫 종류까지 고려해서 레코드 가져와서 PAI 타입을 확인 후 Valid 일 때 스크립트 메세지와 헤어이펙트, 사운드를 발생시킨다.
							local tPetFollowActRecord = { cPet_GetActionRecord( nHandle, "follow" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

							if tPetFollowActRecord ~= nil
							then
								if tPetFollowActRecord[ 1 ] == "script"
								then
									if tPetFollowActRecord[ 2 ] ~= "-"
									then
										PetBaseScriptMessage( nHandle, tPetFollowActRecord[ 2 ] )
									end

									if tPetFollowActRecord[ 3 ] ~= "-"
									then
										PetBaseObjectEffect( nHandle, tPetFollowActRecord[ 3 ] )
									end

									if tPetFollowActRecord[ 4 ] ~= "-"
									then
										PetBaseObjectSound( nHandle, tPetFollowActRecord[ 4 ] )
									end

									cExecCheck( "PetBaseRoutine" )

								else
									ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
								end

							else
								ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
							end

							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_AWAY - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_AWAY
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_AWAY - nHandle( "..nHandle.." )" )

					else
						if tMode["nMasterMode"] == PMM_AWAY or tMode["nMasterMode"] == PMM_IDLE
						then
							-- 너무 멀어졌으니 멈춘것처럼
							local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--							cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
							PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
							PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
						end

						if tMode["nMasterMode"] ~= PMM_FAR
						then
							-- Far 진입 셋팅
							PetMem["PetInfo"]["Time"]["EnterFarIdle"]		= PetMem["CurSec"]
							CheckLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_FAR - nHandle( "..nHandle.." )" )
						end

						tMode["nMasterMode"] = PMM_FAR
						DebugLog( "PetBaseRoutine::PET_MASTER_MODE-PMM_FAR - nHandle( "..nHandle.." )" )

					end
					---------- 거리별 Pattern Decision// ---------------------------------
					----------------------------------------------------------------------
				end
			end

		end


	elseif sMasterMode == "logoutwait"
	then
		-- 로그아웃대기 : 이건 뭔지 알아보기
	else
		-- 이상한 리턴값 : 문제 있으므로 솬해제
	end


DebugLog( "PetBaseRoutine:: Point 2 - 행동하고 있는 것에 따라서.." )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
------ 설정된 마스터 모드에 따라 행동 처리
	if tMode["nMasterMode"] == PMM_IDLE	-----------------------------------------------------------------------------------------------------------PMM_IDLE
	then
		-- 아이들 시간 카운팅 2가지 하기

		-- 행동 타임에 행동 설정
		if PetMem["PetInfo"]["Time"]["ExecIdleActMode"] < PetMem["CurSec"]
		then
			-- 행동할 시간이 왔음
			--local tPetIdleActRecord = { cPet_GetActionRecord( nHandle, "idle" ) } -- { "PupAITypeString", "SM_Inx", "HairEffect", "SoundFile" }

			if PetMem["PetInfo"]["tCurIdleActRecord"] == nil
			then
				PetMem["PetInfo"]["tCurIdleActRecord"] = { cPet_GetActionRecord( nHandle, "idle" ) }
			end

			--if tPetIdleActRecord ~= nil
			if PetMem["PetInfo"]["tCurIdleActRecord"] ~= nil
			then
				if PetBaseIdleAction( PetMem, PetMem["PetInfo"]["tCurIdleActRecord"] ) == false
				then
					ErrorLog( "PetBaseRoutine::PetBaseIdleAction Failed ["..nHandle.."]" );
				end
				cExecCheck( "PetBaseRoutine" )
			else
				ErrorLog( "PetBaseRoutine::cPet_GetActionRecord Failed ["..nHandle.."]" );
			end

			-- 행동상태로 조정
			tMode["nActionMode"] = PAM_IDLE_ACT
			DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_IDLE_ACT - nHandle( "..nHandle.." )" )

		else
			tMode["nActionMode"] = PAM_IDLE_WAIT
			DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_IDLE_WAIT - nHandle( "..nHandle.." )" )

		end

		-- 저장 타임에 저장 요청
		if PetMem["PetInfo"]["Time"]["ExecSaveTendency"] < PetMem["CurSec"]
		then
			-- 저장할 시간이 왔음
			if cPet_SaveTendency( nHandle ) == nil
			then
				ErrorLog( "PetBaseRoutine::cPet_SaveTendency Failed ["..nHandle.."]" )
			else
				CheckLog( "PetBaseRoutine::cPet_SaveTendency Failed ["..nHandle.."]" )
			end

			PetMem["PetInfo"]["Time"]["ExecSaveTendency"] = PetMem["CurSec"] + PetSystem_nSecWaitSaveTendencyAtIdle
		end

	elseif tMode["nMasterMode"] == PMM_AWAY	-----------------------------------------------------------------------------------------------------------PMM_AWAY
	then
		-- 마스터 쪽으로 이동
		local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
		local tTargetCoord = {}
		tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceFollowingStop )

		if tTargetCoord["x"] ~= nil
		then
			cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateFollowingMil )
			PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
			PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
		else
			ErrorLog( "Following Move Target Coord is not Found" )-- 실패메세지
		end
	elseif tMode["nMasterMode"] == PMM_FAR	-----------------------------------------------------------------------------------------------------------PMM_FAR
	then
		-- 이동 하던것 멈추고 정지 후(위에서 처리) 시간 카운팅

		-- 너무 멀어져서 길 잃어 사라지는 시간 체크 후 소환 해제 처리
		if PetMem["PetInfo"]["Time"]["EnterFarIdle"] + PetSystem_nSecWaitMissingAtFar < PetMem["CurSec"]
		then
			-- 소환 해제 요청
			if cPet_Unsummon( nMasterHandle ) == nil
			then
				-- 소환해제에 문제 생김 : 심각한 문제 처리
			end

			-- AI 스크립트 해제
			cAIScriptSet( nHandle )

			-- 메모리 해제
			gPetAIMemory["PetBase"][ nHandle ] = nil

			DebugLog( "PetBaseRoutine::Pet Has Unsummoned - nHandle( "..nHandle.." )" )

			return ReturnAI["END"]

		end


	elseif tMode["nMasterMode"] == PMM_CALL	-----------------------------------------------------------------------------------------------------------PMM_CALL
	then
		-- 마스터 혹은 목표 지점 쪽으로 이동 후 쳐다보기
		local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
		local tDestCoord 	= PetMem["PetInfo"]["Coord"]["Next"]
		local tMasterCoord 	= PetMem["MasterInfo"]["Coord"]["Cur"]

		local nCallingDistanceSquare 	= cDistanceSquar( tPetCoord["x"], tPetCoord["y"], tDestCoord["x"], tDestCoord["y"] )
		local nFollowingDistanceSquare 	= cDistanceSquar( nHandle, nMasterHandle )

		local nDistanceSquare

		-- 불려서 오고있다면 그 목표지점에서의 거리를 보고
		-- 그게 아니라면 현재 마스터와의 거리를 보자.
		if tMode["nActionMode"] == PAM_CALL_COME
		then
			nDistanceSquare = nCallingDistanceSquare
		else
			nDistanceSquare = nFollowingDistanceSquare
		end


		if tMode["nActionMode"] == PAM_CALL_SEE
		then
			-- 설정된 시간만큼만 주인을 쳐다본다.
			if PetMem["PetInfo"]["Time"]["LastEnterStayAtCallSee"] + PetSystem_nSecStayAtCallSee < PetMem["CurSec"]
			then
				-- 모든 모드 취소
				tMode["nMasterMode"] = PMM_NONE
				tMode["nActionMode"] = PAM_NONE
			end

			-- 쳐다보기
			cSetObjectDirect( nHandle, tMasterCoord["x"], tMasterCoord["y"] )
			-- 감정표현
			--?????????????????????????????????????????????????????

		else
			----------------------------------------------------------------------
			---------- //거리별 Pattern Decision ---------------------------------
			if nDistanceSquare < PS_nDS_CallingStop
			then
				-- 가까워졌으면 도착한것이다.
				if tMode["nActionMode"] == PAM_CALL_COME
				then
					-- 충분히 가까워졌으니 멈춘것처럼
					local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--					cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				end

				if tMode["nActionMode"] ~= PAM_CALL_SEE
				then
					PetMem["PetInfo"]["Time"]["LastEnterStayAtCallSee"] = PetMem["CurSec"]

					-- 주인 쳐다보기 진입 셋팅 : 몇초나 쳐다봐??????????????????????????????????
					-- 이 상황을 어떻게 처리할지 추가 질문 필요
				end


				tMode["nActionMode"] = PAM_CALL_SEE
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_CALL_SEE - nHandle( "..nHandle.." )" )

			else

				if tMode["nActionMode"] ~= PAM_CALL_COME
				then
					-- 주인이 부르면 이동하기 진입 셋팅
					-- 마스터 쪽으로 이동 : 주인이 부른 시점, 딱 한번만 체크하여 이동한다. 부른위치를 아는거지 마스터 위치를 아는게 아님.
					local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceCallingStop )

					if tTargetCoord["x"] ~= nil
					then
						cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateCallingMil )
						PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
						PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
					else
						ErrorLog( "Calling Move Target Coord is not Found" )-- 실패메세지
					end

				end

				tMode["nActionMode"] = PAM_CALL_COME
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_CALL_COME - nHandle( "..nHandle.." )" )

			end
			---------- 거리별 Pattern Decision// ---------------------------------
			----------------------------------------------------------------------
		end


	elseif tMode["nMasterMode"] == PMM_DIE	-----------------------------------------------------------------------------------------------------------PMM_DIE
	then
		-- 마스터 혹은 목표 지점 쪽으로 이동 후 쳐다보기
		local tPetCoord 	= PetMem["PetInfo"]["Coord"]["Cur"]
		local tDestCoord 	= PetMem["PetInfo"]["Coord"]["Next"]
		local tMasterCoord 	= PetMem["MasterInfo"]["Coord"]["Cur"]

		local nDiedDistanceSquare 		= cDistanceSquar( tPetCoord["x"], tPetCoord["y"], tDestCoord["x"], tDestCoord["y"] )
		local nFollowingDistanceSquare 	= cDistanceSquar( nHandle, nMasterHandle )

		local nDistanceSquare

		-- 불려서 오고있다면 그 목표지점에서의 거리를 보고
		-- 그게 아니라면 현재 마스터와의 거리를 보자.
		if tMode["nActionMode"] == PAM_DIE_COME
		then
			nDistanceSquare = nDiedDistanceSquare
		else
			nDistanceSquare = nFollowingDistanceSquare
		end


		if tMode["nActionMode"] == PAM_DIE_SAD
		then
			-- 설정된 시간만큼만 죽은 주인을 쳐다보며 슬퍼한다.
			if PetMem["PetInfo"]["Time"]["LastEnterStayAtDiedSad"] + PetSystem_nSecStayAtDiedSad < PetMem["CurSec"]
			then
				-- 모든 모드 취소
				tMode["nMasterMode"] = PMM_NONE
				tMode["nActionMode"] = PAM_NONE
			end
			-- 쳐다보기
			cSetObjectDirect( nHandle, tMasterCoord["x"], tMasterCoord["y"] )
			-- 슬퍼하기는 말로서 표현

		else
			----------------------------------------------------------------------
			---------- //거리별 Pattern Decision ---------------------------------
			if nDistanceSquare < PS_nDS_DiedStop
			then
				-- 가까워졌으면 도착한것이다.
				if tMode["nActionMode"] == PAM_DIE_COME
				then
					-- 충분히 가까워졌으니 멈추기
					local tPetCoord = PetMem["PetInfo"]["Coord"]["Cur"]
--					cRunTo( nHandle, tPetCoord["x"], tPetCoord["y"], 1000 )
					PetMem["PetInfo"]["Coord"]["Next"]["x"] = tPetCoord["x"]
					PetMem["PetInfo"]["Coord"]["Next"]["y"] = tPetCoord["y"]
				end

				if tMode["nActionMode"] ~= PAM_DIE_SAD
				then
					-- 슬픔 진입 셋팅 : 할거없고 다음루틴부터 할일함
					PetMem["PetInfo"]["Time"]["LastEnterStayAtDiedSad"] = PetMem["CurSec"]
					CheckLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_SAD - nHandle( "..nHandle.." )" )
				end


				tMode["nActionMode"] = PAM_DIE_SAD
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_SAD - nHandle( "..nHandle.." )" )

			else

				if tMode["nActionMode"] ~= PAM_DIE_COME
				then
					-- 주인이 부르면 이동하기 진입 셋팅
					-- 마스터 쪽으로 이동 : 주인이 부른 시점, 딱 한번만 체크하여 이동한다. 부른위치를 아는거지 마스터 위치를 아는게 아님.
					local tMasterCoord = PetMem["MasterInfo"]["Coord"]["Cur"]
					local tTargetCoord = {}
					tTargetCoord["x"], tTargetCoord["y"] = cGetCoord_Circle( tMasterCoord["x"], tMasterCoord["y"], PetSystem_nDistanceDiedStop )

					if tTargetCoord["x"] ~= nil
					then
						cRunTo( nHandle, tTargetCoord["x"], tTargetCoord["y"], PetSystem_nSpeedRateMasterDiedMil )
						PetMem["PetInfo"]["Coord"]["Next"]["x"] = tTargetCoord["x"]
						PetMem["PetInfo"]["Coord"]["Next"]["y"] = tTargetCoord["y"]
					else
						ErrorLog( "Master Died Move Target Coord is not Found" )-- 실패메세지
					end

					CheckLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_COME - nHandle( "..nHandle.." )" )
				end

				tMode["nActionMode"] = PAM_DIE_COME
				DebugLog( "PetBaseRoutine::PET_ACTION_MODE-PAM_DIE_COME - nHandle( "..nHandle.." )" )

			end
			---------- 거리별 Pattern Decision// ---------------------------------
			----------------------------------------------------------------------
		end

	elseif tMode["nMasterMode"] == PMM_LINK	-----------------------------------------------------------------------------------------------------------PMM_LINK
	then
		tMode["nActionMode"] = PAM_LINK

	else
		-- 정의 안된 모드이거나 아무것도 아니거나..
	end

	-- 원래 몹의 AI 를 적용
	return ReturnAI["CPP"]
end
