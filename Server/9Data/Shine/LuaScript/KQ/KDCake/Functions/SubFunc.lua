--------------------------------------------------------------------------------
--                      Cake War Sub Functions 		                         --
--------------------------------------------------------------------------------


function DummyFunc( Var )
cExecCheck "DummyFunc"
end



----------------------------------------------------------------------
-- Player
----------------------------------------------------------------------
function Player_Insert( Var, CharNo, Handle, TeamType )
cExecCheck "Player_Insert"


	if Var == nil
	then
		ErrorLog( "Player_Insert : Var nil" )
		return
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Insert : PlayerList nil" )
		return
	end

	if CharNo == nil
	then
		ErrorLog( "Player_Insert : ErrorLog nil" )
		return
	end

	if Handle == nil
	then
		ErrorLog( "Player_Insert : Handle nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "Player_Insert : TeamType nil" )
		return
	end


	local InsertIndex = #PlayerList + 1

	PlayerList[ InsertIndex ] = {}
	PlayerList[ InsertIndex ]["CharNo"]					= CharNo
	PlayerList[ InsertIndex ]["CharID"]					= cGetPlayerName( Handle )
	PlayerList[ InsertIndex ]["Handle"]					= Handle
	PlayerList[ InsertIndex ]["TeamType"]				= TeamType
--	PlayerList[ InsertIndex ]["Goal"]					= 0
	PlayerList[ InsertIndex ]["IsInMap"]				= true
	PlayerList[ InsertIndex ]["CakeHandle"]				= nil
	PlayerList[ InsertIndex ]["CakeAbstateTime"]		= 0
	PlayerList[ InsertIndex ]["PrisonLinkToWaitTime"]	= 0
	PlayerList[ InsertIndex ]["IsOut"]					= false

end


function Player_Get( Var, CharNo )
cExecCheck "Player_Get"


	if Var == nil
	then
		ErrorLog( "Player_Get : Var nil" )
		return
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Get : PlayerList nil" )
		return
	end


	for i = 1, #PlayerList
	do
		if PlayerList[ i ]["CharNo"] == CharNo
		then
			return PlayerList[ i ]
		end
	end

end


function Player_TeamMemberCount( Var, TeamType )
cExecCheck "Player_TeamMemberCount"


	if Var == nil
	then
		ErrorLog( "Player_TeamMemberCount : Var nil" )
		return
	end

	if TeamType == nil
	then
		ErrorLog( "Player_TeamMemberCount : TeamType nil" )
		return
	end


	local PlayerCount	= 0
	local PlayerList 	= Var["Player"]

	if PlayerList == nil
	then
		ErrorLog( "Player_TeamMemberCount : PlayerList nil" )
		return
	end


	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]


		if PlayerInfo["TeamType"] == TeamType
		then

			if PlayerInfo["IsInMap"] == true
			then

				PlayerCount = PlayerCount + 1

			end
		end


	end


	return PlayerCount

end


