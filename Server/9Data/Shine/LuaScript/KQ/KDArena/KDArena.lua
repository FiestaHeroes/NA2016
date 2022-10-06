--------------------------------------------------------------------------------
--                            Arena Main File                                 --
--------------------------------------------------------------------------------

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		------------------------------------------------------------
		-- 아레나 정보 초기화
		------------------------------------------------------------
		InstanceField[ Field ]	= {}						-- 아레나 테이블 생성
		Var						= InstanceField[ Field ]
		Var[ "MapIndex" ]		= Field						-- 맵 인덱스( 필드 인덱스 )
		Var[ "KQLimitTime" ]	= 0							-- 아레나 진행 시간
		Var[ "InitialSec" ]		= cCurrentSecond()			-- 최초 실행 시간
		Var[ "CurSec" ] 		= Var["InitialSec"]			-- 현재 시간
		Var[ "StepFunc" ]		= InitArena					-- 스탭 함수-


		-- 깃발
		Var[ "ArenaFlag" ]				= {}
		Var[ "ArenaFlag" ][ RED_TEAM ]	= {}
		Var[ "ArenaFlag" ][ BLUE_TEAM ]	= {}
		--[[
		Var[ "ArenaFlag" ][ RED_TEAM ] =
		{
			Handle					= nil,
			PlayerHandle			= nil,
			PlayerTeam				= nil,
			Drop_LifeTime			= nil,
			X						= 0,
			Y						= 0,
			GoalConditionNoticeTime	= 0,
			Penalty	=
			{
				Step      = 0,
				CheckTime = 0,
			},
		}
		--]]


		-- 게이트
		Var[ "ArenaGate" ]				= {}
		Var[ "ArenaGate" ][ "Count" ]	= 0


		-- 크리스탈 수호석
		Var[ "ArenaStone" ]						= {}
		Var[ "ArenaStone" ][ "Count" ]			= 0
		Var[ "ArenaStone" ][ "SkillUseTime" ]	= {}


		-- 크리스탈
		Var[ "ArenaCrystal" ] =
		{
			Handle 			= nil,
			VanishTime		= nil,
			SkillUseTime	= 0,
		}


		-- 고대 아레나 용사
		Var[ "AncientArenaWarrior" ] = {}
		--[[
		Var[ "AncientArenaWarrior" ][ 1 ] =
		{
			Handle		= nil,
			RegenTime	= nil,
		}
		--]]


		-- 플레이어 정보 초기화
		Var[ "Player" ]	= {}
		--[[
		Var[ "Player" ][ 1 ] =
		{
			Handle		= nil,
			CharNo		= nil,
			FlagPickSec	= 0,
			InMap		= false,
			TeamNumber	= DEF_TEAM
		}
		--]]


		-- 팀 정보 초기화
		Var[ "Team" ] =
		{
			[ RED_TEAM ] =
			{
				Score	= 0,
				Member	= {},
			},

			[ BLUE_TEAM ] =
			{
				Score	= 0,
				Member	= {},
			},
		}


		-- 맵 로그인 함수 설정
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- 필드 설정
		cSetCanUseReviveItem( Field, false )							-- 부활 아이템 사용 불가
		cSetCanUseReviveSkill( Field, false )						-- 부활 스킬 사용 불가
		cSetReviveDelayTime( Field, DelayTime[ "ReviveWaitTime" ] )	-- 부활 시간 3초
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
