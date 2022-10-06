require( "common" )
require( "KQ/KDSpring/KDSpring_Data" )
require( "KQ/KDSpring/KDSpring_StepFunc" )


------------------------------------------------------------------------------------------
--                            킹덤 퀘스트 데이터 초기화                                 --
------------------------------------------------------------------------------------------
function KF_INIT( Field, KSMemory, nCurSec )
cExecCheck "KF_INIT"

	if Field == nil
	then	-- 필드 이름 확인
		return
	end

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return
	end

	if nCurSec == nil
	then	-- 시간 확인
		return
	end


	-- 킹덤 퀘스트 필드 스크립트 설정
	cSetFieldScript( Field, KQ_SCRIPT_NAME )
	cFieldScriptFunc( Field, "MapLogin", "KF_MAP_LOGIN" )	-- 캐릭터 맵로그인시 호출되는 함수 설정


	-- 진행 정보 초기화
	KSMemory["FIELD_NAME"] 		= Field
	KSMemory["WORK_TICK"]		= 0
	KSMemory["STEP_NO"] 		= 1
	KSMemory["STEP_NEXT_TIME"] 	= nCurSec + KQ_STEP[1]["KS_NEXT_TIME"]
	KSMemory["MSG_NO"] 			= 1
	KSMemory["MSG_NEXT_TIME"] 	= 1
	KSMemory["GAME_TYPE"] 		= KQ_GAME_TYEP["KGT_NORMAL"]

	-- 깃발 정보 초기화
	KSMemory["FLAG_INFO"]						= {}
	KSMemory["FLAG_INFO"]["FHND"]				= KQ_INVALID_HANDLE
	KSMemory["FLAG_INFO"]["FINDEX"]				= ""
	KSMemory["FLAG_INFO"]["FPHND"]				= KQ_INVALID_HANDLE
	KSMemory["FLAG_INFO"]["FPICK_TIME"]			= 0
	KSMemory["FLAG_INFO"]["FREGEN_TIME"]		= 0
	KSMemory["FLAG_INFO"]["FREGEN_X"]			= KQ_FLAG_POINT["KFP_X"]
	KSMemory["FLAG_INFO"]["FREGEN_Y"]			= KQ_FLAG_POINT["KFP_Y"]

	-- 플레이어 리스트 초기화
	KSMemory["PLAYER_LIST"]	= {}
--	KSMemory["PLAYER_LIST"][n]	= {}
--	KSMemory["PLAYER_LIST"][n]["PHND"]			= KQ_INVALID_HANDLE
--	KSMemory["PLAYER_LIST"][n]["PREG_NO"]		= KQ_INVALID_HANDLE
--	KSMemory["PLAYER_LIST"][n]["PNAME"]			= ""
--	KSMemory["PLAYER_LIST"][n]["PTEAM_NO"]		= 0
--	KSMemory["PLAYER_LIST"][n]["PIS_MAP"]		= false
--	KSMemory["PLAYER_LIST"][n]["PPICK_TIME"]	= 0


	-- 팀 정보 초기화
	KSMemory["TEAM_LIST"] =
	{
		{	-- RED TEAM
			TSCORE			= 0,
			TPOINT_HND 		= KQ_INVALID_HANDLE,
			TMEMBER_LIST	= {},
		},

		{	-- BLUE TEAM
			TSCORE			= 0,
			TPOINT_HND 		= KQ_INVALID_HANDLE,
			TMEMBER_LIST 	= {},
		},
	}

	-- 몬스터 정보
	KSMemory["MOB_LIST"] 	= {}
--	KSMemory["MOB_LIST"][n]	= {}
--	KSMemory["MOB_LIST"][n]["MHND"]			= KQ_INVALID_HANDLE
--	KSMemory["MOB_LIST"][n]["MREGEN_TIME"]	= 0

	-- 문 소환
	KSMemory["DOOR_LIST"]	= {}
	for i = 1, #KQ_DOOR
	do
		KSMemory["DOOR_LIST"][i] = cDoorBuild( KSMemory["FIELD_NAME"], KQ_DOOR[i]["KD_INDEX"], KQ_DOOR[i]["KD_X"], KQ_DOOR[i]["KD_Y"], KQ_DOOR[i]["KD_DIR"], KQ_DOOR[i]["KD_SCALE"] )
		cDoorAction( KSMemory["DOOR_LIST"][i], KQ_DOOR[i]["KD_BLOCK"], "open" )
	end

