var map = null;
var geocoder = null;
var base_url = null;

/*
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
	}, 
	countryOf: function(code) {
		var country = null;

		$.ajax({url: '/countries/' + code, async: false, dataType: 'json', success: function(json) {country = json.name;}});

		return country;
	},
	findAddress: function(location, identifier, callback) {
		if (geocoder) {
	    	geocoder.getLatLng(location, function(point) {
				if (!point) {
					$.ajax({type: 'DELETE', url: '/groups/' + identifier, async: true});
					$.goTo('/groups');
					alert('The given location (' + location + ") was not found on the map.");
				} else {callback(point);}
	      	});
	  	}
	},
	placeMarker: function(point, text) {
	  	var text = text;
	  	var marker = new GMarker(point);
	  
		map.addOverlay(marker);
	  	GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(text);});
		
		return marker;
	},
	markGroups: function() {
		$.getJSON('/groups', function(groups) {
			$.each(groups, function() {
				var group = this;
				var country = $.googleMaps.countryOf(group.country_code);
				var location = group.city + ', ' + country;
				
				$.googleMaps.findAddress(location, group.id, function(point) {
					if (group.website == "") {html = '<h3>' + group.name + '</h3>';}
					else {html = '<a href="' + group.website + '"><h3>' + group.name + '</h3></a>';}
					html = html + '<p>' + location + '</p>';
			    	$.googleMaps.placeMarker(point, html);
				});				
			});
		});
	}
}

jQuery.fn.openLink = function(url) {
	$(this).click(function() {window.open(url, '_self');});
}

jQuery.goTo = function(url) {
	if (base_url == null) {
		base_url = 'http://' + location.href.substr(7).split('/')[0];
	}

	location.href = base_url + url;
}

$(document).ready(function() {
	$.googleMaps.initialize();
	$.googleMaps.markGroups();
	// Header.
	$('.about').click(function(){
		$('#dialog').css({'width': '700px', 'height': '500px'});
		$('#dialog').fadeIn('slow', function(){
			$('#map, #content').css({'opacity': '0.65'});
			$('#dialog > .text').load('/about');
		});
	});
	$('.groups').click(function() {$.goTo('/groups');});
	//$('li.search').click();
	$('.title').click(function() {$.goTo('/')});
	// Dialog.
	$('#dialog > .close').click(function() {
		$('#dialog').fadeOut('slow', function() {
			$('#map, #content').css({'opacity': '1.0'});
			$('#dialog > .text').html("");
		});
	});
	$('.actions > ul > .add').click(function() {
		$('#dialog').css({'width': '500px', 'height': '300px'});
		$('#dialog').fadeIn('slow', function() {
			$('#map, #content').css({'opacity': '0.65'});
			$('#dialog > .text').load('/groups/new');
		});
	});
	// Content.
	// ...
	// Footer.
	$('.linkedin').openLink('http://www.linkedin.com/groups?gid=2400973');
	$('.facebook').openLink('http://www.facebook.com/pages/Europe/RubyistsEU/188196555796');
	$('.twitter').openLink('http://twitter.com/rubyists_eu');
	$('.mailing').openLink('http://groups.google.com/group/rubyists-eu');
	$('.contribute').openLink('http://github.com/amsterdamrb/rubyists-eu');
	$('.license').openLink('http://creativecommons.org/licenses/by-nc-sa/3.0/');
});