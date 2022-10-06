--------------------------------------------------------------------------------
--                             Main File                                 --
--------------------------------------------------------------------------------
require( "common" )

--[[
require( "Data/Name" ) 				-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "Data/Process" )		    -- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "Data/NPC" )			    -- NPC 정보
require( "Data/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)

require( "Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "Functions/Progress" )		-- 각 단계가 정의된 진행 함수들
--]]--


require( "KQ/KDSoccer/Data/Name" ) 				-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "KQ/KDSoccer/Data/Process" )		    -- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "KQ/KDSoccer/Data/NPC" )			    -- NPC 정보
require( "KQ/KDSoccer/Data/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)

require( "KQ/KDSoccer/Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "KQ/KDSoccer/Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "KQ/KDSoccer/Functions/Progress" )		-- 각 단계가 정의된 진행 함수들
--]]--


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then
		InstanceField[ Field ]	= {}						-- 킹퀘 테이블 생성

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field					-- 맵 인덱스( 필드 인덱스 )
		Var["KQLimitTime"]	= 0						-- 킹퀘 진행 시간
		Var["InitialSec"]	= cCurrentSecond()		-- 최초 실행 시간
		Var["CurSec"] 		= Var["InitialSec"]		-- 현재 시간
		Var["StepFunc"]		= InitSoccer			-- 스탭 함수-


		-- 플레이어 정보 초기화
		Var["Player"] = {}
--		Var["Player"][ i ]["CharNo"]	= nil
--		Var["Player"][ i ]["CharID"]	= nil
--		Var["Player"][ i ]["Handle"]	= nil
--		Var["Player"][ i ]["TeamType"]	= KQ_TEAM["MAX"]
--		Var["Player"][ i ]["Goal"]		= nil
--		Var["Player"][ i ]["IsInMap"]	= true
--		Var["Player"][ i ]["SpeedUpBuff"]		= {}	-- 걸릴때 만들어준다.
--		Var["Player"][ i ]["InvincibleBuff"]	= {}	-- 걸릴때 만들어준다.



		-- 팀 정보(점수) 초기화
		Var["Team"]	= {}
		Var["Team"][ KQ_TEAM["RED"] ] 	= 0
		Var["Team"][ KQ_TEAM["BLUE"] ] 	= 0


		-- Kicker 정보 초기화
		Var["Kicker"]	= {}
--		Var["Kicker"]["IsPlayer"]	= nil
--		Var["Kicker"]["TeamType"]	= KQ_TEAM["MAX"]
--		Var["Kicker"]["CharNo"]		= nil
--		Var["Kicker"]["NPCHandle"]	= nil


		-- InvisibleDoor 정보 초기화
		Var["InvisibleDoor"] = nil


		-- SoccerBall 정보 초기화
		Var["SoccerBall"] = nil


		-- Referee 정보 초기화
		Var["Referee"] = {}
--		Var["Referee"]["Handle"]			= nil
--		Var["Referee"]["FollowCheckTime"]	= 0
--		Var["Referee"]["RoutineCheckTime"]	= 0


		-- Keeper 정보 초기화
		Var["Keeper"] = {}
--		Var["Keeper"][ i ]["Handle"]			= nil
--		Var["Keeper"][ i ]["TeamType"]			= KQ_TEAM["MAX"]
--		Var["Keeper"][ i ]["RoutineCheckTime"]	= 0
--		Var["Keeper"][ i ]["MoveStep"]			= 1
--		Var["Keeper"][ i ]["MoveBack"]			= false


		-- BuffBox 정보 초기화
		Var["BuffBox"] = {}
--		Var["BuffBox"][ i ] = 0  다음 리젠 시간


		-- 맵 로그인 함수 설정
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )
	end


	-- 0.1초 마다 실행
	if Var["CurSec"] + 0.1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- 스텝함수 실행 ( Functions/Progress.lua )
	Var["StepFunc"]   ( Var )

end
