require( "common" )


----------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 데이터
----------------------------------------------------------------------------------------------------

-- 할로윈 이벤트 맵 접속 정보
EVENT_MAP_DATA =
{
	-- 이동할 이벤트 맵 정보
	EMD_INDEX			= "E_Hwin",
	EMD_REGEN_X			= 914,
	EMD_REGEN_Y			= 238,

	-- 이벤트 맵 접속 조건
	EMD_ENTRY_CONDITION =
	{
		"StaE_Slime",
		"StaE_Honeying",
		"StaE_Phino",
		"StaE_LizardMan",
		"StaE_KingCrab",
		"StaE_SparkDog",
		"StaE_LavaVivi",
		"StaE_PhinoFlie",
		"StaE_MushRoom",
		"StaE_Spider",
		"StaE_B_CrackerHumar",
		"StaE_Helga",
		"StaE_JackO",
	    "StaE_Kebing",
        "StaE_ForasChief",
		"StaE_Zombie",
		"StaE_MaraCrew",
		"StaE_MaraElite",
		"StaE_MaraSailor",
		"StaE_Psyken",
		"StaE_PsykenDog",
		"StaE_Megan",
		"StaE_Yeti",
		"StaE_Imp",
		"StaE_Robo",
		"StaE_Hob",
		"StaE_Pinky",
		"StaE_WarH_Devildom",
		"StaE_ArkNovice",
		"StaE_ArkTech",
		"StaE_Mandragora",
		"StaE_S_Hayreddin",
		"StaE_Mara",
	}
}

-- 이벤트 게이트 에러 메시지
EVENT_ERROR_NOTICE =
{
	EEN_FILENAME 	= "Event",
	EEN_INDEX		= "SystemMsg_01",
}

-- 맵 이동 서버메뉴 정보
SERVER_MENU_DATA =
{
	-- 타이틀
	SMD_TITLE 	= { TITLE_SCRIPT_FILENAME = "MenuString", TITLE_INDEX = "LinkTitle", TITLE_STRING = nil },

	-- 버튼
	SMD_BT_YES	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "Yes", BT_STRING = nil, BT_FUNC = "Click_Yes" },
	SMD_BT_NO	= { BT_SCRIPT_FILENAME = "ETC", BT_INDEX = "No",  BT_STRING = nil, BT_FUNC = "Click_No" }
}

-- 로밍용 몬스터 정보
ROAMING_MOB_DATA =
{
	RMD_CHECK_INTERVAL = 0.1,

	{ RMD_INDEX = "E_HwinPhino", RMD_X = 13881, RMD_Y = 13411, RMG_REGEN_INTERVAL = 10 },		-- 1
	{ RMD_INDEX = "E_HwinFlie",  RMD_X = 13815, RMD_Y = 13411, RMG_REGEN_INTERVAL = 10 },		-- 2
}

-- 로밍 정보
ROAMING_PATTERN_DATA =
{
	RPD_CHECK_INTERVAL	= 0.1,	-- 도착지점 확인 시간 간격
	RPD_GOAL_INTERVAL	= 10,	-- 도착지점과의 체크 거리

	-- 이동 좌표
	{ { X = 13881, Y = 13411 }, { X = 14915, Y = 13396 }, { X = 13881, Y = 13411 }, },										-- 1
	{ { X = 13815, Y = 13411 }, { X = 14721, Y = 13404 }, { X = 13815, Y = 13411 }, },										-- 2
}

-- 몬스터 채팅 정보
MOB_CHAT_DATA =
{
	E_HwinPhino =
	{
		MCD_CHAT_INTERVAL 	= 10,
		MCD_SCRIPT_FILE		= "Event",

		"E_HwinPhino_Chat01",
		"E_HwinPhino_Chat02",
	},

	E_HwinFlie =
	{
		MCD_CHAT_INTERVAL 	= 10,
		MCD_SCRIPT_FILE		= "Event",

		"E_HwinFlie_Chat01",
		"E_HwinFlie_Chat02",
	},
}



----------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 전역 변수
----------------------------------------------------------------------------------------------------

-- 이벤트 게이트 용 버퍼
EventGateBuf = {}
--[[
EventGateBuf[ Handle ]["RoamingMobChackTime"]				= 로밍 몬스터 확인 시간
EventGateBuf[ Handle ]["RoamingMobList"]					= 로밍 몬스터 리스트
EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"] 	= 로밍 몬스터 핸들
EventGateBuf[ Handle ]["RoamingMobList"][ i ]["RegenTime"] 	= 로밍 몬스터 리젠 시간
--]]

