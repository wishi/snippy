(function(opera){

/*
	~~~ Opera Arioso!  ~~~ 
	by rvdh, 0x000000.com
	
	$revisions$
	update: 20/7/2008: 7:15 PM, keylog pattern adjusted.
*/

// Ariosos magic (ghost) varibales
window.opera.defineMagicVariable('arioso_links', function() {}, null);
window.opera.defineMagicVariable('arioso_sanitize_xss', function() {}, null);
window.opera.defineMagicVariable('arioso_message', function() {}, null);
window.opera.defineMagicVariable('arioso_alert', function() {}, null);

// Arioso variables
var arioso_links = document.links;
var arioso_sanitize_xss = true;
var arioso_message, arioso_alert = '';
var crlf = ". \r\n";

// Arioso messages
var message1 = 'Found unsafe URI hyperlink schemes, inspect the source for details';
var message2 = 'Possible denial of service vector found and blocked';
var message3 = 'Possible heapspraying or denial of service vector found and blocked';
var message4 = 'VBInjection vector found and blocked';
var message5 = 'Cookie stealing attempt blocked';
var message6 = 'Prevented non-same origin URI sourcing';
var message7 = 'Prevented keylogging';
var message8 = 'Prevented Arioso script access';
var message9 = 'Prevented ActiveX Shell access';
var message10 = 'Prevented Java access';
var message11 = 'Prevented Rogue XmlHttpRequest';

// Arioso  patterns
var  pattern1 = /^(chrome|file|opera|res|data|telnet|about|resource|view-source|acrobat|mms|localhost|loopback):/gim;
var  pattern2 = /for\s*\(\s*[a-z]\s*\=\s*[0-9]\s*;\s*[a-z]\s*(<|>|<=|>=|<==|>==)\s*[0-9]{3,}\s*;\s*/gim;
var  pattern3 = /(while|for|space|block|memory).*unescape\(("|')(%[0-9]|\\x|\\u)([a-z]|[0-9])("|')\)/gim;
var  pattern4 = /String\(\s*[0-9]{6,},\s*"[a-z]"\)/gim;
var  pattern5 = /http:\/\/.*\?.*=.*(\+|concat|join).*document\.(cookie|domain)/gim;
var  pattern6 = /(src|href|location)\s*=.*(localhost|loopback|telnet|file|res|resource|about|javascript|data):/gim;
var  pattern7 = /(\.keyCode|\.keypress|(e|event)\.charCode)/gim;
var  pattern8 = /(bad_arioso_schemes|arioso_links|arioso_schemes|arioso_sanitize_xss)/gim;
var  pattern9 = /(ActiveXObject\(("|').*Shell("|')\)|HKEY\_)/gim;
var  pattern10 = /(java\.(sun|awt)|packages\.(.*)(plugin|javascript))/gim;
var  pattern11 = /open\(("|')\s*(GET|TRACE|POST)\s*("|').*(\\r|\\r\\n|\\n|(%[0-9]|\\x|\\u)([a-z]|[0-9])).*\)/gim;
												  

// Arioso strict non-same origin JS blocker (think: ads, and cookie stealers)
window.opera.addEventListener('BeforeExternalScript', function(e) {
   		 if ( ! e.element.getAttribute('src').match(document.location)) {
       			e.preventDefault();
   		 }
}, false);

// Arioso link enumerator detecting bad schemes
window.addEventListener('DOMContentLoaded', function(e) {
		for (i = 0; i < arioso_links.length; i++) {
              entity = arioso_links[i].toString();
              if (entity.match(pattern1)) {
              	arioso_alert += message1;
              }
       }
}, false);

window.opera.addEventListener('BeforeScript', function(e) {
													   
		if (e.element.text.match(pattern2)) {
			arioso_alert += message2 + crlf;
			e.preventDefault();
		} 
		if (e.element.text.match(pattern3)) {
			arioso_alert += message3 + crlf;
			e.preventDefault();
		} 
		if (e.element.text.match(pattern4)) {
			arioso_alert += message4 + crlf;
			e.preventDefault();
		} 
		if (e.element.text.match(pattern5)) {
			arioso_alert += message5 + crlf;
			e.preventDefault();
		}
		if (e.element.text.match(pattern6)) {
			arioso_alert += message6 + crlf;
			e.preventDefault();
		}
		if (e.element.text.match(pattern7)) {
			arioso_alert += message7 + crlf;
			e.preventDefault();
		}
		if (e.element.text.match(pattern8)) {
			arioso_alert += message8 + crlf;
			e.preventDefault();
		}
		if (e.element.text.match(pattern9)) {
			arioso_alert += message9 + crlf;
			e.preventDefault();
		}	
		if (e.element.text.match(pattern10)) {
			arioso_alert += message10 + crlf;
			e.preventDefault();
		}	
		if (e.element.text.match(pattern11)) {
			arioso_alert += message11 + crlf;
			e.preventDefault();
		}	
}, false);

document.addEventListener('load', function(e) {

    if (arioso_alert != '' ) {
        var ary = document.createElement('div');
        ary.style.position 					= 'fixed';
        ary.style.top						= '0px';
        ary.style.left 						= '0px';
        ary.style.width 					= '100%';
        ary.style.opacity 					= '.90';
        ary.style.filter 					= 'alpha(opacity=90)';
        ary.style.border					= '1px dotted #f30';
        ary.style.padding 					= '3px';
        ary.style.font 						= '8pt sans-serif';
        ary.style.backgroundColor 				= '#f00';
        ary.style.color 				 	= '#fff';
        ary.appendChild(document.createTextNode('ARIOSO ALERT: ' + arioso_alert))
        document.body.appendChild(ary);
    	} 
		
}, false);

})(window.opera);