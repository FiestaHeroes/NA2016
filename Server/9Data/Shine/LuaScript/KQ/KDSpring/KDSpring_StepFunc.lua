------------------------------------------------------------------------------------------
--                                  팀 나누기 대기                                      --
------------------------------------------------------------------------------------------
function SF_DIVIDE_TEAM_WAIT( KSMemory, nCurSec )
cExecCheck "SF_DIVIDE_TEAM_WAIT"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if #KSMemory["PLAYER_LIST"] >= KQ_MAX_PLAYER
	then	-- 게임 참여 인원 확인
		KSMemory["STEP_NEXT_TIME"] = nCurSec	-- 다음 단계(팀 나누기)로 진행하기 위해 시간 설정
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		for i = 1, #KSMemory["PLAYER_LIST"]
		do	-- 모든 플레이어 파티 해제
			cPartyLeave( KSMemory["PLAYER_LIST"][i]["PHND"] )
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                    팀 나누기                                         --
------------------------------------------------------------------------------------------
function SF_DIVIDE_TEAM( KSMemory, nCurSec )
cExecCheck "SF_DIVIDE_TEAM"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		local nConnectNum = #KSMemory["PLAYER_LIST"]	-- 킹덤 퀘스트 맵에 접속해있는 플레이어 수

		-- 게임 참가 플레이어 확인
		for i = 1, nConnectNum
		do
			if cIsInMap( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"] ) == nil
			then	-- 킹덤 퀘스트 맵에 접속해있는지 확인
				nConnectNum								= nConnectNum - 1
				KSMemory["PLAYER_LIST"][i]["PIS_MAP"]	= false
			end
		end

		if nConnectNum <= 1
		then	-- 킹덤 퀘스트맵에 접속해있는 플레이어 수 확인
			return false
		end


		-- 문 닫기
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "close" )
		end


		for i = 1, #KQ_NPC
		do	-- NPC 소환
			cNPCRegen( KSMemory["FIELD_NAME"], KQ_NPC[i] )
		end


		local TeamInfo 			= KSMemory["TEAM_LIST"]		-- 팀 정보
		local nTeamNo 			= KQ_TEAM_NO["KTN_DEFAULT"]	-- 팀 번호
		local nTeamMemberMaxNum = nConnectNum / 2			-- 팀 멤버 최대맴수

		if TeamInfo == nil
		then	-- 팀 정보 확인
			return false
		end

		-- 게임 참가 플레이어 팀 나누기
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- 킹덤 퀘스트맵에 접속해있는 플레이어

				-- 50% 확률로 팀 설정
				if cPermileRate( 500 ) == 1
				then	-- 레드 팀

					nTeamNo = KQ_TEAM_NO["KTN_RED"]

					if #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"] >= nTeamMemberMaxNum
					then	-- 레드 팀 멤버 수 확인
						if #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"] < nTeamMemberMaxNum
						then	-- 블루 팀 멤버 수 확인
							nTeamNo = KQ_TEAM_NO["KTN_BLUE"]
						end
					end
				else	-- 블루 팀

					nTeamNo = KQ_TEAM_NO["KTN_BLUE"]

					if #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"] >= nTeamMemberMaxNum
					then	-- 블루 팀 멤버 수 확인
						if #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"] < nTeamMemberMaxNum
						then	-- 레드 팀 멤버 수 확인
							nTeamNo = KQ_TEAM_NO["KTN_RED"]
						end
					end
				end

				local nIndex = (#TeamInfo[nTeamNo]["TMEMBER_LIST"] + 1)	-- 팀 멤버 리스트 인덱스

				TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] 	= KSMemory["PLAYER_LIST"][i]["PHND"]	-- 팀 멤버 리스트
				KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]		= nTeamNo								-- 플레이어 팀 번호

				if nIndex > 1
				then	-- 파티 참가
					cPartyJoin( TeamInfo[nTeamNo]["TMEMBER_LIST"][1], TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] )
				end