-- 로밍 몬스터 용 버퍼
RoamingMobBuf = {}
--[[
RoamingMobBuf[ Handle ]["ChatData"]					= 몬스터 채팅 정보
RoamingMobBuf[ Handle ]["ChatTime"]					= 몬스터 채팅 시간
RoamingMobBuf[ Handle ]["ChatStep"]					= 몬스터 채팅 스탭

RoamingMobBuf[ Handle ]["MovePattern"]				= 이동 패턴 정보
RoamingMobBuf[ Handle ]["MoveBack"]					= 이동 패턴 돌아가기
RoamingMobBuf[ Handle ]["MoveStep"] 				= 이동 패턴 단계
RoamingMobBuf[ Handle ]["MoveCheckTime"] 			= 이동 패턴 확인 시간
--]]

----------------------------------------------------------------------------------------------------
-- 할로윈 이벤트 함수
----------------------------------------------------------------------------------------------------

-- 게이트 기본함수
function E_HwinIn( Handle, MapIndex )
cExecCheck "E_HwinIn"


	local CurSec = cCurrentSecond()


	-- 게이트 초기화
	if EventGateBuf[ Handle ] == nil
	then
		EventGateBuf[ Handle ] = {}
		EventGateBuf[ Handle ]["RoamingMobChackTime"] 	= CurSec
		EventGateBuf[ Handle ]["RoamingMobList"]		= {}

		cAIScriptFunc( Handle, "NPCClick", "EventGateClick" )
		cSetObjectDirect( Handle, 0 )

		-- 서버메뉴에서 사용할 문자열 가져오기
		if SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] == nil
		then
			local MapName = cGetMapName( EVENT_MAP_DATA["EMD_INDEX"] )
			SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"] = cGetScriptString( SERVER_MENU_DATA["SMD_TITLE"]["TITLE_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_TITLE"]["TITLE_INDEX"], MapName )
			SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_YES"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_INDEX"] )
			SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"]	  = cGetScriptString( SERVER_MENU_DATA["SMD_BT_NO"]["BT_SCRIPT_FILENAME"], SERVER_MENU_DATA["SMD_BT_NO"]["BT_INDEX"] )
		end

		-- 로밍 몬스터 소환
		for i = 1, #ROAMING_MOB_DATA
		do
			local dataRoamingMob	= ROAMING_MOB_DATA[ i ]
			local MobHandle			= cMobRegen_XY( MapIndex, dataRoamingMob["RMD_INDEX"], dataRoamingMob["RMD_X"], dataRoamingMob["RMD_Y"], 0 )

			if MobHandle ~= nil
			then
				cAIScriptSet( MobHandle, Handle )
				cAIScriptFunc( MobHandle, "Entrance", "RoamingMobRoutine" )
				cResetAbstate( MobHandle, "StaImmortal" )

				RoamingMobBuf[ MobHandle ] = {}
				RoamingMobBuf[ MobHandle ]["ChatData"] 		= MOB_CHAT_DATA[ dataRoamingMob["RMD_INDEX"] ]
				RoamingMobBuf[ MobHandle ]["ChatTime"] 		= CurSec
				RoamingMobBuf[ MobHandle ]["ChatStep"] 		= 1

				RoamingMobBuf[ MobHandle ]["MovePattern"]	= ROAMING_PATTERN_DATA[ i ]
				RoamingMobBuf[ MobHandle ]["MoveBack"]		= false
				RoamingMobBuf[ MobHandle ]["MoveStep"] 		= 1
				RoamingMobBuf[ MobHandle ]["MoveCheckTime"] = CurSec

				EventGateBuf[ Handle ]["RoamingMobList"][ i ] = {}
				EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"] = MobHandle
				EventGateBuf[ Handle ]["RoamingMobList"][ i ]["RegenTime"] = 0

				cWalkTo( MobHandle, ROAMING_PATTERN_DATA[ i ][ 1 ]["X"], ROAMING_PATTERN_DATA[ i ][ 1 ]["Y"], 500 )
			else
				cAssertLog( "Init - RoamingMob regen fail "..i )
			end
		end
	end

	-- 게이트 죽으면 스크립트 해제
	if cIsObjectDead( Handle ) ~= nil
	then

		for i = 1, #EventGateBuf[ Handle ]["RoamingMobList"]
		do
			local MobHandle = EventGateBuf[ Handle ]["RoamingMobList"][ i ]["MobHandle"]

			RoamingMobBuf[ MobHandle ] = nil
			cAIScriptSet( MobHandle )
			cNPCVanish( MobHandle )
		end

		EventGateBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 로밍 몬스터 확인
	if EventGateBuf[ Handle ]["RoamingMobChackTime"] <= CurSec
	then
		local RoamingMobList = EventGateBuf[ Handle ]["RoamingMobList"]

		for i = 1, #RoamingMobList
		do

			if RoamingMobList[ i ]["RegenTime"] == 0			-- 리젠 시간이 설정안된 경우
			then

				-- 로밍 몬스터가 죽었으면 리젠 시간 설정
				if cIsObjectDead( RoamingMobList[ i ]["MobHandle"] ) ~= nil
				then
					RoamingMobList[ i ]["RegenTime"] = CurSec + ROAMING_MOB_DATA[ i ]["RMG_REGEN_INTERVAL"]
				end

			elseif RoamingMobList[ i ]["RegenTime"] <= CurSec	-- 리젠 시간 확인
			then
				-- 로밍 몬스터 소환
				local dataRoamingMob	= ROAMING_MOB_DATA[ i ]
				local MobHandle			= cMobRegen_XY( MapIndex, dataRoamingMob["RMD_INDEX"], dataRoamingMob["RMD_X"], dataRoamingMob["RMD_Y"], 0 )

				if MobHandle ~= nil
				then
					cAIScriptSet( MobHandle, Handle )
					cAIScriptFunc( MobHandle, "Entrance", "RoamingMobRoutine" )
					cResetAbstate( MobHandle, "StaImmortal" )

					RoamingMobBuf[ MobHandle ] = {}
					RoamingMobBuf[ MobHandle ]["ChatData"] 		= MOB_CHAT_DATA[ dataRoamingMob["RMD_INDEX"] ]
					RoamingMobBuf[ MobHandle ]["ChatTime"] 		= CurSec
					RoamingMobBuf[ MobHandle ]["ChatStep"] 		= 1

					RoamingMobBuf[ MobHandle ]["MovePattern"]	= ROAMING_PATTERN_DATA[ i ]
					RoamingMobBuf[ MobHandle ]["MoveBack"]		= false
					RoamingMobBuf[ MobHandle ]["MoveStep"] 		= 1
					RoamingMobBuf[ MobHandle ]["MoveCheckTime"] = CurSec

					RoamingMobList[ i ]["MobHandle"] = MobHandle
					RoamingMobList[ i ]["RegenTime"] = 0
				else
					cAssertLog( "Init - RoamingMob regen fail "..i )
				end
			end
		end
	end

	return ReturnAI["END"]
