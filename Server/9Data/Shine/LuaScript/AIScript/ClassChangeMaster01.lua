require( "common" )

gIsInit 	= false		-- �ʱ�ȭ �Ǿ���? ����
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster01( Handle, MapIndex )
cExecCheck( "ClassChangeMaster01" )


	-- �̺�Ʈ �ʱ�ȭ
	if gIsInit == false
	then

		-- AISctipt Function ����
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster01_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster01_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster01_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster01_Click" )

	-- ���̾�α� �޴� ���
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster01_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster01_Menu" )

	-- Ŭ���� ����? ����
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