--				for j = 1, #KQ_TEAM[nTeamNo]["KT_UNIFORM"]
--				do		-- 유니폼 설정
--					cViewSlotEquip( TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex], KQ_TEAM[nTeamNo]["KT_UNIFORM"][j] )
--				end
			end

		end


		-- 게임 참가자 팀 위치로 이동
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			nTeamNo = KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]

			if nTeamNo ~= KQ_TEAM_NO["KTN_DEFAULT"]
			then	-- 팀 번호 확인
				cLinkTo( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
			end
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                    시작 대기                                         --
------------------------------------------------------------------------------------------
function SF_START_WAIT( KSMemory, nCurSec )
cExecCheck "SF_START_WAIT"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		if KSMemory["FLAG_INFO"] == nil
		then	-- 깃발 정보 확인
			return false
		end


		cStartMsg_AllInMap( KSMemory["FIELD_NAME"] ) -- 킹퀘 시작 카운트 다운


		-- 아이템 몬스터 소환
		for i = 1, #KQ_ITEM_MOB
		do
			KSMemory["MOB_LIST"][i] = {}
			KSMemory["MOB_LIST"][i]["MHND"] 		= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_ITEM_MOB[i]["KIM_INDEX"], KQ_ITEM_MOB[i]["KIM_X"], KQ_ITEM_MOB[i]["KIM_Y"], KQ_ITEM_MOB[i]["KIM_DIR"] )
			KSMemory["MOB_LIST"][i]["MREGEN_TIME"]	= 0
		end


		local nNextStep = KSMemory["STEP_NO"] + 1		-- 다음 단계


		-- 깃발 소환
		KSMemory["FLAG_INFO"]["FHND"] 	= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG_POINT["KFP_INDEX"], KQ_FLAG_POINT["KFP_X"], KQ_FLAG_POINT["KFP_Y"], KQ_FLAG_POINT["KFP_DIR"] )
		if KSMemory["FLAG_INFO"]["FHND"] == nil then
			nNextStep = 10	-- SF_END_WAIT
		else

			KSMemory["FLAG_INFO"]["FINDEX"]	= KQ_FLAG_POINT["KFP_INDEX"]

			-- 깃발 루아 스크립트 설정
			cSetAIScript( KQ_SCRIPT_NAME, KSMemory["FLAG_INFO"]["FHND"] )
			cAIScriptFunc( KSMemory["FLAG_INFO"]["FHND"], "Entrance", "KF_FLGAG_OBJECT" )
		end

		if #KQ_STEP >= nNextStep
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= nNextStep													-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                       시작                                           --
------------------------------------------------------------------------------------------
function SF_START( KSMemory, nCurSec )
cExecCheck "SF_START"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		-- 문 열기
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "open" )
		end


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			-- 타이머 표시
			cTimer( KSMemory["FIELD_NAME"], KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"] )


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

end


------------------------------------------------------------------------------------------
--                                       진행                                           --
------------------------------------------------------------------------------------------
function SF_ROUTINE( KSMemory, nCurSec )
cExecCheck "SF_ROUTINE"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	local TeamInfo = KSMemory["TEAM_LIST"]
	local FlagInfo = KSMemory["FLAG_INFO"]

	if TeamInfo == nil
	then
		return false
	end

	if FlagInfo == nil
	then
		return false
	end

	-- 깃발 들고 있는 플레이어 확인
	FLAG_PLAYER_CHECK( KSMemory, nCurSec )


	if FlagInfo["FREGEN_TIME"] ~= 0
	then	-- 깃발 포인트 리젠 대기 중

		if nCurSec >= FlagInfo["FREGEN_TIME"]
		then	-- 깃발 리젠 시간 확인

			-- 깃발 소환
			FlagInfo["FHND"] = cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG_POINT["KFP_INDEX"], KQ_FLAG_POINT["KFP_X"], KQ_FLAG_POINT["KFP_Y"], KQ_FLAG_POINT["KFP_DIR"] )

			if FlagInfo["FHND"] == nil then
				FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
			else
				-- 깃발 루아 스크립트 설정
				cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
				cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

				-- 깃발 정보 초기화
				FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
				FlagInfo["FINDEX"]			= KQ_FLAG_POINT["KFP_INDEX"]
				FlagInfo["FPICK_TIME"]		= 0
				FlagInfo["FREGEN_TIME"]		= 0
				FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
				FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]

				-- 깃발 소환 알림
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_REGEN02"] )
			end
		end
	end


	if FlagInfo["FHND"]  == KQ_INVALID_HANDLE and	-- 깃발 핸들
	   FlagInfo["FPHND"] == KQ_INVALID_HANDLE and	-- 깃발 획득 플레이어 핸들
	   FlagInfo["FREGEN_TIME"] == 0			-- 깃발 리젠 타임
	then	-- 킹덤 퀘스트 맵에 깃발이 존재하지는 확인
		FlagInfo["FREGEN_TIME"] = KQ_FLAG_POINT["KFP_REGEN_TIME"] + nCurSec
	end


	if KSMemory["WORK_TICK"] <= nCurSec
	then	-- 일정 시간마다 처리되는 작업(1초에 한번)

		if FlagInfo["FHND"]	 ~= KQ_INVALID_HANDLE 	or	-- 깃발
		   FlagInfo["FPHND"] ~= KQ_INVALID_HANDLE		-- 깃발 획득 플레이어
		then
			local MapMarkTable = {}
			local mmData = {}

			mmData["Group"]     = 0
			mmData["x"]         = FlagInfo["FREGEN_X"]
			mmData["y"]         = FlagInfo["FREGEN_Y"]
			mmData["KeepTime"]  = 1000
			mmData["IconIndex"] = KQ_FLAG_ICON

			MapMarkTable[mmData["Group"]] = mmData

			-- 깃발 마킹 정보 알림
			cMapMark( KSMemory["FIELD_NAME"], MapMarkTable )
		end

		-- 게임 참가 플레이어 킹덤 퀘스트맵 접속 여부 확인
		local nLogOut_RedTeam	= 0		-- 레드 팀 접속하지 않은 멤버 수
		local nLogOut_BlueTeam	= 0		-- 블루 팀 접속하지 않은 멤버 수

		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"] [i]["PIS_MAP"] == true
			then	-- 킹덤 퀘스트맵에 접속해있는 플레이어
				if cIsInMap( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"] ) == nil
				then	-- 킹덤 퀘스트맵에 접속해있는지 확인
					KSMemory["PLAYER_LIST"][i]["PIS_MAP"] = false
				end
			end

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == false
			then	-- 킹덤 퀘스트맵에 접속하지 않은 팀원
				if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
				then
					nLogOut_RedTeam = nLogOut_RedTeam + 1
				elseif KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
				then
					nLogOut_BlueTeam = nLogOut_BlueTeam + 1
				end
			end
		end

		if nLogOut_RedTeam  >= #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"]		or	-- 레드 팀
		   nLogOut_BlueTeam >= #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"]		-- 블루 팀
		then	-- 킹덤 퀘스트맵에 접속하지 않은 멤버 수 확인
			TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"]	= 0
			TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]	= 0

			KSMemory["GAME_TYPE"] 		= KQ_GAME_TYEP["KGT_EXTRATIME"]
			KSMemory["STEP_NEXT_TIME"]	= 0
		end


		-- 몬스터 확인( 아이템 몬스터 )
		for i = 1, #KSMemory["MOB_LIST"]
		do
			if cIsObjectDead( KSMemory["MOB_LIST"][i]["MHND"] ) ~= nil
			then	-- 몬스터 죽었는지 확인

				if KSMemory["MOB_LIST"][i]["MREGEN_TIME"] == 0
				then	-- 리젠 시간 설정
					KSMemory["MOB_LIST"][i]["MREGEN_TIME"] = KQ_ITEM_MOB[i]["KIM_REGEN_TICK"] + nCurSec
				else 	-- 리젠 시간 확인
					if KSMemory["MOB_LIST"][i]["MREGEN_TIME"] <= nCurSec
					then	-- 몬스터 리젠
						KSMemory["MOB_LIST"][i]["KSMM_HND"]		= cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_ITEM_MOB[i]["KIM_INDEX"], KQ_ITEM_MOB[i]["KIM_X"],
																				KQ_ITEM_MOB[i]["KIM_Y"], KQ_ITEM_MOB[i]["KIM_DIR"] )
						KSMemory["MOB_LIST"][i]["MREGEN_TIME"]	= 0
					end
				end
			end
		end


		-- 다음 시간 설정
		KSMemory["WORK_TICK"] = nCurSec + 1

	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		if FlagInfo["FPHND"] ~= KQ_INVALID_HANDLE
		then	-- 깃발 상태이상 해제
			for k = 1, #KQ_FLAG_ABSTATE
			do
				cResetAbstate( FlagInfo["FPHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"] )
			end
		end

		if FlagInfo["FHND"] ~= KQ_INVALID_HANDLE
		then	-- 깃발 오브젝트 삭제
			cNPCVanish( FlagInfo["FHND"] )
		end

		-- 깃발 정보 초기화
		FlagInfo["FHND"]			= KQ_INVALID_HANDLE
		FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
		FlagInfo["FINDEX"]			= ""
		FlagInfo["FPICK_TIME"]		= 0
		FlagInfo["FREGEN_TIME"] 	= 0
		FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
		FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]


		-- 몬스터 삭제( 아이템 몬스터 )
		for i = 1, #KSMemory["MOB_LIST"]
		do
			cNPCVanish( KSMemory["MOB_LIST"][i]["MHND"] )
			KSMemory["MOB_LIST"][i] = nil
		end


		-- 팀별 득점 포인트 삭제
		for i = 1, #TeamInfo
		do
			if TeamInfo[i]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
			then	-- 득점 포인트 핸들 확인
				cNPCVanish( TeamInfo[i]["TPOINT_HND"] )
				TeamInfo[i]["TPOINT_HND"] = KQ_INVALID_HANDLE
			end
		end


		cTimer( KSMemory["FIELD_NAME"], 0 )


		local nNextStep = 10						-- SF_END_WAIT
		if KSMemory["GAME_TYPE"] == KQ_GAME_TYEP["KGT_NORMAL"] 										and -- 일반 경기
		   TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] == TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]		-- 무승부
		then
			nNextStep = KSMemory["STEP_NO"] + 1		-- SF_EXTRATIME_INIT
		else
			for i = 1, #KSMemory["PLAYER_LIST"]
			do
				cSetAbstate( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_STUN_ABSTATE["KSA_INDEX"], KQ_STUN_ABSTATE["KSA_STR"], KQ_STUN_ABSTATE["KSA_KEEPTIME"] )
			end
		end


		if KSMemory["STEP_NEXT_TIME"] ~= 0
		then
			cScriptMessage( KSMemory["FIELD_NAME"], KQ_MSG["KM_GAME_TIME"][1]["KM_INDEX"] )
		end


		if #KQ_STEP >= nNextStep
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= nNextStep													-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end

