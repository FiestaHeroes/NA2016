require( "common" )

gIsInit 	= false		-- �ʱ�ȭ �Ǿ���? ����
------------------------------------------------------------------------------------------------------
--
-- FUNCTION : CPP -> LUA
--
------------------------------------------------------------------------------------------------------
function DummyFunction()
end


function ClassChangeMaster02( Handle, MapIndex )
cExecCheck( "ClassChangeMaster02" )


	-- �̺�Ʈ �ʱ�ȭ
	if gIsInit == false
	then

		-- AISctipt Function ����
		cAIScriptFunc( Handle, "NPCClick", "ClassChangeMaster02_Click" )
		cAIScriptFunc( Handle, "NPCMenu",  "ClassChangeMaster02_Menu"  )

		gIsInit = true;

	end

end


function ClassChangeMaster02_Click( NPCHandle, PlyHandle, PlyCharNo )
cExecCheck( "ClassChangeMaster02_Click" )

	-- ���̾�α� �޴� ���
	cNPCMenuOpen( NPCHandle, PlyHandle )

end


function ClassChangeMaster02_Menu( NPCHandle, PlyHandle, PlyCharNo, Value )
cExecCheck( "ClassChangeMaster02_Menu" )

	-- Ŭ���� ����? ����
	if Value == 1
	then

		cClassChangeOpen( PlyHandle )

	end

end
