require( "common" )

gIsInit 	= false		-- �ʱ�ȭ �Ǿ���? ����
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster03( Handle, MapIndex )
cExecCheck( "ClassChangeMaster03" )


	-- �̺�Ʈ �ʱ�ȭ
	if gIsInit == false
	then

		-- AISctipt Function ����
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster03_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster03_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster03_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster03_Click" )

	-- ���̾�α� �޴� ���
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster03_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster03_Menu" )

	-- Ŭ���� ����? ����
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
