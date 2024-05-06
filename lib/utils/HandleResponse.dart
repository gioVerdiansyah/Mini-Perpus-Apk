class HandleResponse{
  static Map<String, Map<String, Object>> failResponse(message){
    return {
      "meta": {
        "success": false,
        "status": 500,
        'message': message
      }
    };
  }
}