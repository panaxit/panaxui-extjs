<%
'/**
' * @class Response
' * A simple JSON Response class.
' */
Class Response 
    public bSuccess, $data, $message, $errors, $tid, $trace;
	
	Public Property Get Success()
		Success = bSuccess
	End Property
	Public Property Let Success(input)
		bSuccess = input
	End Property
	
    public function __construct($params = array()) {
        $this->success  = isset($params["success"]) ? $params["success"] : false;
        $this->message  = isset($params["message"]) ? $params["message"] : '';
        $this->data     = isset($params["data"])    ? $params["data"]    : array();
    Function

    public function to_json() {
        return json_encode(array(
            'success'   => $this->success,
            'message'   => $this->message,
            'data'      => $this->data
        ));
    End Function
End Class
%>