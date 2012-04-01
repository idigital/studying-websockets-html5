$(function() {
  
  // Top level variables
  var ws = null;
  var cells = {};
  
  // Check for websocket support
  var support = "MozWebSocket" in window ? 'MozWebSocket' : ("WebSocket" in window ? 'WebSocket' : null);
  if(support==null) {
    $("#board").before("<p>Your browser is a little too old to run this application.</p>");
  }
  
  // Set up networking 
  $('#connect').focus();
  $('#connect').click(function() {
    if (ws != null) {
      ws.close();
    }
    ws = new WebSocket("ws://localhost:9292");
    ws.onopen = function() {
      handleOpen();
    };
    ws.onmessage = function (evt) {
      var received_msg = evt.data;
      //$('#log').append('<p>Message Received: ' + received_msg + '</p>');
      
      if (received_msg == "request_login") {
        ws.send($("#username").val());
      } else {
        handleMessage(received_msg);
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
  
  function handleOpen() {
    cells = {}
  }
  
  function handleMessage(msg) {
    delta = JSON.parse(msg);
    
    for (i = 0; i < delta.length; i++) {
      action = delta[i];
      executeAction(action);
    }
  }
  
  function executeAction(action) {
    if (action['action'] == "alive") {
      var x = action['x'];
      var y = action['y'];
      var key = x + "_" + y;
      cells[key] = { x: x, y: y }
    }
    else if (action['action'] == "dead") {
      var x = action['x'];
      var y = action['y'];
      var key = x + "_" + y;
      delete cells[key];
    }
    else {
      console.log('unknown action? ' + action);
    }
    
    drawBoard(); // do it here, don't really need a render loop in this application
  }
  
  // Main rendering function
  function drawBoard() {
    var board = document.getElementById("board");
    var ctx = board.getContext("2d");
    
    ctx.clearRect(0, 0, 300, 300);
    
    for (var index in cells) {
      var cell = cells[index]
      
      var width = 3;
      var x = cell.x * width;
      var y = cell.y * width;
      ctx.fillRect(x, y, width, width);
    }
  }
});








