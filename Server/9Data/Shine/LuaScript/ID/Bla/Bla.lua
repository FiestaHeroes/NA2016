--------------------------------------------------------------------------------
--                      Seiren Castle Main File                               --
--------------------------------------------------------------------------------

require( "common" )

--[[
require( "Data/Name" )				-- 파일경로, 파일이름, 역참조, 단계 진행을 위한 네임 테이블
require( "Data/Chat" )				-- 모든 채팅 관련
require( "Data/Process" )			-- 각종 딜레이타임과 링크 정보, 퀘스트 등의 진행 관련 데이터
require( "Data/Regen" )				-- 리젠 데이터(그룹, 몹, NPC, 문, 아이템 등의 리젠 종류, 위치 및 속성 관련)
require( "Data/Stuff" )				-- Stuff관련 처리 데이터( NPC 액션 정보 및 액션을 일으키기 위한 요소 정보 )
require( "Data/Boss" )				-- Boss관련 처리 데이터

require( "Functions/SubFunc" )		-- 전체적인 진행에 필요한 각종 Sub Functions
require( "Functions/Routine" )		-- 몹 등에 붙는 AI 관련 루틴들
require( "Functions/Progress" )		-- 각 단계가 정의된 진행 함수들

--]]

require( "ID/Bla/Data/Name" )
require( "ID/Bla/Data/Chat" )
require( "ID/Bla/Data/Process" )
require( "ID/Bla/Data/Regen" )
require( "ID/Bla/Data/Stuff" )
require( "ID/Bla/Data/Boss" )

require( "ID/Bla/Functions/SubFunc" )
require( "ID/Bla/Functions/Routine" )
require( "ID/Bla/Functions/Progress" )
--]]

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		InstanceField[ Field ] = {}

		Var					= InstanceField[ Field ]
		Var["MapIndex"]		= Field

		Var["AreaMobGroup"] 						= {}	-- 어디에 몹을 리젠할지 랜덤으로 정해진 결과를 저장해둠

		Var["RootManager"]							= {}
		Var["RootManager"]["RootA"]					= 1
		Var["RootManager"]["RootB"]					= 1
		Var["RootManager"]["DelayTime"]				= {}
		Var["RootManager"]["DelayTime"]["RootA"]	= cCurrentSecond() + DelayTime["RootManagerFuncTick"]
		Var["RootManager"]["DelayTime"]["RootB"]	= cCurrentSecond() + DelayTime["RootManagerFuncTick"]


		Var["Door"]									= {}	-- 문 정보 담는 메모리

		Var["RoutineTime"]							= {}
		--Var["RoutineTime"]["Routine_Blakan"]
		--Var["RoutineTime"]["Routine_Seal"]
		--Var["RoutineTime"]["Routine_Fagels"]


		Var["Enemy"]								= {}	-- 적 정보 담는 메모리
		--Var["Enemy"]["MildWin"]
		--Var["Enemy"]["Blakan"]
		--Var["Enemy"]["Seal"]{}
		--Var["Enemy"]["Fagels"]



		Var["TimeList"]								= {}
		--Var["TimeList"]["FaceCutArea"]			= {}
		--Var["TimeList"]["FaceCutArea"]["PlayerEntrance"]
		--Var["TimeList"]["FaceCutArea"]["Dialog_Blakan"]

		--Var["TimeList"]["TeleportArea"]			= {}
		--Var["TimeList"]["TeleportArea"]["PlayerEntrance"]
		--Var["TimeList"]["TeleportArea"]["Dialog_Blakan"]
		--Var["TimeList"]["TeleportArea"]["Dialog_Fagels"]
		--Var["TimeList"]["TeleportArea"]["SummonStart"]


		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- 최초 시간 입력
		Var["InitialSec"] 	= cCurrentSecond()
		Var["CurSec"] 	  	= cCurrentSecond()

		DebugLog("메인함수 시작")

		-- 첫 스텝으로
		Var["StepFunc"]		= InitDungeon

		-- 랜덤으로 리젠몹 세팅
		RandomRegenMobGroupSetFunc( Var )

	end


	-- 0.2초마다 실행
	if Var["CurSec"] + 0.5 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end


	-- 스텝함수 실행 ( Functions/Progress.lua )
	Var["StepFunc"]( Var )


	RootManagerFunc( Var, "RootA" )
	RootManagerFunc( Var, "RootB" )
	TeleportFunc( Var )

end
