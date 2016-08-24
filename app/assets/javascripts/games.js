function updateTimer(currentTime) {
	timer = document.getElementById('timer');
	if (timer != null && currentTime >= 0) {
		setTimeout(function() {
			timer.innerHTML = currentTime;
			updateTimer(currentTime-1);
		}, 1000);
	} else {
    console.log("no time or timer")
	};
};
