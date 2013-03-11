RNumber = (function() {
	function RNumber(x) {
		this.x = x;
	}

	RNumber.prototype._Req = function(y) {
		return (this.x == y);
	}

	RNumber.prototype._Rplus = function(y) {
		return (this.x + y)
	}

	return RNumber;
})();

Number.prototype.upto = function(y, cb) {
	var _i;
	for(_i = this; _i<y; _i++) {
		if(cb) cb(_i);
	}
}

R = function(x){
	switch(typeof(x)){
		case "number":
			return new RNumber(x);
		default:
			return x;
	}
};

puts = function(str) {
	console.log(""+str)
};

