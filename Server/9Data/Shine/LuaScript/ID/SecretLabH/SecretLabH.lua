--------------------------------------------------------------------------------
--                    Secret Laboratory Main File                             --
--------------------------------------------------------------------------------

require( "common" )

require( "ID/SecretLabH/Data/Name" ) 			-- 파일경로, 파일이름, 역참조, 단계 진행을 위한 네임 테이블
require( "ID/SecretLabH/Data/Process" )			-- 각종 딜레이타임과 링크 정보, 퀘스트 등의 진행 관련 데이터
require( "ID/SecretLabH/Data/Regen" )			-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "ID/SecretLabH/Data/NPC" )				-- NPC관련 처리 데이터( NPC 액션 정보 및 액션을 일으키기 위한 요소 정보 )
require( "ID/SecretLabH/Data/Boss" )				-- Boss관련 처리 데이터( 보스전 Phase Data(소환 몹 포함), 상태이상, 치프몹 관련 경고문 정보 )
require( "ID/SecretLabH/Data/Chat" )				-- 모든 채팅 관련

require( "ID/SecretLabH/Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "ID/SecretLabH/Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "ID/SecretLabH/Functions/Progress" )	-- 각 단계가 정의된 진행 함수들


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["Friend"]		= {}	-- 아군 정보 담는 메모리
		Var["Enemy"]		= {}	-- 적 정보 담는 메모리
		Var["Door"]			= {}	-- 문 정보 담는 메모리
		Var["RoutineTime"] 	= {}	-- 루틴 타임을 핸들마다 보관하는 메모리
		Var["StageInfo"]	= {}	-- 스테이지 순서와 함께 각 단계 정보를 저장해줄 메모리


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
