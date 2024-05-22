import Xml;
class MadnessUtils{
	public static function isSpace(s:String, pos:Int):Bool {

		var c = s.charCodeAt(pos);
		return (c > 8 && c < 14) || c == 32;
	}
	
	public static function trim(s:String):String {

		var l = s.length;
		var r = 0;
		while (r < l && isSpace(s, l - r - 1)) {
			r++;
		}
		if (r > 0) {
			return s.substr(0, l - r);
		} else {
			return s;
		}
		
	}
	public static function get_innerData(xml:Xml) {
		var it = xml.iterator();
		if (!it.hasNext())
			throw " does not have data";
		var v = it.next();
		if (it.hasNext()) {
			var n = it.next();
			// handle <spaces>CDATA<spaces>
			if (v.nodeType == Xml.PCData && n.nodeType == Xml.CData && trim(v.nodeValue) == "") {
				if (!it.hasNext())
					return n.nodeValue;
				var n2 = it.next();
				if (n2.nodeType == Xml.PCData && trim(n2.nodeValue) == "" && !it.hasNext())
					return n.nodeValue;
			}
			throw " does not only have data";
		}
		if (v.nodeType != Xml.PCData && v.nodeType != Xml.CData)
			throw " does not have data";
		return v.nodeValue;
	}

}