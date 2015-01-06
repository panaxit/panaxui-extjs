<%
IF UCASE(SESSION("lang"))="ES" THEN
SESSION("lang")="en"
ELSE
SESSION("lang")="es"
END IF
 %>
 <%= SESSION("lang") %>