function Player_Manager( Var )
cExecCheck "Player_Manager"


	if Var == nil
	then
		ErrorLog( "Player_Manager : Var nil" )
		return false
	end

	local PlayerList = Var["Player"]
	if PlayerList == nil
	then
		ErrorLog( "Player_Manager : PlayerList nil" )
		return false
	end

	local TeamInfo = Var["Team"]
	if TeamInfo == nil
	then
		ErrorLog( "Player_Manager : TeamInfo nil" )
		return false
	end


	-- 플레이어 접속 확인
	local TeamMemberCnt = {}

	for i = 1, #PlayerList
	do
		local PlayerInfo = PlayerList[ i ]
		local PlayerTeam = PlayerInfo["TeamType"]


		-- 플레이어가 맵에 있는지 확인
		if PlayerInfo["IsInMap"] == true
		then
			if cIsInMap( PlayerInfo["Handle"], Var["MapIndex"] ) == nil
			then
				PlayerInfo["IsInMap"] = false

				if PlayerInfo["IsOut"] == false
				then
					TeamInfo[ PlayerTeam ]["Score"] = TeamInfo[ PlayerTeam ]["Score"] - 1
				end
			end
		end

		-- 접속하고 있는 유저 수 확인
		if PlayerInfo["IsInMap"] == true
		then
			if TeamMemberCnt[ PlayerTeam ] == nil
			then
				TeamMemberCnt[ PlayerTeam ] = 1
			else
				TeamMemberCnt[ PlayerTeam ] = TeamMemberCnt[ PlayerTeam ] + 1
			end
		end
	end


	if 	TeamMemberCnt[ KQ_TEAM["RED"] ]  == nil
	then
		TeamInfo[ KQ_TEAM["RED"] ]["Win"] 	= 0
		TeamInfo[ KQ_TEAM["BLUE"] ]["Win"] 	= TeamInfo[ KQ_TEAM["BLUE"] ]["Win"] + 1
		return false
	end


	if TeamMemberCnt[ KQ_TEAM["BLUE"] ] == nil
	then
		TeamInfo[ KQ_TEAM["RED"] ]["Win"] 	= TeamInfo[ KQ_TEAM["RED"] ]["Win"] + 1
		TeamInfo[ KQ_TEAM["BLUE"] ]["Win"] 	= 0
		return false
	end


	-- 플레이어 관련 작업
	for i = 1, #PlayerList
	do
		local PlayerInfo	= PlayerList[ i ]
		local TeamType 		= PlayerInfo["TeamType"]


		if PlayerInfo["IsInMap"] == true
		then


			-- 케이크 상태이상 걸어주는 시간
			if PlayerInfo["CakeHandle"] ~= nil and
			   PlayerInfo["CakeAbstateTime"] <= Var["CurSec"]
			then

				cSetAbstate( PlayerInfo["Handle"], Cake["Abstate"]["Index"], 1, Cake["Abstate"]["KeepTime"], PlayerInfo["CakeHandle"] )

				PlayerInfo["CakeHandle"]		= nil
				PlayerInfo["CakeAbstateTime"]	= 0

			end


			-- 대기 시간이 지났을 경우
			if	PlayerInfo["PrisonLinkToWaitTime"] > 0 and
				PlayerInfo["PrisonLinkToWaitTime"] <= Var["CurSec"]
			then

				-- 대기 시간  초기화, 아웃 설정
				PlayerInfo["PrisonLinkToWaitTime"] 	= 0
				PlayerInfo["IsOut"]					= true


				-- 감옥으로 이동
				cCastTeleport( PlayerInfo["Handle"], "SpecificCoord", PrisonLocation["X"], PrisonLocation["Y"] )
				--cLinkTo( PlayerInfo["Handle"], Var["MapIndex"], PrisonLocation["X"], PrisonLocation["Y"] )


				-- 점수 계산 및 알림
				TeamInfo[ TeamType ]["Score"] = TeamInfo[ TeamType ]["Score"] - 1

				cScoreBoard_AllInMap( Var["MapIndex"], true, Var["Round"], TeamInfo[ KQ_TEAM["RED"] ]["Win"],  TeamInfo[ KQ_TEAM["RED"] ]["Score"],
																		   TeamInfo[ KQ_TEAM["BLUE"] ]["Win"], TeamInfo[ KQ_TEAM["BLUE"] ]["Score"] )

				-- 캐릭터 아웃 알림
				cScriptMsg( Var["MapIndex"], nil, NoticeInfo["PlayerOut"][ TeamType ], PlayerInfo["CharID"] )

			end

		end
	end


	return true

end



----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function GoToFail( Var, Msg )
cExecCheck( "GoToFail" )


	if Var == nil
	then
		ErrorLog( "BuffBox_KnockBack : Var nil" );
		return
	end


	ErrorLog( Msg )


	-- 모든 객체 삭제
	if Var["Door"]  ~= nil
	then
		--cNPCVanish( Var["InvisibleDoor"] )
		for k = 1, #Var["Door"]
		do
			cNPCVanish( Var["Door"][ k ] )
		end
	end


	Var["StepFunc"] = ReturnToHome
end



----------------------------------------------------------------------
-- Log Functions
----------------------------------------------------------------------
function DebugLog( String )

	if String == nil
	then
		cAssertLog( "DebugLog::String == nil" )
		return
	end

	--cAssertLog( "Debug - "..String )

end


function ErrorLog( String )

	if String == nil
	then
		cAssertLog( "ErrorLog::String == nil" )
		return
	end

	cAssertLog( "Error - "..String )

end
