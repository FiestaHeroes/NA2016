--------------------------------------------------------------------------------
--                            Kingkong Routine                              --
--------------------------------------------------------------------------------

function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	-- ù �÷��̾��� �� �α��� üũ
	Var["bPlayerMapLogin"] = true

	-- �ð� ������ ���� ���� ���� ��쿡�� �ƹ��͵� �������� �ʴ´�.
	if Var["KQLimitTime"] == nil
	then
		return
	end

	if Var["CurSec"] == nil
	then
		return
	end

	-- ���� �ð� �������� ���ѽð��� �޾Ƽ� ��û�Ѵ�.
	local nLimitSec = Var["KQLimitTime"] - Var["CurSec"]

	cShowKQTimerWithLife_Obj( Handle, nLimitSec )

end



MemBlock = {}
function BossRoutine( Handle, MapIndex )
cExecCheck "BossRoutine"

	if InstanceField[MapIndex] == nil
	then
		MemBlock[Handle] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end

	if cIsObjectDead( Handle ) == 1
	then
		MemBlock[Handle] = nil
		cAIScriptSet( Handle )
		return ReturnAI["END"]
	end


	local CurSec = cCurrentSecond()


	local Var = MemBlock[Handle]

	if Var == nil
	then
		MemBlock[Handle]			= {}

		Var							= MemBlock[Handle]
		Var["Handle"]				= Handle
		Var["MapIndex"]				= MapIndex

		-- ���� ���̾�α� ó�� ���� ���� �ʱ�ȭ
		Var["RegenDialog"]			= {}
		Var["RegenDialog"]["Data"]	= BossDialog["BossFloorStart"]
		Var["RegenDialog"]["Step"]	= 1
		Var["RegenDialog"]["Wait"]	= CurSec


		-- ���� ������ ó�� ���� ���� �ʱ�ȭ
		Var["HPChkTime"]			= 0

		Var["SkillRate"]			= {}
		Var["Summon"]				= {}
		Var["Heal"]					= {}


		Var["SkillRate"]["Step"]	= 1
		Var["Summon"]["Step"]		= 1
		Var["Heal"]["Step"]			= 1


		Var["SkillRate"]["Flag"]	= false
		Var["Summon"]["Flag"]		= false
		Var["Heal"]["Flag"]			= false


		if Var["SkillRate"]["Step"] <= #BossSkillRateNameTable
		then
			Var["SkillRate"]["CurData"]	= BossSkillRate[ BossSkillRateNameTable[ Var["SkillRate"]["Step"] ] ]
		end

		if Var["Summon"]["Step"] <= #BossSummonNameTable
		then
			Var["Summon"]["CurData"]	= BossSummon[ BossSummonNameTable[ Var["Summon"]["Step"] ] ]
		end

		if Var["Heal"]["Step"] <= #BossHealNameTable
		then
			Var["Heal"]["CurData"]		= BossHeal[ BossHealNameTable[ Var["Heal"]["Step"] ] ]
		end


		cMobDetectRange( Var["Handle"], BossDetectRange["Regen"] )

		cAIScriptFunc( Var["Handle"], "MobDamaged", "BossDamaged" )

		local Curhp, Maxhp = cObjectHP( Var["Handle"] )
		BossDamaged( Var["MapIndex"], 0, Maxhp, Curhp, Var["Handle"] )

	end


	-- ���� Ÿ�� ������ DetectRange �÷���
	if Var["TargetHandle"] == nil
	then
		Var["TargetHandle"] = cTargetHandle( Var["Handle"] )
		if Var["TargetHandle"] ~= nil
		then
			cMobDetectRange( Var["Handle"], BossDetectRange["View"] )
		end
	end


	-- �ѹ��� ���� �������� �Ծ ����� ó�� �ȵ� ���ɼ� ������ 1�ʸ��� hp üũ.
	if Var["HPChkTime"] + 1 <= CurSec
	then
		Var["HPChkTime"] = CurSec

		local Curhp, Maxhp = cObjectHP( Var["Handle"] )
		BossDamaged( Var["MapIndex"], 0, Maxhp, Curhp, Var["Handle"] )
	end


	RegenDialogProc( Var )

	SkillRateChange( Var )
	SummonMob( Var )
	Recovery( Var )


	return ReturnAI["CPP"]

