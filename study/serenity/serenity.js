$(function() {
  
  // Top level variables
  var ws = null;
  
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
  
  // Parsing example:
  //cell = '{ "x" : 10, "y" : 10, "alive" : false }';
  //obj = JSON.parse(cell);
  
  // Draw some stuff
  var cells = new Array();
  cells[0] = { x: 10, y: 10 }
  cells[1] = { x: 20, y: 20 }
  
  function drawBoard() {
    var board = document.getElementById("board");
    var ctx = board.getContext("2d");
    
    for (var i = 0; i < cells.length; i++) {
      cell = cells[i];
      
      var width = 3;
      var x = cell.x * width;
      var y = cell.y * width;
      ctx.fillRect(x, y, width, width);
    }
  }
  drawBoard();
});













