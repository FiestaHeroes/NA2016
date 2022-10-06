require( "common" )
require( "KQ/KDMine/KDMineData" )		-- 데이터 테이블
require( "KQ/KDMine/KDMineFunc" )
require( "KQ/KDMine/KDMineObjectRoutine" )


function Main( Field )
cExecCheck "Main"

	local Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var["MapIndex"]	= Field

		cSetFieldScript( Var["MapIndex"], SCRIPT_MAIN )
		cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )
		cFieldScriptFunc( Var["MapIndex"], "ItemUse",  "PlayerItemUse" )

		Var["StepControl"] = StepControl
		Var["StepFunc"]    = DummyFunc

	end


	Var["StepControl"]( Var )
	Var["StepFunc"]( Var )

end


function DummyFunc( Var )
end


function StepControl( Var )

	if Var == nil then
		return
	end


	MapMarking( Var ) -- 맵마킹 지속 처리


	local CurSec = cCurrentSecond()

	if Var["Step"] == nil then

		Var["Step"]     = 1
		Var["StepFunc"] = InitKingdomQuestDefence

		return

	end


	if Var["Step"] == 1 then

		if Var["StepWaitTime"] == nil then

			Var["StepWaitTime"] = CurSec

		end

		if Var["StepWaitTime"] + KD_JOIN_WAIT_TIME < CurSec then

			Var["StepWaitTime"] = nil

			Var["Step"]         = Var["Step"] + 1
			Var["StepFunc"]     = InitBalance

		end

		return

	end


	if Var["Step"] == 2 then

		if Var["Dialog"] == nil then

			Var["Dialog"]     = DialogInfo["KDMine_Join"]
			Var["DialogStep"] = 1
			Var["DialogTime"] = CurSec

		end

		if Var["DialogStep"] <= #Var["Dialog"] then

			if Var["DialogTime"] + Var["Dialog"][Var["DialogStep"]]["Delay"] > CurSec then
				return
			end

			cMobDialog( Var["MapIndex"],
						Var["Dialog"][Var["DialogStep"]]["Portrait"],
						Var["Dialog"][Var["DialogStep"]]["FileName"],
						Var["Dialog"][Var["DialogStep"]]["Index"] )

			Var["DialogTime"] = CurSec
			Var["DialogStep"] = Var["DialogStep"] + 1

			return

		end


		Var["Dialog"]     = nil
		Var["DialogStep"] = nil
		Var["DialogTime"] = nil

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = DummyFunc

		return

	end


	if Var["Step"] == 3 then

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = WaveProcess

		return

	end


	if Var["Step"] == 4 then

		if Var["StepWaitTime"] == nil then

			Var["StepWaitTime"] = CurSec

		end


		if Var["MainObj"] == nil then

			cQuestResult( Var["MapIndex"], "Fail" )

			Var["Step"]         = 5
			Var["StepFunc"]     = DummyFunc

			return

		end

		if Var["MainObj"]["CurHP"] <= 0 then

			cQuestResult( Var["MapIndex"], "Fail" )

			Var["Step"]         = 5
			Var["StepFunc"]     = DummyFunc

			return

		end


		if Var["StepWaitTime"] + KD_WAVE_WAIT_TIME < CurSec then

			Var["StepWaitTime"] = nil

			cQuestResult( Var["MapIndex"], "Success" )
--			cReward( Var["MapIndex"], "KQ" )

			-- 보상 상태이상 처리
			local Players      = { cGetPlayerList( Var["MapIndex"] ) }

			for i=1, #Players do

				for j=1, #RewardAbstate do

					cSetAbstate( Players[i], RewardAbstate[j]["Index"], 1, RewardAbstate[j]["KeepTime"] )

				end

			end


			Var["Step"]         = 6
			Var["StepFunc"]     = DummyFunc

			return

		end

		return

	end


	if Var["Step"] == 5 or Var["Step"] == 6 then

		if Var["Dialog"] == nil then

			if Var["Step"] == 5 then
				Var["Dialog"]     = DialogInfo["KDMine_Fail"]
			else
				Var["Dialog"]     = DialogInfo["KDMine_Success"]
			end
			Var["DialogStep"] = 1
			Var["DialogTime"] = CurSec

		end

		if Var["DialogStep"] <= #Var["Dialog"] then

			if Var["DialogTime"] + Var["Dialog"][Var["DialogStep"]]["Delay"] > CurSec then
				return
			end

			cMobDialog( Var["MapIndex"],
						Var["Dialog"][Var["DialogStep"]]["Portrait"],
						Var["Dialog"][Var["DialogStep"]]["FileName"],
						Var["Dialog"][Var["DialogStep"]]["Index"] )

			Var["DialogTime"] = CurSec
			Var["DialogStep"] = Var["DialogStep"] + 1

			return

		end


		Var["Dialog"]     = nil
		Var["DialogStep"] = nil
		Var["DialogTime"] = nil

		Var["Step"]     = 99
		Var["StepFunc"] = DummyFunc

	end



	if 	Var["Step"] == 99 then

		if Var["Notice"] == nil then

			Var["Notice"]     = NoticeInfo["KQReturn"]
			Var["NoticeStep"] = 1
			Var["NoticeTime"] = CurSec

		end

		if Var["NoticeStep"] <= #Var["Notice"] then

			if Var["Noticed"] == nil then

				cNotice( Var["MapIndex"], Var["Notice"][Var["NoticeStep"]]["FileName"], Var["Notice"][Var["NoticeStep"]]["Index"] )
				Var["Noticed"] = 1

			end


			if Var["NoticeTime"] + Var["Notice"][Var["NoticeStep"]]["WaitTime"] > CurSec then
				return
			end

			Var["NoticeTime"] = CurSec
			Var["NoticeStep"] = Var["NoticeStep"] + 1
			Var["Noticed"]    = nil

			return

		end

		Var["Notice"]     = nil
		Var["NoticeStep"] = nil
		Var["NoticeTime"] = nil
		Var["Noticed"]    = nil

		Var["Step"]         = Var["Step"] + 1
		Var["StepFunc"]     = DummyFunc

	end


	if Var["Step"] == 100 then

		cLinkToAll( Var["MapIndex"], KD_END_LINKTO["Index"], KD_END_LINKTO["x"], KD_END_LINKTO["y"] )
		cEndOfKingdomQuest( Var["MapIndex"] )

		Var["Step"]         = Var["Step"] + 1
		Var["StepFunc"]     = DummyFunc

	end

end
