Number.prototype.upto = function(y, cb) {
	var _i;
	for(_i = this; _i<=y; _i++) {
		if(cb) cb(_i);
	}
}

Number.prototype.downto = function(y, cb) {
	var _i;
	for(_i = this; _i>=y; _i--) {
		if(cb) cb(_i);
	}
}


