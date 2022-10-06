require( "common" )
require( "KQ/KDEgg/KDEggData" )		-- 데이터 테이블
require( "KQ/KDEgg/KDEggFunc" )
require( "KQ/KDEgg/KDEggObjectRoutine" )


function Main( Field )
cExecCheck( "Main" )

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
cExecCheck( "StepControl" )

	if Var == nil then
		return
	end


	MapMarking( Var )


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

		end

		return

	end


	if Var["Step"] == 2 then

		if WarN_Dialog( Var, DialogInfo["Egg_Join"] ) ~= nil then
			return
		end

		Var["Step"]     = Var["Step"] + 1
		Var["StepFunc"] = WaveProcess

		return

	end


	if Var["Step"] == 3 then

		if Var["StepWaitTime"] == nil then

			Var["StepWaitTime"] = CurSec

		end


		if Var["MainObj"] == nil then

			Var["QuestResult"]	= QUEST_FAIL

			Var["WaveRunner"]	= nil
			Var["StepWaitTime"]	= nil

			Var["Step"]         = Var["Step"] + 1
			Var["StepFunc"]     = DummyFunc

			return

		end

		if Var["MainObj"]["CurHP"] <= 0 then

			Var["QuestResult"]	= QUEST_FAIL

			Var["WaveRunner"]	= nil
			Var["StepWaitTime"]	= nil

			Var["Step"]         = Var["Step"] + 1
			Var["StepFunc"]     = DummyFunc

			return

		end


		if Var["StepWaitTime"] + KD_WAVE_WAIT_TIME < CurSec then

			Var["StepWaitTime"] = nil


			Var["QuestResult"]	= QUEST_SUCCESS

			Var["WaveRunner"]	= nil
			Var["StepWaitTime"]	= nil

			Var["Step"]         = Var["Step"] + 1
			Var["StepFunc"]     = DummyFunc

			return

		end


		if Var["StepFunc"] == DummyFunc then

			local bAnnihilate = true

			for index, value in pairs(Var["WaveRunner"]) do
				bAnnihilate = false
				break
			end

			if bAnnihilate == true then

				Var["QuestResult"]	= QUEST_SUCCESS

				Var["WaveRunner"]	= nil
				Var["StepWaitTime"]	= nil

				Var["Step"]         = Var["Step"] + 1
				Var["StepFunc"]     = DummyFunc

				return

			end

		end

		return

	end


	if Var["Step"] == 4 then

		local Players      = { cGetPlayerList( Var["MapIndex"] ) }

		for i=1, #Players do

			cSetAbstate( Players[i], CM_STUN_INDEX, 1, CM_STUN_KEEP )

		end

		cCameraMove( Var["MapIndex"],
						CameraMove["x"],
						CameraMove["y"],
						CameraMove["AngleXZ"],
						CameraMove["AngleY"],
						CameraMove["Dist"], 1 )


		Var["Step"] = Var["Step"] + 1

		return

	end



	if Var["Step"] == 5 then

		if Var["StepWaitTime"] == nil then
			Var["StepWaitTime"] = CurSec
		end


		if Var["StepWaitTime"] + END_EFFECT_WAIT < CurSec then

			Var["StepWaitTime"] = nil


			if Var["QuestResult"] == QUEST_SUCCESS then

				if Var["MainObj"]["Handle"] ~= nil then

					cAnimate( Var["MainObj"]["Handle"], "start", Ani_Index[5] )

				end

				cScriptMessage( Var["MapIndex"], AnnounceInfo["KDEgg_Success"] )

				local Players      = { cGetPlayerList( Var["MapIndex"] ) }

				for i=1, #Players do

					for j=1, #RewardAbstate do

						cSetAbstate( Players[i], RewardAbstate[j]["Index"], 1, RewardAbstate[j]["KeepTime"] )

					end

				end

				Var["Step"] = 6

			else

				if Var["MainObj"]["Handle"] ~= nil then

					cAnimate( Var["MainObj"]["Handle"], "start", Ani_Index[6] )

				end

				cScriptMessage( Var["MapIndex"], AnnounceInfo["KDEgg_Fail"] )

				Var["Step"] = 7

			end

		end

		return

	end


	-- 성공
	if Var["Step"] == 6 then

		if WarN_Dialog( Var, DialogInfo["Egg_Success"] ) ~= nil then
			return
		end

		cCameraMove( Var["MapIndex"], 0, 0, 0, 0, 0, 0 )
		cAnimate( Var["MainObj"]["Handle"], "start", Ani_Index[2] )


		local Players      = { cGetPlayerList( Var["MapIndex"] ) }

		for i=1, #Players do

			cResetAbstate( Players[i], CM_STUN_INDEX )

		end

		Var["Step"] = 99

		return

	end


	-- 실패
	if Var["Step"] == 7 then

		if WarN_Dialog( Var, DialogInfo["Egg_Fail"] ) ~= nil then
			return
		end

		cCameraMove( Var["MapIndex"], 0, 0, 0, 0, 0, 0 )
		Var["MainObj"] = nil


		local Players      = { cGetPlayerList( Var["MapIndex"] ) }

		for i=1, #Players do

			cResetAbstate( Players[i], CM_STUN_INDEX )

		end

		Var["Step"] = 99

		return

	end


	if 	Var["Step"] == 99 then

		if WarN_Notice( Var, NoticeInfo["KQReturn"] ) ~= nil then
			return
		end

		cLinkToAll( Var["MapIndex"], KD_END_LINKTO["Index"], KD_END_LINKTO["x"], KD_END_LINKTO["y"] )
		cEndOfKingdomQuest( Var["MapIndex"] )

		Var["Step"]         = Var["Step"] + 1

	end

end