------------------------------------------------------------------------------------------
--                             연장전 진행을 위한 초기화                                --
------------------------------------------------------------------------------------------
function SF_EXTRATIME_INIT( KSMemory, nCurSec )
cExecCheck "SF_EXTRATIME_INIT"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		-- 문 닫기
		for i = 1, #KSMemory["DOOR_LIST"]
		do
			cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "close" )
		end

		-- 팀위치로 이동
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			local nTeamNo = KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]	-- 팀 번호

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- 킹덤 퀘스트맵에 접속해있는지 확인
				cLinkTo( KSMemory["PLAYER_LIST"][i]["PHND"], KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
			end
		end


		-- 연장전 설정
		KSMemory["GAME_TYPE"] = KQ_GAME_TYEP["KGT_EXTRATIME"]


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                                  게임 끝 대기                                        --
------------------------------------------------------------------------------------------
function SF_END_WAIT( KSMemory, nCurSec )
cExecCheck "SF_END_WAIT"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		local TeamInfo			= KSMemory["TEAM_LIST"]	-- 팀 정보
		local RedTeamResult		= nil					-- 레드 팀 결과	정보
		local BlueTeamResult	= nil					-- 블루 팀 결과	정보
		local PlayerReward 		= nil					-- 플레이어 결과 정보

		if TeamInfo == nil
		then	-- 팀 정보 확인
			return false
		end

		if TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] == TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]
		then	-- 무승부
			RedTeamResult 	= KQ_RESULT["KR_DRAW"]
			BlueTeamResult	= KQ_RESULT["KR_DRAW"]
		elseif TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"] > TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"]
		then	-- 레드팀 승리
			RedTeamResult 	= KQ_RESULT["KR_WIN"]
			BlueTeamResult	= KQ_RESULT["KR_LOSE"]
		else	-- 블루팀 승리
			RedTeamResult 	= KQ_RESULT["KR_LOSE"]
			BlueTeamResult	= KQ_RESULT["KR_WIN"]
		end


		-- 게임 결과 처리
		for i = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == true
			then	-- 킹덤 퀘스트맵에 접속해있는지 확인

				if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
				then	-- 레드 팀
					PlayerReward = RedTeamResult
				elseif KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
				then	-- 블루 팀
					PlayerReward = BlueTeamResult
				end

				cPartyLeave( KSMemory["PLAYER_LIST"][i]["PHND"] )										-- 파티 해제
				cViewSlotUnEquipAll( KSMemory["PLAYER_LIST"][i]["PHND"] )								-- 코스튬 해제
				cResetAbstate( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_MAPLOGIN_ABSTATE["KMA_INDEX"] )	-- 이동 속도 증가 상태이상 제거
				cKQRewardIndex( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_REWAED"] )		-- 보상
				cEffectMsg( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_EFFECT_MSG"] )		-- 이펙트 메세지
				cEmoticon( KSMemory["PLAYER_LIST"][i]["PHND"], PlayerReward["KRE_EMOTICON"] )			-- 이모션
			end

			-- 팀 번호 초기화
			KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] = KQ_TEAM_NO["KTN_DEFAULT"]
		end

		-- 팀 정보 초기화
		for i = 1, #KSMemory["TEAM_LIST"]
		do
			KSMemory["TEAM_LIST"][i]["TSCORE"] 			= 0
			KSMemory["TEAM_LIST"][i]["TPOINT_HND"] 		= KQ_INVALID_HANDLE
			KSMemory["TEAM_LIST"][i]["TMEMBER_LIST"] 	= nil
			KSMemory["TEAM_LIST"][i]["TMEMBER_LIST"]	= {}
		end


		-- 타이머 초기화
		cTimer( KSMemory["FIELD_NAME"], 0 )


		if #KQ_STEP >= (KSMemory["STEP_NO"] + 1)
		then	-- 다음 단계 확인

			-- 단계 설정
			KSMemory["STEP_NO"] 		= KSMemory["STEP_NO"] + 1									-- 다음 단계
			KSMemory["STEP_NEXT_TIME"]	= nCurSec + KQ_STEP[KSMemory["STEP_NO"]]["KS_NEXT_TIME"]	-- 다음 단계 진행 시간


			local MsgIndex = KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]	-- 메세지 정보

			if MsgIndex ~= nil
			then	-- 메세지 인덱스 확인

				local MsgData = KQ_MSG[MsgIndex]	--	메세지 정보

				if MsgData ~= nil
				then	-- 메세지 정보 학인
					KSMemory["MSG_NO"] 			= 1									-- 메세지 단계
					KSMemory["MSG_NEXT_TIME"] 	= nCurSec + MsgData[1]["KM_TIME"]	-- 메세지 출력 시간
				end
			end
		end
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

