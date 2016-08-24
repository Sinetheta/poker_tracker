function timeRemaining(roundLength, timeStarted) {
  var seconds = Date.now()/1000;
  var roundLength = roundLength*60;
  var timeRemaining = roundLength-(seconds-timeStarted);
  if (timeRemaining <= 0) {
    return 0;
  } else if (timeRemaining <= roundLength) {
    return timeRemaining;
  } else {
    return roundLength;
  };
};

function updateTimer(roundLength, timeStarted) {
  var t = Math.round(timeRemaining(roundLength, timeStarted));
  document.getElementById('timer').innerHTML = t;
  var i = setInterval(updateTimer, 1000, roundLength, timeStarted);
  if (t == 0) {
    clearInterval(i);
  };
};