end



function RegenDialogProc( Var )
cExecCheck "RegenDialogProc"

	if Var == nil
	then
		return
	end

	if Var["RegenDialog"] == nil
	then
		return
	end

	if Var["RegenDialog"]["Step"] > #Var["RegenDialog"]["Data"]
	then
		Var["RegenDialog"] = nil
		return
	end

	local CurSec	= cCurrentSecond()
	local CurData	= Var["RegenDialog"]["Data"][ Var["RegenDialog"]["Step"] ]

	if Var["RegenDialog"]["Wait"] + CurData["Delay"] > CurSec
	then
		return
	end

	cMobDialog( Var["MapIndex"], CurData["MobIndex"], BossDialog["ScriptFileName"], CurData["Index"] )


	Var["RegenDialog"]["Wait"] = CurSec
	Var["RegenDialog"]["Step"] = Var["RegenDialog"]["Step"] + 1

end



function BossDamaged( MapIndex, Attacker, MaxHP, CurHP, Defender )
cExecCheck "BossDamaged"

	local Var = MemBlock[Defender]

	if Var == nil
	then
		return
	end

	local HPRate = (CurHP * 1000) / MaxHP

	SkillRateCheck( Var, HPRate )
	SummonCheck( Var, HPRate )
	HealCheck( Var, HPRate )

end




function SkillRateCheck( Var, HPRate )
cExecCheck "SkillRateCheck"

	if Var == nil
	then
		return
	end


	if Var["SkillRate"] == nil
	then
		return
	end

	if Var["SkillRate"]["Flag"] == true
	then
		return
	end

	if HPRate > Var["SkillRate"]["CurData"]["HPRate"]
	then
		return
	end


	Var["SkillRate"]["Flag"] = true

end

function SkillRateChange( Var )
cExecCheck "SkillRateChange"

	if Var == nil
	then
		return
	end


	if Var["SkillRate"] == nil
	then
		return
	end

	if Var["SkillRate"]["Flag"] == false
	then
		return
	end


	-- ���� Ȯ�� ����
	local Values = Var["SkillRate"]["CurData"]["Value"]

	cMobWeaponRate( Var["Handle"], Values[1], Values[2], Values[3], Values[4] )



	Var["SkillRate"]["Step"] = Var["SkillRate"]["Step"] + 1

	if Var["SkillRate"]["Step"] > #BossSkillRateNameTable
	then
		Var["SkillRate"] = nil
	else
		Var["SkillRate"]["CurData"]	= BossSkillRate[ BossSkillRateNameTable[ Var["SkillRate"]["Step"] ] ]

		Var["SkillRate"]["Flag"]	= false
	end

end



function SummonCheck( Var, HPRate )
cExecCheck "SummonCheck"

	if Var == nil
	then
		return
	end


	if Var["Summon"] == nil
	then
		return
	end

	if Var["Summon"]["Flag"] == true
	then
		return
	end

	if HPRate > Var["Summon"]["CurData"]["HPRate"]
	then
		return
	end


	Var["Summon"]["Flag"] = true

end