end

-- 게이트 클릭
function EventGateClick( NPCHandle, PlyHandle, PlyCharNo  )
cExecCheck "EventGateClick"

	-- 입장 조건 확인
	local dataEntryCondition = EVENT_MAP_DATA[ "EMD_ENTRY_CONDITION" ]
	for i = 1, #dataEntryCondition
	do
		if cAbstateRestTime( PlyHandle, dataEntryCondition[ i ] ) ~= nil
		then
			cServerMenu( PlyHandle, NPCHandle, SERVER_MENU_DATA["SMD_TITLE"]["TITLE_STRING"],
											   SERVER_MENU_DATA["SMD_BT_YES"]["BT_STRING"], SERVER_MENU_DATA["SMD_BT_YES"]["BT_FUNC"],
											   SERVER_MENU_DATA["SMD_BT_NO"]["BT_STRING"],  SERVER_MENU_DATA["SMD_BT_NO"]["BT_FUNC"] )
			return
		end
	end

	-- 입장 조건을 충족하지 못했을 경우
	local MapIndex = cGetCurMapIndex( NPCHandle )
	if MapIndex ~= nil
	then
		cNotice_Obj( PlyHandle, EVENT_ERROR_NOTICE["EEN_FILENAME"], EVENT_ERROR_NOTICE["EEN_INDEX"] )
	end
end