end


------------------------------------------------------------------------------------------
--                                    게임 끝                                           --
------------------------------------------------------------------------------------------
function SF_END( KSMemory, nCurSec )
cExecCheck "SF_END"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	if KSMemory["STEP_NEXT_TIME"] <= nCurSec
	then	-- 현재 단계 진행 시간 확인

		-- 마을로 이동
		cLinkToAll( KSMemory["FIELD_NAME"], KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"], KQ_RETURN_MAP["KRM_Y"] )

		-- 킹덤 퀘스트 종료
		cEndOfKingdomQuest( KSMemory["FIELD_NAME"] )


		-- 다음 단계 설정
		KSMemory["STEP_NO"] 		= nil
		KSMemory["STEP_NEXT_TIME"]	= nil
		return true
	end


	-- 메시지 출력
	KF_MESSAGE( KSMemory, nCurSec )

	return true

end


------------------------------------------------------------------------------------------
--                               플레이어 깃발 확인                                     --
------------------------------------------------------------------------------------------
function FLAG_PLAYER_CHECK( KSMemory, nCurSec )
cExecCheck "FLAG_PLAYER_CHECK"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end


	local TeamInfo = KSMemory["TEAM_LIST"]
	local FlagInfo = KSMemory["FLAG_INFO"]

	if TeamInfo == nil
	then	-- 팀 정보 확인
		return
	end

	if FlagInfo == nil
	then	-- 깃발 정보 확인
		return
	end

	if FlagInfo["FREGEN_TIME"] ~= 0
	then	-- 깃발 리젠 타임 확인
		return
	end

	if FlagInfo["FPHND"] == KQ_INVALID_HANDLE
	then	-- 깃발 획득 플레이어 확인
		return
	end


	local PlayerInfo	= nil						-- 플레이어 정보
	local PlayerMaxNum	= #KSMemory["PLAYER_LIST"]	-- 게임 참가 플레이어 수

	-- 깃발 획득 플레이어 찾기
	for i = 1, PlayerMaxNum
	do
		if FlagInfo["FPHND"] == KSMemory["PLAYER_LIST"][i]["PHND"]
		then
			PlayerInfo = KSMemory["PLAYER_LIST"][i]
		end
	end

	if PlayerInfo == nil
	then	-- 플레이어 정보 확인
		return
	end


	if cIsInMap( PlayerInfo["PHND"], KSMemory["FIELD_NAME"] ) == nil
	then	--  킹덤 퀘스트맵에 접속해있지 않을 경우

		-- 마지막 위치에 깃발 소환
		FlagInfo["FHND"] = cMobRegen_XY( KSMemory["FIELD_NAME"], KQ_FLAG["KF_INDEX"], FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"], 0 )

		if FlagInfo["FHND"] == nil then
			FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
		else
			-- 깃발 루아 스크립트 설정
			cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
			cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

			-- 깃발 드랍 알림
			cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_DROP"], PlayerInfo["PNAME"] )

			-- 깃발 정보 설정
			FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
			FlagInfo["FINDEX"]			= KQ_FLAG["KF_INDEX"]
			FlagInfo["FPICK_TIME"]		= nCurSec + KQ_FLAG["KF_PICK_DELAY"]
			FlagInfo["FREGEN_TIME"] 	= 0

			-- 득점 포인트 삭제
			if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
			then
				cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
				TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
			end
		end
	else

		-- 깃발 상태이상 지속시간
		local RestTime = cAbstateRestTime( PlayerInfo["PHND"], KQ_FLAG_ABSTATE[1]["KFA_INDEX"] )

		if RestTime == nil
		then -- 깃발 상태이상 지속시간 확인

			-- 깃발 화살표 상태이상 제거
			cResetAbstate( FlagInfo["FPHND"], KQ_FLAG_ABSTATE[2]["KFA_INDEX"] )

			-- 깃발 소환
			FlagInfo["FHND"] = cMobRegen_Obj( KQ_FLAG["KF_INDEX"], PlayerInfo["PHND"] )

			if FlagInfo["FHND"] == nil then
				FlagInfo["FHND"] 			= KQ_INVALID_HANDLE
			else
				-- 깃발 루아 스크립트 설정
				cSetAIScript( KQ_SCRIPT_NAME, FlagInfo["FHND"] )
				cAIScriptFunc( FlagInfo["FHND"], "Entrance", "KF_FLGAG_OBJECT" )

				-- 깃발 드랍 알림
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_DROP"], PlayerInfo["PNAME"] )

				-- 깃발 정보 설정
				FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
				FlagInfo["FINDEX"]			= KQ_FLAG["KF_INDEX"]
				FlagInfo["FPICK_TIME"]		= nCurSec + KQ_FLAG["KF_PICK_DELAY"]
				FlagInfo["FREGEN_TIME"] 	= 0

				-- 깃발 위치 설정
				FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] = cObjectLocate( PlayerInfo["PHND"] )

				if FlagInfo["FREGEN_X"] == nil or FlagInfo["FREGEN_Y"] == nil
				then	-- 플레이어 위치 정보 확인
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_Y"]
				end

				-- 득점 포인트 삭제
				if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
				then
					cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
					TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
				end
			end
		else
			if TeamInfo[PlayerInfo["PTEAM_NO"]] ~= nil
			then	-- 플레이어 정보 확인

				-- 플레이어 위치
				FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] = cObjectLocate( PlayerInfo["PHND"] )

				if FlagInfo["FREGEN_X"] == nil or FlagInfo["FREGEN_Y"] == nil
				then	-- 플레이어 위치 정보 확인
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_X"] = KQ_FLAG_POINT["KFP_Y"]
				end


				-- 스코어 포인트 거리
				local Dist 		= cDistanceSquar( KQ_TEAM[PlayerInfo["PTEAM_NO"]]["KT_POINT_X"], KQ_TEAM[PlayerInfo["PTEAM_NO"]]["KT_POINT_Y"], FlagInfo["FREGEN_X"], FlagInfo["FREGEN_Y"] )
				local CheckDist	= ( KQ_TEAM_POINT_CHECK_DIST * KQ_TEAM_POINT_CHECK_DIST )

				if  Dist <= CheckDist
				then	-- 스코어 포인트 거리 확인

					-- 깃발 해제
					for k = 1, #KQ_FLAG_ABSTATE
					do
						cResetAbstate( PlayerInfo["PHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"] )
					end

					-- 깃발 정보 초기화 및 리젠 시간 설정
					FlagInfo["FHND"]			= KQ_INVALID_HANDLE
					FlagInfo["FPHND"] 			= KQ_INVALID_HANDLE
					FlagInfo["FINDEX"]			= ""
					FlagInfo["FPICK_TIME"]		= 0
					FlagInfo["FREGEN_TIME"] 	= nCurSec + KQ_FLAG_POINT["KFP_REGEN_TIME"]
					FlagInfo["FREGEN_X"] 		= KQ_FLAG_POINT["KFP_X"]
					FlagInfo["FREGEN_Y"] 		= KQ_FLAG_POINT["KFP_Y"]

					-- 득점
					TeamInfo[PlayerInfo["PTEAM_NO"]]["TSCORE"] = TeamInfo[PlayerInfo["PTEAM_NO"]]["TSCORE"] + 1

					-- 팀 정보 알림
					cScoreInfo_AllInMap( KSMemory["FIELD_NAME"],  #KQ_TEAM , TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"],
																			 TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"] )

					-- 득점 포인트 삭제
					if TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] ~= KQ_INVALID_HANDLE
					then
						cNPCVanish( TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] )
						TeamInfo[PlayerInfo["PTEAM_NO"]]["TPOINT_HND"] = KQ_INVALID_HANDLE
					end

					-- 연장전에서 득점시, 바로 경기 종료
					if KSMemory["GAME_TYPE"] == KQ_GAME_TYEP["KGT_EXTRATIME"]
					then
						KSMemory["STEP_NEXT_TIME"] = 0
					else
						-- 득점 알림
						if PlayerInfo["PTEAM_NO"] == KQ_TEAM_NO["KTN_RED"]
						then	-- 레드 팀
							cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_POINT_RED"], PlayerInfo["PNAME"] )
						elseif PlayerInfo["PTEAM_NO"] == KQ_TEAM_NO["KTN_BLUE"]
						then	-- 블루 팀
							cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_POINT_BLUE"], PlayerInfo["PNAME"] )
						end

						-- 득,실점 사운드
						for i = 1, #KSMemory["PLAYER_LIST"]
						do
							if KSMemory["PLAYER_LIST"][i]["PTEAM_NO"] == PlayerInfo["PTEAM_NO"]
							then
								cPlaySound( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_SOUND["KS_GETPOINT"] );
							else
								cPlaySound( KSMemory["PLAYER_LIST"][i]["PHND"], KQ_SOUND["KS_LOSEPOINT"] );
							end
						end

						-- 깃발 생성 관련 메세지 알림
						cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_REGEN01"] )
					end

				end
			end
		end
	end

