var map = null;
var geocoder = null;
var base_url = null;

/*
function each(ary, block) {
  for (i in ary) {
    block(ary[i]);
  }
}

function findAddress(address, callback) {
  if (geocoder) {
    var callback = callback;
    geocoder.getLatLng(
      address,
      function(point) {
        if (!point) {
          alert(address + " not found");
        } else {
          callback(point);
        }
      }
    );
  }
}

function placeMarker(point, text) {
  var text = text;
  var marker = new GMarker(point);
  map.addOverlay(marker);
  GEvent.addListener(marker, "click", function() {
    marker.openInfoWindowHtml(text);
  });
  return marker;
}

function tag(name, content) {
  return "<" + name + ">" + content + "</" + name + ">"
}

function addUserGroupMarker(name, city, country) {
  var name = name;
  var address = city + ", " + country
  findAddress(address, function(point) {
    html = tag('h3', name) + tag('p', address)
    placeMarker(point, html);
  })
} 

function showAddress(address) {
  var address = address;
  findAddress(address, function(point) {
    map.setCenter(point, 8);
  });
}
*/

jQuery.googleMaps = {
	initialize: function() {
		if (GBrowserIsCompatible()) {
			var mapControl = null;
			
			mapControl = new GLargeMapControl();
			geocoder = new GClientGeocoder();
		    map = new GMap2(document.getElementById('map'));
		
		    map.setCenter(new GLatLng(54.0, -6.24), 4);
		    map.addControl(mapControl);
		}
	}
}

jQuery.fn.openLink = function(url) {
	$(this).click(function(){window.open(url, '_self');});
}

jQuery.goTo = function(url) {
	if (base_url == null) {
		base_url = 'http://' + location.href.substr(7).split('/')[0];
	}

	location.href = base_url + url;
}

$(document).ready(function() {
	$(window).load(function(){$.googleMaps.initialize();});
	// Header.
	$('.about').click(function(){
		$('#dialog').css({'width': '700px', 'height': '500px'});
		$('#dialog').fadeIn('slow', function(){
			$('#map, #content').css({'opacity': '0.65'});
			$('#dialog > .text').load('/about');
		});
	});
	$('.groups').click(function(){$.goTo('/groups');});
	//$('li.search').click();
	$('.title').click(function(){$.goTo('/')});
	// Dialog.
	$('#dialog > .close').click(function(){
		$('#dialog').fadeOut('slow', function(){
			$('#map, #content').css({'opacity': '1.0'});
			$('#dialog > .text').html("");
		});
	});
	$('.actions > ul > .add').click(function(){
		$('#dialog').css({'width': '500px', 'height': '300px'});
		$('#dialog').fadeIn('slow', function(){
			$('#map, #content').css({'opacity': '0.65'});
			$('#dialog > .text').load('/groups/new');
		});
	});
	// Content.
	// ...
	// Footer.
	$('.twitter').openLink('http://twitter.com/rubyists_eu');
	$('.mailing').openLink('http://groups.google.com/group/rubyists-eu');
	$('.contribute').openLink('http://github.com/amsterdamrb/rubyists-eu');
	$('.license').openLink('http://creativecommons.org/licenses/by-nc-sa/3.0/');
});