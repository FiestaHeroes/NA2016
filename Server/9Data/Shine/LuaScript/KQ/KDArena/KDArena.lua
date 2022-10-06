--------------------------------------------------------------------------------
--                            Arena Main File                                 --
--------------------------------------------------------------------------------

function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[ Field ]

	if Var == nil
	then

		------------------------------------------------------------
		-- �Ʒ��� ���� �ʱ�ȭ
		------------------------------------------------------------
		InstanceField[ Field ]	= {}						-- �Ʒ��� ���̺� ����
		Var						= InstanceField[ Field ]
		Var[ "MapIndex" ]		= Field						-- �� �ε���( �ʵ� �ε��� )
		Var[ "KQLimitTime" ]	= 0							-- �Ʒ��� ���� �ð�
		Var[ "InitialSec" ]		= cCurrentSecond()			-- ���� ���� �ð�
		Var[ "CurSec" ] 		= Var["InitialSec"]			-- ���� �ð�
		Var[ "StepFunc" ]		= InitArena					-- ���� �Լ�-


		-- ���
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


		-- ����Ʈ
		Var[ "ArenaGate" ]				= {}
		Var[ "ArenaGate" ][ "Count" ]	= 0


		-- ũ����Ż ��ȣ��
		Var[ "ArenaStone" ]						= {}
		Var[ "ArenaStone" ][ "Count" ]			= 0
		Var[ "ArenaStone" ][ "SkillUseTime" ]	= {}


		-- ũ����Ż
		Var[ "ArenaCrystal" ] =
		{
			Handle 			= nil,
			VanishTime		= nil,
			SkillUseTime	= 0,
		}


		-- ��� �Ʒ��� ���
		Var[ "AncientArenaWarrior" ] = {}
		--[[
		Var[ "AncientArenaWarrior" ][ 1 ] =
		{
			Handle		= nil,
			RegenTime	= nil,
		}
		--]]


		-- �÷��̾� ���� �ʱ�ȭ
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


		-- �� ���� �ʱ�ȭ
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


		-- �� �α��� �Լ� ����
		cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )

		-- �ʵ� ����
		cSetCanUseReviveItem( Field, false )							-- ��Ȱ ������ ��� �Ұ�
		cSetCanUseReviveSkill( Field, false )						-- ��Ȱ ��ų ��� �Ұ�
		cSetReviveDelayTime( Field, DelayTime[ "ReviveWaitTime" ] )	-- ��Ȱ �ð� 3��
	end


	-- 0.1�� ���� ����
	if Var["CurSec"] + 0.1 > cCurrentSecond()
	then
		return
	else
		Var["CurSec"] = cCurrentSecond()
	end

	-- �����Լ� ���� ( Functions/Progress.lua )
	Var["StepFunc"]   ( Var )

end
