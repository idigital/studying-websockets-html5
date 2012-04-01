$(function() {
  var ws = null;
  
  $('#connect').focus();
  $('#connect').click(function() {
    if (ws != null) {
      ws.close();
    }
    ws = new WebSocket("ws://localhost:9292");
    ws.onopen = function() {
      $('#log').append('<p>Connection Opened</p>');
    };
    ws.onmessage = function (evt) { 
      var received_msg = evt.data;
      $('#log').append('<p>Message Received: ' + received_msg + '</p>');
      
      if (received_msg == "request_login") {
        ws.send($("#username").val());
      }
    };
    ws.onclose = function() { 
      $('#log').append('<p>Connection Closed</p>');
    };
  });
  
  $('#send').click(function() {
    if (ws != null) {
      ws.send($("#msg").val());
    }
  });
  
  $('#disconnect').click(function() {
    if (ws != null) {
      ws.close();
      ws = null;
    }
  });
});