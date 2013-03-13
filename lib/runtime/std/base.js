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

R = function(x){
	switch(typeof(x)){
		case "number":
			return new RNumber(x);
		default:
			return x;
	}
};

puts = function(s) {
	//console.log(""+str)
	process.stdout.write(""+s+"\n")
};

print = function(str) {
	var i, s="";
	for (i =0 ; i < arguments.length; i++){
		s += arguments[i];
	}
	//puts(s);
	process.stdout.write(s)
};

$stdout = {
	flush : function(){}
};

