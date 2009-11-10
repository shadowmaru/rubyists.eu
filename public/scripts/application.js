var map = null;
var base_url = null;

jQuery.googleMaps = {
	initialize: function() {
		if (GBrowserIsCompatible()) {
			if (!map) {
				map = new GMap2(document.getElementById('map'));
				
				map.enableScrollWheelZoom();
				map.enableDoubleClickZoom();
				
				map.addControl(new GLargeMapControl3D());
				map.addControl(new GMapTypeControl());
			}
			
		    map.setCenter(new GLatLng(-8.146243, -59.765625), 4);
		}
	}, 
	markGroups: function() {
		$.getJSON('/groups', function(groups) {
			$.each(groups, function() {
				var html = "";
				var group = this;
				var marker = new GMarker(new GLatLng(group.location.latitude, group.location.longitude));
				var location = group.location.city + ', ' + group.location.country_code;

				if (group.website == "") {html = '<h3>' + group.name + '</h3><p>' + location + '</p>';} 
				else {html = '<a href="' + group.website + '"><h3>' + group.name + '</h3></a><p>' + location + '</p>';}

				map.addOverlay(marker);
				GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(html);});
			});
		});
	}
}

jQuery.fn.openLink = function(url) {
	$(this).click(function() {window.open(url, '_self');});
}

jQuery.fn.opacity = function(value) {
	var ms_value = value * 100
	
	$(this).css({'opacity': value, 'filter': 'alpha(opacity=' + ms_value + ')', 
				 '-ms-filter': '"progid:DXImageTransform.Microsoft.Alpha(Opacity=' + ms_value + ')"'});
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
	// Window.
	$(window).unload(function() {GUnload();});
	// Header.
	$('.about').click(function(){
		$('#dialog').css({'width': '800px', 'height': '550px'});
		$('#dialog').fadeIn('slow', function(){
			$('#map, #content').opacity(0.65);
			$('#dialog > .text').load('/about');
		});
	});
	$('.groups').click(function() {$.goTo('/groups');});
	//$('li.search').click();
	$('.title').click(function() {$.goTo('/')});
	// Dialog.
	$('#dialog > .close').click(function() {
		$('#dialog').fadeOut('slow', function() {
			$('#map, #content').opacity(1.0);
			$('#dialog > .text').html("");
		});
	});
	$('.actions > ul > .add').click(function() {
		$('#dialog').css({'width': '500px', 'height': '300px'});
		$('#dialog').fadeIn('slow', function() {
			$('#map, #content').opacity(0.65);
			$('#dialog > .text').load('/groups/new');
		});
	});
	// Content.
	// ...
	// Footer.
	$('.linkedin').openLink('http://www.linkedin.com/groups?about=&gid=160865&goback=%2Egdr_1257619690458_1%2Eanb_160865_*2&report%2Esuccess=r3Tayp0nRRro3Er8iWS8vO-u_mFd11ndGIOEdAI27ES3KgpplepkOcIgotS3mJWzXqb2u21wqjDJwM');
	$('.facebook').openLink('http://www.facebook.com/group.php?gid=13919915410&ref=ts');
	$('.twitter').openLink('http://twitter.com/akitaonrails');
	$('.mailing').openLink('http://groups.google.com/group/rails-br');
	$('.irc').openLink('irc://irc.freenode.net/rails-br');
	$('.involved').openLink('http://github.com/akitaonrails/rubyists.eu');
	$('.license').openLink('http://creativecommons.org/licenses/by-nc-sa/3.0/');
	$('.ondetrabalhar').openLink('http://ondetrabalhar.com/');
});