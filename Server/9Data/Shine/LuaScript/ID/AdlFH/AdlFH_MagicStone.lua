require( "common" )


-- ����۵�������A
function AdlFH_EStone01( Handle, MapIndex )
cExecCheck "AdlF_magic_stoneA"

	return MagicStone( Handle, MapIndex )

end

-- ����۵�������B
function AdlFH_EStone02( Handle, MapIndex )
cExecCheck "AdlF_magic_stoneB"

	return MagicStone( Handle, MapIndex )

end

-- ����۵�������C
function AdlFH_EStone03( Handle, MapIndex )
cExecCheck "AdlF_magic_stoneC"

	return MagicStone( Handle, MapIndex )

end



MagicStoneMemBlock = {}

function MagicStone( Handle, MapIndex )
cExecCheck "MagicStone"

	local Var = MagicStoneMemBlock[Handle]

	if cIsObjectDead( Handle ) then			-- �׾���

		cAIScriptSet( Handle )				-- ��ũ��Ʈ ����
		MagicStoneMemBlock[Handle] = nil	-- �޸�����

		return ReturnAI.END
	end

	if Var == nil then

		MagicStoneMemBlock[Handle] = {}

		Var = MagicStoneMemBlock[Handle]

		Var.Handle		= Handle
		Var.MapIndex	= MapIndex

		cAIScriptFunc( Var.Handle, "NPCClick", "MagicStone_Click" )
		cAIScriptFunc( Var.Handle, "NPCMenu",  "MagicStone_Casting" )
	end

	return ReturnAI.END

end



function MagicStone_Click( NPCHandle, PlyHandle, RegistNumber )
cExecCheck "MagicStone_Click"

	local Var = MagicStoneMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "MagicStone_Click : nil NPC " .. NPCHandle )
		return
	end

	-- �ʵ� ���� ����
	if InstanceField[Var.MapIndex] == nil then
		return
	end

--	local Field = InstanceField[Var.MapIndex]

--	if Field.SummonStone_Active ~= nil then
--		return
--	end

	cCastingBar( PlyHandle, NPCHandle, WaveEvent.MS_CastingTime * 1000, AniIndex.CharactorCasting )

end

function MagicStone_Casting( NPCHandle, PlyHandle, RegistNumber, Menu )
cExecCheck "MagicStone_Casting"


	local Var = MagicStoneMemBlock[NPCHandle]
	if Var == nil then
		cDebugLog( "MagicStone_Casting : nil NPC " .. NPCHandle )
		return
	end

	-- �ʵ� ���� ����
	if InstanceField[Var.MapIndex] == nil then
		return
	end

	local Field = InstanceField[Var.MapIndex]


	-- ��ȯ���� ���¿� ���� ó���� �޶�����
	if Field.SummonStone_Active == nil then

		local AniIndexNum

		if Field.Magic_stoneA == NPCHandle then
			Field.MagicStoneA_ActiveTime = cCurrentSecond() + WaveEvent.MS_ActiveTime
			AniIndexNum = 1

		elseif Field.Magic_stoneB == NPCHandle then
			Field.MagicStoneB_ActiveTime = cCurrentSecond() + WaveEvent.MS_ActiveTime
			AniIndexNum = 2

		elseif Field.Magic_stoneC == NPCHandle then
			Field.MagicStoneC_ActiveTime = cCurrentSecond() + WaveEvent.MS_ActiveTime
			AniIndexNum = 3

		else
			cDebugLog( "MagicStone_Casting : " .. NPCHandle )

		end


		if AniIndexNum ~= nil then
			cAnimate( NPCHandle, "start", AniIndex.MagicStoneActive[AniIndexNum] )
		end
	else

		if Field.Magic_stoneA == NPCHandle then
			Field.MagicStoneA_ActiveTime = cCurrentSecond() + WaveEvent.MS_NonActiveTime

		elseif Field.Magic_stoneB == NPCHandle then
			Field.MagicStoneB_ActiveTime = cCurrentSecond() + WaveEvent.MS_NonActiveTime

		elseif Field.Magic_stoneC == NPCHandle then
			Field.MagicStoneC_ActiveTime = cCurrentSecond() + WaveEvent.MS_NonActiveTime

		else
			cDebugLog( "MagicStone_Casting : " .. NPCHandle )
		end

		cAnimate( NPCHandle, "stop" )
	end

end