end


------------------------------------------------------------------------------------------
--                                    맵 로그인                                         --
------------------------------------------------------------------------------------------
function KF_MAP_LOGIN( Field, Handle )
cExecCheck "KF_MAP_LOGIN"

	local KSMemory	= InstanceField[Field]	-- 킹덤 퀘스트 버퍼
	local nCurSec 	= cCurSec();			-- 현재 시간(초)

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return
	end

	if Handle == nil
	then	-- 플레이어 핸들 확인
		return
	end

	if nCurSec == nil
	then	-- 시간 확인
		nCurSec = 0
	end


	local nAdminLevel	= cGetAdminLevel( Handle )	-- 운영자 레벨
	local nCharNo		= cGetCharNo( Handle )		-- 캐릭터 번호
	local TeamInfo 		= KSMemory["TEAM_LIST"]		-- 킹덤 퀘스트 버퍼 : 팀 정보

	if nAdminLevel > 0
	then	-- 운영자 레벨 확인
		if cAbstateRestTime( Handle, "StaGMHideMode" ) ~= nil
		then	-- Hide 상태 확인
			return
		end
	end

	if nCharNo == nil
	then	-- 캐릭터 번호 확인
		return
	end

	if TeamInfo == nil
	then	-- 팀 정보 확인
		return
	end


	local bLinkto		= false							-- 팀 위치로 이동
	local bNewPlayer 	= true							-- 새로 들어온 플레이어
	local nPlayerNum 	= #KSMemory["PLAYER_LIST"]		-- 참여 플레이어 수
	local nPlayerIndex	= nPlayerNum + 1				-- 플레이어 목록에 새로 추가될 인덱스
	local nTeamNo 		= KQ_TEAM_NO["KTN_DEFAULT"]		-- 팀 번호

	for i = 1, nPlayerNum
	do	-- 플레이어 목록 탐색

		if KSMemory["PLAYER_LIST"][i]["PREG_NO"] == nCharNo
		then	-- 플레이어 목록에 존재하는 플레이어

			bNewPlayer		= false
			nPlayerIndex	= i
			nTeamNo 		= KSMemory["PLAYER_LIST"][i]["PTEAM_NO"]

			if KSMemory["PLAYER_LIST"][i]["PHND"] ~= Handle
			then	-- 서버 재접속으로 핸들이 바뀐 플레이어

				cAssertLog( "Handle Change" )
				KSMemory["PLAYER_LIST"][i]["PHND"] = Handle

				for j = 1, #TeamInfo[nTeamNo]
				do	-- 팀 목록 탐색

					if TeamInfo[nTeamNo]["TMEMBER_LIST"][j] == KSMemory["PLAYER_LIST"][i]["PHND"]
					then	-- 팀 멤버 확인
						TeamInfo[nTeamNo]["TMEMBER_LIST"][j] = Handle
					end
				end
			end

			KSMemory["PLAYER_LIST"][i]["PPICK_TIME"]	= nCurSec + KQ_PLAYER_PICK_DELAY	-- 깃발 획득 가능 시간

			if KSMemory["PLAYER_LIST"][i]["PIS_MAP"] == false
			then	-- 킹퀘 앱에 있었는지 확인
				bLinkto									= true
				KSMemory["PLAYER_LIST"][i]["PIS_MAP"] 	= true
			end

			break
		end
	end


	if bNewPlayer == true			and		-- 새로 들어온 플레이어
	   nPlayerNum >= KQ_MAX_PLAYER			-- 참가 플레이어의 수
	then	-- 참가 플레이어 최대 수 확인
		cLinkTo( Handle, KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"],KQ_RETURN_MAP["KRM_Y"] )
		return
	end


	if bNewPlayer == true
	then	-- 새로 들어온 플레이어
		KSMemory["PLAYER_LIST"][nPlayerIndex] = {}
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PHND"]		= Handle							-- 핸들
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PREG_NO"]	= nCharNo							-- 캐릭터 번호
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PNAME"]		= cGetPlayerName( Handle )			-- 캐릭터 이름
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PTEAM_NO"]	= KQ_TEAM_NO["KTN_DEFAULT"]			-- 팀 번호
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PIS_MAP"]	= true								-- 맵에 존재하는지
		KSMemory["PLAYER_LIST"][nPlayerIndex]["PPICK_TIME"]	= nCurSec + KQ_PLAYER_PICK_DELAY	-- 깃발 획득 가능 시간

		-- 파티 해제
		cPartyLeave( Handle )
	end

	-- 점수 정보 보내기
	cScoreInfo( Handle, #KQ_TEAM, TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TSCORE"], TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TSCORE"] )


	-- 맵 로그인시 상태이상 걸기
	cSetAbstate( Handle, KQ_MAPLOGIN_ABSTATE["KMA_INDEX"], KQ_MAPLOGIN_ABSTATE["KMA_STR"], KQ_MAPLOGIN_ABSTATE["KMA_KEEPTIME"] )


	if nTeamNo == KQ_TEAM_NO["KTN_DEFAULT"]
	then	-- 팀 번호 확인

		local RedMemberNum	= #TeamInfo[KQ_TEAM_NO["KTN_RED"]]["TMEMBER_LIST"]
		local BlueMemberNum	= #TeamInfo[KQ_TEAM_NO["KTN_BLUE"]]["TMEMBER_LIST"]

		if RedMemberNum > 0 or BlueMemberNum > 0
		then	-- 팀 배정 여부 확인

			if cPermileRate( 500 ) == 1
			then	-- 랜덤하게 팀 번호 설정
				nTeamNo = KQ_TEAM_NO["KTN_RED"]

				if RedMemberNum > BlueMemberNum
				then	-- 레드팀 인원이 블루팀보다 많을 경우
					nTeamNo = KQ_TEAM_NO["KTN_BLUE"]
				end
			else
				nTeamNo = KQ_TEAM_NO["KTN_BLUE"]

				if BlueMemberNum > RedMemberNum
				then	-- 블루팀 인원이 레드팀보다 많을 경우
					nTeamNo = KQ_TEAM_NO["KTN_RED"]
				end
			end

			local nIndex = (#TeamInfo[nTeamNo]["TMEMBER_LIST"] + 1)

			-- 팀 멤버에 추가
			TeamInfo[nTeamNo]["TMEMBER_LIST"][nIndex] 			= Handle
			KSMemory["PLAYER_LIST"][nPlayerIndex]["PTEAM_NO"]	= nTeamNo

			-- 파티 참가
			cPartyJoin( TeamInfo[nTeamNo]["TMEMBER_LIST"][1], Handle )

			-- 팀 시작점으로 이동
			cLinkTo( Handle, KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
		end

		return
	end


	if bLinkto == true											and	-- 팀 위치로 이동
	   KQ_STEP[KSMemory["STEP_NO"]]["KS_LINKTO_TEAM"] == true		-- 스탭 정보 : 팀 위치로 이동
	then	-- 플레이어 팀 위치로 이동
		cLinkTo( Handle, KSMemory["FIELD_NAME"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"] )
		return
	end


	for j = 1, #KQ_TEAM[nTeamNo]["KT_UNIFORM"]
	do	-- 팀 유니폼 입히기
		cViewSlotEquip( Handle, KQ_TEAM[nTeamNo]["KT_UNIFORM"][j] )
	end


	if KQ_STEP[KSMemory["STEP_NO"]]["KS_TIMER"] == true
	then	-- 타이머 표시 여부 확인
		local nTime = (KSMemory["STEP_NEXT_TIME"] - nCurSec)
		cTimer_Obj( Handle, nTime )
	end

end


------------------------------------------------------------------------------------------
--                                    메세지 전송                                       --
------------------------------------------------------------------------------------------
function KF_MESSAGE( KSMemory, nCurSec )
cExecCheck "KF_MESSAGE"

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return false
	end

	if nCurSec == nil
	then	-- 시간 확인
		return false
	end

	if KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"] == nil
	then	-- 해당 스탭 메시지 정보 확인
		return true
	end

	if KSMemory["MSG_NEXT_TIME"] > nCurSec
	then	-- 메시지 출력 시간 확인
		return true
	end


	local MsgData = KQ_MSG[KQ_STEP[KSMemory["STEP_NO"]]["KS_MSG"]]	-- 메시지 정보
	local MsgStep = KSMemory["MSG_NO"]								-- 메시지 단계

	if MsgData == nil
	then	-- 메시지 정보 확인
		return false
	end

	if MsgStep == nil
	then	-- 메시지 단계 확인
		return false
	end

	if #MsgData < MsgStep
	then	--메시지 단계 최대치 확인
		return true
	end


	if MsgData[MsgStep]["KM_TYPE"] == KQ_MSG_TYPE["KMT_SHN"]
	then	-- ScriptMessage
		cScriptMessage( KSMemory["FIELD_NAME"], MsgData[MsgStep]["KM_INDEX"], MsgData[MsgStep]["KM_VAL"] )
	elseif MsgData[MsgStep]["KM_TYPE"] == KQ_MSG_TYPE["KMT_TXT"]
	then	-- Notice
		cNotice( KSMemory["FIELD_NAME"], MsgData[MsgStep]["KM_FILE_NAME"], MsgData[MsgStep]["KM_INDEX"] )
	end


	-- 메시지 다음 단계 설정
	MsgStep = MsgStep + 1

	if #MsgData < MsgStep
	then	-- 모든 메시지 처리
		KSMemory["MSG_NO"] 			= 1
		KSMemory["MSG_NEXT_TIME"]	= KSMemory["STEP_NEXT_TIME"]
	else	-- 다음 단계 설정
		KSMemory["MSG_NO"] 			= MsgStep
		KSMemory["MSG_NEXT_TIME"]	= nCurSec + MsgData[MsgStep]["KM_TIME"]
	end

end


------------------------------------------------------------------------------------------
--                               깃발 오브젝트 루틴                                     --
------------------------------------------------------------------------------------------
function KF_FLGAG_OBJECT( Handle, Field )
cExecCheck "KF_FLGAG_OBJECT"

	local KSMemory	= InstanceField[Field]		-- 킹덤 퀘스트 버퍼
	local nCurSec	= cCurSec()					-- 현재 시간(초)

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인
		return ReturnAI.END
	end

	if KSMemory["FLAG_INFO"] == nil
	then	-- 킹덤 퀘스트 버퍼 : 깃발 정보 확인
		return ReturnAI.END
	end

	if KSMemory["FLAG_INFO"]["FPHND"] ~= KQ_INVALID_HANDLE
	then	-- 킹덤 퀘스트 버퍼 : 누군가 깃발을 가지고 있을 경우
		cNPCVanish( Handle )
		return ReturnAI.END
	end

	if KSMemory["PLAYER_LIST"] == nil
	then	-- 킹덤 퀘스트 버퍼 : 플레이어 정보 확인
		return ReturnAI.END
	end

	if nCurSec == nil
	then	-- 시간 변수 확인
		return ReturnAI.END
	end

	if nCurSec < KSMemory["FLAG_INFO"]["FPICK_TIME"]
	then	-- 시간 확인
		return ReturnAI.END
	end


	local nCheckDist = KQ_FLAG["KF_CHECK_DIST"]	-- 깃발 체크 거리(기본 깃발 오브젝트 거리)
	if KSMemory["FLAG_INFO"]["FINDEX"] == KQ_FLAG_POINT["KFP_INDEX"]
	then	-- 깃발 종류 확인 ( 깃발 오브젝트, 깃발 포인트 오브젝트 )
		nCheckDist = KQ_FLAG_POINT["KFP_CHECK_DIST"]
	end


	-- 깃발 체크 거리 안에 있는 플레이어 리스트 가져오기
	local PlayerList = { cNearObjectList( Handle, nCheckDist, ObjectType["Player"] ) }

	for i = 1, #PlayerList
	do
		for j = 1, #KSMemory["PLAYER_LIST"]
		do
			if KSMemory["PLAYER_LIST"][j]["PHND"] == PlayerList[i] 					and	-- 핸들
			   KSMemory["PLAYER_LIST"][j]["PTEAM_NO"] ~= KQ_TEAM_NO["KTN_DEFAULT"]	and	-- 팀 번호
			   KSMemory["PLAYER_LIST"][j]["PPICK_TIME"] <= nCurSec						-- 깃발 획득가능 시간
			then	-- 깃발 획득 가능 초건 확인

				-- 깃발 정보 설정
				KSMemory["FLAG_INFO"]["FHND"]	= KQ_INVALID_HANDLE	-- 깃발 핸들
				KSMemory["FLAG_INFO"]["FPHND"]	= PlayerList[i]		-- 깃발 획득 플레이어 핸들

				-- 깃발 상태이상 걸기
				for  k = 1, #KQ_FLAG_ABSTATE
				do
					cSetAbstate( KSMemory["FLAG_INFO"]["FPHND"], KQ_FLAG_ABSTATE[k]["KFA_INDEX"], KQ_FLAG_ABSTATE[k]["KFA_STR"], KQ_FLAG_ABSTATE[k]["KFA_KEEPTIME"] )
				end

				-- 깃발 획득 알림
				cScriptMessage( KSMemory["FIELD_NAME"], KQ_FLAG_SCRIPT_MSG["KFSM_HAVE"], KSMemory["PLAYER_LIST"][j]["PNAME"] )

				-- 리젠 포인트 생성
				local nTeamNo = KSMemory["PLAYER_LIST"][j]["PTEAM_NO"]

				if nTeamNo ~= nil
				then	-- 팀 번호 확인
					if KSMemory["TEAM_LIST"][nTeamNo]["TPOINT_HND"] == KQ_INVALID_HANDLE
					then	-- 리젠 포인트 핸드 확인
						KSMemory["TEAM_LIST"][nTeamNo]["TPOINT_HND"] = cMobRegen_XY( Field, KQ_TEAM[nTeamNo]["KT_POINT_INDEX"], KQ_TEAM[nTeamNo]["KT_POINT_X"], KQ_TEAM[nTeamNo]["KT_POINT_Y"], 0 )
					end

					for k = 1, #KSMemory["TEAM_LIST"][nTeamNo]["TMEMBER_LIST"]
					do
						cPlaySound( KSMemory["TEAM_LIST"][nTeamNo]["TMEMBER_LIST"][k], KQ_SOUND["KS_GETFLAG"] );
					end
				end

				-- 깃발 삭제
				cNPCVanish( Handle )
				return ReturnAI.END
			end
		end
	end


	return ReturnAI.END

end


------------------------------------------------------------------------------------------
--                                    메인 함수                                         --
------------------------------------------------------------------------------------------
function Main( Field )
cExecCheck "Main"

	local nCurSec	= cCurSec()				-- 현재 시간(초)
	local KSMemory	= InstanceField[Field]	-- 킹덤 퀘스트 버퍼

	if KSMemory == nil
	then	-- 킹덤 퀘스트 버퍼 확인

		-- 킹덤 퀘스트 버퍼 초기화
		InstanceField[Field]	= {}
		KSMemory				= InstanceField[Field]

		KF_INIT( Field, KSMemory, nCurSec )
	end


	if KSMemory["STEP_NO"] == nil
	then	-- 처리 단계 확인
		return
	end

	if KQ_STEP[KSMemory["STEP_NO"]]["KS_FUNC"]( KSMemory, nCurSec ) == false
	then	-- 스탭 함수 실행 실패
		cLinkToAll( KSMemory["FIELD_NAME"], KQ_RETURN_MAP["KRM_INDEX"], KQ_RETURN_MAP["KRM_X"], KQ_RETURN_MAP["KRM_Y"] )
		cEndOfKingdomQuest( KSMemory["FIELD_NAME"] )
	end

end