-- 예 클릭( 이벤트 맵 입장 )
function Click_Yes( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_Yes"

	-- 입장 조건 확인
	local dataEntryCondition = EVENT_MAP_DATA[ "EMD_ENTRY_CONDITION" ]
	for i = 1, #dataEntryCondition
	do
		if cAbstateRestTime( PlyHandle, dataEntryCondition[ i ] ) ~= nil
		then
			cLinkTo( PlyHandle, EVENT_MAP_DATA["EMD_INDEX"], EVENT_MAP_DATA["EMD_REGEN_X"], EVENT_MAP_DATA["EMD_REGEN_Y"] )
			return
		end
	end

	-- 입장 조건을 충족하지 못했을 경우
	local MapIndex = cGetCurMapIndex( NPCHandle )
	if MapIndex ~= nil
	then
		cNotice_Obj( PlyHandle, EVENT_ERROR_NOTICE["EEN_FILENAME"], EVENT_ERROR_NOTICE["EEN_INDEX"] )
	end
end

-- 아니오 클릭
function Click_No( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck "Click_No"
end


-- 로밍 몬스터 기본 함수
function RoamingMobRoutine( Handle, MapIndex )
cExecCheck "RoamingMobRoutine"

	local CurSec = cCurrentSecond()


	-- 함정 살아 있는지 확인
	if cIsObjectDead( Handle ) ~= nil
	then
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	-- 함정 버퍼 확인
	local infoMobBuf = RoamingMobBuf[ Handle ]
	if infoMobBuf == nil
	then
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 함정 정보 확인
	if infoMobBuf["ChatData"] == nil			-- 기본 정보
	then
		cAssertLog( "Mob ChatData nil" )
		RoamingMobBuf[ Handle ] = nil
		cAIScriptSet( Handle )
		cNPCVanish( Handle )
		return ReturnAI["END"]
	end


	-- 몬스터 채팅
	if infoMobBuf["ChatTime"] <= CurSec
	then

		if infoMobBuf["ChatStep"] > #infoMobBuf["ChatData"]
		then
			infoMobBuf["ChatStep"] = 1
		end

		cMobChat( Handle, infoMobBuf["ChatData"]["MCD_SCRIPT_FILE"], infoMobBuf["ChatData"][ infoMobBuf["ChatStep"] ], false )

		infoMobBuf["ChatStep"] = infoMobBuf["ChatStep"] + 1
		infoMobBuf["ChatTime"] = CurSec + infoMobBuf["ChatData"]["MCD_CHAT_INTERVAL"]
	end

	-- 이동
	if infoMobBuf["MoveCheckTime"] <= CurSec
	then
		local MoveStep 					= infoMobBuf["MoveStep"]
		local GoalInterval				= ROAMING_PATTERN_DATA["RPD_GOAL_INTERVAL"] * ROAMING_PATTERN_DATA["RPD_GOAL_INTERVAL"]
		local CurLocate_X, CurLocate_Y 	= cObjectLocate( Handle )
		local MaxMovePattern			= #infoMobBuf["MovePattern"]

		if cDistanceSquar( CurLocate_X, CurLocate_Y, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"] ) < GoalInterval
		then
			-- 이동 단계 계산
			if infoMobBuf["MoveBack"] == false
			then
				MoveStep = MoveStep + 1

				if MoveStep > MaxMovePattern
				then
					MoveStep 				= MaxMovePattern - 1
					infoMobBuf["MoveBack"]	= true
				end
			else
				MoveStep = MoveStep - 1

				if MoveStep < 1
				then
					MoveStep 				= 2
					infoMobBuf["MoveBack"]	= false
				end
			end

			cWalkTo( Handle, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"], 500 )

			infoMobBuf["MoveStep"] 	= MoveStep
		else
			local AggroListSize = cAggroListSize( Handle )
			if AggroListSize <= 0
			then
				--if cGetMoveState( Handle ) == 0
				local MoveState, MoveStateTime, MoveStateSetTime = cGetMoveState( Handle )
				if MoveState == 0
				then
					cWalkTo( Handle, infoMobBuf["MovePattern"][ MoveStep ]["X"], infoMobBuf["MovePattern"][ MoveStep ]["Y"], 500 )
				end
			end
		end

		infoMobBuf["MoveCheckTime"] = CurSec + ROAMING_PATTERN_DATA["RPD_CHECK_INTERVAL"]
	end

	return ReturnAI["CPP"]
end