end


-- 킹덤 퀘스트 단계별 데이터
KQ_STEP =
{
  --------------------------------------------------------------------------------------------
  --  진행 함수,							다음 진행 시간,		메시지 데이터( KDSpring_Data )
  --------------------------------------------------------------------------------------------
	{ KS_FUNC = SF_DIVIDE_TEAM_WAIT,	KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 30, 	KS_MSG = nil 					},		-- 1	팀 나누기 대기
	{ KS_FUNC = SF_DIVIDE_TEAM, 		KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 5, 	KS_MSG = "KM_DIVIDE_TEAM"		},		-- 2	팀 나누기
	{ KS_FUNC = SF_START_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 55, 	KS_MSG = "KM_START_WAIT" 		},		-- 3	게임 시작 대기
	{ KS_FUNC = SF_START, 				KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 5, 	KS_MSG = nil					},		-- 4	게임 시작
	{ KS_FUNC = SF_ROUTINE, 			KS_TIMER = true,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 600, KS_MSG = nil					},		-- 5	게임 진행

	-- 연장전
	{ KS_FUNC = SF_EXTRATIME_INIT, 		KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 10, 	KS_MSG = "KM_EXTRA_TIME_WAIT"	},		-- 6	연장전 시작을 위한 초기화
	{ KS_FUNC = SF_START_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 10,	KS_MSG = nil					},		-- 7	연장전 게임 시작 대기
	{ KS_FUNC = SF_START, 				KS_TIMER = false,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 5, 	KS_MSG = nil					},		-- 8	연장전 게임 시작
	{ KS_FUNC = SF_ROUTINE, 			KS_TIMER = true,	KS_LINKTO_TEAM = true,	KS_NEXT_TIME = 180,	KS_MSG = nil					},		-- 9	연장전 게임 진행
	{ KS_FUNC = SF_END_WAIT, 			KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 2, 	KS_MSG = nil					},		-- 10	게임 종료 대기
	{ KS_FUNC = SF_END,					KS_TIMER = false,	KS_LINKTO_TEAM = false,	KS_NEXT_TIME = 60, 	KS_MSG = "KM_END"				},		-- 11	게임 종료
}
