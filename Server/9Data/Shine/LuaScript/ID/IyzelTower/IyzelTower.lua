--------------------------------------------------------------------------------
--                       Tower Of Iyzel Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/IyzelTower/Data/Name" ) 			-- 파일경로, 파일이름, 역참조를 위한 네임 테이블
require( "ID/IyzelTower/Data/Process" )			-- 각종 딜레이타임과 링크 정보, 공지, 퀘스트 등의 진행 관련 데이터
require( "ID/IyzelTower/Data/Regen" )			-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "ID/IyzelTower/Data/NPC" )				-- NPC의 행동 관련(페이스컷(Dialog), 샤우팅, 일반 채팅 등)
require( "ID/IyzelTower/Data/Boss" )			-- 던전 Boss의 행동 관련(채팅 및 보스전 페이즈 제어를 위한 데이터(몹소환 정보 포함))

require( "ID/IyzelTower/Functions/SubFunc" )	-- 전체적인 진행에 필요한 각종 Sub Functions
require( "ID/IyzelTower/Functions/Routine" )	-- 몹 등에 붙는 AI 관련 루틴들
require( "ID/IyzelTower/Functions/Progress" )	-- 각 단계가 정의된 진행 함수들


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Enemy"]		= {}
		Var["Door"]			= {}
		Var["RoutineTime"] 	= {}


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		Var["StepFunc"] = DummyFunc

		-- 최초 시간 입력
		Var["InitialSec"] = cCurrentSecond()
		Var["CurSec"] 	  = cCurrentSecond()

		-- 첫 스텝으로
		GoToNextStep( Var )

	end


	-- 0.5초마다 실행
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- 스텝함수 실행 ( Functions/Progress.lua )
	Var["StepFunc"]   ( Var )

end
