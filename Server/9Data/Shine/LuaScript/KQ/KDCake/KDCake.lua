--------------------------------------------------------------------------------
--                             Main File                                 --
--------------------------------------------------------------------------------
require( "common" )

--[[
require( "Data/Name" ) 				-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "Data/Process" )		    -- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "Data/Servant" )			-- 소환수 정보
require( "Data/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)

require( "Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "Functions/Progress" )		-- 각 단계가 정의된 진행 함수들
--]]--


require( "KQ/KDCake/Data/Name" ) 				-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "KQ/KDCake/Data/Process" )		   		-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "KQ/KDCake/Data/Servant" )				-- 소환수 정보
require( "KQ/KDCake/Data/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)

require( "KQ/KDCake/Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "KQ/KDCake/Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "KQ/KDCake/Functions/Progress" )		-- 각 단계가 정의된 진행 함수들
--]]--


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then
		InstanceField[ Field ]	= {}				-- 킹퀘 테이블 생성

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field					-- 맵 인덱스( 필드 인덱스 )
		Var["InitialSec"]	= cCurrentSecond()		-- 최초 실행 시간
		Var["CurSec"] 		= Var["InitialSec"]		-- 현재 시간
		Var["StepFunc"]		= KQInit				-- 스탭 함수
		Var["Round"]		= 1						-- 현재 라운드
		Var["RoundEndTime"]	= 0						-- 라운드 끝나는 시간
		Var["RoundTimeOver"]= false					-- 라운드 종료가 타임오버 일경우


		-- 플레이어 정보 초기화
		Var["Player"] = {}
--		Var["Player"][ i ]["CharNo"]				= nil
--		Var["Player"][ i ]["CharID"]				= nil
--		Var["Player"][ i ]["Handle"]				= nil
--		Var["Player"][ i ]["TeamType"]				= KQ_TEAM["MAX"]
--------		Var["Player"][ i ]["Goal"]					= nil
--		Var["Player"][ i ]["IsInMap"]				= true
--		Var["Player"][ i ]["CakeHandle"]			= nil
--		Var["Player"][ i ]["CakeAbstateTime"]		= 0
--		Var["Player"][ i ]["PrisonLinkToWaitTime"]	= 0
--		Var["Player"][ i ]["IsOut"]					= false


		-- 도어 핸들
--		Var["Door"] = nil


		-- 팀 정보(점수) 초기화
		Var["Team"]	= {}
		Var["Team"][ KQ_TEAM["RED"] ] 	=
		{
			Score 	= 0,
			Win		= 0,
			Lose	= 0,
			Draw	= 0,
		}

		Var["Team"][ KQ_TEAM["BLUE"] ] 	=
		{
			Score 	= 0,
			Win		= 0,
			Lose	= 0,
			Draw	= 0,
		}


--		-- InvisibleDoor 정보 초기화
--		Var["InvisibleDoor"] = nil


		-- 맵 로그인 함수 설정
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", 		"PlayerMapLogin" )
		cFieldScriptFunc( Var["MapIndex"], "ServantSummon", "ServantSummon" )
	end


	-- 0.1초 마다 실행
	if Var["CurSec"] + 0.1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- 스텝함수 실행 ( Functions/Progress.lua )
	Var["StepFunc"]( Var )

end
