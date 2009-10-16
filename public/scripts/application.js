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

jQuery.goTo = function(url) {
	if (base_url == null) {
		base_url = 'http://' + location.href.substr(7).split('/')[0];
	}

	location.href = base_url + url;
}

$(document).ready(function() {
	$(window).load(function(){$.googleMaps.initialize();});
	$('li.about').click();
	$('li.groups').click(function(){$.goTo('/groups');});
	$('li.search').click();
	$('div.title').click(function(){$.goTo('/')});
	$('li.contribute').click(function(){window.open('http://github.com/amsterdamrb/rubyists-eu', '_self');});
	$('li.license').click(function(){window.open('http://creativecommons.org/licenses/by-nc-sa/3.0/', '_self');});
});