function SummonMob( Var )
cExecCheck "SummonMob"

	if Var == nil
	then
		return
	end


	if Var["Summon"] == nil
	then
		return
	end

	if Var["Summon"]["Flag"] == false
	then
		return
	end


	-- ���̾�α� ���� 2�� ������
	if Var["Summon"]["OnTime"] == nil
	then
		local LastFloorName = FloorNameTable[#FloorNameTable]
		local LastBossIndex = RegenInfo["BossMob"][LastFloorName]["Success"]["Index"]
		cMobDialog( Var["MapIndex"], LastBossIndex, BossDialog["ScriptFileName"], BossDialog["SummonMob"]["Index"] )

		Var["Summon"]["OnTime"] = cCurrentSecond()
	end


	if Var["Summon"]["OnTime"] + BossSummon["BossSummonDelay"] > cCurrentSecond()
	then
		return
	end

	Var["Summon"]["OnTime"] = nil


	-- ��ȯ
	local Values = Var["Summon"]["CurData"]["Value"]

	for i = 1, #Values
	do
		cMobRegen_Obj( Values[i], Var["Handle"] )
	end



	Var["Summon"]["Step"] = Var["Summon"]["Step"] + 1

	if Var["Summon"]["Step"] > #BossSummonNameTable
	then
		Var["Summon"] = nil
	else
		Var["Summon"]["CurData"]	= BossSummon[ BossSummonNameTable[ Var["Summon"]["Step"] ] ]

		Var["Summon"]["Flag"]		= false
	end

end


function HealCheck( Var, HPRate )
cExecCheck "HealCheck"

	if Var == nil
	then
		return
	end


	if Var["Heal"] == nil
	then
		return
	end

	if Var["Heal"]["Flag"] == true
	then
		return
	end

	if HPRate > Var["Heal"]["CurData"]["HPRate"]
	then
		return
	end


	Var["Heal"]["Flag"] = true

end

function Recovery( Var )
cExecCheck "Recovery"

	if Var == nil
	then
		return
	end


	if Var["Heal"] == nil
	then
		return
	end

	if Var["Heal"]["Flag"] == false
	then
		return
	end


	local CurSec = cCurrentSecond()


	if Var["Heal"]["HealTickCount"] == nil
	then
		-- ���̾�α� ���� 2�� ������
		if Var["Heal"]["OnTime"] == nil
		then
			local LastFloorName = FloorNameTable[#FloorNameTable]
			local LastBossIndex = RegenInfo["BossMob"][LastFloorName]["Success"]["Index"]
			cMobDialog( Var["MapIndex"], LastBossIndex, BossDialog["ScriptFileName"], BossDialog["Heal"]["Index"] )

			Var["Heal"]["OnTime"] = CurSec
		end

		if Var["Heal"]["OnTime"] + BossHeal["BossHealDelay"] > CurSec
		then
			return
		end


		-- ���̵� ���
		if cWaitIdle( Var["Handle"] ) == nil
		then
			return
		end


		-- �����̻� �ɾ��ְ�, �ִϸ��̼� �ɾ���
		cSetAbstate( Var["Handle"], BossHeal["Abstate"]["Index"], BossHeal["Abstate"]["Strength"], BossHeal["Abstate"]["KeepTime"] )
		cAnimate( Var["Handle"], "start", BossHeal["AniIndex"] )

		Var["Heal"]["HealTickCount"]	= BossHeal["Tick"]
		Var["Heal"]["OnTime"]			= nil
		Var["Heal"]["ChkTime"]			= CurSec
	end


	if Var["Heal"]["ChkTime"] + BossHeal["TickTime"] > CurSec
	then
		return
	end

	Var["Heal"]["ChkTime"] = CurSec


	-- ��
	cHeal( Var["Handle"], Var["Heal"]["CurData"]["Value"] )



	Var["Heal"]["HealTickCount"] = Var["Heal"]["HealTickCount"] - 1


	if Var["Heal"]["HealTickCount"] <= 0
	then
		cAnimate( Var["Handle"], "stop" )

		Var["Heal"]["Step"] = Var["Heal"]["Step"] + 1

		Var["Heal"]["HealTickCount"]	= nil
		Var["Heal"]["OnTime"]			= nil
		Var["Heal"]["ChkTime"]			= nil

		if Var["Heal"]["Step"] > #BossHealNameTable
		then
			Var["Heal"] = nil
		else
			Var["Heal"]["CurData"]	= BossHeal[ BossHealNameTable[ Var["Heal"]["Step"] ] ]

			Var["Heal"]["Flag"]		= false
		end

	end

end
