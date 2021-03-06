/*

File: mapManager.js
Description: Functions to render and manage Google maps

Change Log:

Mauricio Created on 07/05/12

*/

// Object used to manage Google maps
var MapManager = function() {

	// if should use geolocation to pin point user's position, if false, defaults users position to SF
    var useGeolocation = false;
    
    // Stores the rendered map
    var map;
    
    // List of vehicle markers, necessary to update their position
    var vehicleMarkers = {};
    
    // List of bus stop markers
    var busStopMarkers = {};
    
    // Used to calculate coordinates based on addresses
    var geocoder = new google.maps.Geocoder();
    
    // A marker that indicates the position of the user
    var myMarker;
    
    // Current location of the user, defaults to the initial location if location tracking is not enabled in the browser
    var currentLocation = new google.maps.LatLng(37.788008, -122.400682);
    
    // The info window
    var infoWindow;
    
    // Simple popup listener that just shows content from the popupInfo of the associated object
    function simpleMarkerListener() {
      if(infoWindow) {
        infoWindow.close();
      }
    
      infoWindow = new google.maps.InfoWindow({
         content: "<div style='margin-top:10px'>" + this.popupInfo + "</div>"
      });
      infoWindow.open(map, this);
    } 
    
    function doRenderMap(element) {
        // Icon associated with the student marker
        var studentMarkerImage = new google.maps.MarkerImage(imgStudentMarker,
				    	null, //new google.maps.Size((72*0.3), (79*0.3)),
				    	null, //new google.maps.Point(0,0),
				    	null, //new google.maps.Point(36,79),
				    	new google.maps.Size(25, 27) //new google.maps.Size((72*0.3),(79*0.3))											
				    	);
    
        var myOptions = {
            center: currentLocation,
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        
        map = new google.maps.Map(element[0], myOptions);        
		
        myMarker = new google.maps.Marker({
                     position: currentLocation,
                     title: "Me",
                     animation: google.maps.Animation.DROP,
                     icon: studentMarkerImage 
                  });
        
        myMarker.popupInfo = "This is where you are!";
                  
        google.maps.event.addListener(myMarker, 'click', simpleMarkerListener);
        
        myMarker.setMap(map);
    }
    
    return {
      // Trigger a resize event on the map so it redraws on the full canvas
      triggerResize: function() {
        google.maps.event.trigger(map, 'resize');
      },
    
      // Renders a map in a specific element on the page, centralizing the map
      // in the specified latitude and longitude
      renderMap: function(element) {
        
        // finds location
        if(useGeolocation && navigator && navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                utils.log(position);
                currentLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                doRenderMap(element);
            });
        } else {
            currentLocation = new google.maps.LatLng(37.781983, -122.407577);
            doRenderMap(element);
        }
      },
      
      // Given a JSON array of objects returned from teletrac, adds markers for those
      // vehicles to the map. If a marker for a vehicle with the same name already exists,
      // this updates the vehicle position rather than adding another vehicle marker.
      addVehicles: function(vehicles) {
      	var busMarker = new google.maps.MarkerImage(imgBusMarker,
				    	null, //new google.maps.Size((72*0.3), (79*0.3)),
				    	null, //new google.maps.Point(0,0),
				    	null, //new google.maps.Point(36,79),
				    	new google.maps.Size(25, 27) //new google.maps.Size((72*0.3),(79*0.3))											
				    	);
        $(vehicles.Vehicle).each(function() {
            var marker = vehicleMarkers[this.VehicleName];
            
            if(!marker) {
              marker = new google.maps.Marker({
                position: new google.maps.LatLng(this.Latitude, this.Longitude),
                title: this.VehicleName,
                animation: google.maps.Animation.DROP,
                icon: busMarker
              });
              
              marker.popupInfo = "Vehicle Name: " + this.VehicleName;
              
              google.maps.event.addListener(marker, 'click', simpleMarkerListener);

              marker.setMap(map);
            } else {
              marker.setPosition(new google.maps.LatLng(this.Latitude, this.Longitude));
            }

            vehicleMarkers[this.VehicleName] = marker;
        });
        
      },
      
      // Adds bus stops markers to the map, if a stop already exists with the same name, this
      // updates the marker position rather than adding a new stop marker
      addStops: function(stops) {
        $.each(stops, function(key, value) {
    					var marker = new google.maps.Marker({
    						position: new google.maps.LatLng(value.lat, value.long),
    						title: value.stopName,
    						animation: google.maps.Animation.DROP
    					});
 
                        marker.popupInfo = "Stop at: " + value.stopName;
              
                        google.maps.event.addListener(marker, 'click', simpleMarkerListener);
    					
    					marker.setMap(map);
    					vehicleMarkers[value.stopName] = marker;
    			});    		
      }
    };
};

var mapManager;